# MF-002-US-004 — Administración confirma recepción de pago (habilita cierre formal del proyecto)

**Epic**: MF-002 — Factura de cierre / liquidación y registro de pago  
**Referencia guía**: EP-022-US-004

**Como** administración, **quiero** confirmar la recepción del pago de la factura de cierre cuando el cliente ha pagado fuera del sistema, **para** que el estado de pago pase a "Recibido" y el proyecto pueda cerrarse formalmente.

**Incluye**: Acción "Confirmar recepción de pago" o "Marcar como cobrado" en la factura de cierre; actualización de estado de pago a "Recibido"; registro de fecha de cobro y usuario que confirmó. A partir de ese momento el proyecto cumple la condición de "pago de cierre recibido" para el cierre formal.  
**Excluye**: Generación de factura (MF-002-US-001, US-002); lógica de cierre del proyecto (solo consume este estado como condición).

**Precondiciones**: Factura de cierre generada y notificada al cliente (MF-002-US-003); pago recibido fuera del sistema.  
**Postcondiciones**: Estado de pago = Recibido; proyecto listo para cierre formal según reglas del módulo de cierre.

**Criterios BDD**: *Dado* que administración ha recibido el pago del cliente, *cuando* confirma la recepción en la factura de cierre, *entonces* el estado de pago pasa a Recibido y el proyecto puede cerrarse.
