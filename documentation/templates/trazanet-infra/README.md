# TrazaNet Infrastructure

Configuración de infraestructura para TrazaNet.

## 📂 Contenido

```
trazanet-infra/
├── docker/
│   ├── docker-compose.yml      # Desarrollo local
│   └── docker-compose.prod.yml # Producción
├── k8s/                        # Kubernetes manifests (futuro)
├── github/
│   └── workflows/              # CI/CD pipelines
└── scripts/                    # Scripts de utilidad
```

## 🐳 Docker - Desarrollo Local

### Iniciar todos los servicios

```bash
cd docker
docker-compose up -d
```

### Servicios disponibles

| Servicio | Puerto | URL |
|----------|--------|-----|
| API | 4000 | http://localhost:4000 |
| Web | 3000 | http://localhost:3000 |

### Ver logs

```bash
docker-compose logs -f api
docker-compose logs -f web
```

### Detener

```bash
docker-compose down
```

## 🔄 CI/CD

GitHub Actions workflows para:
- Build y test en cada PR
- Deploy automático a staging en merge a `main`
- Deploy manual a producción

## 📄 Licencia

Propiedad de +CríaUY. Todos los derechos reservados.
