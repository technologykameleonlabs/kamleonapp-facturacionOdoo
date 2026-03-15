# MF-001-US-001 — Activación del proyecto (manual o por evento: contrato firmado)

**Epic**: MF-001 — Activación de proyecto (sin pago inicial obligatorio)  
**Referencia guía**: EP-010-US-001

**Como** usuario o sistema, **quiero** activar el proyecto (cambio de estado a "Activo") de forma manual (acción "Activar proyecto") o automáticamente cuando se detecte contrato firmado u otra regla configurable, **para** que el proyecto quede disponible para producción.

**Incluye**: Disparador manual (usuario con permiso) o por evento (contrato firmado); cambio de estado a Activo; registro de fecha de activación; idempotencia (no activar si ya está activo).  
**Excluye**: Registro de anticipo y factura (MF-001-US-002); reserva de fecha (MF-001-US-004).

**Precondiciones**: Proyecto en estado que permita activación (ej. contrato firmado, pendiente de activación).  
**Postcondiciones**: Proyecto en estado Activo; fecha de activación registrada.

**Criterios BDD**: *Dado* un proyecto pendiente de activación, *cuando* el usuario activa manualmente o el sistema detecta contrato firmado, *entonces* el proyecto pasa a estado Activo y la fecha de activación queda registrada.
