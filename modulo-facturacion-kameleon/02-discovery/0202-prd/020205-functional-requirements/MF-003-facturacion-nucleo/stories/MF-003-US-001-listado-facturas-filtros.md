# MF-003-US-001 — Listado de facturas con filtros por cliente y estado

**Epic**: MF-003 — Facturación núcleo

**Como** usuario con permiso de facturación, **quiero** ver un listado de facturas con columnas cliente, número, fecha, total, estado (borrador/publicada/enviada/etc.) y estado de pago, y **filtrar** por cliente y por estado de documento y de pago, **para** gestionar las facturas desde el menú Facturación en Kameleon.

**Criterios de aceptación**: Existe listado de facturas con paginación, filtros por cliente y estados, y la respuesta aporta los campos necesarios para renderizar la tabla.

### Campos de datos

| Campo                         | Descripción                                                       | Tipo |
|-------------------------------|-------------------------------------------------------------------|------|
| factura.numero                | Número/identificador visible de la factura                      | Texto |
| factura.fecha                 | Fecha de emisión de la factura                                 | Fecha |
| factura.cliente_id           | Cliente de facturación                                           | Relación (FK) |
| cliente.nombre               | Nombre/razón social del cliente (para mostrar en tabla)       | Texto corto |
| factura.total                 | Total de la factura (suma final)                                 | Numérico (decimal) |
| factura.estado_documento     | Estado del documento (borrador/publicada/enviada/vencida/...) | Enumerado |
| factura.estado_pago          | Estado de pago (no pagada/parcial/pagada)                     | Enumerado |
| filtro.cliente_id            | Filtro opcional por cliente                                      | Relación (FK) |
| filtro.estado_documento      | Filtro opcional por estado de documento                          | Enumerado |
| filtro.estado_pago           | Filtro opcional por estado de pago                               | Enumerado |
| filtro.fecha_desde / hasta  | Filtro opcional por rango de fechas                              | Fecha |
| page / pageSize              | Paginación                                                        | Entero |

### Estimación de esfuerzo (con IA)

- Endpoint de listado + filtros + paginación: **0,25 días**.
- Definición de respuesta (campos y ordenación): **0,1 días**.
- UI de tabla/filtrado (si aplica en el alcance de la story): **0,15 días**.
- Total estimado para esta US: **~0,5 días** de desarrollo efectivo.

**Prioridad**: Alta
