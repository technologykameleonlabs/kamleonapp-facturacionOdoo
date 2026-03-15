# MF-002 — Factura de cierre / liquidación y registro de pago

**Contexto**: La facturación de proyectos es **mensual** (MF-007). Al cierre del proyecto se genera una **factura de cierre** por el **saldo pendiente de facturar** (si lo hay).

**Descripción**: Cuando el proyecto se cierra o se acepta la última entrega (según flujo de proyectos), el sistema puede generar una **factura de cierre** (o de liquidación) por el **saldo pendiente de facturar**: importe aún no facturado según la facturación mensual ya emitida y los anticipos descontados (presupuesto o total acordado − ya facturado). Notificación al cliente, registro de factura y estado de pago; administración confirma la recepción del pago para habilitar el cierre formal del proyecto.

**Proceso TO-BE**: TO-BE-MF-02 — Factura de cierre y registro de pago

**Objetivo de negocio**: Cerrar la facturación del proyecto con una factura por el saldo pendiente (si existe), notificar al cliente y registrar el cobro para dejar el proyecto listo para cierre.

**Alcance**:
- **Incluye**: Detección de evento de cierre (proyecto listo para cerrar, última entrega aceptada o solicitud de "cerrar facturación"); cálculo del saldo pendiente de facturar (total acordado/presupuesto − facturas mensuales ya emitidas − anticipos ya descontados); generación de factura de cierre por ese saldo (si saldo > 0); notificación al cliente; registro de factura y estado de pago; confirmación por administración de la recepción del pago.
- **Excluye**: Pasarela de pago integrada. Si el saldo pendiente es 0 (todo ya facturado mensualmente), no se genera factura de cierre.

**Actores**: Sistema, Cliente (recibe factura), Administración (confirma pago).

---

## Historias de usuario (índice)

| ID | Título | Estado | Prioridad |
|----|--------|--------|-----------|
| MF-002-US-001 | Detección de cierre de proyecto / última entrega y cálculo de saldo pendiente de facturar | Definida | Alta |
| MF-002-US-002 | Generación de factura de cierre por saldo pendiente (si > 0) | Definida | Alta |
| MF-002-US-003 | Notificación al cliente y registro de factura y estado de pago | Definida | Alta |
| MF-002-US-004 | Administración confirma recepción de pago (habilita cierre formal del proyecto) | Definida | Alta |

> Detalle en carpeta `/stories`
