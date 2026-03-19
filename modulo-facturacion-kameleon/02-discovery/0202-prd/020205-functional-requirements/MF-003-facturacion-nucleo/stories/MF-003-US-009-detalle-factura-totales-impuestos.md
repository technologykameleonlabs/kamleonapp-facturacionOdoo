# MF-003-US-009 — Detalle de factura (cabecera y líneas) con totales e impuestos desglosados

**Epic**: MF-003 — Facturación núcleo

**Como** usuario con permisos de facturación, **quiero** ver el detalle de una factura con su cabecera, líneas, totales e impuestos desglosados, **para** validar el cálculo fiscal y el resumen económico antes de enviar y/o cobrar.

**Criterios de aceptación**: La pantalla de detalle (y/o endpoint de detalle) devuelve cabecera, líneas, totales globales e impuestos agregados consistentes con los cálculos de la factura.

### Campos de datos

| Campo                                  | Descripción                                               | Tipo |
|----------------------------------------|-----------------------------------------------------------|------|
| factura.numero                          | Número fiscal de la factura                               | Texto |
| factura.fecha                            | Fecha de la factura                                       | Fecha |
| factura.cliente_id                     | Cliente de facturación                                    | Relación (FK) |
| factura.termino_pago_id               | Término de pago aplicado                                  | Relación (FK) |
| factura.moneda                          | Moneda (si aplica)                                       | Enumerado |
| factura.estado_documento              | Estado del documento                                     | Enumerado |
| factura.estado_pago                   | Estado de pago                                            | Enumerado |
| linea.descripcion                     | Descripción de la línea                                  | Texto |
| linea.cantidad                        | Cantidad de la línea                                      | Numérico (decimal) |
| linea.precio_unitario                | Precio unitario de la línea                               | Numérico (decimal) |
| linea.descuento                       | Descuento aplicado (si existe)                            | Numérico / estructurado |
| linea.impuesto_id                      | Impuesto de la línea                                      | Relación (FK) |
| linea.base_imponible                 | Base imponible de la línea                                 | Numérico (decimal) |
| linea.importe_impuesto               | Importe de impuesto de la línea                            | Numérico (decimal) |
| linea.importe_total                  | Total de la línea                                         | Numérico (decimal) |
| factura.total_base                    | Subtotal/base imponible                                   | Numérico (decimal) |
| factura.total_impuestos              | Total de impuestos                                        | Numérico (decimal) |
| factura.total_descuentos             | Total de descuentos                                       | Numérico (decimal) |
| factura.total                         | Total factura                                             | Numérico (decimal) |
| impuestos_agregados.impuesto_nombre | Nombre del impuesto agregado                               | Texto |
| impuestos_agregados.base            | Base agregada del impuesto                                  | Numérico (decimal) |
| impuestos_agregados.importe        | Importe agregado del impuesto                               | Numérico (decimal) |

### Estimación de esfuerzo (con IA)

- Endpoint de detalle/serialización de respuesta: **0,25 días**.
- Agregación de impuestos y coherencia totales: **0,25 días**.
- UI de detalle para render de cabecera/líneas/totales: **0,25 días**.
- Total estimado para esta US: **~0,75 días** de desarrollo efectivo.

**Prioridad**: Alta

