-- ============================================
-- TrazaNet Database Schema
-- Generado para trazanet-dev
-- ============================================

-- ============================================
-- 1. CORE: Usuarios y Perfiles
-- ============================================

CREATE TABLE IF NOT EXISTS perfiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    nombre TEXT,
    telefono TEXT,
    email TEXT,
    rol TEXT DEFAULT 'propietario',
    creado_en TIMESTAMP DEFAULT now()
);

-- ============================================
-- 2. CORE: Establecimientos
-- ============================================

CREATE TABLE IF NOT EXISTS establecimientos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL,
    dicose TEXT,
    departamento TEXT,
    creado_por UUID REFERENCES perfiles(id),
    fecha_creacion TIMESTAMP DEFAULT now()
);

-- ============================================
-- 3. CORE: Lotes
-- ============================================

CREATE TABLE IF NOT EXISTS lotes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL,
    establecimiento TEXT,
    establecimiento_id UUID REFERENCES establecimientos(id),
    color TEXT,
    fecha_creacion TIMESTAMP DEFAULT now()
);

-- ============================================
-- 4. CORE: Animales
-- ============================================

CREATE TABLE IF NOT EXISTS animales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    caravana TEXT NOT NULL,
    sexo TEXT,
    fecha_nacimiento DATE,
    fecha_alta TIMESTAMP DEFAULT now(),
    activo BOOLEAN DEFAULT true
);

CREATE INDEX IF NOT EXISTS idx_animales_caravana ON animales(caravana);

-- ============================================
-- 5. CORE: Lecturas (desde app móvil)
-- ============================================

CREATE TABLE IF NOT EXISTS lecturas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animales(id),
    lector_id UUID,
    trabajo_id UUID,
    lote_id UUID REFERENCES lotes(id),
    fecha TIMESTAMP DEFAULT now(),
    ubicacion JSONB
);

CREATE INDEX IF NOT EXISTS idx_lecturas_animal ON lecturas(animal_id);
CREATE INDEX IF NOT EXISTS idx_lecturas_lote ON lecturas(lote_id);

-- ============================================
-- 6. CORE: Movimientos de animales
-- ============================================

CREATE TABLE IF NOT EXISTS movimientos_animales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animales(id),
    lote_origen UUID REFERENCES lotes(id),
    lote_destino UUID REFERENCES lotes(id),
    fecha TIMESTAMP DEFAULT now(),
    motivo TEXT
);

-- ============================================
-- 7. PESO: Historial de pesaje
-- ============================================

CREATE TABLE IF NOT EXISTS peso_animales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animales(id),
    peso NUMERIC,
    cc NUMERIC,  -- Condición corporal
    fecha TIMESTAMP DEFAULT now(),
    estimado BOOLEAN DEFAULT false
);

-- ============================================
-- 8. VETERINARIO: Trabajos
-- ============================================

CREATE TABLE IF NOT EXISTS trabajos_veterinarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    veterinario_id UUID REFERENCES perfiles(id),
    tipo_trabajo TEXT,
    establecimiento_id UUID REFERENCES establecimientos(id),
    fecha_inicio TIMESTAMP DEFAULT now(),
    fecha_fin TIMESTAMP,
    notas TEXT
);

-- ============================================
-- 9. VETERINARIO: Certificaciones
-- ============================================

CREATE TABLE IF NOT EXISTS certificaciones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animales(id),
    veterinario_id UUID REFERENCES perfiles(id),
    trabajo_id UUID REFERENCES trabajos_veterinarios(id),
    tipo TEXT NOT NULL,
    resultado TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT now(),
    estado TEXT DEFAULT 'pendiente',
    notas TEXT
);

-- ============================================
-- 10. VETERINARIO: Diagnósticos
-- ============================================

CREATE TABLE IF NOT EXISTS diagnosticos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animales(id),
    tipo TEXT,
    resultado TEXT,
    detalle JSONB,
    fecha TIMESTAMP DEFAULT now()
);

-- ============================================
-- 11. VETERINARIO: Manejos aplicados
-- ============================================

CREATE TABLE IF NOT EXISTS manejos_aplicados (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animales(id),
    lote_id UUID REFERENCES lotes(id),
    manejo TEXT,
    realizado_por TEXT,
    fecha TIMESTAMP DEFAULT now()
);

-- ============================================
-- 12. ALERTAS
-- ============================================

CREATE TABLE IF NOT EXISTS alertas_detectadas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animales(id),
    lote_esperado UUID REFERENCES lotes(id),
    lote_detectado UUID REFERENCES lotes(id),
    tipo TEXT NOT NULL,
    motivo TEXT,
    fecha TIMESTAMP DEFAULT now(),
    resuelto BOOLEAN DEFAULT false,
    resuelto_por TEXT,
    fecha_resuelto TIMESTAMP,
    comentario TEXT
);

-- ============================================
-- 13. ETIQUETAS (Tags personalizados)
-- ============================================

CREATE TABLE IF NOT EXISTS etiquetas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL,
    color TEXT,
    descripcion TEXT,
    creada_por TEXT,
    fecha_creacion TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS etiquetas_animales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animales(id),
    etiqueta_id UUID REFERENCES etiquetas(id),
    fecha TIMESTAMP DEFAULT now()
);

-- ============================================
-- 14. GEO: Antenas/Lectores fijos
-- ============================================

CREATE TABLE IF NOT EXISTS antenas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mac_address TEXT NOT NULL,
    nivel INTEGER,
    es_gps BOOLEAN DEFAULT false,
    lat DOUBLE PRECISION,
    lon DOUBLE PRECISION,
    ultima_comunicacion TIMESTAMP,
    estado TEXT,
    vecinos_detectados JSONB,
    dicose TEXT
);

-- ============================================
-- 15. GEO: Ubicaciones de animales
-- ============================================

CREATE TABLE IF NOT EXISTS ubicaciones_animales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animales(id),
    lat NUMERIC,
    lon NUMERIC,
    timestamp TIMESTAMP DEFAULT now(),
    fuente TEXT
);

-- ============================================
-- 16. GEO: Parcelas
-- ============================================

CREATE TABLE IF NOT EXISTS parcelas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL,
    geojson JSONB NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT now()
);

-- ============================================
-- 17. VISTA: Antenas GPS
-- ============================================

CREATE OR REPLACE VIEW antenas_gps_ubicacion AS
SELECT 
    id,
    mac_address,
    lat,
    lon,
    dicose,
    ultima_comunicacion
FROM antenas
WHERE es_gps = true;

-- ============================================
-- RLS: Row Level Security
-- ============================================

ALTER TABLE perfiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE animales ENABLE ROW LEVEL SECURITY;
ALTER TABLE lotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE lecturas ENABLE ROW LEVEL SECURITY;
ALTER TABLE establecimientos ENABLE ROW LEVEL SECURITY;

-- Políticas básicas (ajustar según necesidad)
CREATE POLICY "Users can view own profile" ON perfiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON perfiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON perfiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Permitir lectura de animales a usuarios autenticados
CREATE POLICY "Authenticated can read animales" ON animales
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated can insert animales" ON animales
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Permitir lectura de lotes a usuarios autenticados
CREATE POLICY "Authenticated can read lotes" ON lotes
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated can insert lotes" ON lotes
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Permitir lecturas a usuarios autenticados
CREATE POLICY "Authenticated can read lecturas" ON lecturas
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated can insert lecturas" ON lecturas
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');
