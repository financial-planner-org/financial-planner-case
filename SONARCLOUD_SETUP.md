# 🔧 Configuração do SonarCloud

## 📋 Pré-requisitos

1. **Conta no SonarCloud**: [https://sonarcloud.io/](https://sonarcloud.io/)
2. **Organização GitHub**: `financial-planner-org`
3. **Repositórios**: 3 repositórios na organização

## 🚀 Passo a Passo

### 1. **Criar Organização no SonarCloud**

1. Acesse [https://sonarcloud.io/](https://sonarcloud.io/)
2. Faça login com sua conta GitHub
3. Clique em "Create Organization"
4. Selecione "GitHub" como provedor
5. Escolha a organização `financial-planner-org`

### 2. **Configurar Projetos**

Para cada repositório, crie um projeto no SonarCloud:

#### **Backend**
- **Project Key**: `financial-planner-org_financial-planner-backend`
- **Organization**: `financial-planner-org`
- **Repository**: `financial-planner-org/financial-planner-backend`

#### **Frontend**
- **Project Key**: `financial-planner-org_financial-planner-frontend`
- **Organization**: `financial-planner-org`
- **Repository**: `financial-planner-org/financial-planner-frontend`

#### **Case Principal**
- **Project Key**: `financial-planner-org_financial-planner-case`
- **Organization**: `financial-planner-org`
- **Repository**: `financial-planner-org/financial-planner-case`

### 3. **Configurar Secrets no GitHub**

No repositório principal, vá em **Settings > Secrets and variables > Actions** e adicione:

- **SONAR_TOKEN**: Token do SonarCloud (gerado automaticamente)
- **DOCKER_USERNAME**: Seu username do Docker Hub (opcional)
- **DOCKER_PASSWORD**: Sua senha do Docker Hub (opcional)

### 4. **Executar Análise**

Os workflows do GitHub Actions executarão automaticamente quando houver push para `main` ou `develop`.

Para executar localmente:

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

## 📊 **Métricas Analisadas**

- **Reliability**: Detecção de bugs
- **Security**: Vulnerabilidades de segurança
- **Maintainability**: Complexidade e duplicação
- **Coverage**: Cobertura de testes
- **Duplications**: Código duplicado

## 🎯 **Resultado Esperado**

Após a configuração, você verá:

- ✅ Badges de qualidade no README
- ✅ Análises automáticas via GitHub Actions
- ✅ Relatórios detalhados no SonarCloud
- ✅ Métricas de cobertura de testes
- ✅ Detecção de problemas de qualidade

## 🔗 **Links Úteis**

- [SonarCloud Dashboard](https://sonarcloud.io/)
- [Documentação SonarCloud](https://docs.sonarcloud.io/)
- [GitHub Actions](https://github.com/financial-planner-org/financial-planner-case/actions)
