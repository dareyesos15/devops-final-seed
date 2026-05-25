# Guia de despliegue en EC2

Este repositorio queda listo para ejecutarse en una instancia EC2 usando Docker Compose.

## 1. Preparar EC2

- Crear instancia Ubuntu 22.04 o Amazon Linux 2023
- Abrir puertos en Security Group:
  - `22` (SSH)
  - `8081` (Nexus UI/API)
  - `8083` (Nexus Docker Registry)
  - `5000` (API)
  - `9090` (Prometheus)
  - `3000` (Grafana)
- Instalar Docker y plugin de Compose

## 2. Obtener codigo

```bash
git clone <repo-url>
cd devops-final-seed
```

## 3. Configurar variables

Crear archivo `.env`:

```env
IMAGE_NAME=<ec2-public-ip-or-dns>:8083/todo-api
IMAGE_TAG=latest
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=<cambiar-esto>
```

## 4. Levantar stack (incluyendo Nexus)

```bash
docker compose up -d
```

## 5. Configurar Nexus (primera vez)

- Entrar a `http://<ec2-public-ip-or-dns>:8081`
- Crear repositorio `docker-hosted` con conector HTTP en puerto `8083`
- Crear repositorio `devops-raw` para almacenar reportes de pipeline
- Crear usuario de CI con permisos de push/pull

## 6. Login Docker en EC2 para pull de imagen privada

```bash
docker login <ec2-public-ip-or-dns>:8083
docker compose pull
docker compose up -d
```

## 7. Validar servicios

- API: `http://<ec2-public-ip>:5000/health`
- Prometheus: `http://<ec2-public-ip>:9090`
- Grafana: `http://<ec2-public-ip>:3000`
- Nexus UI: `http://<ec2-public-ip>:8081`

## 8. Endurecimiento recomendado

- Usar Nginx o ALB con TLS (LetsEncrypt o ACM)
- Restringir puertos 9090 y 3000 por IP/VPN
- Restringir puertos 8081 y 8083 por IP/VPN
- Rotar credenciales y mover secretos a AWS SSM/Secrets Manager
- Programar backups de volumenes Docker
