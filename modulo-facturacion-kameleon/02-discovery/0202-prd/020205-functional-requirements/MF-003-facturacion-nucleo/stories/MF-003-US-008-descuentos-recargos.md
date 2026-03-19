# MF-003-US-008 — Descuentos por línea y descuento global; recargos (pronto pago, mora)

**Epic**: MF-003 — Facturación núcleo

**Como** usuario con permisos de facturación, **quiero** aplicar descuentos por línea y/o descuento global (y recargos cuando apliquen) en una factura, **para** que los totales y el cálculo de impuestos sean consistentes con la política comercial acordada.

**Criterios de aceptación**: En borrador se gestionan descuentos por línea y globales; el motor recalcula totales e impuestos con coherencia respecto a `tipo_calculo` de los impuestos y soporta recargos cuando aplique.

### Campos de datos

| Campo                                  | Descripción                                                | Tipo |
|----------------------------------------|------------------------------------------------------------|------|
| linea.descuento_porcentaje           | Descuento por línea (porcentaje)                          | Numérico (decimal) |
| linea.descuento_importe              | Descuento por línea (importe)                              | Numérico (decimal) |
| descuento_global.porcentaje          | Descuento global (porcentaje)                             | Numérico (decimal) |
| descuento_global.importe             | Descuento global (importe)                                | Numérico (decimal) |
| descuento_global.regla_aplicacion    | Regla de aplicación (sobre base o total)                 | Enumerado |
| recargo_pronto_pago.porcentaje       | Recargo por pronto pago (porcentaje)                     | Numérico (decimal) |
| recargo_pronto_pago.importe          | Recargo por pronto pago (importe)                        | Numérico (decimal) |
| recargo_mora.porcentaje              | Recargo por mora (porcentaje)                            | Numérico (decimal) |
| recargo_mora.importe                 | Recargo por mora (importe)                               | Numérico (decimal) |
| factura.total_descuentos            | Total de descuentos                                         | Numérico (decimal) |
| factura.total_impuestos             | Total impuestos                                            | Numérico (decimal) |
| factura.total                         | Total factura incluyendo recargos si aplican              | Numérico (decimal) |

### Estimación de esfuerzo (con IA)

- Motor de cálculo de descuentos (línea/global) + totales: **0,25 días**.
- Compatibilidad con impuestos incluido/no incluido: **0,15 días**.
- Soporte de recargos (placeholders controlados por flags/reglas): **0,1 días**.
- UI/recalculo en borrador (si aplica en la story): **0,0 días** (se asume reutilización de US-003/US-004).
- Total estimado para esta US: **~0,5 días** de desarrollo efectivo.

**Prioridad**: Media

