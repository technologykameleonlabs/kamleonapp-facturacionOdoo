-- =============================================
-- SEED: CATEGORÍAS DE APUNTES ANALÍTICOS
-- EP-020 - Sistema de apuntes unificados
-- =============================================

-- Nota: Los datos básicos ya se insertan en el SQL principal
-- Este archivo es para categorías adicionales o de testing

-- Categorías adicionales para diferentes tipos de costes
INSERT INTO analytics.mst_analytics_categories (name, type, color) VALUES
('Marketing Digital', 'cost', '#E91E63'),
('Formación', 'cost', '#9C27B0'),
('Equipamiento', 'cost', '#3F51B5'),
('Subcontratación', 'cost', '#2196F3'),
('Viajes Nacionales', 'cost', '#00BCD4'),
('Viajes Internacionales', 'cost', '#009688'),
('Eventos', 'cost', '#4CAF50'),
('Publicidad', 'cost', '#8BC34A'),
('Legal', 'cost', '#CDDC39'),
('Contabilidad', 'cost', '#FFEB3B');

-- Categorías de ingresos adicionales
INSERT INTO analytics.mst_analytics_categories (name, type, color) VALUES
('Consultoría Técnica', 'revenue', '#FFC107'),
('Desarrollo Personalizado', 'revenue', '#FF9800'),
('Mantenimiento', 'revenue', '#FF5722'),
('Licencias', 'revenue', '#795548'),
('Soporte Técnico', 'revenue', '#607D8B');

-- Verificar que las categorías existen
SELECT 'CATEGORÍAS DE COSTES:' as tipo;
SELECT name, type, color
FROM analytics.mst_analytics_categories
WHERE type = 'cost'
ORDER BY name;

SELECT 'CATEGORÍAS DE INGRESOS:' as tipo;
SELECT name, type, color
FROM analytics.mst_analytics_categories
WHERE type = 'revenue'
ORDER BY name;
