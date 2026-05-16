#!/bin/bash

# Script de Limpieza - GŌKU LAB
# Limpia artifacts, caché y archivos temporales

echo "═══════════════════════════════════════════════"
echo "  🧹 Limpieza de Artifacts - GŌKU LAB"
echo "═══════════════════════════════════════════════"
echo ""

# Limpieza local
echo "🗑️  Limpiando artifacts locales..."
rm -rf node_modules
rm -rf .next
rm -rf dist
rm -rf build
rm -rf .cache
echo "✓ Artifacts locales eliminados"

# Limpieza en todos los subdirectorios
echo "🗑️  Limpiando subdirectorios..."
for dir in */; do
    if [ -d "$dir/node_modules" ]; then
        rm -rf "$dir/node_modules"
        echo "✓ Eliminado node_modules en $dir"
    fi
    if [ -d "$dir/.next" ]; then
        rm -rf "$dir/.next"
        echo "✓ Eliminado .next en $dir"
    fi
    if [ -d "$dir/dist" ]; then
        rm -rf "$dir/dist"
        echo "✓ Eliminado dist en $dir"
    fi
done

# Limpieza Docker (opcional)
echo ""
read -p "¿Deseas limpiar contenedores Docker? (s/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    docker-compose -f config/docker-compose.yml down
    echo "✓ Contenedores Docker eliminados"
fi

echo ""
echo "═══════════════════════════════════════════════"
echo "  ✅ Limpieza completada!"
echo "═══════════════════════════════════════════════"
