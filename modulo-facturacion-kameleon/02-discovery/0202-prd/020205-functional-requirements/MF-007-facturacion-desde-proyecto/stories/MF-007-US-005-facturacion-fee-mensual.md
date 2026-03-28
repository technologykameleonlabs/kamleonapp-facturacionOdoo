# MF-007-US-005 — Facturación por fee mensual: importe fijo por mes asociado al proyecto

**Epic**: MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

**Como** usuario con permiso de facturación, **quiero** poder incluir en la factura de periodo el **fee mensual** configurado en el proyecto cuando corresponda a ese mes, **para** facturar el importe fijo acordado una sola vez por proyecto+mes.

**Criterios de aceptación**:
- Si el proyecto tiene `fee_mensual` definido, el flujo de facturación de periodo puede añadir una línea de tipo fee con el importe del mes seleccionado.
- No puede generarse una segunda línea fee para el mismo proyecto+mes en otra factura publicada (coherente con MF-007-US-006).
- La línea es editable en borrador salvo política explícita de bloqueo de importe.
- `linea.origen_tipo` = `fee_mensual`; `origen_id` puede ser nulo.

### Campos de datos

| Campo | Descripción | Tipo |
|-------|-------------|------|
| proyecto.fee_mensual | Importe fijo por mes | Numérico (decimal) |
| linea.origen_tipo | `fee_mensual` | Enumerado |
| linea.origen_id | Null o referencia interna | Null / UUID |
| factura.periodo_facturado | Mes del fee | Texto / fechas |

### Estimación de esfuerzo (con IA)

- Regla fee + validación única por periodo: **0,25–0,5 días**.
- UI opción "Incluir fee mensual": **0,15–0,25 días**.
- Total estimado para esta US: **~0,4–0,75 días** de desarrollo efectivo.

**Prioridad**: Alta
