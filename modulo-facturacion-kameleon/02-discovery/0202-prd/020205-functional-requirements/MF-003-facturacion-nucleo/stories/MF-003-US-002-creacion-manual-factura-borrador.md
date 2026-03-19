# MF-003-US-002 — Creación manual de factura en borrador (cliente, líneas, impuestos, términos)

**Epic**: MF-003 — Facturación núcleo

**Como** usuario con permiso de crear facturas, **quiero** crear una factura manualmente seleccionando el cliente de facturación, añadiendo líneas (descripción, cantidad, precio unitario, impuesto) y el término de pago, **para** tener la factura en borrador lista para revisar y publicar.

**Criterios de aceptación**: Se puede crear una factura en estado `Borrador` con al menos una línea, impuestos por línea y término de pago; el sistema calcula totales e impuestos y la factura se guarda sin número fiscal definitivo.

### Campos de datos

| Campo                              | Descripción                                                     | Tipo |
|------------------------------------|-----------------------------------------------------------------|------|
| factura.estado_documento          | Estado inicial de la factura                                 | Enumerado |
| factura.estado_pago               | Estado de pago inicial                                       | Enumerado |
| factura.cliente_id               | Cliente de facturación seleccionado                           | Relación (FK) |
| factura.fecha                     | Fecha de emisión de la factura                                | Fecha |
| factura.termino_pago_id         | Término de pago asociado (para vencimientos)                | Relación (FK) |
| factura.moneda                    | Moneda de la factura (si está activo MF-012)                  | Enumerado / código ISO |
| linea.descripcion                | Descripción de cada línea                                      | Texto |
| linea.cantidad                   | Cantidad por línea                                            | Numérico (decimal) |
| linea.precio_unitario            | Precio unitario por línea                                     | Numérico (decimal) |
| linea.impuesto_id                | Impuesto aplicado en la línea                                 | Relación (FK) |
| linea.descuento                 | Descuento en la línea (si aplica en UI/alcance)              | Numérico / estructurado |
| factura.total_base               | Base imponible total                                           | Numérico (decimal) |
| factura.total_impuestos          | Total de impuestos                                             | Numérico (decimal) |
| factura.total_descuentos         | Total descuentos (línea + global si aplica)                  | Numérico (decimal) |
| factura.total                     | Total de la factura                                            | Numérico (decimal) |
| factura_vencimiento.fecha_vencimiento | Fecha(s) de vencimiento calculada(s)                      | Fecha |
| factura_vencimiento.importe     | Importe asociado a cada vencimiento                           | Numérico (decimal) |

### Estimación de esfuerzo (con IA)

- Modelado (factura, líneas, totales) + migración base: **0,25 días**.
- Validaciones y cálculo de totales/impuestos para borrador: **0,5 días**.
- Integración con término de pago (estructura de vencimientos): **0,25 días**.
- Persistencia + API para guardar borrador: **0,25 días**.
- Total estimado para esta US: **~1,25 días** de desarrollo efectivo.

**Prioridad**: Alta
