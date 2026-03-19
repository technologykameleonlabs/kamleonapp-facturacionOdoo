# MF-003-US-005 — Ciclo de vida: estados Enviada, Vencida, Parcialmente Pagada, Pagada, Cancelada, Rectificada

**Epic**: MF-003 — Facturación núcleo

**Como** usuario con permisos de facturación, **quiero** que la factura gestione su ciclo de vida y refleje correctamente el estado del documento y el estado de pago, **para** tener trazabilidad del documento y su situación frente a vencimientos y cobros.

**Criterios de aceptación**: El sistema mantiene coherencia entre `estado_documento` y `estado_pago`, permitiendo estados Enviada, Vencida, Parcialmente pagada, Pagada, Cancelada y Rectificada según eventos de envío/notificación, vencimientos y cobros.

### Campos de datos

| Campo                           | Descripción                                              | Tipo |
|---------------------------------|----------------------------------------------------------|------|
| factura.estado_documento        | Estado del documento (Borrador/Publicada/Enviada/Vencida/...) | Enumerado |
| factura.estado_pago            | Estado de pago (No pagada/Parcialmente pagada/Pagada) | Enumerado |
| factura.fecha_envio            | Fecha/hora de envío o notificación (si aplica)        | Fecha |
| factura.fecha_publicacion      | Fecha de publicación (si aplica)                       | Fecha |
| factura.fecha_cancelacion      | Fecha de cancelación (si aplica)                      | Fecha |
| factura.fecha_rectificacion   | Fecha/indicador de rectificación (si aplica)          | Fecha |
| factura.vencimiento_en_curso | Indicador/calculo relacionado con vencimientos (opcional) | Booleano |

### Estimación de esfuerzo (con IA)

- Definición/validación de transiciones y coherencia entre estados: **0,25 días**.
- Integración con eventos de envío (MF-006) y cobros (MF-004): **0,15 días**.
- Reglas para Vencida (MF-003 + vencimientos US-010) y estados de pago: **0,1 días**.
- UI/listado/detalle para mostrar estados y coherencia visual: **0,0 días** (incluido en repositorio/plantilla de UI).
- Total estimado para esta US: **~0,5 días** de desarrollo efectivo.

**Prioridad**: Alta

