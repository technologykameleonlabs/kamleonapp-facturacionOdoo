# MF-001-US-005 — Registro de activación (timestamp, referencia factura si hay anticipo) para trazabilidad

**Epic**: MF-001 — Activación de proyecto (sin pago inicial obligatorio)  
**Referencia guía**: EP-010-US-005

**Como** sistema, **quiero** guardar un registro de activación con proyecto_id, timestamp, usuario o evento que disparó la activación, referencia de factura de anticipo (si existe) y fecha reservada (si aplica), **para** auditoría y para no repetir el flujo de activación.

**Incluye**: Registro de "Activación": proyecto_id, timestamp, disparador (usuario/evento), referencia factura de anticipo (si MF-001-US-002), fecha reservada (si MF-001-US-004).  
**Excluye**: Contenido de las notificaciones (MF-001-US-003).

**Precondiciones**: Proyecto activado (MF-001-US-001).  
**Postcondiciones**: Registro de activación guardado; trazabilidad disponible.

**Criterios BDD**: *Dado* que la activación se ha completado, *cuando* el sistema guarda el registro, *entonces* el registro de activación queda persistido con todos los datos de trazabilidad.
