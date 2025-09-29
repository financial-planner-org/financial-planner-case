# Financial Planner - Multi Family Office

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=flat&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Next.js](https://img.shields.io/badge/Next.js-000000?style=flat&logo=nextdotjs&logoColor=white)](https://nextjs.org/)
[![Prisma](https://img.shields.io/badge/Prisma-3982CE?style=flat&logo=Prisma&logoColor=white)](https://www.prisma.io/)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat&logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)

<!-- SonarCloud Quality Badges -->
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=SUA_ORGANIZATION_financial-planner-case&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=SUA_ORGANIZATION_financial-planner-case)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=SUA_ORGANIZATION_financial-planner-case&metric=coverage)](https://sonarcloud.io/summary/new_code?id=SUA_ORGANIZATION_financial-planner-case)
[![Bugs](https://sonarcloud.io/api/project_badges/measure?project=SUA_ORGANIZATION_financial-planner-case&metric=bugs)](https://sonarcloud.io/summary/new_code?id=SUA_ORGANIZATION_financial-planner-case)
[![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=SUA_ORGANIZATION_financial-planner-case&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=SUA_ORGANIZATION_financial-planner-case)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=SUA_ORGANIZATION_financial-planner-case&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=SUA_ORGANIZATION_financial-planner-case)

## 📋 Descrição do Projeto

Sistema de planejamento financeiro desenvolvido para um **Multi Family Office (MFO)** como parte de um processo seletivo. A ferramenta permite acompanhar o alinhamento dos clientes ao planejamento financeiro, projetar a evolução patrimonial até 2060 e registrar eventos financeiros como movimentações, seguros e metas.

A interface replica fielmente o design dark-mode do Figma fornecido, sendo totalmente responsiva para desktop com suporte a zoom-in/zoom-out.

## 🎯 Funcionalidades Implementadas

### ✅ Projeção Patrimonial

- **Endpoint de projeção**: Recebe ID da simulação e status (Vivo/Morto/Inválido)
- **Projeção ano a ano até 2060**: Taxa real composta configurável (padrão: 4% a.a.)
- **Ponto inicial inteligente**: Considera sempre o registro mais recente de cada ativo anterior à data da simulação
- **Gestão de simulações**: Menu de três pontos com opções de editar, deletar e criar nova versão
- **Situação Atual**: Cópia automática da simulação principal com data atual
- **Controle de versões**: Carrega apenas a versão mais recente, mantendo histórico completo
- **Status de vida**: Morto (sem timeline de entradas, despesas ÷ 2), Inválido (entradas encerradas)
- **Visualizações**: Gráficos empilhados e tabelas para patrimônio financeiro e imobiliário

### ✅ Alocações

- **Ativos Financeiros**: Nome, valor e data de registro
- **Ativos Imobiliários**: Nome, valor, financiamento (data inicial, parcelas, taxa de juros, entrada)
- **Histórico completo**: Timeline de atualizações por ativo
- **Operações**: Editar registros existentes ou adicionar novos na data escolhida
- **Atualização rápida**: Botão para criar registro na data atual com valor atualizado
- **Regra de integridade**: Nunca sobrescreve registros, sempre cria novos

### ✅ Movimentações

- **CRUD completo**: Criar, listar, atualizar e deletar eventos financeiros
- **Frequências**: Única, mensal ou anual
- **Timeline encadeada**: Sequências de transações podem ser conectadas (ex: salário 2025-2035, novo salário 2035-2060)
- **Tipos**: Entradas (receitas) e saídas (despesas)

### ✅ Seguros

- **Registro completo**: Vida e invalidez
- **Campos**: Nome, data de início, duração (meses), prêmio mensal, valor segurado
- **Integração**: Cálculo automático na projeção patrimonial

### ✅ Histórico de Simulações

- **Versões legadas**: Simulações antigas marcadas com warning e tooltip
- **Reabertura**: Visualizar gráficos de qualquer versão anterior
- **Criação a partir de versões**: Possibilidade de criar nova simulação editável a partir de versão legada

## 🏗️ Arquitetura e Tecnologias

### Stack Tecnológica

#### Backend

- **Runtime**: Node.js 20 + TypeScript
- **Framework**: Fastify 4 com documentação Swagger automática
- **Banco de Dados**: PostgreSQL 15
- **ORM**: Prisma com migrações automatizadas
- **Validação**: Zod v4 schemas integrados
- **Testes**: Jest + Supertest (cobertura > 80%)
- **Qualidade**: ESLint + Prettier + SonarCloud
- **Arquitetura**: Camadas (routes → services → repositories)

#### Frontend

- **Framework**: Next.js 14 com App Router
- **UI/UX**: ShadCN/UI com tema dark-mode (conforme Figma)
- **Estado**: TanStack Query com cache inteligente
- **Formulários**: React Hook Form + Zod v4
- **HTTP**: Axios com interceptors configurados
- **Estilização**: Tailwind CSS
- **Responsividade**: Design adaptável com suporte a zoom

#### Infraestrutura

- **Contêinerização**: Docker + Docker Compose
- **Banco de Dados**: PostgreSQL 15
- **CI/CD**: GitHub Actions
- **Análise de Qualidade**: SonarCloud integrado

### Modelo de Dados

- **Simulation**: Simulações com controle de versões
- **Allocation**: Ativos financeiros e imobiliários
- **AssetRecord**: Histórico de valores dos ativos
- **Movement**: Movimentações financeiras
- **Insurance**: Seguros de vida e invalidez

## 📊 Endpoints da API

### Simulações

- `GET /simulations` - Listar simulações
- `POST /simulations` - Criar nova simulação
- `GET /simulations/:id` - Obter simulação por ID
- `PUT /simulations/:id` - Atualizar simulação
- `DELETE /simulations/:id` - Remover simulação

### Projeções

- `POST /projections` - Calcular projeção patrimonial até 2060

### Alocações

- `GET /allocations/:simulationId` - Listar alocações da simulação
- `POST /allocations` - Criar nova alocação
- `PUT /allocations/:id` - Atualizar alocação
- `DELETE /allocations/:id` - Remover alocação
- `POST /allocations/:id/records` - Adicionar registro de valor

### Movimentações

- `GET /movements/:simulationId` - Listar movimentações da simulação
- `POST /movements` - Criar nova movimentação
- `PUT /movements/:id` - Atualizar movimentação
- `DELETE /movements/:id` - Remover movimentação

### Seguros

- `GET /insurances/:simulationId` - Listar seguros da simulação
- `POST /insurances` - Criar novo seguro
- `PUT /insurances/:id` - Atualizar seguro
- `DELETE /insurances/:id` - Remover seguro

### Saúde

- `GET /health` - Verificar status da API

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

```text
financial-planner-case/
├── .github/workflows/                    # CI/CD e SonarCloud
│   ├── sonarcloud-backend.yml           # Análise backend
│   ├── sonarcloud-frontend.yml          # Análise frontend
│   └── sonarcloud-complete.yml          # Análise completa
│
├── financial-planner-backend/            # API REST Node.js + Fastify
│   ├── prisma/
│   │   ├── schema.prisma                # Schema do banco
│   │   └── migrations/                  # Migrações
│   ├── src/
│   │   ├── routes/                      # Rotas da API
│   │   │   ├── health.ts               # Health check
│   │   │   ├── simulations.ts          # CRUD simulações
│   │   │   ├── projections.ts          # Cálculo projeções
│   │   │   ├── allocations.ts          # Gestão alocações
│   │   │   ├── movements.ts            # Gestão movimentações
│   │   │   └── insurances.ts           # Gestão seguros
│   │   ├── services/                    # Lógica de negócios
│   │   ├── schemas/                     # Validações Zod
│   │   └── server.ts                    # Servidor principal
│   ├── tests/                           # Testes Jest + Supertest
│   │   ├── routes/                      # Testes de rotas
│   │   └── services/                    # Testes de serviços
│   └── sonar-project.properties         # Configuração SonarCloud
│
├── financial-planner-frontend/           # Next.js 14 + ShadCN/UI
│   ├── src/
│   │   ├── app/                         # App Router
│   │   │   ├── page.tsx                # Home (Alocações)
│   │   │   ├── projecao/page.tsx       # Página de projeções
│   │   │   ├── historico/page.tsx      # Histórico simulações
│   │   │   ├── movimentacoes/page.tsx  # Gestão movimentações
│   │   │   ├── alocacoes/page.tsx      # Gestão alocações
│   │   │   └── seguros/page.tsx        # Gestão seguros
│   │   ├── components/                  # Componentes reutilizáveis
│   │   │   ├── ui/                     # ShadCN/UI components
│   │   │   ├── layout/                 # Layout components
│   │   │   ├── allocations/            # Components alocações
│   │   │   ├── projections/            # Components projeções
│   │   │   └── movements/              # Components movimentações
│   │   ├── hooks/                       # Custom hooks
│   │   │   └── api/                    # Hooks para API calls
│   │   └── lib/                         # Configurações e utils
│   └── sonar-project.properties         # Configuração SonarCloud
│
├── docker-compose.yml                   # Orquestração containers
├── sonar-project.properties             # Configuração SonarCloud global
└── README.md                            # Esta documentação
```

## 🚀 Instalação e Execução

### Pré-requisitos

- Docker 20.10+
- Docker Compose 2.0+

### Configuração Inicial

1. **Clone o repositório**:

   ```bash
   git clone https://github.com/seu-usuario/financial-planner-case.git
   cd financial-planner-case
   ```

2. **Inicie os serviços**:

   ```bash
   docker-compose up -d --build
   ```

3. **Execute as migrações do banco**:

   ```bash
   docker-compose exec financial-planner-backend npx prisma migrate dev
   ```

4. **Acesse as aplicações**:
   - **Frontend**: <http://localhost:3000>
   - **Backend API**: <http://localhost:3001>
   - **Documentação Swagger**: <http://localhost:3001/documentation>
   - **Banco PostgreSQL**: `localhost:5432` (planner/plannerpw/plannerdb)

### Comandos de Desenvolvimento

```bash
# Ver logs em tempo real
docker-compose logs -f

# Parar todos os serviços
docker-compose down

# Reconstruir e reiniciar
docker-compose up -d --build

# Acessar banco de dados via CLI
docker-compose exec postgres psql -U planner -d plannerdb

# Executar comandos no backend
docker-compose exec financial-planner-backend npm run test
```

## 🧪 Qualidade e Testes

### Estratégia de Testes

O projeto implementa uma estratégia abrangente de testes com foco na qualidade e confiabilidade do código:

- **Testes Unitários**: Cobertura > 80% com Jest
- **Testes de Integração**: Validação de endpoints com Supertest
- **Testes E2E**: Fluxos completos de usuário
- **Organização**: Estrutura espelha a arquitetura do código

### Execução de Testes

```bash
# Backend
cd financial-planner-backend
npm test                    # Testes unitários
npm run test:coverage       # Com relatório de cobertura
npm run test:ci            # Modo CI/CD

# Frontend
cd financial-planner-frontend
npm run lint               # Análise de código
npm run build              # Build de produção
```

### Análise de Qualidade com SonarCloud

O projeto integra o SonarCloud para análise contínua de qualidade de código, conforme especificado no case. A integração monitora bugs, vulnerabilidades de segurança e métricas de cobertura através de workflows do GitHub Actions.

#### Configuração Básica

Para ativar o SonarCloud:

1. Configure os secrets no repositório GitHub:
   - **SONAR_TOKEN**: Token de acesso do SonarCloud
   - **SONAR_ORGANIZATION**: Nome da sua organization GitHub

2. Atualize os arquivos `sonar-project.properties` com o nome da sua organization

3. Instale as dependências:

   ```bash
   # Backend
   cd financial-planner-backend
   npm install sonar-scanner --save-dev
   
   # Frontend  
   cd financial-planner-frontend
   npm install sonar-scanner --save-dev
   ```

#### Execução de Análises

As análises são executadas automaticamente via GitHub Actions quando há push para `main` ou `develop`. Para análises locais:

```bash
# Backend
cd financial-planner-backend
npm run test:coverage
npm run sonar

# Frontend
cd financial-planner-frontend
npm run build
npm run sonar
```

#### Métricas Analisadas

- **Reliability**: Detecção de bugs e vulnerabilidades
- **Security**: Análise de segurança
- **Maintainability**: Complexidade e código duplicado
- **Coverage**: Cobertura de testes unitários
- **Duplications**: Código duplicado

Os resultados são exibidos através de badges no README. Acesse o [SonarCloud Dashboard](https://sonarcloud.io/) para análise detalhada.

## 🤝 Desenvolvimento e Contribuição

### Ambiente de Desenvolvimento

Para contribuir com o projeto:

1. **Configure o ambiente local**:

   ```bash
   # Backend
   cd financial-planner-backend
   npm install
   npm run dev

   # Frontend
   cd financial-planner-frontend
   npm install
   npm run dev
   ```

2. **Execute os testes**:

   ```bash
   # Backend
   npm run test:coverage

   # Frontend
   npm run lint
   npm run build
   ```

### Convenções de Código

- **Commits**: Use conventional commits (feat:, fix:, docs:, etc.)
- **Branches**: `feature/nome-da-feature` ou `fix/nome-do-bug`
- **Testes**: Mantenha cobertura > 80%
- **Código**: Siga padrões ESLint + Prettier

### Processo de Contribuição

1. Fork o repositório
2. Crie uma branch para sua feature
3. Implemente com testes
4. Execute análise SonarCloud
5. Abra Pull Request com descrição clara

## 📝 Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE).
