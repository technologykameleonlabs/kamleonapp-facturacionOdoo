# MF-001-US-004 — Reserva automática de fecha en calendario (si aplica)

**Epic**: MF-001 — Activación de proyecto y prefactura por importe total

**Como** sistema, **quiero** reservar automáticamente la fecha del proyecto en el calendario integrado (bloqueo, e integración con Google Calendar si aplica) tras la activación, **para** que la fecha quede bloqueada sin pasos manuales.

**Criterios de aceptación**:
- Si hay fecha definida y el calendario está en alcance/habilitado, tras una activación exitosa el sistema reserva/bloquea la fecha en el calendario.
- Se obtiene la fecha desde contrato/proyecto y se registra el identificador del evento calendario.
- Evita solapamientos o valida conflictos según la lógica del calendario.
- Si no hay soporte de calendario en el módulo, la funcionalidad puede estar deshabilitada (sin romper el flujo de activación).

### Campos de datos

| Campo                              | Descripción                                      | Tipo |
|------------------------------------|--------------------------------------------------|------|
| proyecto.id                         | Proyecto asociado                                 | Relación (FK) |
| proyecto.fecha_activacion           | Fecha de activación (origen)                   | Fecha/hora |
| calendario.fecha_reservada          | Fecha reservada en calendario                   | Fecha |
| calendario.evento_id               | ID del evento creado/registrado                | Texto / Relación |
| calendario.tipo_evento             | Tipo de evento/bloqueo (si aplica)             | Enumerado / Texto |
| calendario.conflicto_detectado    | Indica si hubo conflicto (si aplica)          | Booleano |

### Estimación de esfuerzo (con IA)

- Obtención de fecha + validaciones habilitado/no habilitado: **0,15 días**.
- Bloqueo/registro de evento y manejo de solapamientos: **0,25 días**.
- Integración opcional con calendario externo (si aplica): **0,10 días**.
- Total estimado para esta US: **~0,5 días** de desarrollo efectivo.

**Prioridad**: Media
