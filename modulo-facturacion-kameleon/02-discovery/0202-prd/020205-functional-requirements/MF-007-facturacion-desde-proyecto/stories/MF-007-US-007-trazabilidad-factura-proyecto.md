# MF-007-US-007 — Trazabilidad factura → proyecto; listado de facturas por proyecto y por periodo

**Epic**: MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

**Como** usuario con acceso al proyecto, **quiero** ver en la factura el proyecto y periodo facturados y en el proyecto el listado de facturas asociadas, **para** auditar y conciliar con el cliente.

**Criterios de aceptación**:
- Toda factura generada desde proyecto tiene `proyecto_id` no nulo y `periodo_facturado` (o equivalente) persistido.
- En ficha de **factura**: etiqueta "Proyecto" con enlace; "Periodo facturado"; opcional desglose de orígenes (tareas, horas, hito, fee).
- En ficha de **proyecto**: sección Facturación con tabla de facturas (número, fecha, periodo, total, estado documento/pago).
- Coherencia con **MF-008** para líneas de aplicación al cupo cuando existan en la factura.

### Campos de datos

| Campo | Descripción | Tipo |
|-------|-------------|------|
| factura.proyecto_id | FK proyecto | Relación (FK) |
| factura.periodo_facturado | Periodo mostrado | Texto / fechas |
| linea.origen_tipo / origen_id | Trazabilidad línea → origen | Enumerado + id |

### Estimación de esfuerzo (con IA)

- Campos en modelo/API y ficha factura: **0,25–0,5 días**.
- Listado en proyecto + enlaces: **0,25–0,5 días**.
- Total estimado para esta US: **~0,5–1 día** de desarrollo efectivo.

**Prioridad**: Alta
