# MF-001-US-002 — Opcional: registro de anticipo/pago inicial y generación de factura por monto acordado

**Epic**: MF-001 — Activación de proyecto (sin pago inicial obligatorio)  
**Referencia guía**: EP-010-US-002

**Como** usuario, **quiero** registrar opcionalmente un anticipo o pago inicial (importe acordado con el cliente) y generar una factura por ese importe asociada al proyecto, **para** facturar por adelantado y descontarlo después en facturas mensuales (MF-008).

**Incluye**: Acción "Registrar anticipo" o "Generar factura de anticipo" desde el proyecto; indicar monto acordado; generación de factura (número, fecha, cliente, concepto "Proyecto [nombre] – Anticipo", importe); asociación al proyecto.  
**Excluye**: Obligatoriedad de anticipo para activar; el descuento del anticipo en facturas mensuales (MF-008).

**Precondiciones**: Proyecto activado (MF-001-US-001) o en contexto de activación; datos de cliente de facturación disponibles; serie de facturas configurada.  
**Postcondiciones**: Factura de anticipo generada y asociada al proyecto; disponible para descuento en MF-008.

**Criterios BDD**: *Dado* un proyecto activo (o en activación), *cuando* el usuario registra un anticipo con importe acordado, *entonces* se genera una factura de anticipo asociada al proyecto en menos de 2 minutos.
