# Exemplos de Código e Padrões
## Marketplace Platform

**Versão:** 1.0  
**Data:** 2025-01-XX

---

## 1. Exemplos de Service Objects

### 1.1 Service Object Simples

```ruby
# app/domains/users/create_service.rb
module Users
  class CreateService
    def self.call(user_params:)
      new(user_params).call
    end

    def initialize(user_params)
      @user_params = user_params
    end

    def call
      Users::Create
        .new(@user_params)
        .validate!
        .to_model!
        .tap(&:save!)
    end
  end
end
```

**Uso:**
```ruby
# app/controllers/users/registrations_controller.rb
def create
  user = Users::CreateService.call(user_params: user_params)
  sign_in(user)
  redirect_to after_sign_up_path_for(user)
rescue Error::InvalidParams => e
  flash[:error] = e.message
  render :new
end
```

### 1.2 Service Object com Transação

```ruby
# Exemplo futuro: app/domains/orders/create_service.rb
module Orders
  class CreateService
    def self.call(order_params:, user:)
      new(order_params, user).call
    end

    def initialize(order_params, user)
      @order_params = order_params
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        order = Orders::Create
          .new(@order_params)
          .validate!
          .to_model!
        
        order.user = @user
        order.save!
        
        # Criar itens do pedido
        @order_params[:items].each do |item_params|
          OrderItem.create!(
            order: order,
            product_id: item_params[:product_id],
            quantity: item_params[:quantity],
            price: item_params[:price]
          )
        end
        
        # Atualizar estoque
        update_inventory(order)
        
        # Enviar notificação
        OrderMailer.confirmation(order).deliver_later
        
        order
      end
    end

    private

    def update_inventory(order)
      order.items.each do |item|
        item.product.decrement!(:stock, item.quantity)
      end
    end
  end
end
```

---

## 2. Exemplos de Domain Objects

### 2.1 Domain Object Básico

```ruby
# app/domains/users/create.rb
module Users
  class Create < Schema
    attribute :email, :string
    attribute :password, :string
    attribute :password_confirmation, :string

    validates :email, presence: true,
                     format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true,
                        length: { minimum: 8 }
    validates :password_confirmation, presence: true
    validate :passwords_match

    def validate!
      raise Error::InvalidParams.new(errors.messages) unless valid?
      self
    end

    def to_model!
      User.new(
        email: email,
        password: password,
        password_confirmation: password_confirmation
      )
    end

    private

    def passwords_match
      return if password.blank? || password_confirmation.blank?
      return if password == password_confirmation

      errors.add(:password_confirmation, "não confere com a senha")
    end
  end
end
```

### 2.2 Domain Object com Transformação Complexa

```ruby
# Exemplo futuro: app/domains/products/create.rb
module Products
  class Create < Schema
    attribute :name, :string
    attribute :description, :string
    attribute :price, :decimal
    attribute :category_id, :integer
    attribute :images, :array, default: []

    validates :name, presence: true, length: { minimum: 3, maximum: 100 }
    validates :description, presence: true, length: { minimum: 10 }
    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :category_id, presence: true
    validate :category_exists
    validate :images_present

    def validate!
      raise Error::InvalidParams.new(errors.messages) unless valid?
      self
    end

    def to_model!
      product = Product.new(
        name: name,
        description: description,
        price: price,
        category_id: category_id,
        slug: generate_slug
      )
      
      # Adicionar imagens via ActiveStorage
      images.each do |image|
        product.images.attach(image)
      end
      
      product
    end

    private

    def category_exists
      return if category_id.blank?
      return if Category.exists?(category_id)

      errors.add(:category_id, "não existe")
    end

    def images_present
      return if images.present?

      errors.add(:images, "é obrigatório ter pelo menos uma imagem")
    end

    def generate_slug
      name.parameterize
    end
  end
end
```

---

## 3. Exemplos de Controllers

### 3.1 Controller "Skinny" (Atual)

```ruby
# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  def create
    user = Users::CreateService.call(user_params: user_params)
    sign_in(user)
    redirect_to after_sign_up_path_for(user)
  rescue Error::InvalidParams => e
    @user = User.new(user_params)
    @user.errors.add(:base, e.message)
    render :new, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
```

### 3.2 Controller com Múltiplas Ações (Futuro)

```ruby
# Exemplo futuro: app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Products::ListService.call(
      filters: params[:filters],
      page: params[:page],
      per_page: params[:per_page]
    )
  end

  def show
    @product = Products::ShowService.call(product_id: params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Products::CreateService.call(
      product_params: product_params,
      user: current_user
    )
    redirect_to @product, notice: 'Produto criado com sucesso!'
  rescue Error::InvalidParams => e
    @product = Product.new(product_params)
    flash.now[:error] = e.message
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    @product = Products::UpdateService.call(
      product_id: params[:id],
      product_params: product_params,
      user: current_user
    )
    redirect_to @product, notice: 'Produto atualizado com sucesso!'
  rescue Error::InvalidParams => e
    flash.now[:error] = e.message
    render :edit, status: :unprocessable_entity
  rescue Error::Forbidden => e
    redirect_to products_path, alert: 'Você não tem permissão para isso.'
  end

  def destroy
    Products::DestroyService.call(
      product_id: params[:id],
      user: current_user
    )
    redirect_to products_path, notice: 'Produto removido com sucesso!'
  rescue Error::Forbidden => e
    redirect_to products_path, alert: 'Você não tem permissão para isso.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name, :description, :price, :category_id,
      images: []
    )
  end
end
```

---

## 4. Exemplos de Models

### 4.1 Model com Relacionamentos

```ruby
# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :user_info, dependent: :destroy
  # Futuro: has_many :products
  # Futuro: has_many :orders

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  accepts_nested_attributes_for :user_info

  # Métodos auxiliares
  def full_name
    user_info&.full_name || email
  end

  def profile_complete?
    user_info.present? && 
    user_info.first_name.present? && 
    user_info.last_name.present? && 
    user_info.phone.present?
  end
end
```

### 4.2 Model com Enums e Validações

```ruby
# app/models/user_info.rb
class UserInfo < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :address, optional: true
  extend FriendlyId

  enum :gender, { 
    male: "male", 
    female: "female", 
    not_respond: "not_respond" 
  }
  
  enum :rg_uf, {
    AC: "AC", AL: "AL", AP: "AP", AM: "AM",
    BA: "BA", CE: "CE", DF: "DF", ES: "ES",
    GO: "GO", MA: "MA", MT: "MT", MS: "MS",
    MG: "MG", PA: "PA", PB: "PB", PR: "PR",
    PE: "PE", PI: "PI", RJ: "RJ", RN: "RN",
    RS: "RS", RO: "RO", RR: "RR", SC: "SC",
    SP: "SP", SE: "SE", TO: "TO"
  }

  friendly_id :full_name, use: :slugged

  has_one_attached :avatar

  validates :phone, presence: true, 
                    numericality: true, 
                    length: { minimum: 10, maximum: 15 }
  validates :cpf, presence: true, 
                  format: { with: /\A\d{11}\z/ }
  validates :rg, presence: true

  accepts_nested_attributes_for :address

  def full_name
    "#{first_name} #{last_name}"
  end
end
```

---

## 5. Exemplos de Background Jobs

### 5.1 Job Simples (ActiveJob)

```ruby
# Exemplo futuro: app/jobs/order_confirmation_job.rb
class OrderConfirmationJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find(order_id)
    OrderMailer.confirmation(order).deliver_now
  end
end
```

**Uso:**
```ruby
# Em um service
OrderConfirmationJob.perform_later(order.id)
```

### 5.2 Sidekiq Worker

```ruby
# Exemplo futuro: app/workers/image_processing_worker.rb
class ImageProcessingWorker
  include Sidekiq::Worker

  def perform(product_id)
    product = Product.find(product_id)
    
    product.images.each do |image|
      # Processar imagem (redimensionar, otimizar, etc.)
      image.variant(resize_to_limit: [800, 600]).processed
    end
  end
end
```

**Uso:**
```ruby
# Em um service
ImageProcessingWorker.perform_async(product.id)
```

---

## 6. Exemplos de Validações Customizadas

### 6.1 Validator Customizado

```ruby
# Exemplo futuro: app/validators/cpf_validator.rb
class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if valid_cpf?(value)

    record.errors.add(attribute, "não é um CPF válido")
  end

  private

  def valid_cpf?(cpf)
    # Lógica de validação de CPF
    cpf = cpf.gsub(/\D/, '')
    return false unless cpf.length == 11
    
    # Algoritmo de validação de CPF
    # ...
    true
  end
end
```

**Uso:**
```ruby
# app/models/user_info.rb
validates :cpf, cpf: true
```

---

## 7. Exemplos de Views

### 7.1 View com Partials

```erb
<!-- app/views/products/show.html.erb -->
<% content_for :title, @product.name %>

<div class="container mx-auto px-4 py-8">
  <div class="grid md:grid-cols-2 gap-8">
    <!-- Imagens -->
    <div>
      <%= render "products/image_gallery", product: @product %>
    </div>
    
    <!-- Informações -->
    <div>
      <%= render "products/product_info", product: @product %>
      <%= render "products/product_actions", product: @product %>
    </div>
  </div>
  
  <!-- Descrição -->
  <div class="mt-8">
    <%= render "products/product_description", product: @product %>
  </div>
</div>
```

### 7.2 Partial Reutilizável

```erb
<!-- app/views/shared/_form_errors.html.erb -->
<% if resource.errors.any? %>
  <div class="rounded-lg bg-red-50 border border-red-200 p-4 mb-4">
    <div class="flex">
      <div class="flex-shrink-0">
        <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
        </svg>
      </div>
      <div class="ml-3">
        <h3 class="text-sm font-medium text-red-800">
          <%= pluralize(resource.errors.count, "erro") %> impediram que este formulário fosse salvo:
        </h3>
        <div class="mt-2 text-sm text-red-700">
          <ul class="list-disc pl-5 space-y-1">
            <% resource.errors.full_messages.each do |message| %>
              <li><%= message %></li>
            <% end %>
          </ul>
        </div>
      </div>
    </div>
  </div>
<% end %>
```

---

## 8. Exemplos de Testes (Futuro)

### 8.1 Teste de Service Object

```ruby
# spec/domains/users/create_service_spec.rb
RSpec.describe Users::CreateService do
  describe ".call" do
    context "com parâmetros válidos" do
      let(:params) do
        {
          email: "user@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      end

      it "cria um novo usuário" do
        expect {
          Users::CreateService.call(user_params: params)
        }.to change(User, :count).by(1)
      end

      it "retorna o usuário criado" do
        user = Users::CreateService.call(user_params: params)
        expect(user).to be_a(User)
        expect(user.email).to eq("user@example.com")
      end
    end

    context "com parâmetros inválidos" do
      let(:params) do
        {
          email: "invalid-email",
          password: "123",
          password_confirmation: "456"
        }
      end

      it "não cria um usuário" do
        expect {
          Users::CreateService.call(user_params: params)
        }.to raise_error(Error::InvalidParams)
      end
    end
  end
end
```

### 8.2 Teste de Controller

```ruby
# spec/controllers/users/registrations_controller_spec.rb
RSpec.describe Users::RegistrationsController, type: :controller do
  describe "POST #create" do
    context "com parâmetros válidos" do
      let(:params) do
        {
          user: {
            email: "user@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      end

      it "cria um novo usuário" do
        expect {
          post :create, params: params
        }.to change(User, :count).by(1)
      end

      it "redireciona para welcome" do
        post :create, params: params
        expect(response).to redirect_to(welcome_path)
      end
    end
  end
end
```

---

## 9. Padrões de Nomenclatura

### 9.1 Services

```
{Entity}::{Action}Service

Exemplos:
- Users::CreateService
- Users::UpdateService
- Products::CreateService
- Orders::CreateService
- Orders::CancelService
```

### 9.2 Domain Objects

```
{Entity}::{Action}

Exemplos:
- Users::Create
- Users::Update
- Products::Create
- Products::Update
```

### 9.3 Controllers

```
{Entity}Controller (singular)
{Entity}::{SubEntity}Controller (namespaced)

Exemplos:
- ProductsController
- OrdersController
- Users::RegistrationsController
- Admin::ProductsController
```

### 9.4 Models

```
{Entity} (singular)

Exemplos:
- User
- Product
- Order
- OrderItem
```

---

## 10. Checklist para Nova Funcionalidade

Ao adicionar uma nova funcionalidade, seguir esta checklist:

- [ ] **Domain Object**
  - [ ] Criar `app/domains/{entity}/{action}.rb`
  - [ ] Definir attributes
  - [ ] Adicionar validações
  - [ ] Implementar `validate!`
  - [ ] Implementar `to_model!`

- [ ] **Service Object**
  - [ ] Criar `app/domains/{entity}/{action}_service.rb`
  - [ ] Implementar `.call` method
  - [ ] Usar Domain Object para validação
  - [ ] Tratar erros apropriadamente

- [ ] **Controller**
  - [ ] Criar/atualizar controller
  - [ ] Chamar Service Object
  - [ ] Tratar erros e redirecionamentos
  - [ ] Adicionar autorização (Pundit)

- [ ] **Views**
  - [ ] Criar views necessárias
  - [ ] Adicionar partials reutilizáveis
  - [ ] Implementar tratamento de erros

- [ ] **Routes**
  - [ ] Adicionar rotas em `config/routes.rb`
  - [ ] Seguir convenções REST

- [ ] **Tests**
  - [ ] Testes de Domain Object
  - [ ] Testes de Service Object
  - [ ] Testes de Controller
  - [ ] Testes de integração

- [ ] **Documentação**
  - [ ] Atualizar PRD se necessário
  - [ ] Adicionar comentários no código
  - [ ] Atualizar este documento se padrão novo

---

**Documento mantido por:** Tech Lead  
**Última atualização:** 2025-01-XX

