#!/bin/bash

# Script para configurar submódulos Git
echo "🔧 Configurando submódulos Git..."

# Inicializa e atualiza submódulos
git submodule init
git submodule update --remote --merge

# Configura o branch principal para os submódulos
git config submodule.financial-planner-backend.branch main
git config submodule.financial-planner-frontend.branch main

echo "✅ Submódulos configurados com sucesso!"
echo ""
echo "📁 Estrutura do projeto:"
echo "├── financial-planner-case/ (repositório principal)"
echo "├── financial-planner-backend/ (submódulo)"
echo "└── financial-planner-frontend/ (submódulo)"
echo ""
echo "🚀 Para executar o projeto:"
echo "docker-compose up -d --build"
