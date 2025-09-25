# Financial Planner - Multi Family Office

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=flat&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Next.js](https://img.shields.io/badge/Next.js-000000?style=flat&logo=nextdotjs&logoColor=white)](https://nextjs.org/)
[![Prisma](https://img.shields.io/badge/Prisma-3982CE?style=flat&logo=Prisma&logoColor=white)](https://www.prisma.io/)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat&logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)

## 🚀 Visão Geral

Sistema de planejamento financeiro desenvolvido para um Multi Family Office (MFO) que permite:
- Acompanhar o alinhamento dos clientes ao planejamento financeiro
- Projetar a evolução patrimonial
- Registrar eventos (movimentações, seguros, metas)

## 🎯 Funcionalidades Principais

### 1. Projeção Patrimonial
- Geração de projeções anuais até 2060
- Taxa real composta ajustável (padrão: 4% a.a.)
- Modos de visualização: "Vivo" e "Morto"
- Histórico de versões das simulações

### 2. Gestão de Ativos
- Cadastro de ativos financeiros e imobiliários
- Controle de financiamentos
- Histórico de atualizações

### 3. Movimentações
- CRUD de eventos financeiros
- Diferentes frequências: única, mensal, anual
- Timeline de entradas e saídas

### 4. Seguros
- Registro de apólices de vida e invalidez
- Controle de prêmios e coberturas

## 🛠️ Tecnologias

### Backend
- **Runtime**: Node.js 20 + TypeScript
- **Framework**: Fastify 4
- **Banco de Dados**: PostgreSQL 15
- **ORM**: Prisma
- **Validação**: Zod v4
- **Testes**: Jest + Supertest
- **Documentação**: Swagger/OpenAPI

### Frontend
- **Framework**: Next.js 14 (App Router)
- **UI**: ShadCN/UI (dark-mode)
- **Gerenciamento de Estado**: TanStack Query
- **Formulários**: React Hook Form + Zod
- **Requisições HTTP**: Axios

## 🐳 Infraestrutura

```yaml
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_USER: planner
      POSTGRES_PASSWORD: plannerpw
      POSTGRES_DB: plannerdb
    volumes:
      - pg_data:/var/lib/postgresql/data

  backend:
    build: ./backend
    depends_on:
      - db
    environment:
      DATABASE_URL: postgresql://planner:plannerpw@db:5432/plannerdb

  frontend:
    build: ./frontend
    depends_on:
      - backend
    ports:
      - "3000:3000"

volumes:
  pg_data:
```

## 📦 Estrutura do Projeto

```
financial-planner-case/
├── .github/                     # Configurações do GitHub (CI/CD, templates, etc.)
│   └── workflows/               # Fluxos de CI/CD
│       └── ci.yml              # Pipeline de integração contínua
│
├── financial-planner-backend/   # API REST em Node.js + Fastify
│   ├── prisma/                 # Definições do banco de dados
│   │   ├── schema.prisma       # Schema do Prisma
│   │   └── migrations/         # Migrações do banco de dados
│   │
│   └── src/                    # Código-fonte do backend
│       ├── config/             # Configurações da aplicação
│       ├── controllers/        # Controladores das rotas da API
│       ├── services/           # Lógica de negócios
│       ├── repositories/       # Camada de acesso a dados
│       ├── schemas/            # Validações com Zod
│       ├── types/              # Tipos TypeScript
│       ├── utils/              # Utilitários e helpers
│       ├── errors/             # Tratamento de erros
│       ├── app.ts              # Configuração do Fastify
│       └── server.ts           # Ponto de entrada da aplicação
│
├── financial-planner-frontend/  # Aplicação Next.js
│   ├── public/                 # Arquivos estáticos
│   │   └── images/             # Imagens e assets
│   │
│   └── src/                    # Código-fonte do frontend
│       ├── App.tsx             # Componente raiz da aplicação
│       ├── app/                # Rotas e páginas (App Router)
│       ├── components/         # Componentes reutilizáveis
│       ├── hooks/              # Custom hooks React
│       ├── lib/                # Configurações e utilitários
│       ├── services/           # Serviços de API e lógica de negócios
│       └── types/              # Tipos TypeScript globais
│
├── docker-compose.yml          # Configuração dos serviços Docker
└── README.md                   # Documentação principal
```

## 🚀 Como Executar

1. Clone o repositório:
   ```bash
   git clone --recurse-submodules https://github.com/seu-usuario/financial-planner-case.git
   cd financial-planner-case
   ```

2. Inicie os containers:
   ```bash
   docker-compose up -d --build
   ```

3. Acesse:
   - Frontend: http://localhost:3000
   - API Docs: http://localhost:3001/documentation

## 📝 Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE).
- **Tecnologia**: Node.js com Fastify e TypeScript
- **Banco de Dados**: PostgreSQL 15 com Prisma ORM
- **Autenticação**: JWT (JSON Web Tokens)
- **Documentação**: Swagger/OpenAPI
- **Testes**: Unitários, de integração e E2E

### Frontend
- **Framework**: Next.js 14 com App Router
- **Linguagem**: TypeScript
- **UI/UX**: ShadCN/UI com tema dark-mode
- **Gerenciamento de Estado**: TanStack Query
- **Formulários**: React Hook Form + Zod

### Comunicação
- **Frontend-Backend**: RESTful API (JSON over HTTP)
- **Autenticação**: JWT via cabeçalho Authorization
- **WebSockets**: Para atualizações em tempo real (opcional)

### Infraestrutura
- **Contêinerização**: Docker + Docker Compose
- **CI/CD**: GitHub Actions
- **Monitoramento**: Prometheus + Grafana (opcional)
- **Logs**: ELK Stack (opcional)

## 🛠️ Ferramentas de Desenvolvimento

### 🔄 Husky - Git Hooks

O projeto utiliza o **Husky** para automatizar tarefas durante o ciclo de vida do Git. Os hooks configurados garantem a qualidade do código antes de cada commit e push.

#### Hooks Configurados:
- **pre-commit**: Executa o `lint-staged` para:
  - Formatar o código com Prettier
  - Verificar problemas de lint com ESLint
  - Executar testes unitários (quando disponíveis)

#### Benefícios:
- Padronização do código
- Prevenção de erros comuns
- Garantia de qualidade antes de cada commit

#### Como usar:
1. Faça suas alterações no código
2. Adicione as mudanças com `git add .`
3. Ao fazer `git commit`, os hooks serão executados automaticamente
4. Se houver erros, corrija-os antes de prosseguir

## 📚 Documentação da API

A documentação completa da API está disponível via Swagger em:
- **Ambiente de Desenvolvimento**: http://localhost:3001/documentation
- **Produção**: https://api.seudominio.com/documentation

### Endpoints Principais

#### Autenticação
- `POST /auth/login` - Autenticação de usuário
- `POST /auth/refresh` - Renovar token de acesso
- `POST /auth/logout` - Encerrar sessão

#### Clientes
- `GET /clients` - Listar clientes
- `POST /clients` - Criar novo cliente
- `GET /clients/:id` - Obter cliente por ID
- `PUT /clients/:id` - Atualizar cliente
- `DELETE /clients/:id` - Remover cliente

#### Ativos Financeiros
- `GET /assets` - Listar ativos
- `POST /assets` - Criar novo ativo
- `GET /assets/:id` - Obter ativo por ID
- `PUT /assets/:id` - Atualizar ativo
- `DELETE /assets/:id` - Remover ativo

#### Projeções
- `POST /projections` - Criar nova projeção
- `GET /projections` - Listar projeções
- `GET /projections/:id` - Obter projeção por ID
- `PUT /projections/:id` - Atualizar projeção
- `DELETE /projections/:id` - Remover projeção


## ✨ Funcionalidades Principais

### 📊 Projeção Patrimonial
- Projeção ano a ano até 2060 com taxa real composta personalizável
- Diferenciação entre cenários "Vivo" e "Morto"
- Gerenciamento de múltiplas simulações com histórico de versões
- Visualização em gráfico e tabela dos ativos financeiros e imobiliários

### 💰 Gestão de Ativos
- Registro de ativos financeiros e imobiliários
- Controle de financiamentos com parcelamento e taxas de juros
- Histórico completo de movimentações
- Atualização simplificada de valores

### 📅 Linha do Tempo
- CRUD de eventos financeiros
- Diferentes frequências de transações (únicas, mensais, anuais)
- Visualização clara de entradas e saídas ao longo do tempo

### 🛡️ Seguros
- Cadastro de apólices de vida e invalidez
- Cálculo automático de prêmios e coberturas
- Integração com a projeção patrimonial

### 🔄 Controle de Versões
- Histórico completo de simulações
- Comparação entre versões
- Criação de novas simulações a partir de versões existentes

## 🛠️ Stack Técnica

### Backend
- **Runtime**: Node.js 20 com TypeScript
- **Framework**: Fastify 4
- **Documentação**: @fastify/swagger
- **ORM**: Prisma
- **Banco de Dados**: PostgreSQL 15
- **Validação**: Zod v4
- **Testes**: Jest + Supertest (cobertura > 80%)
- **Qualidade de Código**: ESLint + Prettier

### Frontend
- **Framework**: Next.js 14 (App Router)
- **Linguagem**: TypeScript
- **UI**: ShadCN/UI (dark-mode)
- **Gerenciamento de Estado**: TanStack Query
- **Formulários**: React Hook Form + Zod
- **Requisições HTTP**: Axios
- **Estilização**: Tailwind CSS
- **Qualidade de Código**: ESLint + Prettier

### Infraestrutura
- **Contêinerização**: Docker + Docker Compose
- **Banco de Dados**: PostgreSQL 15
- **Análise Estática**: SonarCloud
- **CI/CD**: GitHub Actions

## 🚀 Iniciando o Projeto com Docker Compose

A maneira mais fácil de executar todo o ambiente é usando Docker Compose. O arquivo `docker-compose.yml` na raiz do projeto configura todos os serviços necessários.

### Pré-requisitos

- Docker 20.10+
- Docker Compose 2.0+
- Node.js 20+ (apenas para desenvolvimento)
- pnpm (recomendado) ou npm/yarn

### Configuração Inicial com Docker Compose

1. **Clone o repositório**
   ```bash
   git clone https://github.com/seu-usuario/financial-planner-case.git
   cd financial-planner-case
   ```

2. **Configure as variáveis de ambiente**
   ```bash
   cp .env.example .env
   # Edite o .env conforme necessário
   ```

3. **Inicie todos os serviços**
   ```bash
   # Iniciar em modo desenvolvimento (com hot-reload)
   docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
   
   # Ou para produção:
   # docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
   ```

4. **Execute as migrações do banco de dados**
   ```bash
   docker-compose exec financial-planner-backend npx prisma migrate dev
   ```

5. **Acesse os serviços**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:3001
   - Documentação da API: http://localhost:3001/documentation
   - Banco de Dados (via DBeaver/TablePlus):
     - Host: localhost
     - Porta: 5432
     - Banco: financial_planner
     - Usuário: postgres
     - Senha: (definida no .env)

### Comandos úteis do Docker Compose

```bash
# Verificar logs dos serviços
docker-compose logs -f

# Parar todos os serviços
docker-compose down

# Reconstruir e reiniciar um serviço específico
docker-compose up -d --build financial-planner-backend

# Acessar o banco de dados via psql
docker-compose exec postgres psql -U postgres -d financial_planner
```

## 🧪 Testes

### Backend
```bash
# Rodar testes
cd financial-planner-backend
pnpm test

# Gerar relatório de cobertura
pnpm test:coverage
```

### Frontend
```bash
# Rodar testes
cd financial-planner-frontend
pnpm test

# Rodar testes em modo watch
pnpm test:watch
```

### Testes E2E
```bash
# No diretório raiz
docker-compose -f docker-compose.test.yml up --build --exit-code-from financial-planner-test
```

## 🤝 Guia de Contribuição

1. **Crie uma branch** para sua feature ou correção:
   ```bash
   git checkout -b feature/nova-funcionalidade
   # ou
   git checkout -b fix/corrigir-bug
   ```

2. **Siga as convenções de commit**:
   - `feat:` para novas funcionalidades
   - `fix:` para correções de bugs
   - `docs:` para alterações na documentação
   - `style:` para formatação, ponto e vírgula, etc.
   - `refactor:` para mudanças que não corrigem bugs nem adicionam funcionalidades
   - `test:` para adicionar testes
   - `chore:` para atualizações de tarefas de build, configuração, etc.

3. **Escreva testes** para suas alterações e certifique-se de que todos os testes passem:
   ```bash
   pnpm test
   ```

4. **Atualize a documentação** conforme necessário

5. **Envie um Pull Request** com uma descrição clara das alterações

## 📄 Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE).