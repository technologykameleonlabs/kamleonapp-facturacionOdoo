# MF-002-US-001 — Detección de cierre de proyecto / última entrega y cálculo de saldo pendiente de facturar

**Epic**: MF-002 — Factura de cierre / liquidación y registro de pago  
**Referencia guía**: EP-022-US-001

**Como** sistema, **quiero** detectar el evento de cierre del proyecto (última entrega aceptada o "Proyecto listo para cerrar") y calcular el saldo pendiente de facturar (total acordado − total ya facturado para el proyecto), **para** decidir si debe generarse una factura de cierre (solo si saldo > 0).

**Incluye**: Suscripción o consulta al evento/estado de cierre por proyecto_id; obtención del total acordado (presupuesto/contrato); obtención del total ya facturado (facturas mensuales, anticipos, etc.); saldo pendiente = total acordado − ya facturado. Si saldo ≤ 0, no se genera factura y se puede registrar "Facturación cerrada sin saldo pendiente".  
**Excluye**: Generación de la factura de cierre (MF-002-US-002).

**Precondiciones**: Evento de cierre del proyecto disponible; total acordado y facturas del proyecto accesibles.  
**Postcondiciones**: Saldo pendiente calculado; si saldo > 0, flujo continúa a MF-002-US-002; si saldo = 0, proyecto puede cerrarse según reglas sin nueva factura.

**Criterios BDD**: *Dado* que el proyecto está listo para cerrar, *cuando* el sistema calcula el saldo pendiente, *entonces* el resultado es coherente con total acordado y facturas ya emitidas.
