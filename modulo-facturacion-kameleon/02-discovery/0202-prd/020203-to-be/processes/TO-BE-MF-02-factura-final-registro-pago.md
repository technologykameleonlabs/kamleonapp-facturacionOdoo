# Proceso TO-BE-MF-02: Factura de cierre / liquidación y registro de pago

**Guía**: Basado en TO-BE-022 del paquete de referencia (Generación automática de factura final).

**Propósito**: Al cierre del proyecto (última entrega aceptada o evento "listo para cerrar"), calcular el saldo pendiente de facturar (total acordado − ya facturado mensualmente − anticipos descontados) y, si saldo > 0, generar automáticamente la factura de cierre por ese importe. Notificar al cliente, registrar la factura y el estado de pago; permitir que administración confirme la recepción del pago para habilitar el cierre formal del proyecto. Si saldo = 0 no se genera factura.

**Scope**: Desde evento de cierre hasta factura de cierre generada (si hay saldo), notificada, estado de pago registrado (pendiente/recibido) y proyecto listo para cierre formal.

**Actores**: Sistema (cálculo de saldo, generación y notificación), Cliente (recibe factura y paga fuera del sistema), Administración (confirma recepción de pago).

**Criterios de éxito**:
- Saldo pendiente calculado correctamente (total acordado − ya facturado).
- Si saldo > 0: factura de cierre generada en < 2 minutos desde el evento de cierre.
- Notificación automática al cliente con acceso o adjunto a la factura.
- Estado de pago (pendiente → recibido) permite cierre formal del proyecto.

**Salidas**: Factura de cierre asociada al proyecto (si saldo > 0); estado de pago (pendiente → recibido tras confirmación); proyecto listo para cierre cuando corresponda.

---

*Documento TO-BE · modulo-facturacion-kameleon · Referencia: TO-BE-022*
