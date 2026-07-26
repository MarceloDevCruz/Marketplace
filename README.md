# Marketplace Platform

Uma plataforma moderna de marketplace desenvolvida em Ruby on Rails 8.0, projetada para conectar compradores e vendedores em um ecossistema seguro e escalável.

## 📋 Status do Projeto

**Fase Atual:** Fase 1 - Fundação ✅

### Funcionalidades Implementadas
- ✅ Sistema de autenticação (Login, Registro, Logout)
- ✅ Página Home
- ✅ Estrutura base de usuários e perfis
- ✅ Design system com Tailwind CSS
- ✅ Arquitetura de domínios e serviços

### Próximas Fases
- 🔄 Perfil e Configurações
- 📦 Gestão de Produtos
- 🛒 Carrinho e Checkout
- 📋 Sistema de Pedidos

## 🚀 Tecnologias

### Backend
- **Ruby on Rails 8.0.4** - Framework principal
- **PostgreSQL** - Banco de dados
- **Redis** - Cache e jobs
- **Sidekiq** - Background jobs

### Frontend
- **Tailwind CSS 4.4** - Framework de estilos
- **Stimulus** - JavaScript framework
- **Turbo** - SPA-like navigation
- **Import Maps** - ESM modules

### Autenticação & Autorização
- **Devise** - Autenticação
- **Pundit** - Autorização (preparado)

### Outras Bibliotecas
- **FriendlyId** - URLs amigáveis
- **ActiveStorage** - Upload de arquivos
- **Ransack** - Busca e filtros
- **ActiveAdmin** - Painel administrativo

## 📁 Estrutura do Projeto

```
app/
├── controllers/      # Controllers Rails (MVC)
├── models/           # Models ActiveRecord
├── views/            # Templates ERB
├── domains/          # 🎯 Domain Layer (DDD)
│   ├── users/        # Domínio de usuários
│   └── user_infos/   # Domínio de informações
├── services/         # Service objects
├── jobs/             # Background jobs
├── workers/          # Sidekiq workers
├── mailers/          # Email templates
├── errors/           # Custom error classes
└── javascript/       # Stimulus controllers
```

## 🏗️ Arquitetura

O projeto segue princípios de **Clean Architecture** e **Domain-Driven Design (DDD)**:

- **Service Objects:** Lógica de negócio isolada
- **Domain Objects:** Validação e transformação de dados
- **MVC Pattern:** Padrão Rails tradicional
- **Error Handling:** Hierarquia de erros customizados

### Fluxo de Dados

```
Request → Controller → Service → Domain Object → Model → Database
                                                          ↓
Response ← View ← Controller ← Service ← Domain Object ←
```

## 📚 Documentação

### Documentos Principais

1. **[PRD_MARKETPLACE.md](./PRD_MARKETPLACE.md)**
   - Product Requirements Document completo
   - Funcionalidades implementadas e planejadas
   - Requisitos funcionais e não-funcionais
   - Roadmap e cronograma

2. **[ARQUITETURA_E_ESTRUTURA.md](./ARQUITETURA_E_ESTRUTURA.md)**
   - Estrutura completa de pastas
   - Design patterns implementados
   - Estrutura lógica do projeto
   - Convenções e padrões de código

3. **[EXEMPLOS_E_PADROES.md](./EXEMPLOS_E_PADROES.md)**
   - Exemplos práticos de código
   - Service Objects
   - Domain Objects
   - Controllers, Models, Views
   - Padrões de nomenclatura

## 🛠️ Configuração e Instalação

### Pré-requisitos
- Ruby 3.3+
- PostgreSQL
- Redis
- Node.js (para assets)

### Instalação

1. Clone o repositório:
```bash
git clone <repository-url>
cd Marketplace
```

2. Instale as dependências:
```bash
bundle install
```

3. Configure o banco de dados:
```bash
rails db:create
rails db:migrate
```

4. Inicie o servidor:
```bash
bin/dev
```

A aplicação estará disponível em `http://localhost:3000`

## 🧪 Testes

```bash
# Testes Minitest (atual)
rails test

# Testes RSpec (futuro)
bundle exec rspec
```

## 📝 Convenções de Código

### Service Objects
```ruby
# Padrão: {Entity}::{Action}Service
Users::CreateService.call(user_params: params)
```

### Domain Objects
```ruby
# Padrão: {Entity}::{Action}
Users::Create.new(params).validate!.to_model!
```

### Controllers
- Mantidos "skinny" (lógica delegada para services)
- Apenas coordenação e renderização

## 🎨 Design System

### Cores Principais
- Background: `#0b1f39` (azul escuro)
- Accent: `#113056`, `#16406f` (gradientes azuis)
- Primary: `#3b82f6` (blue-500)

### Componentes
- Cards com glassmorphism (backdrop-blur)
- Botões com estados hover/active
- Formulários com validação visual
- Design responsivo (mobile-first)

## 🔐 Segurança

- ✅ Autenticação com Devise
- ✅ Validação de senhas
- ✅ CSRF protection
- ✅ SQL injection protection (ActiveRecord)
- 🔄 Autorização com Pundit (preparado)

## 📊 Banco de Dados

### Modelos Principais
- `users` - Autenticação (Devise)
- `user_infos` - Informações complementares
- `addresses` - Endereços

### Relacionamentos
```
User (1) ──< (1) UserInfo (1) ──< (N) Address
```

## 🚦 Rotas Principais

```
/                    # Home
/login               # Login
/cadastrar           # Registro
/logout              # Logout (DELETE)
/welcome             # Boas-vindas
```

## 🤝 Contribuindo

1. Siga os padrões de código documentados
2. Use Service Objects para lógica de negócio
3. Mantenha controllers "skinny"
4. Adicione testes para novas funcionalidades
5. Atualize a documentação quando necessário

## 📋 Checklist para Nova Funcionalidade

- [ ] Criar Domain Object (`app/domains/{entity}/{action}.rb`)
- [ ] Criar Service Object (`app/domains/{entity}/{action}_service.rb`)
- [ ] Criar/Atualizar Controller
- [ ] Criar Views
- [ ] Adicionar Rotas
- [ ] Adicionar Testes
- [ ] Atualizar Documentação

## 📞 Contato

Para dúvidas ou sugestões, consulte a documentação completa ou entre em contato com a equipe de desenvolvimento.

## 📄 Licença

[Adicionar licença]

---

**Última atualização:** 2025-01-XX
