# MF-002-US-002 — Generación de factura de cierre por saldo pendiente (si > 0)

**Epic**: MF-002 — Factura de cierre / liquidación y registro de pago  
**Referencia guía**: EP-022-US-002

**Como** sistema, **quiero** generar automáticamente una factura de cierre (o de liquidación) por el importe del saldo pendiente calculado en MF-002-US-001, cuando ese saldo es mayor que cero, **para** facturar lo que falte por cobrar al cierre del proyecto.

**Incluye**: Creación de factura con número por serie, fecha actual, cliente del proyecto, concepto (ej. "Proyecto [nombre] – Factura de cierre / liquidación"), importe = saldo pendiente; estado Publicada/Emitida; estado de pago Pendiente; tipo o etiqueta "Factura de cierre"; vinculación al proyecto. Solo se ejecuta si saldo > 0.  
**Excluye**: Cálculo del saldo (MF-002-US-001); notificación y registro (MF-002-US-003).

**Precondiciones**: Saldo pendiente > 0 calculado (MF-002-US-001); datos cliente y serie de facturas disponibles.  
**Postcondiciones**: Factura de cierre generada y asociada al proyecto; generada en menos de 2 minutos desde el evento de cierre.

**Criterios BDD**: *Dado* un saldo pendiente mayor que cero, *cuando* el sistema genera la factura de cierre, *entonces* la factura queda creada con el importe del saldo y asociada al proyecto.
