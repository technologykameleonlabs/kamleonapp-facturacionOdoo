# MF-004 — Cobros y estado de pago

**Fuente**: Propuesta Fase 1 + gap 5 (Modelo de cobros).

**Descripción**: Entidad Pago/Cobro; registro de pagos contra facturas (total o parcial); aplicación de pago a una o varias facturas; actualización del estado de pago de la factura (No pagada, Parcialmente pagada, Pagada). Métodos de pago, fecha valor, reversos si aplica.

**Objetivo**: Registrar cobros recibidos y aplicarlos a facturas; mantener estado de pago actualizado y trazabilidad.

**Alcance**: Asistente registrar pago; aplicación a factura(s); estado de pago en factura; métodos de pago; conciliación básica. Excluye: pasarela de pago online (portal, MF-009); pagos anticipados complejos (MF-008).

---

## Historias de usuario (índice)

| ID | Título | Prioridad |
|----|--------|-----------|
| MF-004-US-001 | Asistente Registrar pago: fecha, importe, método de pago, referencia | Alta |
| MF-004-US-002 | Aplicar pago a una factura (total o parcial); actualizar saldo pendiente | Alta |
| MF-004-US-003 | Aplicar un pago a varias facturas (reparto manual o por orden) | Media |
| MF-004-US-004 | Estado de pago en factura: No pagada, Parcialmente pagada, Pagada | Alta |
| MF-004-US-005 | Listado de cobros y relación cobro ↔ factura(s) aplicadas | Alta |
| MF-004-US-006 | Reverso de aplicación de pago (anular aplicación, devolver estado) | Media |

> Detalle en carpeta `/stories`
