# MF-011-US-001 — Maestro Términos de pago (nombre, tipo, días, vencimientos)

**Epic**: MF-011 — Maestros

**Como** administrador, **quiero** mantener un maestro de términos de pago (nombre, tipo: contado/30 días/etc., días o fechas de vencimiento), **para** poder asignarlos a las facturas y calcular vencimientos automáticamente.

**Criterios de aceptación**: CRUD de términos de pago; al menos nombre, tipo y días o regla de vencimiento; disponibles al crear/editar factura.

### Campos de datos

| Campo               | Descripción                                                      | Tipo                 |
|---------------------|------------------------------------------------------------------|----------------------|
| nombre              | Nombre del término de pago (Contado, 30 días, 60 días, etc.)    | Texto corto          |
| tipo                | Clasificación del término (contado, 30 días, 60 días, custom…)  | Enumerado            |
| dias_vencimiento    | Número de días desde la fecha de factura hasta el vencimiento   | Entero               |
| regla_vencimiento   | Regla alternativa (fechas fijas, % a 30/60 días, etc.)          | Texto estructurado   |
| activo              | Indica si el término se puede usar en nuevas facturas           | Booleano             |
| orden_visualizacion | Orden sugerido en listados y combos                             | Entero / opcional    |

### Estimación de esfuerzo (con IA)

- Diseño de modelo + migración básica: **0,25 días**.
- API/servicio CRUD + validaciones: **0,5 días**.
- Pantallas de alta/edición/listado con filtros simples: **0,5 días**.
- Total estimado para esta US (apoyándose en IA): **~1,25 días** de desarrollo efectivo.

**Prioridad**: Alta
