# 🔍 Configuração do SonarCloud - Financial Planner

## 📋 Visão Geral

Este guia explica como configurar o SonarCloud para análise de qualidade de código nos repositórios do projeto Financial Planner, conforme especificado no case.

## 🏢 Organização GitHub

### 1. Criar Organização

1. Acesse [GitHub](https://github.com) e faça login
2. Clique no ícone "+" no canto superior direito
3. Selecione "New organization"
4. Escolha "Free" para plano gratuito
5. Nome sugerido: `financial-planner-org`
6. Complete o processo de criação

### 2. Criar Repositórios na Organização

```bash
# Repositório principal
https://github.com/financial-planner-org/financial-planner-case

# Backend
https://github.com/financial-planner-org/financial-planner-backend

# Frontend
https://github.com/financial-planner-org/financial-planner-frontend
```

## 🔧 Configuração do SonarCloud

### 1. Acessar SonarCloud

1. Acesse [SonarCloud](https://sonarcloud.io/)
2. Faça login com sua conta GitHub
3. Autorize o acesso à organização `financial-planner-org`

### 2. Importar Repositórios

1. Clique em "Import an organization"
2. Selecione `financial-planner-org`
3. Autorize o acesso
4. Os repositórios aparecerão automaticamente

### 3. Configurar Projetos

#### Backend

- **Nome**: `financial-planner-backend`
- **Organization**: `financial-planner-org`
- **Repository**: `financial-planner-org/financial-planner-backend`

#### Frontend

- **Nome**: `financial-planner-frontend`
- **Organization**: `financial-planner-org`
- **Repository**: `financial-planner-org/financial-planner-frontend`

## 🔑 Configuração de Tokens

### 1. Gerar Token SonarCloud

1. Acesse [SonarCloud](https://sonarcloud.io/)
2. Clique no seu avatar → "My Account"
3. Vá para "Security" → "Generate Tokens"
4. Nome: `financial-planner-ci`
5. Expiration: `No expiration`
6. Copie o token gerado

### 2. Configurar Secrets no GitHub

Para cada repositório, adicione os seguintes secrets:

#### Repositório Principal (financial-planner-case)

```
SONAR_TOKEN = [token_gerado]
SONAR_ORGANIZATION = financial-planner-org
```

#### Backend (financial-planner-backend)

```
SONAR_TOKEN = [token_gerado]
SONAR_ORGANIZATION = financial-planner-org
```

#### Frontend (financial-planner-frontend)

```
SONAR_TOKEN = [token_gerado]
SONAR_ORGANIZATION = financial-planner-org
```

### Como Adicionar Secrets

1. Acesse o repositório no GitHub
2. Vá para "Settings" → "Secrets and variables" → "Actions"
3. Clique em "New repository secret"
4. Adicione cada secret conforme listado acima

## 📁 Arquivos de Configuração

### 1. sonar-project.properties (Backend)

```properties
# Backend Configuration
sonar.projectKey=financial-planner-org_financial-planner-backend
sonar.organization=financial-planner-org
sonar.projectName=Financial Planner Backend
sonar.projectVersion=1.0.0

# Source code
sonar.sources=src
sonar.tests=tests
sonar.test.inclusions=tests/**/*.test.ts,tests/**/*.spec.ts

# Coverage
sonar.javascript.lcov.reportPaths=coverage/lcov.info
sonar.typescript.lcov.reportPaths=coverage/lcov.info

# Exclusions
sonar.exclusions=**/node_modules/**,**/dist/**,**/coverage/**,**/*.d.ts

# Language
sonar.sourceEncoding=UTF-8
```

### 2. sonar-project.properties (Frontend)

```properties
# Frontend Configuration
sonar.projectKey=financial-planner-org_financial-planner-frontend
sonar.organization=financial-planner-org
sonar.projectName=Financial Planner Frontend
sonar.projectVersion=1.0.0

# Source code
sonar.sources=src
sonar.tests=tests
sonar.test.inclusions=tests/**/*.test.ts,tests/**/*.spec.ts

# Coverage
sonar.javascript.lcov.reportPaths=coverage/lcov.info
sonar.typescript.lcov.reportPaths=coverage/lcov.info

# Exclusions
sonar.exclusions=**/node_modules/**,**/.next/**,**/out/**,**/coverage/**,**/*.d.ts

# Language
sonar.sourceEncoding=UTF-8
```

### 3. sonar-project.properties (Principal)

```properties
# Main Project Configuration
sonar.projectKey=financial-planner-org_financial-planner-case
sonar.organization=financial-planner-org
sonar.projectName=Financial Planner Case
sonar.projectVersion=1.0.0

# Source code
sonar.sources=.
sonar.exclusions=**/node_modules/**,**/dist/**,**/.next/**,**/coverage/**

# Language
sonar.sourceEncoding=UTF-8
```

## 🚀 GitHub Actions

### 1. Workflow para Backend

```yaml
# .github/workflows/backend-ci.yml
name: Backend CI/CD

on:
  push:
    branches: [main, develop]
    paths: ['financial-planner-backend/**']
  pull_request:
    branches: [main]
    paths: ['financial-planner-backend/**']

jobs:
  test-and-sonar:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: financial-planner-backend/package-lock.json

      - name: Install dependencies
        run: |
          cd financial-planner-backend
          npm ci

      - name: Run tests
        run: |
          cd financial-planner-backend
          npm run test:coverage

      - name: SonarCloud Scan
        uses: SonarSource/sonarcloud-github-action@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        with:
          projectBaseDir: financial-planner-backend
```

### 2. Workflow para Frontend

```yaml
# .github/workflows/frontend-ci.yml
name: Frontend CI/CD

on:
  push:
    branches: [main, develop]
    paths: ['financial-planner-frontend/**']
  pull_request:
    branches: [main]
    paths: ['financial-planner-frontend/**']

jobs:
  test-and-sonar:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: financial-planner-frontend/package-lock.json

      - name: Install dependencies
        run: |
          cd financial-planner-frontend
          npm ci

      - name: Build project
        run: |
          cd financial-planner-frontend
          npm run build

      - name: SonarCloud Scan
        uses: SonarSource/sonarcloud-github-action@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        with:
          projectBaseDir: financial-planner-frontend
```

## 📊 Scripts de Análise Local

### 1. Backend

```bash
# Instalar sonar-scanner
cd financial-planner-backend
npm install sonar-scanner --save-dev

# Adicionar script no package.json
{
  "scripts": {
    "sonar": "sonar-scanner"
  }
}

# Executar análise
npm run test:coverage
npm run sonar
```

### 2. Frontend

```bash
# Instalar sonar-scanner
cd financial-planner-frontend
npm install sonar-scanner --save-dev

# Adicionar script no package.json
{
  "scripts": {
    "sonar": "sonar-scanner"
  }
}

# Executar análise
npm run build
npm run sonar
```

## 🎯 Métricas Analisadas

### 1. Reliability (Confiabilidade)

- **Bugs**: Detecção de bugs potenciais
- **Vulnerabilities**: Vulnerabilidades de segurança
- **Code Smells**: Problemas de qualidade de código

### 2. Security (Segurança)

- **Security Hotspots**: Pontos quentes de segurança
- **Vulnerabilities**: Vulnerabilidades conhecidas
- **OWASP Top 10**: Conformidade com padrões

### 3. Maintainability (Manutenibilidade)

- **Technical Debt**: Dívida técnica em minutos
- **Code Smells**: Problemas de design
- **Duplications**: Código duplicado

### 4. Coverage (Cobertura)

- **Line Coverage**: Cobertura de linhas
- **Branch Coverage**: Cobertura de branches
- **Function Coverage**: Cobertura de funções

## 📈 Badges no README

### 1. Backend

```markdown
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=financial-planner-org_financial-planner-backend&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=financial-planner-org_financial-planner-backend)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=financial-planner-org_financial-planner-backend&metric=coverage)](https://sonarcloud.io/summary/new_code?id=financial-planner-org_financial-planner-backend)
[![Bugs](https://sonarcloud.io/api/project_badges/measure?project=financial-planner-org_financial-planner-backend&metric=bugs)](https://sonarcloud.io/summary/new_code?id=financial-planner-org_financial-planner-backend)
[![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=financial-planner-org_financial-planner-backend&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=financial-planner-org_financial-planner-backend)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=financial-planner-org_financial-planner-backend&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=financial-planner-org_financial-planner-backend)
[![Duplicated Lines (%)](https://sonarcloud.io/api/project_badges/measure?project=financial-planner-org_financial-planner-backend&metric=duplicated_lines_density)](https://sonarcloud.io/summary/new_code?id=financial-planner-org_financial-planner-backend)
```

### 2. Frontend

```markdown
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=financial-planner-org_financial-planner-frontend&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=financial-planner-org_financial-planner-frontend)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=financial-planner-org_financial-planner-frontend&metric=coverage)](https://sonarcloud.io/summary/new_code?id=financial-planner-org_financial-planner-frontend)
[![Bugs](https://sonarcloud.io/api/project_badges/measure?project=financial-planner-org_financial-planner-frontend&metric=bugs)](https://sonarcloud.io/summary/new_code?id=financial-planner-org_financial-planner-frontend)
[![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=financial-planner-org_financial-planner-frontend&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=financial-planner-org_financial-planner-frontend)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=financial-planner-org_financial-planner-frontend&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=financial-planner-org_financial-planner-frontend)
[![Duplicated Lines (%)](https://sonarcloud.io/api/project_badges/measure?project=financial-planner-org_financial-planner-frontend&metric=duplicated_lines_density)](https://sonarcloud.io/summary/new_code?id=financial-planner-org_financial-planner-frontend)
```

## 🔧 Troubleshooting

### 1. Problemas Comuns

#### Token Inválido

```
Error: Invalid token
```

**Solução**: Verifique se o token está correto e não expirou

#### Organização Não Encontrada

```
Error: Organization not found
```

**Solução**: Verifique se a organização existe e o token tem acesso

#### Projeto Não Encontrado

```
Error: Project not found
```

**Solução**: Verifique se o projectKey está correto no sonar-project.properties

### 2. Logs de Debug

```bash
# Habilitar logs detalhados
export SONAR_LOG_LEVEL=DEBUG
npm run sonar
```

### 3. Verificação de Configuração

```bash
# Verificar configuração
sonar-scanner -Dsonar.projectKey=test -Dsonar.sources=. -Dsonar.host.url=https://sonarcloud.io
```

## 📚 Recursos Adicionais

### 1. Documentação Oficial

- [SonarCloud Documentation](https://docs.sonarcloud.io/)
- [GitHub Actions Integration](https://docs.sonarcloud.io/advanced-setup/ci-based-analysis/github-actions/)
- [Quality Gates](https://docs.sonarcloud.io/user-guide/quality-gates/)

### 2. Exemplos de Configuração

- [TypeScript Projects](https://docs.sonarcloud.io/languages/typescript/)
- [Node.js Projects](https://docs.sonarcloud.io/languages/javascript/)
- [Next.js Projects](https://docs.sonarcloud.io/languages/typescript/)

### 3. Comunidade

- [SonarSource Community](https://community.sonarsource.com/)
- [GitHub Discussions](https://github.com/SonarSource/sonarcloud-github-action/discussions)

---

## ✅ Checklist de Configuração

- [ ] Organização GitHub criada
- [ ] Repositórios criados na organização
- [ ] SonarCloud configurado
- [ ] Tokens gerados e configurados
- [ ] Secrets adicionados no GitHub
- [ ] Arquivos sonar-project.properties criados
- [ ] GitHub Actions configurados
- [ ] Scripts locais configurados
- [ ] Badges adicionados ao README
- [ ] Primeira análise executada com sucesso

---

<div align="center">

**🎉 SonarCloud Configurado com Sucesso! 🎉**

_Análise de qualidade de código ativa e monitorando o projeto_

</div>
