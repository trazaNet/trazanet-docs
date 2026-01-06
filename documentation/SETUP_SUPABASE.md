# 📋 Guía: Configurar Supabase

## Paso 1: Crear Organización

1. Ve a: https://supabase.com/
2. Login con el email `dev@trazanet.com`
3. Click en el dropdown de organizaciones (arriba izquierda)
4. Click **"New organization"**
5. Nombre: `TrazaNet`

## Paso 2: Crear Proyecto de Desarrollo

1. Click **"New project"**
2. Completar:
   - **Name**: `trazanet-dev`
   - **Database Password**: (guardar en lugar seguro!)
   - **Region**: South America (São Paulo) - más cercano a Uruguay
   - **Plan**: Free (por ahora)
3. Click **"Create new project"**
4. Esperar 2-3 minutos a que se cree

## Paso 3: Obtener Credenciales

1. Ir a **Settings** > **API**
2. Copiar:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public key**: `eyJhbxxxxxx`
   - **service_role key**: `eyJhbxxxxxx` (solo para backend!)

## Paso 4: Configurar Base de Datos

1. Ir a **SQL Editor**
2. Ejecutar el siguiente script:

```sql
-- Tabla de perfiles (extiende auth.users)
CREATE TABLE IF NOT EXISTS perfiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nombre TEXT NOT NULL,
  apellido TEXT DEFAULT '',
  telefono TEXT,
  email TEXT NOT NULL,
  dicose VARCHAR(50),
  rol TEXT CHECK (rol IN ('admin', 'veterinario', 'propietario')) DEFAULT 'propietario',
  verificado BOOLEAN DEFAULT false,
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de animales
CREATE TABLE IF NOT EXISTS animales (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  dispositivo VARCHAR(50) UNIQUE NOT NULL,
  raza VARCHAR(100),
  sexo VARCHAR(10),
  fecha_nacimiento DATE,
  propietario_dicose VARCHAR(50),
  estado VARCHAR(20) DEFAULT 'activo',
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de lotes
CREATE TABLE IF NOT EXISTS lotes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT,
  tipo VARCHAR(50),
  estado VARCHAR(20) DEFAULT 'activo',
  propietario_id UUID REFERENCES perfiles(id),
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de lecturas (desde app móvil)
CREATE TABLE IF NOT EXISTS lecturas (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  dispositivo VARCHAR(50) NOT NULL,
  fecha_lectura TIMESTAMP WITH TIME ZONE NOT NULL,
  lote_id UUID REFERENCES lotes(id),
  usuario_id UUID REFERENCES auth.users(id),
  latitud DECIMAL(10,8),
  longitud DECIMAL(11,8),
  sincronizado BOOLEAN DEFAULT true,
  creado_en TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_animales_dispositivo ON animales(dispositivo);
CREATE INDEX IF NOT EXISTS idx_animales_propietario ON animales(propietario_dicose);
CREATE INDEX IF NOT EXISTS idx_lecturas_dispositivo ON lecturas(dispositivo);
CREATE INDEX IF NOT EXISTS idx_lecturas_lote ON lecturas(lote_id);
```

## Paso 5: Configurar RLS (Row Level Security)

```sql
-- Habilitar RLS
ALTER TABLE perfiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE animales ENABLE ROW LEVEL SECURITY;
ALTER TABLE lotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE lecturas ENABLE ROW LEVEL SECURITY;

-- Políticas para perfiles
CREATE POLICY "Users can view own profile" ON perfiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON perfiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON perfiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Políticas para animales (todos pueden leer, solo admin escribe)
CREATE POLICY "Anyone can view animales" ON animales
  FOR SELECT USING (true);

CREATE POLICY "Authenticated can insert animales" ON animales
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Políticas para lotes
CREATE POLICY "Users can view own lotes" ON lotes
  FOR SELECT USING (propietario_id = auth.uid());

CREATE POLICY "Users can insert own lotes" ON lotes
  FOR INSERT WITH CHECK (propietario_id = auth.uid());

-- Políticas para lecturas
CREATE POLICY "Users can view own lecturas" ON lecturas
  FOR SELECT USING (usuario_id = auth.uid());

CREATE POLICY "Users can insert lecturas" ON lecturas
  FOR INSERT WITH CHECK (usuario_id = auth.uid());
```

## Paso 6: Guardar Credenciales

Crear archivo `.env` en cada proyecto con las credenciales.

**IMPORTANTE**: Nunca commitear el archivo `.env`!

## Proyectos Adicionales (Futuro)

Cuando estés listo para producción:
1. Crear `trazanet-staging` (testing)
2. Crear `trazanet-prod` (producción)

Cada uno con su propia base de datos y credenciales.

## ✅ Listo!

Tu Supabase está configurado. Próximos pasos:
- Configurar Auth providers (email, Google, etc.)
- Agregar Storage buckets para imágenes
- Configurar Edge Functions si necesitás lógica serverless
