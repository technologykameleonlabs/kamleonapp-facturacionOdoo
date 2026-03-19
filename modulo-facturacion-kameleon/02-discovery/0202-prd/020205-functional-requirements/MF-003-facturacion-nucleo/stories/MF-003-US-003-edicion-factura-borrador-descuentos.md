# MF-003-US-003 — Edición de factura en borrador (líneas, descuentos por línea o global)

**Epic**: MF-003 — Facturación núcleo

**Como** usuario con permiso de facturación, **quiero** editar una factura solo cuando esté en estado `Borrador`, **para** corregir líneas, precios, descuentos e importes antes de publicarla.

**Criterios de aceptación**: La factura solo es editable en borrador; se pueden gestionar líneas y aplicar descuentos por línea y global, recalculando automáticamente totales e impuestos.

### Campos de datos

| Campo                                  | Descripción                                            | Tipo |
|----------------------------------------|--------------------------------------------------------|------|
| factura.id                              | Identificador interno de la factura                   | Entero/UUID |
| factura.estado_documento              | Debe ser `Borrador`                                   | Enumerado |
| factura.cliente_id                   | Cliente asociado (inamovible si ya está publicada)  | Relación (FK) |
| linea.id                                | Identificador de línea                               | Entero/UUID |
| linea.descripcion                      | Descripción de línea                                | Texto |
| linea.cantidad                         | Cantidad por línea                                   | Numérico (decimal) |
| linea.precio_unitario                 | Precio unitario por línea                            | Numérico (decimal) |
| linea.impuesto_id                     | Impuesto aplicado                                     | Relación (FK) |
| linea.descuento                       | Descuento de línea (porcentaje o importe)          | Numérico / estructurado |
| descuento_global.porcentaje          | Porcentaje de descuento global (si aplica)           | Numérico (decimal) |
| descuento_global.importe            | Importe de descuento global (si aplica)             | Numérico (decimal) |
| regla_descuento_global                 | Regla de aplicación del descuento global              | Enumerado |
| factura.total_base                    | Subtotal/base imponible                                | Numérico (decimal) |
| factura.total_impuestos               | Total impuestos                                          | Numérico (decimal) |
| factura.total_descuentos             | Total descuentos (línea + global)                     | Numérico (decimal) |
| factura.total                         | Total factura                                           | Numérico (decimal) |

### Estimación de esfuerzo (con IA)

- Validaciones de estado + control de edición en borrador: **0,25 días**.
- Gestión de líneas (add/edit/delete) y recalculo de totales: **0,5 días**.
- Aplicación de descuentos por línea y descuento global (incl. regla de aplicación): **0,25 días**.
- Recalcular desglose de impuestos consistente con `incluido/no incluido`: **0,25 días**.
- Total estimado para esta US: **~1,25 días** de desarrollo efectivo.

**Prioridad**: Alta

