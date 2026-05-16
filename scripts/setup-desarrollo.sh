#!/bin/bash

# Script de Setup para Desarrollo - GŌKU LAB
# Este script configura el ambiente de desarrollo local

set -e

echo "═══════════════════════════════════════════════"
echo "  🚀 Setup Desarrollo - GŌKU LAB"
echo "═══════════════════════════════════════════════"
echo ""

# Verificar requisitos
echo "✓ Verificando requisitos..."

if ! command -v node &> /dev/null; then
    echo "✗ Node.js no está instalado"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "✗ npm no está instalado"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "✗ Git no está instalado"
    exit 1
fi

echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"
echo ""

# Setup directorios
echo "📁 Creando estructura de directorios..."
mkdir -p logs
mkdir -p cache
mkdir -p uploads

# Copiar archivos de configuración
echo "⚙️  Configurando variables de entorno..."
if [ ! -f ".env.local" ]; then
    cp config/shared-env.example .env.local
    echo "✓ Archivo .env.local creado"
else
    echo "✓ .env.local ya existe"
fi

# Iniciar servicios con Docker
echo "🐳 Iniciando servicios con Docker..."
if command -v docker &> /dev/null; then
    docker-compose -f config/docker-compose.yml up -d
    echo "✓ Servicios Docker iniciados"
    echo ""
    echo "📊 URLs de servicios:"
    echo "   PostgreSQL:      localhost:5432"
    echo "   Redis:          localhost:6379"
    echo "   pgAdmin:        http://localhost:5050"
    echo "   Redis Commander: http://localhost:8081"
else
    echo "⚠️  Docker no está instalado (opcional pero recomendado)"
fi

echo ""
echo "═══════════════════════════════════════════════"
echo "  ✅ Setup completado exitosamente!"
echo "═══════════════════════════════════════════════"
echo ""
echo "📚 Próximos pasos:"
echo ""
echo "1. Clone los repositorios satelitales:"
echo "   git clone https://github.com/jcrendon0909/GokuLab_WebSite.git"
echo ""
echo "2. Instale dependencias:"
echo "   cd GokuLab_WebSite"
echo "   npm install"
echo ""
echo "3. Inicie el servidor de desarrollo:"
echo "   npm run dev"
echo ""
echo "4. Visite http://localhost:3000"
echo ""
echo "🎉 ¡Listo para desarrollar!"
