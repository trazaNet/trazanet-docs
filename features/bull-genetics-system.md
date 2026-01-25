# Sistema de Perfiles Genéticos de Toros

## Objetivo

Permitir a los usuarios de TrazaNet acceder a un catálogo completo de toros reproductores con evaluaciones genéticas oficiales (INIA/ARU Uruguay), facilitando:

- **Selección de toros para inseminación artificial** sin ingreso manual
- **Análisis de impacto genético** en la progenie
- **Rankings y comparaciones** entre reproductores
- **Trazabilidad genealógica** (vincular padres con hijos)

---

## Arquitectura

### Fuente de Datos

Los datos provienen de [geneticabovina.com.uy](https://www.geneticabovina.com.uy), portal oficial del INIA (Instituto Nacional de Investigación Agropecuaria) y ARU (Asociación Rural del Uruguay).

```
┌─────────────────────────────────────────────────────────────────┐
│                    geneticabovina.com.uy                        │
│                     (INIA/ARU Uruguay)                          │
└───────────────────────────┬─────────────────────────────────────┘
                            │ Scraper (Python)
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                   scraper_genetica_bovina/                      │
│  ├── scraper.py              # Descarga datos por establecimiento│
│  ├── import_to_supabase.py   # Importa a la base de datos       │
│  └── datos_genetica_bovina/  # Archivos descargados             │
└───────────────────────────┬─────────────────────────────────────┘
                            │ REST API
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                         Supabase                                │
│  ├── razas                   # Catálogo de razas               │
│  ├── cabanas                 # Establecimientos/criaderos      │
│  ├── toros                   # Perfiles de reproductores       │
│  ├── toros_deps              # DEPs por año de evaluación      │
│  ├── toros_favoritos         # Favoritos del usuario           │
│  └── animales_padres_genetica # Vinculación con animales       │
└───────────────────────────┬─────────────────────────────────────┘
                            │ API
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                      TrazaNet Mobile App                        │
│  - Búsqueda de toros                                            │
│  - Perfil detallado con DEPs                                    │
│  - Favoritos                                                     │
│  - Asignación de padres a animales                              │
└─────────────────────────────────────────────────────────────────┘
```

---

## Modelo de Datos

### Tabla: `razas`

Catálogo de razas bovinas disponibles.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| id | SERIAL | ID único |
| codigo | VARCHAR(10) | Código corto (AN, HE, etc.) |
| nombre | VARCHAR(100) | Nombre completo |
| url_asociacion | VARCHAR(255) | URL de la asociación de criadores |

**Razas disponibles:** Angus, Hereford, Polled Hereford, Bradford, Brangus, Charolais, Limousin, Holando, Jersey, Normando, Shorthorn

---

### Tabla: `cabanas`

Establecimientos/cabañas donde se crían los reproductores.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| id | SERIAL | ID único |
| codigo_externo | VARCHAR(20) | Código INIA (ej: I459, R374) |
| nombre | VARCHAR(200) | Nombre del establecimiento |
| raza_id | INTEGER | Raza principal |
| departamento | VARCHAR(100) | Ubicación |

---

### Tabla: `toros`

Perfiles de toros reproductores.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| id | SERIAL | ID único |
| nombre | VARCHAR(200) | Nombre del toro |
| hbu | VARCHAR(50) | **Herd Book Uruguay** (registro único) |
| rp | VARCHAR(50) | Registro Particular |
| cabana_id | INTEGER | Cabaña de origen |
| raza_id | INTEGER | Raza |
| fecha_nacimiento | DATE | Fecha de nacimiento |
| padre_hbu | VARCHAR(50) | HBU del padre |
| madre_hbu | VARCHAR(50) | HBU de la madre |
| disponible_semen | BOOLEAN | Si hay semen disponible |

---

### Tabla: `toros_deps`

DEPs (Diferencias Esperadas de Progenie) por año de evaluación.

| Columna | Tipo | Descripción |
|---------|------|-------------|
| toro_id | INTEGER | Referencia al toro |
| año_evaluacion | INTEGER | Año de la evaluación |
| **pavg** | DECIMAL | Índice de Producción de Carne |
| **gepd** | DECIMAL | DEP Genómico (con marcadores ADN) |

#### DEPs de Crecimiento

| DEP | Unidad | Descripción |
|-----|--------|-------------|
| dep_peso_nacer | kg | Peso al nacer (valores bajos = mejor facilidad de parto) |
| dep_peso_destete | kg | Peso al destete |
| dep_peso_18_meses | kg | Peso a los 18 meses |
| dep_peso_adulto_vaca | kg | Peso adulto de las hijas |

#### DEPs Reproductivos

| DEP | Unidad | Descripción |
|-----|--------|-------------|
| dep_circ_escrotal | cm | Circunferencia escrotal (fertilidad) |
| dep_habilidad_lechera | kg | Producción de leche de las hijas |
| dep_dias_parto | días | Días al primer parto |
| dep_paricion_vaq | % | Tasa de parición en vaquillonas |

#### DEPs de Carcasa/Calidad

| DEP | Unidad | Descripción |
|-----|--------|-------------|
| dep_aob | cm² | Área del Ojo del Bife |
| dep_egs | mm | Espesor de Grasa Subcutánea |
| dep_marb | score | Marbling (grasa intramuscular) |

---

## Casos de Uso

### 1. Búsqueda de Toros para Inseminación

```sql
-- Buscar toros por nombre o HBU
SELECT * FROM buscar_toros('ANGUS CHAMPION', 'AN', 20);
```

**En la app:**

- Usuario busca "ANGUS"
- Ve lista ordenada por PAVG (índice de producción)
- Selecciona toro para asignar a inseminación

### 2. Ver Perfil Completo

```sql
SELECT * FROM vw_perfil_toros WHERE id = 123;
```

Muestra: nombre, cabaña, todos los DEPs, padre, madre, etc.

### 3. Asignar Padre a Animal

```sql
INSERT INTO animales_padres_genetica (animal_id, toro_padre_id, confirmado)
VALUES ('uuid-del-animal', 123, true);
```

El usuario selecciona un animal de su rodeo y le asigna el toro padre del catálogo.

### 4. Ranking de Toros

```sql
-- Top 10 toros por peso al destete
SELECT nombre, hbu, cabana_nombre, dep_peso_destete
FROM vw_perfil_toros
WHERE raza_codigo = 'AN'
ORDER BY dep_peso_destete DESC
LIMIT 10;
```

### 5. Análisis de Impacto Genético

Si un usuario usó el toro X para inseminar, puede ver:

- DEPs esperados en la progenie
- Comparación con promedios de la raza
- Tendencias genéticas de su rodeo

---

## Scripts de Mantenimiento

### Actualizar datos (mensualmente)

```bash
cd scraper_genetica_bovina

# 1. Descargar nuevos datos
python scraper.py

# 2. Importar a Supabase
python import_to_supabase.py
```

### Agregar nueva raza

1. Insertar en tabla `razas`
2. Modificar `scraper.py` para incluir el `raza_id`
3. Ejecutar scraper

---

## Estadísticas Actuales

- **Raza:** Angus
- **Establecimientos:** ~245 cabañas
- **Archivos:** 490 (2 años x 245 cabañas)
- **Años disponibles:** 2023, 2024
- **Evaluación:** Diciembre 2025

---

## Próximos Pasos

1. [ ] Crear endpoints API para búsqueda de toros
2. [ ] Pantalla de búsqueda en la app móvil
3. [ ] Pantalla de perfil detallado del toro
4. [ ] Funcionalidad de favoritos
5. [ ] Asignación de padre a animales del usuario
6. [ ] Ranking y comparaciones
7. [ ] Gráficos de tendencias genéticas
8. [ ] Agregar más razas (Hereford, etc.)

---

## Archivos Relacionados

- [`scraper_genetica_bovina/scraper.py`](../scraper_genetica_bovina/scraper.py) - Descarga datos
- [`scraper_genetica_bovina/import_to_supabase.py`](../scraper_genetica_bovina/import_to_supabase.py) - Importa a BD
- [`migrations/009_create_bull_genetics.sql`](../trazanet-api-new/migrations/009_create_bull_genetics.sql) - Schema de BD
