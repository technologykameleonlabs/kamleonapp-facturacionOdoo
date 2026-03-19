# MF-003-US-010 — Vencimientos múltiples según término de pago (fechas de vencimiento)

**Epic**: MF-003 — Facturación núcleo

**Como** usuario con permisos de facturación, **quiero** que la factura calcule y muestre múltiples fechas de vencimiento según la definición del término de pago, **para** gestionar correctamente el estado de vencimiento y el pago parcial.

**Criterios de aceptación**: El sistema calcula, persiste y muestra múltiples vencimientos; el estado `Vencida` se determina considerando vencimientos vencidos y pagos aplicados.

### Campos de datos

| Campo                               | Descripción                                                 | Tipo |
|-------------------------------------|-------------------------------------------------------------|------|
| factura_vencimiento.factura_id     | Factura a la que pertenece el vencimiento                  | Relación (FK) |
| factura_vencimiento.orden         | Orden de aparición del vencimiento                          | Entero |
| factura_vencimiento.fecha_vencimiento | Fecha de vencimiento                                      | Fecha |
| factura_vencimiento.importe       | Importe asociado al vencimiento                            | Numérico (decimal) |
| factura_vencimiento.porcentaje    | Porcentaje asociado (si el término lo define así)          | Numérico (decimal) |
| factura.termino_pago_id            | Término de pago aplicado                                  | Relación (FK) |
| factura_vencimiento.estado_cubierto | Indicador si el vencimiento está cubierto por pagos   | Booleano |

### Estimación de esfuerzo (con IA)

- Modelo/entidad de vencimientos múltiples + migración: **0,25 días**.
- Lógica de cálculo basada en término de pago: **0,15 días**.
- Persistencia y recalculo en borrador: **0,1 días**.
- Integración con estado `Vencida` (consulta de vencimientos vs pagos): **0,1 días**.
- UI/serialización para mostrar vencimientos: **0,15 días**.
- Total estimado para esta US: **~0,5 días** de desarrollo efectivo.

**Prioridad**: Media

