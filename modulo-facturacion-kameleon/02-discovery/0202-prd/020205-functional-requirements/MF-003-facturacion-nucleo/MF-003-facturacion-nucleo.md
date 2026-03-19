# MF-003 — Facturación núcleo

**Fuente**: Propuesta Fase 1 + gaps 1 (Numeración fiscal), 2 (Ciclo de vida), 8 (Descuentos/recargos), 12 (Reglas de bloqueo).

**Descripción**: Facturas de cliente con creación manual, líneas de detalle, impuestos y términos de pago. Ciclo de vida: Borrador → Publicada → (Enviada, Vencida, Parcialmente Pagada, Pagada, Cancelada, Rectificada). Numeración fiscal por serie; bloqueo de campos tras publicar.

**Objetivo**: Poder crear, editar en borrador y publicar facturas con numeración definitiva, cumpliendo reglas fiscales y de negocio.

**Alcance**: Listado de facturas; creación manual; líneas (descripción, cantidad, precio, impuesto); términos de pago; estados y transiciones; numeración por serie; reglas de bloqueo post-publicación. Excluye: cobros (MF-004), NC (MF-005), PDF/email (MF-006).

---

## Historias de usuario (índice)


| ID            | Título                                                                                       | Prioridad |
| ------------- | -------------------------------------------------------------------------------------------- | --------- |
| MF-003-US-001 | Listado de facturas con filtros por cliente y estado                                         | Alta      |
| MF-003-US-002 | Creación manual de factura en borrador (cliente, líneas, impuestos, términos)                | Alta      |
| MF-003-US-003 | Edición de factura en borrador (líneas, descuentos por línea o global)                       | Alta      |
| MF-003-US-004 | Publicar factura: asignar número definitivo (serie), pasar a Publicada, bloquear edición     | Alta      |
| MF-003-US-005 | Ciclo de vida: estados Enviada, Vencida, Parcialmente Pagada, Pagada, Cancelada, Rectificada | Alta      |
| MF-003-US-006 | Numeración fiscal: series por país/empresa, prefijos, control de huecos                      | Alta      |
| MF-003-US-007 | Reglas de bloqueo: campos inamovibles tras publicar; cierre de periodo (opcional)            | Media     |
| MF-003-US-008 | Descuentos por línea y descuento global; recargos (pronto pago, mora)                        | Media     |
| MF-003-US-009 | Detalle de factura (cabecera y líneas) con totales e impuestos desglosados                   | Alta      |
| MF-003-US-010 | Vencimientos múltiples según término de pago (fechas de vencimiento)                         | Media     |


> Detalle en carpeta `/stories`

