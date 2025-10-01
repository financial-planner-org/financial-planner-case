# 🚀 Guia de Deploy em Produção - Financial Planner

## 📋 Visão Geral

Este guia detalha como fazer o deploy do sistema Financial Planner em ambiente de produção, incluindo configurações de segurança, monitoramento e otimizações.

## 🏗️ Arquitetura de Produção

### 1. Infraestrutura Recomendada

```mermaid
graph TB
    A[Load Balancer] --> B[Frontend Container]
    A --> C[Backend Container]
    B --> D[PostgreSQL Database]
    C --> D
    E[Redis Cache] --> C
    F[File Storage] --> C
    G[Monitoring] --> B
    G --> C
    G --> D
```

### 2. Componentes

- **Load Balancer**: Nginx ou CloudFlare
- **Frontend**: Next.js com SSR/SSG
- **Backend**: Fastify com clustering
- **Database**: PostgreSQL com replicação
- **Cache**: Redis para sessões e cache
- **Storage**: AWS S3 ou similar
- **Monitoring**: Prometheus + Grafana

## 🐳 Docker Compose para Produção

### 1. docker-compose.production.yml

```yaml
version: '3.8'

services:
  # Database
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_INITDB_ARGS: '--encoding=UTF-8 --lc-collate=C --lc-ctype=C'
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backups:/backups
    ports:
      - '5432:5432'
    restart: unless-stopped
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -U ${DB_USER} -d ${DB_NAME}']
      interval: 30s
      timeout: 10s
      retries: 3

  # Redis Cache
  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    ports:
      - '6379:6379'
    restart: unless-stopped
    healthcheck:
      test: ['CMD', 'redis-cli', 'ping']
      interval: 30s
      timeout: 10s
      retries: 3

  # Backend
  backend:
    build:
      context: ./financial-planner-backend
      dockerfile: Dockerfile.production
    environment:
      NODE_ENV: production
      DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@postgres:5432/${DB_NAME}
      REDIS_URL: redis://:${REDIS_PASSWORD}@redis:6379
      JWT_SECRET: ${JWT_SECRET}
      API_PORT: 3001
      CORS_ORIGIN: ${FRONTEND_URL}
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    ports:
      - '3001:3001'
    restart: unless-stopped
    healthcheck:
      test: ['CMD', 'curl', '-f', 'http://localhost:3001/health']
      interval: 30s
      timeout: 10s
      retries: 3
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
        reservations:
          memory: 256M
          cpus: '0.25'

  # Frontend
  frontend:
    build:
      context: ./financial-planner-frontend
      dockerfile: Dockerfile.production
    environment:
      NODE_ENV: production
      NEXT_PUBLIC_API_URL: ${API_URL}
      NEXT_PUBLIC_APP_URL: ${FRONTEND_URL}
    depends_on:
      backend:
        condition: service_healthy
    ports:
      - '3000:3000'
    restart: unless-stopped
    healthcheck:
      test: ['CMD', 'curl', '-f', 'http://localhost:3000/api/health']
      interval: 30s
      timeout: 10s
      retries: 3
    deploy:
      resources:
        limits:
          memory: 256M
          cpus: '0.25'
        reservations:
          memory: 128M
          cpus: '0.1'

  # Nginx Load Balancer
  nginx:
    image: nginx:alpine
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/ssl:/etc/nginx/ssl
    ports:
      - '80:80'
      - '443:443'
    depends_on:
      - frontend
      - backend
    restart: unless-stopped

  # Monitoring
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    ports:
      - '9090:9090'
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    environment:
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_PASSWORD}
    volumes:
      - grafana_data:/var/lib/grafana
      - ./monitoring/grafana/dashboards:/var/lib/grafana/dashboards
    ports:
      - '3001:3000'
    restart: unless-stopped

volumes:
  postgres_data:
  redis_data:
  prometheus_data:
  grafana_data:
```

### 2. Dockerfile.production (Backend)

```dockerfile
# Multi-stage build para produção
FROM node:20-alpine AS base

# Instalar dependências do sistema
RUN apk add --no-cache libc6-compat

WORKDIR /app

# Copiar arquivos de dependências
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine AS runner
WORKDIR /app

# Criar usuário não-root
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copiar arquivos necessários
COPY --from=base /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/package.json ./package.json

# Configurar permissões
USER nextjs

# Expor porta
EXPOSE 3001

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3001/health || exit 1

# Comando de inicialização
CMD ["node", "dist/server.js"]
```

### 3. Dockerfile.production (Frontend)

```dockerfile
# Multi-stage build para produção
FROM node:20-alpine AS base

# Instalar dependências do sistema
RUN apk add --no-cache libc6-compat

WORKDIR /app

# Copiar arquivos de dependências
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine AS runner
WORKDIR /app

# Criar usuário não-root
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copiar arquivos necessários
COPY --from=base /app/node_modules ./node_modules
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

# Configurar permissões
USER nextjs

# Expor porta
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/api/health || exit 1

# Comando de inicialização
CMD ["node", "server.js"]
```

## 🔐 Configuração de Segurança

### 1. Variáveis de Ambiente (.env.production)

```bash
# Database
DB_USER=planner_prod
DB_PASSWORD=super_secure_password_here
DB_NAME=plannerdb_prod

# Redis
REDIS_PASSWORD=redis_secure_password_here

# JWT
JWT_SECRET=your_jwt_secret_here

# URLs
FRONTEND_URL=https://your-domain.com
API_URL=https://api.your-domain.com

# Monitoring
GRAFANA_PASSWORD=grafana_secure_password_here

# SSL
SSL_CERT_PATH=/etc/nginx/ssl/cert.pem
SSL_KEY_PATH=/etc/nginx/ssl/key.pem
```

### 2. Nginx Configuration (nginx.conf)

```nginx
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server backend:3001;
    }

    upstream frontend {
        server frontend:3000;
    }

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=web:10m rate=30r/s;

    # Security headers
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

    # Backend API
    server {
        listen 80;
        server_name api.your-domain.com;

        # Redirect to HTTPS
        return 301 https://$server_name$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name api.your-domain.com;

        # SSL configuration
        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/key.pem;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
        ssl_prefer_server_ciphers off;

        # Rate limiting
        limit_req zone=api burst=20 nodelay;

        location / {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }

    # Frontend
    server {
        listen 80;
        server_name your-domain.com;

        # Redirect to HTTPS
        return 301 https://$server_name$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name your-domain.com;

        # SSL configuration
        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/key.pem;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
        ssl_prefer_server_ciphers off;

        # Rate limiting
        limit_req zone=web burst=50 nodelay;

        location / {
            proxy_pass http://frontend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

## 📊 Monitoramento e Logs

### 1. Prometheus Configuration (prometheus.yml)

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - 'rules/*.yml'

scrape_configs:
  - job_name: 'backend'
    static_configs:
      - targets: ['backend:3001']
    metrics_path: '/metrics'
    scrape_interval: 5s

  - job_name: 'frontend'
    static_configs:
      - targets: ['frontend:3000']
    metrics_path: '/api/metrics'
    scrape_interval: 5s

  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres:5432']
    scrape_interval: 30s

  - job_name: 'redis'
    static_configs:
      - targets: ['redis:6379']
    scrape_interval: 30s
```

### 2. Grafana Dashboards

#### Backend Metrics

- Request rate
- Response time
- Error rate
- Memory usage
- CPU usage

#### Frontend Metrics

- Page load time
- Bundle size
- Error rate
- User sessions

#### Database Metrics

- Connection count
- Query performance
- Disk usage
- Cache hit ratio

## 🚀 Deploy Scripts

### 1. deploy.sh

```bash
#!/bin/bash

# Deploy script para produção
set -e

echo "🚀 Iniciando deploy em produção..."

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker não está rodando"
    exit 1
fi

# Verificar se Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose não está instalado"
    exit 1
fi

# Carregar variáveis de ambiente
if [ ! -f .env.production ]; then
    echo "❌ Arquivo .env.production não encontrado"
    exit 1
fi

export $(cat .env.production | xargs)

# Parar containers existentes
echo "🛑 Parando containers existentes..."
docker-compose -f docker-compose.production.yml down

# Remover imagens antigas
echo "🧹 Removendo imagens antigas..."
docker system prune -f

# Construir novas imagens
echo "🔨 Construindo novas imagens..."
docker-compose -f docker-compose.production.yml build --no-cache

# Iniciar serviços
echo "🚀 Iniciando serviços..."
docker-compose -f docker-compose.production.yml up -d

# Aguardar serviços ficarem prontos
echo "⏳ Aguardando serviços ficarem prontos..."
sleep 30

# Verificar saúde dos serviços
echo "🔍 Verificando saúde dos serviços..."
docker-compose -f docker-compose.production.yml ps

# Executar migrações do banco
echo "🗄️ Executando migrações do banco..."
docker-compose -f docker-compose.production.yml exec backend npx prisma migrate deploy

# Verificar se os serviços estão respondendo
echo "🔍 Verificando se os serviços estão respondendo..."
curl -f http://localhost:3000/api/health || echo "❌ Frontend não está respondendo"
curl -f http://localhost:3001/health || echo "❌ Backend não está respondendo"

echo "✅ Deploy concluído com sucesso!"
echo "🌐 Frontend: https://your-domain.com"
echo "🔧 Backend: https://api.your-domain.com"
echo "📊 Monitoring: http://your-domain.com:3001"
```

### 2. backup.sh

```bash
#!/bin/bash

# Script de backup para produção
set -e

echo "💾 Iniciando backup..."

# Criar diretório de backup
mkdir -p backups/$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"

# Backup do banco de dados
echo "🗄️ Fazendo backup do banco de dados..."
docker-compose -f docker-compose.production.yml exec postgres pg_dump -U planner_prod plannerdb_prod > $BACKUP_DIR/database.sql

# Backup dos volumes
echo "📁 Fazendo backup dos volumes..."
docker run --rm -v financial-planner-case_postgres_data:/data -v $(pwd)/$BACKUP_DIR:/backup alpine tar czf /backup/postgres_data.tar.gz -C /data .

# Backup dos logs
echo "📝 Fazendo backup dos logs..."
docker-compose -f docker-compose.production.yml logs > $BACKUP_DIR/logs.txt

# Compactar backup
echo "📦 Compactando backup..."
tar -czf $BACKUP_DIR.tar.gz -C backups $(basename $BACKUP_DIR)
rm -rf $BACKUP_DIR

echo "✅ Backup concluído: $BACKUP_DIR.tar.gz"
```

## 🔧 Manutenção

### 1. Comandos Úteis

```bash
# Ver logs em tempo real
docker-compose -f docker-compose.production.yml logs -f

# Ver logs de um serviço específico
docker-compose -f docker-compose.production.yml logs -f backend

# Reiniciar um serviço
docker-compose -f docker-compose.production.yml restart backend

# Escalar serviços
docker-compose -f docker-compose.production.yml up -d --scale backend=3

# Acessar container
docker-compose -f docker-compose.production.yml exec backend sh

# Executar comandos no banco
docker-compose -f docker-compose.production.yml exec postgres psql -U planner_prod -d plannerdb_prod
```

### 2. Atualizações

```bash
# Atualizar código
git pull origin main

# Reconstruir e reiniciar
docker-compose -f docker-compose.production.yml up -d --build

# Executar migrações
docker-compose -f docker-compose.production.yml exec backend npx prisma migrate deploy
```

## 📈 Performance

### 1. Otimizações Recomendadas

- **CDN**: Use CloudFlare ou AWS CloudFront
- **Caching**: Implemente Redis para cache de queries
- **Database**: Configure índices apropriados
- **Images**: Use WebP e lazy loading
- **Bundle**: Implemente code splitting

### 2. Monitoramento

- **APM**: New Relic ou DataDog
- **Logs**: ELK Stack ou similar
- **Uptime**: Pingdom ou UptimeRobot
- **Errors**: Sentry para tracking de erros

## 🔒 Segurança

### 1. Checklist de Segurança

- [ ] SSL/TLS configurado
- [ ] Firewall configurado
- [ ] Senhas fortes
- [ ] Backup automático
- [ ] Logs de auditoria
- [ ] Rate limiting
- [ ] Headers de segurança
- [ ] Validação de entrada
- [ ] Sanitização de dados
- [ ] CORS configurado

### 2. Atualizações de Segurança

```bash
# Atualizar dependências
npm audit fix

# Atualizar imagens Docker
docker-compose -f docker-compose.production.yml pull
docker-compose -f docker-compose.production.yml up -d
```

---

## ✅ Checklist de Deploy

- [ ] Servidor configurado
- [ ] Docker instalado
- [ ] Domínio configurado
- [ ] SSL configurado
- [ ] Variáveis de ambiente configuradas
- [ ] Backup configurado
- [ ] Monitoramento configurado
- [ ] Testes de carga realizados
- [ ] Documentação atualizada
- [ ] Equipe treinada

---

<div align="center">

**🚀 Sistema Pronto para Produção! 🚀**

_Deploy seguro, monitorado e otimizado_

</div>
