# MF-008 — Anticipos y facturación parcial (en contexto de facturación mensual)

**Fuente**: Propuesta Fase 2 + gap 8. Contexto: proyectos facturados **mensualmente** por tareas/horas/hitos/fee (MF-007).

**Descripción**: Anticipos (importe o % sobre proyecto) facturados al inicio; descuento del anticipo en las **facturas mensuales** posteriores (o en una factura de cierre). **Facturación parcial** en este modelo son las **múltiples facturas mensuales** por proyecto: cada mes (o periodo) se emite una factura con lo realizado en ese periodo; trazabilidad de total facturado vs presupuesto y prevención de doble facturación (MF-007).

**Objetivo**: Soportar anticipos y su descuento en facturas mensuales o cierre; y control de facturación parcial (varias facturas por proyecto) sin duplicar importes.

**Alcance**:
- **Incluye**: Factura de anticipo asociada a proyecto; descuento del anticipo en facturas mensuales siguientes (reparto automático o manual por factura); vista de anticipos pendientes de descontar por proyecto; total facturado por proyecto (suma de facturas mensuales + anticipos) vs presupuesto; alertas si se supera presupuesto.
- **Excluye**: Lógica contable de asientos de anticipo (fase posterior).

---

## Historias de usuario (índice)

| ID | Título | Prioridad |
|----|--------|-----------|
| MF-008-US-001 | Crear factura de anticipo (importe o %) asociada a proyecto/cliente | Alta |
| MF-008-US-002 | Descontar anticipo en facturas mensuales (reparto por factura o en cierre) | Alta |
| MF-008-US-003 | Facturación parcial: total facturado por proyecto (mensual + anticipos) vs presupuesto | Alta |
| MF-008-US-004 | Vista de anticipos pendientes de descontar por proyecto/cliente | Media |

> Detalle en carpeta `/stories`
