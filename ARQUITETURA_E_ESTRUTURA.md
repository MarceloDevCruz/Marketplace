# Documentação de Arquitetura e Estrutura
## Marketplace Platform

**Versão:** 1.0  
**Data:** 2025-01-XX

---

## 1. Visão Geral da Arquitetura

O Marketplace é construído seguindo os princípios de **Clean Architecture** e **Domain-Driven Design (DDD)**, utilizando Ruby on Rails 8.0 como framework principal. A arquitetura combina padrões Rails tradicionais com abstrações de domínio para manter o código organizado, testável e escalável.

---

## 2. Estrutura de Pastas

### 2.1 Estrutura Completa do Projeto

```
Marketplace/
├── app/                          # Código da aplicação
│   ├── assets/                   # Assets estáticos
│   │   ├── builds/              # Assets compilados
│   │   │   └── tailwind/        # CSS compilado do Tailwind
│   │   ├── images/              # Imagens estáticas
│   │   ├── stylesheets/         # Stylesheets SCSS/CSS
│   │   └── tailwind/            # Arquivos fonte do Tailwind
│   │
│   ├── controllers/             # Controllers Rails (MVC)
│   │   ├── application_controller.rb    # Controller base
│   │   ├── homepage_controller.rb      # Controller da home
│   │   ├── welcome_controller.rb       # Controller de boas-vindas
│   │   ├── concerns/            # Concerns compartilhados
│   │   └── users/               # Controllers de usuários (Devise)
│   │       ├── confirmations_controller.rb
│   │       ├── omniauth_callbacks_controller.rb
│   │       ├── passwords_controller.rb
│   │       ├── registrations_controller.rb
│   │       ├── sessions_controller.rb
│   │       └── unlocks_controller.rb
│   │
│   ├── models/                  # Models ActiveRecord
│   │   ├── application_record.rb       # Model base
│   │   ├── user.rb                     # Model de usuário (Devise)
│   │   ├── user_info.rb                # Informações complementares
│   │   ├── address.rb                  # Model de endereço
│   │   └── concerns/           # Concerns de models
│   │
│   ├── views/                   # Templates ERB
│   │   ├── layouts/             # Layouts principais
│   │   │   ├── application.html.erb
│   │   │   ├── mailer.html.erb
│   │   │   └── mailer.text.erb
│   │   ├── shared/              # Partials compartilhados
│   │   │   ├── _header.html.erb
│   │   │   └── _footer.html.erb
│   │   ├── devise/              # Views do Devise
│   │   │   ├── confirmations/
│   │   │   ├── mailer/
│   │   │   ├── passwords/
│   │   │   ├── registrations/
│   │   │   ├── sessions/
│   │   │   ├── shared/
│   │   │   └── unlocks/
│   │   ├── homepage/            # View da home
│   │   │   └── homepage.html.erb
│   │   ├── welcome/             # Views de boas-vindas
│   │   └── pwa/                 # PWA files
│   │       ├── manifest.json.erb
│   │       └── service-worker.js
│   │
│   ├── domains/                  # 🎯 DOMAIN LAYER (DDD)
│   │   ├── schema.rb            # Classe base para schemas
│   │   ├── users/               # Domínio de usuários
│   │   │   ├── create_service.rb    # Service object
│   │   │   └── create.rb            # Domain object (schema)
│   │   └── user_infos/          # Domínio de informações
│   │       ├── update_sevice.rb     # Service object
│   │       └── update.rb            # Domain object
│   │
│   ├── services/                # Service objects (camada de aplicação)
│   │   └── user_infos/          # Serviços relacionados a user_infos
│   │
│   ├── jobs/                    # Background jobs (ActiveJob)
│   │   ├── application_job.rb   # Job base
│   │   └── user_infos/          # Jobs relacionados a user_infos
│   │
│   ├── workers/                 # Sidekiq workers
│   │   └── user_infos/          # Workers relacionados a user_infos
│   │
│   ├── listeners/               # Event listeners
│   │   └── user_infos/          # Listeners relacionados a user_infos
│   │
│   ├── mailers/                 # Email templates
│   │   └── application_mailer.rb
│   │
│   ├── serializers/             # JSON serializers (futuro)
│   │
│   ├── validators/              # Custom validators
│   │
│   ├── errors/                  # Custom error classes
│   │   └── error.rb             # Hierarquia de erros
│   │
│   ├── decorators/              # Decorators (futuro)
│   │
│   ├── helpers/                 # View helpers
│   │   └── application_helper.rb
│   │
│   └── javascript/              # JavaScript/Stimulus
│       ├── application.js
│       └── controllers/         # Stimulus controllers
│           ├── application.js
│           ├── hello_controller.js
│           └── index.js
│
├── config/                      # Configurações
│   ├── application.rb           # Configuração principal
│   ├── boot.rb                  # Boot configuration
│   ├── routes.rb                # Rotas da aplicação
│   ├── database.yml             # Config do banco
│   ├── puma.rb                  # Config do servidor
│   ├── environments/            # Config por ambiente
│   │   ├── development.rb
│   │   ├── production.rb
│   │   └── test.rb
│   ├── initializers/            # Inicializadores
│   │   ├── devise.rb
│   │   ├── sidekiq.rb
│   │   ├── friendly_id.rb
│   │   └── ...
│   └── locales/                # I18n
│       ├── en.yml
│       └── devise.en.yml
│
├── db/                          # Banco de dados
│   ├── schema.rb                # Schema atual
│   ├── seeds.rb                 # Seeds
│   ├── migrate/                 # Migrations
│   ├── cable_schema.rb          # Action Cable schema
│   ├── cache_schema.rb          # Solid Cache schema
│   └── queue_schema.rb          # Solid Queue schema
│
├── lib/                         # Bibliotecas customizadas
│   └── tasks/                   # Rake tasks
│
├── spec/                        # Testes RSpec (futuro)
│
├── test/                        # Testes Minitest
│   ├── controllers/
│   ├── models/
│   ├── helpers/
│   ├── integration/
│   ├── mailers/
│   ├── system/
│   └── fixtures/
│
├── public/                      # Arquivos públicos
│   ├── 400.html, 404.html, etc. # Páginas de erro
│   ├── icon.png, icon.svg       # Ícones
│   └── robots.txt
│
├── storage/                     # Active Storage files
│
├── tmp/                         # Arquivos temporários
│   ├── cache/
│   ├── pids/
│   └── sockets/
│
├── vendor/                      # Dependências vendor
│   └── javascript/
│
├── bin/                         # Scripts executáveis
│   ├── rails
│   ├── rake
│   ├── setup
│   └── ...
│
├── config.ru                    # Rack config
├── Gemfile                      # Dependências Ruby
├── Gemfile.lock                 # Versões lockadas
├── Rakefile                     # Rake tasks
├── README.md                    # Documentação
├── Dockerfile                   # Docker config
├── Procfile.dev                 # Processos de desenvolvimento
└── .gitignore                   # Git ignore
```

---

## 3. Design Patterns Implementados

### 3.1 Service Object Pattern

**Localização:** `app/domains/*/` e `app/services/*/`

**Propósito:** Isolar lógica de negócio complexa dos controllers, mantendo-os "skinny" e focados apenas em coordenação.

**Exemplo:**
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

**Uso no Controller:**
```ruby
# app/controllers/users/registrations_controller.rb
def create
  user = Users::CreateService.call(user_params: user_params)
  # ...
end
```

**Benefícios:**
- ✅ Separação de responsabilidades
- ✅ Testabilidade
- ✅ Reutilização
- ✅ Manutenibilidade

### 3.2 Domain Object Pattern (Schema Pattern)

**Localização:** `app/domains/*/`

**Propósito:** Validar e transformar dados antes de criar models, seguindo princípios de DDD.

**Exemplo:**
```ruby
# app/domains/users/create.rb
module Users
  class Create < Schema
    attribute :email, :string
    attribute :password, :string
    attribute :password_confirmation, :string

    def validate!
      raise Error::InvalidParams.new(errors.messages) unless valid?
      self
    end

    def to_model!
      User.new(attributes)
    end
  end
end
```

**Classe Base:**
```ruby
# app/domains/schema.rb
class Schema
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  def validate!
    raise NotImplementedError "not implemented"
  end
end
```

**Benefícios:**
- ✅ Validação centralizada
- ✅ Transformação de dados
- ✅ Testabilidade isolada
- ✅ Type safety com ActiveModel::Attributes

### 3.3 MVC Pattern (Rails Tradicional)

**Localização:** `app/controllers/`, `app/models/`, `app/views/`

**Propósito:** Padrão fundamental do Rails para organização de código.

**Estrutura:**
- **Models:** `app/models/` - Lógica de dados e validações
- **Views:** `app/views/` - Templates de apresentação
- **Controllers:** `app/controllers/` - Coordenação entre models e views

### 3.4 Repository Pattern (Implícito)

**Localização:** `app/models/`

**Propósito:** ActiveRecord atua como repositório, abstraindo acesso ao banco de dados.

**Exemplo:**
```ruby
# app/models/user.rb
class User < ApplicationRecord
  # ActiveRecord fornece métodos como:
  # User.find(id)
  # User.where(...)
  # User.create(...)
  # etc.
end
```

### 3.5 Error Handling Pattern

**Localização:** `app/errors/error.rb`

**Propósito:** Hierarquia de erros customizados para tratamento consistente.

**Estrutura:**
```ruby
# app/errors/error.rb
class Error
  class Unauthorized < StandardError; end
  class Forbidden < StandardError; end
  class NotFound < StandardError; end
  class UnprocessableEntity < StandardError; end
  class InternalServerError < StandardError; end
  class InvalidParams < StandardError; end
end
```

**Uso:**
```ruby
# app/domains/users/create.rb
def validate!
  raise Error::InvalidParams.new(errors.messages) unless valid?
  self
end
```

### 3.6 Decorator Pattern (Preparado)

**Localização:** `app/decorators/`

**Status:** Estrutura criada, aguardando implementação

**Propósito:** Adicionar lógica de apresentação aos models sem modificar a classe original.

### 3.7 Observer Pattern (Preparado)

**Localização:** `app/listeners/`

**Status:** Estrutura criada, aguardando implementação

**Propósito:** Reagir a eventos do sistema (ex: após criar usuário, enviar email).

---

## 4. Estrutura Lógica do Projeto

### 4.1 Fluxo de Autenticação

```
1. Usuário acessa /cadastrar
   ↓
2. Users::RegistrationsController#new
   ↓
3. Renderiza app/views/devise/registrations/new.html.erb
   ↓
4. Usuário preenche formulário e submete
   ↓
5. Users::RegistrationsController#create
   ↓
6. Users::CreateService.call(user_params:)
   ↓
7. Users::Create.new(params).validate!.to_model!.save!
   ↓
8. User criado no banco
   ↓
9. ApplicationController#after_sign_up_path_for
   ↓
10. Redireciona para /welcome
```

### 4.2 Fluxo de Login

```
1. Usuário acessa /login
   ↓
2. Users::SessionsController#new
   ↓
3. Renderiza app/views/devise/sessions/new.html.erb
   ↓
4. Usuário preenche credenciais e submete
   ↓
5. Users::SessionsController#create (Devise)
   ↓
6. Devise autentica usuário
   ↓
7. ApplicationController#after_sign_in_path_for
   ↓
8. Verifica profile_complete?(user)
   ↓
9. Se incompleto → /welcome
   Se completo → root_path
```

### 4.3 Estrutura de Dados

**Relacionamentos:**
```
User (1) ──< (1) UserInfo (1) ──< (N) Address
```

**Detalhamento:**
- `User`: Autenticação (email, password)
- `UserInfo`: Informações complementares (nome, telefone, CPF, RG, etc.)
- `Address`: Endereço físico (rua, cidade, estado, CEP, etc.)

### 4.4 Camadas da Aplicação

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Controllers, Views, Helpers)      │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│        Application Layer            │
│  (Services, Jobs, Mailers)           │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│          Domain Layer               │
│  (Domain Objects, Schemas)          │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│        Infrastructure Layer         │
│  (Models, Database, External APIs)  │
└─────────────────────────────────────┘
```

### 4.5 Fluxo de Dados Típico

```
Request → Controller → Service → Domain Object → Model → Database
                                                          ↓
Response ← View ← Controller ← Service ← Domain Object ←
```

---

## 5. Convenções e Padrões de Código

### 5.1 Nomenclatura

**Controllers:**
- Nome no plural: `Users::RegistrationsController`
- Namespace para agrupamento: `Users::`

**Models:**
- Nome no singular: `User`, `UserInfo`
- Relacionamentos: `has_one`, `belongs_to`, `has_many`

**Services:**
- Padrão: `{Domain}::{Action}Service`
- Exemplo: `Users::CreateService`
- Método principal: `.call`

**Domain Objects:**
- Padrão: `{Domain}::{Action}`
- Exemplo: `Users::Create`
- Herda de `Schema`

**Views:**
- Seguem estrutura de controllers
- Partials com `_` prefix: `_header.html.erb`

### 5.2 Organização de Código

**Controllers:**
- Mantidos "skinny" (lógica delegada para services)
- Apenas coordenação e renderização

**Models:**
- Validações e relacionamentos
- Lógica de domínio simples
- Sem lógica de negócio complexa

**Services:**
- Lógica de negócio complexa
- Orquestração de múltiplos models
- Transações quando necessário

**Domain Objects:**
- Validação de dados
- Transformação de dados
- Regras de negócio de validação

### 5.3 Tratamento de Erros

**Estratégia:**
1. Validações em Domain Objects
2. Erros customizados em `app/errors/`
3. Tratamento em controllers ou middleware

**Exemplo:**
```ruby
begin
  user = Users::CreateService.call(user_params: params)
rescue Error::InvalidParams => e
  # Tratar erro de validação
end
```

---

## 6. Dependências e Integrações

### 6.1 Gems Principais

| Gem | Propósito | Versão |
|-----|-----------|--------|
| rails | Framework principal | ~> 8.0.4 |
| devise | Autenticação | - |
| pundit | Autorização | - |
| sidekiq | Background jobs | - |
| redis | Cache e jobs | ~> 5.0 |
| tailwindcss-rails | CSS framework | ~> 4.4 |
| friendly_id | URLs amigáveis | ~> 5.4 |
| activeadmin | Admin panel | - |
| ransack | Busca e filtros | - |

### 6.2 Infraestrutura

- **Database:** PostgreSQL
- **Cache:** Redis + Solid Cache
- **Jobs:** Sidekiq + Solid Queue
- **Web Server:** Puma
- **Asset Pipeline:** Propshaft

---

## 7. Próximos Passos de Arquitetura

### 7.1 Melhorias Planejadas

1. **Event Sourcing** (futuro)
   - Para auditoria e rastreabilidade
   - Localização: `app/events/`

2. **CQRS** (futuro)
   - Separação de comandos e queries
   - Localização: `app/commands/`, `app/queries/`

3. **API Layer** (futuro)
   - Endpoints JSON para mobile/web
   - Localização: `app/controllers/api/`
   - Serializers em `app/serializers/`

4. **GraphQL** (opcional)
   - Para APIs flexíveis
   - Localização: `app/graphql/`

---

## 8. Guia de Contribuição

### 8.1 Adicionando Nova Funcionalidade

1. **Criar Domain Object:**
   ```ruby
   # app/domains/{domain}/{action}.rb
   module {Domain}
     class {Action} < Schema
       # attributes e validações
     end
   end
   ```

2. **Criar Service:**
   ```ruby
   # app/domains/{domain}/{action}_service.rb
   module {Domain}
     class {Action}Service
       def self.call(params:)
         new(params).call
       end
       # implementação
     end
   end
   ```

3. **Criar/Atualizar Controller:**
   ```ruby
   # app/controllers/{resource}_controller.rb
   def action
     result = {Domain}::{Action}Service.call(params: params)
     # render ou redirect
   end
   ```

4. **Criar Views:**
   ```erb
   # app/views/{resource}/{action}.html.erb
   ```

### 8.2 Testes

**Estrutura:**
- Unit tests: `test/models/`, `test/domains/`
- Integration tests: `test/integration/`
- System tests: `test/system/`

**Futuro:** Migração para RSpec em `spec/`

---

## 9. Referências

- [Rails Guides](https://guides.rubyonrails.org)
- [Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html)
- [Service Objects in Rails](https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Documento mantido por:** Tech Lead  
**Última atualização:** 2025-01-XX

