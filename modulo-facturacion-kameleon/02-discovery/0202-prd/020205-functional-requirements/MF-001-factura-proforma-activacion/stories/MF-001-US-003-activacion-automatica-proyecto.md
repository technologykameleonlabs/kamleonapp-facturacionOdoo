# MF-001-US-003 — Registro de fecha de activación y notificaciones a equipo y cliente

**Epic**: MF-001 — Activación de proyecto y prefactura por importe total

**Como** sistema, **quiero** notificar al equipo y al cliente cuando el proyecto se activa, **para** que todas las partes tengan visibilidad.

**Criterios de aceptación**:
- Tras una activación exitosa (US-001) y la prefactura (US-002), el sistema envía:
  - Notificación al equipo con `Proyecto [nombre] activado` y, si aplica, fecha reservada y/o referencia a la **prefactura/cupo** (número o identificador según tipo documental).
  - Notificación al cliente con `Proyecto activado` e información o enlace a la **prefactura** generada (según decisión fiscal: PDF proforma o factura).
- El canal de notificación es configurable (email y/o notificación in-app según exista soporte).
- Se persisten indicadores/flags de envío (equipo/cliente) para trazabilidad.
- El contenido de la factura no se gestiona en esta historia (eso corresponde a US-002); solo se referencian/adjuntan los datos necesarios.

### Campos de datos

| Campo                                | Descripción                                       | Tipo |
|--------------------------------------|---------------------------------------------------|------|
| notificacion.equipo_enviada         | Flag de que se envió al equipo                   | Booleano |
| notificacion.cliente_enviada        | Flag de que se envió al cliente                  | Booleano |
| notificacion.canal                  | Canal usado (email/in-app)                       | Enumerado |
| notificacion.fecha_envio           | Fecha/hora de envío                               | Fecha/hora |
| notificacion.mensaje_equipo        | Mensaje o plantilla usada                         | Texto |
| notificacion.mensaje_cliente       | Mensaje o plantilla usada                         | Texto |
| notificacion.prefactura_documento_id | Referencia a prefactura/cupo (si existe) | Relación (FK) |
| notificacion.calendario_evento_id | Evento calendario de reserva (si aplica)         | Texto / Relación |

### Estimación de esfuerzo (con IA)

- Diseño de plantillas/mensajes y mapeo de condiciones (con/sin prefactura según flujo, con/sin reserva): **0,15 días**.
- Integración con sistema de notificaciones + flags de persistencia: **0,3 días**.
- UI/indicadores y manejo de errores (si aplica): **0,15 días**.
- Total estimado para esta US: **~0,6 días** de desarrollo efectivo.

**Prioridad**: Alta
