# MF-007-US-006 — Prevención doble facturación: marcar tareas/horas/hitos/periodos como facturados; alertas

**Epic**: MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

**Como** usuario con permiso de facturación, **quiero** que el sistema impida facturar dos veces el mismo concepto o el mismo proyecto+periodo, **para** evitar errores de cobro y reclamaciones.

**Criterios de aceptación**:
- **Por periodo**: para un mismo proyecto y mismo periodo (mes/rango), no se permite una segunda factura **publicada**; mensaje con referencia a la factura existente (salvo flujo de rectificación/NC).
- **Por tarea/hora/hito**: cada elemento solo puede vincularse a **una** factura; al generar líneas no aparecen elementos ya facturados; si la validación detecta conflicto (p. ej. concurrencia), se rechaza o se advierte según política.
- **Fee mensual**: un solo fee facturable por proyecto+mes en facturas publicadas.
- Al publicar, todos los conceptos incluidos en líneas quedan **marcados** como facturados de forma atómica con la publicación (o transacción equivalente).

### Campos de datos

| Campo | Descripción | Tipo |
|-------|-------------|------|
| factura.proyecto_id + periodo_facturado | Clave lógica anti-duplicado periodo | FK + periodo |
| tarea/registro/hito.factura_id | Vínculo único | FK / Null |
| validacion.mensaje | Texto de error/advertencia | Texto |

### Estimación de esfuerzo (con IA)

- Reglas de unicidad y validaciones en creación/publicación: **0,5–1 día**.
- Pruebas de casos borde (borrador vs publicada, rectificación): **0,25–0,5 días**.
- Total estimado para esta US: **~0,75–1,5 días** de desarrollo efectivo.

**Prioridad**: Alta
