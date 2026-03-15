# MF-001-US-004 — Reserva automática de fecha en calendario (si aplica)

**Epic**: MF-001 — Activación de proyecto (sin pago inicial obligatorio)  
**Referencia guía**: EP-010-US-004 / TO-BE-011

**Como** sistema, **quiero** reservar automáticamente la fecha del proyecto en el calendario integrado (bloqueo, integración con Google Calendar si aplica) tras la activación, **para** que la fecha quede bloqueada sin pasos manuales.

**Incluye**: Obtención de fecha desde contrato/proyecto; bloqueo en calendario interno; integración con calendario externo si está en alcance.  
**Excluye**: Notificaciones (MF-001-US-003). Puede ser opcional si el módulo de facturación no incluye calendario.

**Precondiciones**: Proyecto activado (MF-001-US-001); fecha del evento/proyecto disponible.  
**Postcondiciones**: Fecha reservada en calendario; sin solapamientos.

**Criterios BDD**: *Dado* un proyecto recién activado con fecha definida, *cuando* el sistema reserva la fecha, *entonces* la fecha queda bloqueada en el calendario.
