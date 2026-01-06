# 🗄️ Esquema de Base de Datos - TrazaNet

## Visión General

TrazaNet usa **Supabase** (PostgreSQL) como base de datos principal.

---

## Tablas Principales

### `users` - Usuarios del sistema

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  dicose VARCHAR(50) UNIQUE NOT NULL,    -- Código DICOSE (identificador ganadero Uruguay)
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  password VARCHAR(255) NOT NULL,         -- Hash bcrypt
  name VARCHAR(100),
  last_name VARCHAR(100),
  role VARCHAR(20) DEFAULT 'user',        -- 'admin', 'user', 'veterinario', 'propietario'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### `perfiles` - Perfiles Supabase Auth

```sql
CREATE TABLE perfiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  apellido TEXT DEFAULT '',
  rol TEXT CHECK (rol IN ('veterinario', 'propietario')) DEFAULT 'propietario',
  verificado BOOLEAN DEFAULT false,
  email TEXT NOT NULL,
  telefono TEXT,
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### `animales` - Animales/Caravanas

```sql
CREATE TABLE animales (
  id SERIAL PRIMARY KEY,
  dispositivo VARCHAR(50),                 -- Número de caravana electrónica
  raza VARCHAR(100),
  cruza VARCHAR(100),
  sexo VARCHAR(10),                        -- 'M', 'H'
  edad_meses INTEGER,
  edad_dias INTEGER,
  propietario VARCHAR(50),                 -- Código DICOSE del propietario
  nombre_propietario VARCHAR(100),
  ubicacion VARCHAR(200),
  tenedor VARCHAR(100),                    -- Quien tiene físicamente el animal
  status_vida VARCHAR(50),                 -- 'vivo', 'muerto', 'faenado'
  status_trazabilidad VARCHAR(50),         -- Estado en SNIG
  errores TEXT,
  fecha_identificacion DATE,
  fecha_registro DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_animales_dispositivo ON animales(dispositivo);
CREATE INDEX idx_animales_propietario ON animales(propietario);
```

### `lotes` - Lotes/Grupos de animales

```sql
CREATE TABLE lotes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT,
  tipo VARCHAR(50),                        -- 'engorde', 'cría', 'recría'
  campo VARCHAR(255),
  latitud DECIMAL(10,8),
  longitud DECIMAL(11,8),
  fecha_inicio DATE,
  capacidad INTEGER,
  observaciones TEXT,
  estado VARCHAR(20) DEFAULT 'activo',     -- 'activo', 'cerrado', 'archivado'
  fecha_creacion TIMESTAMP DEFAULT NOW()
);
```

---

## Tablas Futuras (Planificadas)

### `movimientos` - Movimientos de animales

```sql
CREATE TABLE movimientos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  animal_id INTEGER REFERENCES animales(id),
  lote_origen_id UUID REFERENCES lotes(id),
  lote_destino_id UUID REFERENCES lotes(id),
  tipo_movimiento VARCHAR(50),             -- 'entrada', 'salida', 'transferencia'
  fecha_movimiento TIMESTAMP,
  observaciones TEXT,
  usuario_id UUID REFERENCES auth.users(id),
  created_at TIMESTAMP DEFAULT NOW()
);
```

### `lecturas_bt` - Lecturas Bluetooth (desde app móvil)

```sql
CREATE TABLE lecturas_bt (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  dispositivo VARCHAR(50) NOT NULL,        -- Caravana leída
  fecha_lectura TIMESTAMP NOT NULL,
  lote_id UUID REFERENCES lotes(id),
  latitud DECIMAL(10,8),
  longitud DECIMAL(11,8),
  usuario_id UUID REFERENCES auth.users(id),
  sincronizado BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## Políticas RLS (Row Level Security)

Para `perfiles`:
```sql
-- Usuarios autenticados pueden leer
CREATE POLICY "Enable read for authenticated" ON perfiles
  FOR SELECT USING (auth.role() = 'authenticated');

-- Usuarios pueden insertar su perfil
CREATE POLICY "Enable insert for authenticated" ON perfiles
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Usuarios pueden actualizar solo su perfil
CREATE POLICY "Enable update own profile" ON perfiles
  FOR UPDATE USING (auth.uid() = id);
```

---

## Datos de Prueba

Ver: [credentials/README.md](../credentials/README.md)

Usuarios de prueba:
| Email | Password | Rol |
|-------|----------|-----|
| admin@mail.com | admin123 | Admin |
| test@example.com | password | User |
