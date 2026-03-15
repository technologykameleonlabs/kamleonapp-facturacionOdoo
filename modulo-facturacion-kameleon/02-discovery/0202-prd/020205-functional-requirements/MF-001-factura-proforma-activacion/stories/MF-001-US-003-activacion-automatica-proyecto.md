# MF-001-US-003 — Registro de fecha de activación y notificaciones a equipo y cliente

**Epic**: MF-001 — Activación de proyecto (sin pago inicial obligatorio)  
**Referencia guía**: EP-010-US-003

**Como** sistema, **quiero** notificar al equipo (proyecto activado, fecha reservada si aplica) y al cliente (proyecto activado; si hubo factura de anticipo: factura generada con enlace o adjunto), **para** que todas las partes tengan visibilidad.

**Incluye**: Notificación a equipo: "Proyecto [nombre] activado" (+ fecha reservada si MF-001-US-004 aplica; + "Factura de anticipo [número] generada" si hubo MF-001-US-002). Notificación a cliente: "Proyecto activado"; si hay factura de anticipo, incluir enlace o adjunto según configuración. Canal configurado (email, notificación in-app).  
**Excluye**: Contenido de la factura (generada en MF-001-US-002); reserva de fecha (MF-001-US-004).

**Precondiciones**: Proyecto activado (MF-001-US-001).  
**Postcondiciones**: Notificaciones enviadas a equipo y cliente.

**Criterios BDD**: *Dado* que el proyecto está activado, *cuando* el sistema envía las notificaciones, *entonces* equipo y cliente reciben la información correspondiente.
