# MF-007-US-009 — Vista en proyecto: total facturado, pendiente por periodo, facturas del proyecto

**Epic**: MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

**Como** usuario con acceso al proyecto, **quiero** ver en la ficha del proyecto el total facturado, lo pendiente de cobro, el estado por periodo (mes) y el **saldo de prefactura** (cupo), **para** planificar la siguiente factura y no exceder el cupo.

**Criterios de aceptación**:
- Resumen: **Total facturado** (suma facturas del proyecto según definición acordada con MF-001/MF-008), **Pendiente de cobro**, y si aplica **Presupuesto total** para comparación visual.
- **Saldo prefactura**: mostrar importe total del cupo, importe ya aplicado en facturas de periodo y **saldo pendiente** (`total − aplicado`), alineado con REQUISITOS MF-007 y **MF-008**.
- Por periodo: indicar si hay factura asociada ("Enero 2026: FAC-xxx") o "Pendiente de facturar" (según granularidad acordada).
- Enlaces a facturas y acción "Crear factura de periodo" coherente con MF-007-US-001.

### Campos de datos

| Campo | Descripción | Tipo |
|-------|-------------|------|
| proyecto.presupuesto_total | Opcional, para UI | Numérico |
| vista.total_facturado | Derivado / agregado | Numérico |
| vista.pendiente_cobro | Derivado | Numérico |
| vista.saldo_prefactura | Cupo pendiente (MF-001/MF-008) | Numérico |
| periodo.estado_facturacion | Facturado / pendiente | Enumerado + refs |

### Estimación de esfuerzo (con IA)

- Agregados y consultas por proyecto: **0,35–0,65 días**.
- UI panel Facturación + timeline por mes: **0,5–1 día**.
- Total estimado para esta US: **~0,85–1,65 días** de desarrollo efectivo.

**Prioridad**: Alta
