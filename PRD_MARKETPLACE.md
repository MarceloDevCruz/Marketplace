# Product Requirements Document (PRD)
## Marketplace Platform

**Versão:** 1.0  
**Data:** 2025-01-XX  
**Autor:** Product Manager  
**Status:** Em Desenvolvimento

---

## 1. Visão Geral do Produto

### 1.1 Resumo Executivo
O Marketplace é uma plataforma digital moderna desenvolvida em Ruby on Rails 8.0, projetada para conectar compradores e vendedores em um ecossistema seguro, escalável e performático. A plataforma está na fase inicial de desenvolvimento, com funcionalidades básicas de autenticação implementadas.

### 1.2 Objetivos do Produto
- **Objetivo Principal:** Criar uma plataforma de marketplace completa que permita a compra e venda de produtos/serviços de forma segura e intuitiva.

- **Objetivos Secundários:**
  - Fornecer experiência de usuário moderna e responsiva
  - Garantir segurança e privacidade dos dados
  - Escalar para suportar milhares de usuários simultâneos
  - Facilitar transações entre compradores e vendedores

### 1.3 Público-Alvo
- **Usuários Primários:** Compradores e vendedores que buscam uma plataforma confiável para transações online
- **Usuários Secundários:** Administradores da plataforma

### 1.4 Estado Atual
O produto está na **Fase 1 - Fundação**, com as seguintes funcionalidades implementadas:
- ✅ Sistema de autenticação (Login, Registro, Logout)
- ✅ Página Home
- ✅ Estrutura base de usuários e perfis
- ✅ Design system com Tailwind CSS
- ✅ Arquitetura de domínios e serviços

---

## 2. Funcionalidades Implementadas (MVP Fase 1)

### 2.1 Autenticação de Usuários

#### 2.1.1 Registro de Usuário
**Prioridade:** Crítica  
**Status:** ✅ Implementado

**Descrição:**
Permite que novos usuários criem uma conta na plataforma.

**Requisitos Funcionais:**
- RF-001: Usuário deve poder se registrar com email e senha
- RF-002: Sistema deve validar formato de email
- RF-003: Sistema deve validar senha (mínimo de caracteres)
- RF-004: Sistema deve confirmar senha antes de criar conta
- RF-005: Após registro, usuário deve ser redirecionado para página de boas-vindas

**Requisitos Não-Funcionais:**
- RNF-001: Formulário deve ser responsivo (mobile-first)
- RNF-002: Validações devem ocorrer em tempo real
- RNF-003: Mensagens de erro devem ser claras e acionáveis

**Fluxo:**
1. Usuário acessa `/cadastrar`
2. Preenche email, senha e confirmação de senha
3. Sistema valida dados
4. Cria conta e redireciona para `/welcome`

#### 2.1.2 Login de Usuário
**Prioridade:** Crítica  
**Status:** ✅ Implementado

**Descrição:**
Permite que usuários autenticados acessem a plataforma.

**Requisitos Funcionais:**
- RF-006: Usuário deve poder fazer login com email e senha
- RF-007: Sistema deve validar credenciais
- RF-008: Sistema deve oferecer opção "Lembrar-me"
- RF-009: Sistema deve redirecionar para página apropriada após login
- RF-010: Se perfil incompleto, redirecionar para `/welcome`

**Fluxo:**
1. Usuário acessa `/login`
2. Preenche email e senha
3. Sistema autentica
4. Redireciona baseado no estado do perfil

#### 2.1.3 Logout
**Prioridade:** Crítica  
**Status:** ✅ Implementado

**Descrição:**
Permite que usuários encerrem sua sessão.

**Requisitos Funcionais:**
- RF-011: Usuário deve poder fazer logout
- RF-012: Sistema deve confirmar ação antes de encerrar sessão
- RF-013: Após logout, usuário deve ser redirecionado para home

### 2.2 Página Home
**Prioridade:** Alta  
**Status:** ✅ Implementado

**Descrição:**
Página inicial da plataforma que apresenta o marketplace e convida usuários a se cadastrarem.

**Requisitos Funcionais:**
- RF-014: Página deve exibir informações sobre o marketplace
- RF-015: Página deve ter call-to-action para registro/login
- RF-016: Página deve ser acessível sem autenticação

**Requisitos Não-Funcionais:**
- RNF-004: Página deve carregar em menos de 2 segundos
- RNF-005: Design deve ser moderno e atraente

### 2.3 Perfil de Usuário (Estrutura Base)
**Prioridade:** Média  
**Status:** ⚠️ Parcialmente Implementado

**Descrição:**
Estrutura base para informações de perfil do usuário.

**Modelos Implementados:**
- `User`: Autenticação (Devise)
- `UserInfo`: Informações complementares (nome, telefone, CPF, RG, etc.)
- `Address`: Endereço do usuário

**Status:**
- ✅ Modelos criados
- ✅ Relacionamentos definidos
- ⚠️ Interface de edição não implementada

---

## 3. Funcionalidades Planejadas (Roadmap)

### 3.1 Fase 2 - Perfil e Configurações (Próxima)
**Prioridade:** Alta  
**Estimativa:** 2-3 sprints

**Funcionalidades:**
- [ ] Completar perfil de usuário
- [ ] Upload de avatar
- [ ] Edição de informações pessoais
- [ ] Gerenciamento de endereços
- [ ] Configurações de conta

### 3.2 Fase 3 - Produtos (Alta Prioridade)
**Prioridade:** Crítica  
**Estimativa:** 4-6 sprints

**Funcionalidades:**
- [ ] CRUD de produtos
- [ ] Upload de imagens de produtos
- [ ] Categorias de produtos
- [ ] Busca e filtros
- [ ] Visualização de produtos
- [ ] Gestão de estoque

### 3.3 Fase 4 - Carrinho e Checkout
**Prioridade:** Crítica  
**Estimativa:** 3-4 sprints

**Funcionalidades:**
- [ ] Adicionar produtos ao carrinho
- [ ] Gerenciar carrinho
- [ ] Processo de checkout
- [ ] Seleção de endereço de entrega
- [ ] Cálculo de frete
- [ ] Processamento de pagamento

### 3.4 Fase 5 - Pedidos
**Prioridade:** Alta  
**Estimativa:** 2-3 sprints

**Funcionalidades:**
- [ ] Histórico de pedidos
- [ ] Detalhes do pedido
- [ ] Rastreamento de pedidos
- [ ] Status de pedidos
- [ ] Notificações de pedidos

### 3.5 Fase 6 - Avaliações e Comentários
**Prioridade:** Média  
**Estimativa:** 2 sprints

**Funcionalidades:**
- [ ] Sistema de avaliações
- [ ] Comentários em produtos
- [ ] Avaliações de vendedores
- [ ] Moderação de conteúdo

### 3.6 Fase 7 - Dashboard do Vendedor
**Prioridade:** Alta  
**Estimativa:** 3-4 sprints

**Funcionalidades:**
- [ ] Painel de controle do vendedor
- [ ] Estatísticas de vendas
- [ ] Gerenciamento de produtos
- [ ] Relatórios financeiros

### 3.7 Fase 8 - Notificações
**Prioridade:** Média  
**Estimativa:** 2 sprints

**Funcionalidades:**
- [ ] Notificações em tempo real
- [ ] Email notifications
- [ ] Push notifications (PWA)
- [ ] Preferências de notificação

### 3.8 Fase 9 - Admin Panel
**Prioridade:** Média  
**Estimativa:** 2-3 sprints

**Funcionalidades:**
- [ ] Dashboard administrativo (ActiveAdmin já configurado)
- [ ] Gerenciamento de usuários
- [ ] Gerenciamento de produtos
- [ ] Moderação de conteúdo
- [ ] Relatórios gerais

---

## 4. Requisitos Técnicos

### 4.1 Stack Tecnológica

**Backend:**
- Ruby on Rails 8.0.4
- PostgreSQL (banco de dados)
- Redis (cache e jobs)
- Sidekiq (background jobs)

**Frontend:**
- Tailwind CSS 4.4 (styling)
- Stimulus (JavaScript framework)
- Turbo (SPA-like navigation)
- Import Maps (ESM modules)

**Autenticação:**
- Devise (autenticação)

**Autorização:**
- Pundit (políticas de acesso)

**Outras Bibliotecas:**
- FriendlyId (URLs amigáveis)
- ActiveStorage (upload de arquivos)
- Ransack (busca e filtros)
- ActiveAdmin (painel administrativo)

### 4.2 Arquitetura

**Padrões de Design:**
- **Service Objects:** Lógica de negócio isolada em serviços
- **Domain Objects:** Schemas para validação e transformação
- **Repository Pattern:** (implícito através de models)
- **MVC:** Padrão Rails tradicional

**Estrutura de Pastas:**
```
app/
├── controllers/        # Controllers Rails
├── models/            # Models ActiveRecord
├── views/             # Templates ERB
├── domains/           # Domain objects e services
├── services/          # Service objects
├── jobs/              # Background jobs
├── mailers/           # Email templates
├── serializers/       # JSON serializers
├── validators/        # Custom validators
├── errors/            # Custom error classes
└── workers/           # Sidekiq workers
```

### 4.3 Banco de Dados

**Tabelas Principais:**
- `users`: Autenticação (Devise)
- `user_infos`: Informações complementares do usuário
- `addresses`: Endereços
- `friendly_id_slugs`: URLs amigáveis

**Relacionamentos:**
- User `has_one` UserInfo
- UserInfo `belongs_to` User
- UserInfo `belongs_to` Address
- Address `has_many` UserInfos

### 4.4 Segurança

**Implementado:**
- ✅ Autenticação com Devise
- ✅ Validação de senhas
- ✅ CSRF protection
- ✅ SQL injection protection (ActiveRecord)

**Planejado:**
- [ ] Autorização com Pundit
- [ ] Rate limiting
- [ ] HTTPS enforcement
- [ ] Content Security Policy
- [ ] Sanitização de inputs

### 4.5 Performance

**Implementado:**
- ✅ Solid Cache (cache)
- ✅ Solid Queue (jobs)
- ✅ Sidekiq (background processing)
- ✅ Redis (cache e jobs)

**Planejado:**
- [ ] CDN para assets
- [ ] Image optimization
- [ ] Database indexing
- [ ] Query optimization
- [ ] Caching strategies

---

## 5. Design e UX

### 5.1 Design System

**Cores Principais:**
- Background: `#0b1f39` (azul escuro)
- Accent: `#113056`, `#16406f` (gradientes azuis)
- Primary: `#3b82f6` (blue-500)
- Text: Branco e tons de azul claro

**Componentes:**
- Cards com glassmorphism (backdrop-blur)
- Botões com estados hover/active
- Formulários com validação visual
- Gradientes e sombras para profundidade

### 5.2 Responsividade

**Breakpoints:**
- Mobile: < 640px
- Tablet: 640px - 1024px
- Desktop: > 1024px

**Princípios:**
- Mobile-first approach
- Layouts adaptativos
- Touch-friendly interfaces

### 5.3 Acessibilidade

**Implementado:**
- ✅ Semantic HTML
- ✅ Labels em formulários
- ✅ Focus states

**Planejado:**
- [ ] ARIA labels
- [ ] Keyboard navigation
- [ ] Screen reader support
- [ ] Color contrast compliance

---

## 6. Métricas e KPIs

### 6.1 Métricas de Produto

**Fase 1 (Atual):**
- Taxa de registro de novos usuários
- Taxa de conversão de visitantes para usuários
- Taxa de retenção de usuários

**Fases Futuras:**
- Número de produtos cadastrados
- Taxa de conversão de compras
- Ticket médio
- NPS (Net Promoter Score)

### 6.2 Métricas Técnicas

- Tempo de resposta das páginas (< 2s)
- Uptime (> 99.9%)
- Taxa de erros (< 0.1%)
- Performance do banco de dados

---

## 7. Riscos e Mitigações

### 7.1 Riscos Técnicos

| Risco | Impacto | Probabilidade | Mitigação |
|-------|---------|---------------|-----------|
| Escalabilidade do banco | Alto | Média | Indexação adequada, read replicas |
| Performance de uploads | Médio | Alta | CDN, processamento assíncrono |
| Segurança de pagamentos | Crítico | Baixa | Integração com gateway confiável |

### 7.2 Riscos de Produto

| Risco | Impacto | Probabilidade | Mitigação |
|-------|---------|---------------|-----------|
| Baixa adoção | Alto | Média | Marketing, onboarding otimizado |
| Concorrência | Médio | Alta | Diferenciação, foco em UX |

---

## 8. Cronograma e Milestones

### 8.1 Fase 1 - Fundação ✅
**Status:** Concluída
- Autenticação básica
- Página home
- Estrutura base

### 8.2 Fase 2 - Perfil
**Estimativa:** 2-3 sprints
**Início:** Próxima sprint

### 8.3 Fase 3 - Produtos
**Estimativa:** 4-6 sprints
**Dependências:** Fase 2

### 8.4 Fase 4 - Transações
**Estimativa:** 3-4 sprints
**Dependências:** Fase 3

---

## 9. Definições e Glossário

- **MVP:** Minimum Viable Product
- **PWA:** Progressive Web App
- **CRUD:** Create, Read, Update, Delete
- **RF:** Requisito Funcional
- **RNF:** Requisito Não-Funcional
- **KPI:** Key Performance Indicator
- **NPS:** Net Promoter Score

---

## 10. Aprovações

**Stakeholders:**
- [ ] Product Owner
- [ ] Tech Lead
- [ ] Design Lead
- [ ] Business Stakeholder

**Data de Aprovação:** _______________

---

## Apêndices

### A. Referências
- Rails Guides: https://guides.rubyonrails.org
- Devise Documentation: https://github.com/heartcombo/devise
- Tailwind CSS: https://tailwindcss.com

### B. Contatos
- Product Manager: [Nome]
- Tech Lead: [Nome]
- Design Lead: [Nome]

---

**Documento mantido por:** Product Manager  
**Última atualização:** 2025-01-XX  
**Próxima revisão:** Após conclusão da Fase 2

