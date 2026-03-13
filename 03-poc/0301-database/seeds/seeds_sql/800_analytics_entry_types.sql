-- =============================================
-- SEED: TIPOS DE APUNTES ANALÍTICOS
-- EP-020 - Sistema de apuntes unificados
-- =============================================

-- Nota: Los datos básicos ya se insertan en el SQL principal
-- Este archivo es para datos adicionales o de testing

-- Tipos adicionales si son necesarios en el futuro
-- INSERT INTO analytics.mst_analytics_entry_types (code, name, category, color, sort_order) VALUES
-- ('INTERNAL_ADJUSTMENT', 'Ajuste Interno', 'adjustment', '#9CA3AF', 6)
-- ON CONFLICT (code) DO NOTHING;

-- Verificar que los datos existen
SELECT 'TIPOS DE APUNTES ANALÍTICOS:' as info;
SELECT code, name, category, color
FROM analytics.mst_analytics_entry_types
ORDER BY sort_order;
