-- ================================================
-- NUVO Pool System - Database Migration
-- PostgreSQL Version
-- ================================================

-- Conectar a la base de datos de pools
\c nuvo_pool_db;

-- ========== 1. CREAR TABLA POOLS ==========
CREATE TABLE IF NOT EXISTS pools (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(1000),
    interest_rate_per_day DOUBLE PRECISION NOT NULL,
    max_participants INTEGER NOT NULL,
    active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- ========== 2. MODIFICAR TABLA INVESTMENTS ==========
-- Agregar columna pool_id si no existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'investments' AND column_name = 'pool_id'
    ) THEN
        ALTER TABLE investments ADD COLUMN pool_id BIGINT;
        
        -- Agregar constraint de foreign key
        ALTER TABLE investments 
        ADD CONSTRAINT fk_investments_pool 
        FOREIGN KEY (pool_id) REFERENCES pools(id);
    END IF;
END $$;

-- ========== 3. CREAR POOL POR DEFECTO ==========
INSERT INTO pools (name, description, interest_rate_per_day, max_participants, active)
VALUES ('Pool General', 'Pool de inversión general por defecto', 0.01, 1000, true)
ON CONFLICT (name) DO NOTHING;

-- ========== 4. MIGRAR INVERSIONES EXISTENTES AL POOL POR DEFECTO ==========
-- Actualizar todas las inversiones que no tienen pool asignado
UPDATE investments 
SET pool_id = (SELECT id FROM pools WHERE name = 'Pool General')
WHERE pool_id IS NULL;

-- ========== 5. CREAR POOLS DE EJEMPLO ==========
INSERT INTO pools (name, description, interest_rate_per_day, max_participants, active)
VALUES 
    ('Pool Conservador', 'Inversión de bajo riesgo con rendimientos estables', 0.005, 50, true),
    ('Pool Moderado', 'Balance entre riesgo y rentabilidad', 0.01, 100, true),
    ('Pool Agresivo', 'Alto riesgo, altos rendimientos potenciales', 0.02, 30, true)
ON CONFLICT (name) DO NOTHING;

-- ========== 6. VERIFICACIÓN ==========
SELECT 'Migración completada exitosamente' AS status;
SELECT 
    COUNT(*) as total_pools,
    SUM(CASE WHEN active = true THEN 1 ELSE 0 END) as active_pools
FROM pools;

SELECT 
    COUNT(*) as total_investments,
    COUNT(pool_id) as investments_with_pool,
    COUNT(*) - COUNT(pool_id) as investments_without_pool
FROM investments;
