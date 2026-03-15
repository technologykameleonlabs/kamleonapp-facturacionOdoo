# MF-002-US-003 — Notificación al cliente y registro de factura y estado de pago

**Epic**: MF-002 — Factura de cierre / liquidación y registro de pago  
**Referencia guía**: EP-022-US-003

**Como** sistema, **quiero** notificar al cliente cuando la factura de cierre está generada (email y/o portal con enlace o adjunto PDF) y registrar la factura con estado de pago "Pendiente", **para** que el cliente sepa que debe pagar y el módulo de cierre pueda comprobar el estado de cobro.

**Incluye**: Notificación al cliente (email/portal) con enlace o adjunto a la factura de cierre; registro del envío (MF-014); la factura queda con estado de pago "Pendiente" por defecto; el módulo de cierre del proyecto puede consultar "factura de cierre cobrada" o "todas las facturas del proyecto cobradas".  
**Excluye**: Generación de factura (MF-002-US-002); confirmación de recepción de pago por administración (MF-002-US-004).

**Precondiciones**: Factura de cierre generada (MF-002-US-002).  
**Postcondiciones**: Cliente notificado; factura y estado de pago registrados; proyecto puede evaluarse para cierre formal cuando el pago esté confirmado.

**Criterios BDD**: *Dado* que la factura de cierre está generada, *cuando* el sistema notifica y registra, *entonces* el cliente recibe la notificación y la factura queda con estado de pago Pendiente.
