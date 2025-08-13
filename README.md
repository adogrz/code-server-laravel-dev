# 🚀 Code Server - Entorno de Desarrollo Laravel + React + InertiaJS

<div align="center">

![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)
![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![InertiaJS](https://img.shields.io/badge/Inertia-9553E9?style=for-the-badge&logo=inertia&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![VS Code](https://img.shields.io/badge/VS_Code-007ACC?style=for-the-badge&logo=visual-studio-code&logoColor=white)

**Entorno de desarrollo completo y containerizado con VS Code en el navegador**

[🚀 Inicio Rápido](#-inicio-rápido) •
[📋 Características](#-características) •
[⚙️ Configuración](#️-configuración) •
[📖 Documentación](#-documentación)

</div>

---

## 🎯 Descripción

Un entorno de desarrollo completo y moderno para Laravel + React + InertiaJS que funciona completamente en el navegador a través de Code Server. Perfecto para desarrollo remoto, trabajo colaborativo o cuando necesitas un entorno consistente en cualquier dispositivo.

### ✨ ¿Por qué este proyecto?

- **🌐 Acceso desde cualquier lugar**: Desarrolla desde cualquier dispositivo con navegador
- **🔧 Entorno pre-configurado**: Todo listo para Laravel, React e InertiaJS
- **🐳 Containerizado**: Instalación limpia y reproducible
- **⚡ Desarrollo rápido**: Scripts automatizados para tareas comunes
- **🎨 VS Code completo**: Todas las extensiones y herramientas necesarias

---

## 📋 Características

### 🛠️ Stack Tecnológico

- **Backend**: PHP 8.2 + Laravel (última versión)
- **Frontend**: React 18 + InertiaJS + Vite
- **Base de Datos**: SQLite (por defecto) + MySQL/PostgreSQL
- **Editor**: VS Code Server con extensiones pre-instaladas
- **Herramientas**: Composer, NPM, Yarn, PNPM

### 🎁 Incluye

- ✅ PHP 8.2 con todas las extensiones de Laravel
- ✅ Node.js 22 LTS + gestores de paquetes
- ✅ Composer con Laravel Installer global
- ✅ Scripts automatizados para desarrollo
- ✅ Configuración optimizada para rendimiento
- ✅ Soporte para PWA y acceso remoto
- ✅ Cache persistente para dependencias
- ✅ Git pre-configurado

---

## 🚀 Inicio Rápido

### 📋 Requisitos Previos

- Docker y Docker Compose
- 4GB RAM mínimo
- Puerto 8443 disponible

### ⚡ Instalación en 3 Pasos

1. **Clonar y configurar**

   ```bash
   git clone https://github.com/tu-usuario/code-server-laravel-dev.git
   cd code-server-laravel-dev
   cp .env.example .env
   ```

2. **Personalizar configuración**

   ```bash
   # Edita .env con tus datos
   nano .env
   ```

3. **Levantar el entorno**
   ```bash
   docker-compose up -d
   ```

🎉 **¡Listo!** Accede a `https://tu-dominio.com` o `http://localhost:8443`

---

## ⚙️ Configuración

### 🔧 Variables de Entorno

| Variable        | Descripción                 | Ejemplo                |
| --------------- | --------------------------- | ---------------------- |
| `CODE_PASSWORD` | Contraseña para Code Server | `mi_password_seguro`   |
| `PROXY_DOMAIN`  | Tu dominio público          | `codigo.midominio.com` |
| `TIMEZONE`      | Zona horaria                | `America/El_Salvador`  |
| `PUID/PGID`     | IDs de usuario/grupo        | `1000`                 |

### 📁 Estructura de Directorios

```
code-server-laravel-dev/
├── 📄 docker-compose.yml     # Configuración de servicios
├── 🐳 Dockerfile            # Imagen personalizada
├── 📝 .env.example          # Variables de ejemplo
├── 🚀 dev-start.sh          # Script de desarrollo
├── 📋 .gitignore            # Archivos ignorados
└── 📋 .dockerignore         # Archivos excluidos del build
```

---

## 💻 Uso

### 🎯 Acceso al Editor

- **Navegador**: `https://tu-dominio.com`
- **Local**: `http://localhost:8443`
- **Password**: El configurado en `CODE_PASSWORD`

### 🛠️ Scripts de Desarrollo

#### Dentro del contenedor:

```bash
# Script principal de desarrollo Laravel + React
./dev-start.sh

# Con opciones personalizadas
./dev-start.sh -p 8001 -v 5174 --yarn

# Ver ayuda
./dev-start.sh --help
```

#### Comandos Docker:

```bash
# Iniciar servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Ejecutar comando en el contenedor
docker-compose exec code-server bash

# Parar servicios
docker-compose down
```

---

## 📖 Documentación

### 🎨 Crear Nuevo Proyecto Laravel + InertiaJS

1. **Accede al terminal** en Code Server
2. **Navega al workspace**: `cd /config/workspace`
3. **Crea proyecto Laravel**:
   ```bash
   laravel new mi-proyecto
   cd mi-proyecto
   ```
4. **Instala InertiaJS**:
   ```bash
   composer require inertiajs/inertia-laravel
   npm install @inertiajs/react
   ```
5. **Inicia desarrollo**:
   ```bash
   ./dev-start.sh
   ```

### 🔗 URLs de Desarrollo

Cuando uses `dev-start.sh`, tendrás acceso a:

- **🎨 Code Server**: `https://tu-dominio/`
- **🐘 Laravel App**: `https://tu-dominio/proxy/8000`
- **⚡ Vite Dev Server**: `https://tu-dominio/proxy/5173`

### 📊 Gestión de Puertos

El script automáticamente:

- ✅ Detecta puertos disponibles
- ✅ Configura proxy reverso
- ✅ Muestra URLs de acceso
- ✅ Gestiona procesos de desarrollo

---

## 🔧 Personalización

### 🎯 Extensiones de VS Code

Añade extensiones editando el `Dockerfile`:

```dockerfile
# Instalar extensiones específicas
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension bradlc.vscode-tailwindcss
```

### 🎨 Configuración de PHP

Modifica configuraciones en el `Dockerfile`:

```dockerfile
# Configurar PHP para desarrollo
RUN echo "memory_limit = 1G" >> /etc/php/8.2/cli/php.ini
RUN echo "max_execution_time = 600" >> /etc/php/8.2/cli/php.ini
```

### 🗄️ Base de Datos

**SQLite** (por defecto):

```bash
# Ya configurado, sin configuración adicional
touch database/database.sqlite
```

**MySQL/PostgreSQL**:

```bash
# Añadir al docker-compose.yml
services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: laravel
      MYSQL_ROOT_PASSWORD: password
```

---

## 🚨 Solución de Problemas

### ❌ Problemas Comunes

**Puerto 8443 ocupado**:

```bash
# Cambiar puerto en .env
HOST_PORT=8444
docker-compose up -d
```

**Permisos de archivos**:

```bash
# Ajustar PUID/PGID en .env
PUID=$(id -u)
PGID=$(id -g)
```

**Memoria insuficiente**:

```bash
# Aumentar memoria del contenedor
docker-compose down
docker system prune -f
docker-compose up -d
```

### 📋 Logs y Debugging

```bash
# Ver logs del contenedor
docker-compose logs code-server

# Acceder al contenedor
docker-compose exec code-server bash

# Verificar servicios
docker-compose ps
```

---

## 🤝 Contribución

¡Las contribuciones son bienvenidas! Por favor:

1. 🍴 **Fork** el proyecto
2. 🌿 **Crea** una branch para tu feature
3. 💻 **Commitea** tus cambios
4. 📤 **Push** a la branch
5. 🔄 **Abre** un Pull Request

### 📝 Desarrollo Local

```bash
# Clonar repo
git clone https://github.com/tu-usuario/code-server-laravel-dev.git

# Crear branch
git checkout -b feature/nueva-caracteristica

# Hacer cambios y probar
docker-compose up -d

# Commitear
git commit -m "feat: nueva característica increíble"
```

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

---

## 👨‍💻 Autor

**Adonay Gutierrez** - [@adogrz](https://github.com/adogrz)

- 📧 Email: adonaygutierrez50@gmail.com
- 🌐 Web: [tu-sitio-web.com](https://tu-sitio-web.com)

---

## ⭐ Soporte

Si este proyecto te ha sido útil, ¡dale una ⭐ en GitHub!

### 💡 ¿Encontraste un bug?

[Reportar Issue](https://github.com/tu-usuario/code-server-laravel-dev/issues/new)

### 💬 ¿Tienes preguntas?

[Iniciar Discusión](https://github.com/tu-usuario/code-server-laravel-dev/discussions)

---

<div align="center">

**🚀 ¡Hecho con ❤️ para la comunidad de desarrolladores!**

</div>
