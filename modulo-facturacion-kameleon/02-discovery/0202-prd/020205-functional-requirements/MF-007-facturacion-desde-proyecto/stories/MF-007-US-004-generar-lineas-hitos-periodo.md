# MF-007-US-004 — Generar líneas desde hitos completados en el periodo (no facturados previamente)

**Epic**: MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

**Como** usuario con permiso de facturación, **quiero** que los hitos del proyecto completados en el periodo y no facturados generen líneas de factura, **para** cobrar entregables acordados de forma trazable.

**Criterios de aceptación**:
- Se listan hitos con estado completado en el periodo y **sin** factura asociada.
- Cada hito genera una línea con descripción (nombre hito) e importe (presupuestado, fijo o según regla de proyecto).
- Edición/exclusión en borrador (MF-003) permitida antes de publicar.
- Al publicar, los hitos incluidos quedan marcados como facturados.

### Campos de datos

| Campo | Descripción | Tipo |
|-------|-------------|------|
| linea.origen_tipo | Valor `hito` | Enumerado |
| linea.origen_id | Identificador del hito | Entero / UUID |
| hito.estado | Completado | Enumerado |
| hito.factura_id | Asignación tras publicar | Relación (FK) / Null |

### Estimación de esfuerzo (con IA)

- Consulta hitos por periodo + líneas: **0,4–0,75 días**.
- Marcado facturado al publicar: **0,2–0,35 días**.
- Total estimado para esta US: **~0,6–1,1 días** de desarrollo efectivo.

**Prioridad**: Alta
