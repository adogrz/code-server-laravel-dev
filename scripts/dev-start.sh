#!/bin/bash
# =============================================================================
# SCRIPT DE INICIO PARA DESARROLLO LARAVEL + REACT + INERTIAJS
# =============================================================================

set -e  # Salir en caso de error

echo "🚀 Iniciando entorno de desarrollo Laravel + React + InertiaJS..."

# =============================================================================
# FUNCIONES AUXILIARES
# =============================================================================

# Función para manejar la limpieza al salir
cleanup() {
    echo ""
    echo "🛑 Deteniendo servicios..."
    pkill -f "php artisan serve" 2>/dev/null || true
    pkill -f "npm run dev" 2>/dev/null || true
    pkill -f "yarn dev" 2>/dev/null || true
    echo "✅ Servicios detenidos"
    exit 0
}

# Función para mostrar ayuda
show_help() {
    cat << EOF
🚀 Script de desarrollo Laravel + React + InertiaJS

USO:
    $0 [OPCIONES]

OPCIONES:
    -h, --help          Mostrar esta ayuda
    -p, --php-port      Puerto para Laravel (default: 8000)
    -v, --vite-port     Puerto para Vite (default: 5173)
    --no-migrate        No ejecutar migraciones
    --yarn              Usar yarn en lugar de npm

EJEMPLOS:
    $0                          # Inicio normal
    $0 -p 8001 -v 5174         # Puertos personalizados
    $0 --yarn --no-migrate     # Usar yarn y sin migraciones

ACCESO A SERVICIOS:
    Una vez iniciado, accede a:
    🎨 Code Server: https://$PROXY_DOMAIN/
    🐘 Laravel App: https://$PROXY_DOMAIN/proxy/$PHP_PORT
    ⚡ Vite Dev Server: https://$PROXY_DOMAIN/proxy/$VITE_PORT

EOF
}

# Función para verificar si un puerto está disponible
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 1  # Puerto ocupado
    else
        return 0  # Puerto disponible
    fi
}

# Función para encontrar puerto disponible
find_available_port() {
    local start_port=$1
    local port=$start_port
    
    while ! check_port $port; do
        port=$((port + 1))
        if [ $port -gt $((start_port + 100)) ]; then
            echo "❌ No se pudo encontrar puerto disponible cerca de $start_port"
            exit 1
        fi
    done
    
    echo $port
}

# =============================================================================
# CONFIGURACIÓN Y ARGUMENTOS
# =============================================================================

PHP_PORT=8000
VITE_PORT=5173
RUN_MIGRATIONS=true
USE_YARN=false

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -p|--php-port)
            PHP_PORT="$2"
            shift 2
            ;;
        -v|--vite-port)
            VITE_PORT="$2"
            shift 2
            ;;
        --no-migrate)
            RUN_MIGRATIONS=false
            shift
            ;;
        --yarn)
            USE_YARN=true
            shift
            ;;
        *)
            echo "❌ Opción desconocida: $1"
            show_help
            exit 1
            ;;
    esac
done

# Capturar señales para limpieza
trap cleanup SIGINT SIGTERM

# =============================================================================
# VALIDACIONES
# =============================================================================

# Verificar que estamos en un proyecto Laravel
if [ ! -f "artisan" ]; then
    echo "❌ No se encontró el archivo artisan."
    echo "   ¿Estás en la raíz de un proyecto Laravel?"
    echo "   Usa: laravel new mi-proyecto para crear uno nuevo"
    exit 1
fi

# Verificar que existe package.json
if [ ! -f "package.json" ]; then
    echo "❌ No se encontró package.json. ¿Es un proyecto con frontend?"
    exit 1
fi

# Verificar puertos disponibles
if ! check_port $PHP_PORT; then
    echo "⚠️ Puerto $PHP_PORT ocupado, buscando alternativa..."
    PHP_PORT=$(find_available_port $PHP_PORT)
    echo "✅ Usando puerto $PHP_PORT para Laravel"
fi

if ! check_port $VITE_PORT; then
    echo "⚠️ Puerto $VITE_PORT ocupado, buscando alternativa..."
    VITE_PORT=$(find_available_port $VITE_PORT)
    echo "✅ Usando puerto $VITE_PORT para Vite"
fi

# =============================================================================
# INSTALACIÓN DE DEPENDENCIAS
# =============================================================================

echo "📦 Verificando dependencias..."

# Instalar dependencias de PHP
if [ ! -d "vendor" ] || [ ! -f "vendor/autoload.php" ]; then
    echo "📦 Instalando dependencias de PHP..."
    composer install --no-interaction --prefer-dist --optimize-autoloader
else
    echo "✅ Dependencias de PHP ya instaladas"
fi

# Instalar dependencias de Node.js
PKG_MANAGER="npm"
if $USE_YARN; then
    PKG_MANAGER="yarn"
fi

if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependencias de Node.js con $PKG_MANAGER..."
    $PKG_MANAGER install
else
    echo "✅ Dependencias de Node.js ya instaladas"
fi

# =============================================================================
# CONFIGURACIÓN INICIAL
# =============================================================================

echo "⚙️ Configurando proyecto..."

# Copiar .env si no existe
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "📄 Creado archivo .env desde .env.example"
    else
        echo "⚠️ No se encontró .env.example, creando .env básico..."
        cat > .env << EOF
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:$PHP_PORT

LOG_CHANNEL=stack

DB_CONNECTION=sqlite
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=laravel
# DB_USERNAME=root
# DB_PASSWORD=

VITE_DEV_SERVER_URL=http://localhost:$VITE_PORT
EOF
    fi
fi

# Actualizar APP_URL en .env para que coincida con el puerto
sed -i "s|APP_URL=.*|APP_URL=http://localhost:$PHP_PORT|" .env

# Generar clave de aplicación si no existe
if ! grep -q "APP_KEY=base64:" .env 2>/dev/null; then
    echo "🔑 Generando clave de aplicación..."
    php artisan key:generate --no-interaction
fi

# Crear base de datos SQLite si no existe
if grep -q "DB_CONNECTION=sqlite" .env && [ ! -f "database/database.sqlite" ]; then
    echo "🗄️ Creando base de datos SQLite..."
    touch database/database.sqlite
fi

# Ejecutar migraciones
if $RUN_MIGRATIONS && [ -d "database/migrations" ] && [ "$(ls -A database/migrations 2>/dev/null)" ]; then
    echo "🗄️ Ejecutando migraciones..."
    php artisan migrate --force --no-interaction
fi

# Limpiar cachés
echo "🧹 Limpiando cachés..."
php artisan config:clear >/dev/null 2>&1 || true
php artisan route:clear >/dev/null 2>&1 || true
php artisan view:clear >/dev/null 2>&1 || true

# =============================================================================
# CONFIGURACIÓN ESPECÍFICA PARA INERTIA + VITE
# =============================================================================

# Verificar si existe vite.config.js y configurarlo para proxy
if [ -f "vite.config.js" ]; then
    echo "⚙️ Configurando Vite para desarrollo..."
    # Backup del archivo original
    cp vite.config.js vite.config.js.backup 2>/dev/null || true
    
    # Crear configuración optimizada para Code Server
    cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import react from '@vitejs/plugin-react';

export default defineConfig({
    plugins: [
        laravel({
            input: 'resources/js/app.jsx',
            refresh: true,
        }),
        react(),
    ],
    server: {
        host: '0.0.0.0', // Escuchar en todas las interfaces
        port: 5173,
        strictPort: true,
        hmr: {
            host: 'localhost',
        },
    },
});
EOF
fi

# =============================================================================
# INICIO DE SERVICIOS
# =============================================================================

echo ""
echo "🌐 Iniciando servidor Laravel..."
echo "   📝 Accede vía: https://${PROXY_DOMAIN:-localhost:8443}/proxy/$PHP_PORT"

# Laravel debe escuchar en 0.0.0.0 para ser accesible desde el proxy
php artisan serve --host=0.0.0.0 --port=$PHP_PORT &
LARAVEL_PID=$!

# Esperar un poco para que Laravel inicie
sleep 3

echo ""
echo "⚡ Iniciando Vite dev server..."
echo "   📝 Accede vía: https://${PROXY_DOMAIN:-localhost:8443}/proxy/$VITE_PORT"

# Configurar variables de entorno para Vite
export VITE_DEV_SERVER_HOST="0.0.0.0"
export VITE_DEV_SERVER_PORT=$VITE_PORT

if $USE_YARN; then
    yarn dev --host=0.0.0.0 --port=$VITE_PORT &
else
    npm run dev -- --host=0.0.0.0 --port=$VITE_PORT &
fi
VITE_PID=$!

# =============================================================================
# INFORMACIÓN FINAL
# =============================================================================

sleep 5
echo ""
echo "✅ ¡Servicios iniciados exitosamente!"
echo ""
echo "🔗 URLs disponibles:"
if [ -n "$PROXY_DOMAIN" ]; then
    echo "   📝 Code Server (VS Code): https://$PROXY_DOMAIN"
    echo "   🐘 Laravel App: https://$PROXY_DOMAIN/proxy/$PHP_PORT"
    echo "   ⚡ Vite Dev Server: https://$PROXY_DOMAIN/proxy/$VITE_PORT"
    echo ""
    echo "   💡 También disponible vía subdominio (si tienes wildcard DNS):"
    echo "   🐘 Laravel App: https://$PHP_PORT.$PROXY_DOMAIN"
    echo "   ⚡ Vite Dev Server: https://$VITE_PORT.$PROXY_DOMAIN"
else
    echo "   📝 Code Server: http://localhost:8443"
    echo "   🐘 Laravel App: http://localhost:8443/proxy/$PHP_PORT"
    echo "   ⚡ Vite Dev Server: http://localhost:8443/proxy/$VITE_PORT"
fi
echo ""
echo "📊 Información de servicios:"
echo "   🐘 Laravel PID: $LARAVEL_PID (Puerto: $PHP_PORT)"
echo "   ⚡ Vite PID: $VITE_PID (Puerto: $VITE_PORT)"
echo ""
echo "💡 Presiona Ctrl+C para detener todos los servicios"
echo "📖 Panel de puertos de VS Code mostrará links automáticamente"

# =============================================================================
# ESPERAR HASTA CTRL+C
# =============================================================================

# Esperar a que se presione Ctrl+C
wait