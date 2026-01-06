# 📋 Checklist de Setup - TrazaNet

Usá este checklist para trackear tu progreso.

## Fase 1: Identidad Digital

- [ ] **Dominio**
  - [ ] Registrar `trazanet.com` 
  - [ ] Verificar que funciona (puede tardar hasta 48hs)

- [ ] **Email Corporativo**
  - [ ] Crear cuenta Google Workspace o Zoho
  - [ ] Verificar dominio (registro TXT)
  - [ ] Configurar MX records
  - [ ] Crear `dev@trazanet.com`
  - [ ] Crear `admin@trazanet.com`
  - [ ] Probar envío/recepción de emails

## Fase 2: GitHub

- [ ] **Organización**
  - [ ] Crear org `trazanet` en GitHub
  - [ ] Configurar con email `dev@trazanet.com`

- [ ] **Git Local**
  - [ ] Configurar `git config` con email corporativo
  - [ ] Generar SSH key
  - [ ] Agregar SSH key a GitHub
  - [ ] Probar conexión: `ssh -T git@github.com`

- [ ] **Repositorios**
  - [ ] Crear `trazanet-mobile`
  - [ ] Crear `trazanet-api`
  - [ ] Crear `trazanet-web`
  - [ ] Crear `trazanet-infra`

## Fase 3: Supabase

- [ ] **Organización**
  - [ ] Crear org "TrazaNet" en Supabase
  - [ ] Usar email `dev@trazanet.com`

- [ ] **Proyecto Dev**
  - [ ] Crear proyecto `trazanet-dev`
  - [ ] Guardar Database Password
  - [ ] Copiar URL y keys

- [ ] **Base de Datos**
  - [ ] Ejecutar script de creación de tablas
  - [ ] Configurar RLS policies
  - [ ] Probar conexión

## Fase 4: Migración de Código

- [ ] **Mobile**
  - [ ] Clonar repo `trazanet-mobile`
  - [ ] Copiar código de `bt-test-app`
  - [ ] Actualizar package identifiers
  - [ ] Copiar templates (README, .gitignore)
  - [ ] Commit y push
  - [ ] Verificar que compila

- [ ] **API**
  - [ ] Clonar repo `trazanet-api`
  - [ ] Copiar templates
  - [ ] Instalar dependencias
  - [ ] Configurar .env
  - [ ] Probar que corre

- [ ] **Web** (más adelante)
  - [ ] Clonar repo `trazanet-web`
  - [ ] Migrar código de `trazaMovil`

## Fase 5: Infraestructura

- [ ] **Docker**
  - [ ] Copiar docker-compose.yml
  - [ ] Probar `docker-compose up`

- [ ] **CI/CD**
  - [ ] Copiar workflows de GitHub Actions
  - [ ] Configurar secrets en GitHub
  - [ ] Probar pipeline

---

## Notas

Fecha de inicio: _______________

Dominio comprado en: _______________

Email configurado: _______________
