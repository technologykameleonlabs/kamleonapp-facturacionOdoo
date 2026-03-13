# EP-011 — Reserva automática de fechas

**Descripción:** Bloqueo automático de la fecha del proyecto en calendario al activar proyecto (o por reserva manual), con validación de disponibilidad, integración correcta con Google Calendar y notificación de reserva confirmada a equipo y cliente.

**Proceso TO-BE origen:** TO-BE-011: Proceso de reserva automática de fechas

**Bloque funcional:** Reserva en calendario integrado — Desde activación de proyecto (o disparo manual) hasta fecha reservada y bloqueada en calendario.

**Objetivo de negocio:** Reservar automáticamente las fechas al activar proyectos, integrar correctamente con Google Calendar sin comportamientos erráticos, evitar solapamientos y notificar reserva confirmada.

**Alcance y exclusiones:**
- **Incluye:**
  - Obtención de la fecha del proyecto desde contrato firmado.
  - Validación automática de disponibilidad (consulta fechas reservadas, verificación de no bloqueo).
  - Si hay conflicto: notificación y requerimiento de resolución (no reservar automáticamente).
  - Reserva automática: bloqueo en calendario interno, creación de evento en Google Calendar correctamente, fecha marcada como "Reservada".
  - Notificación automática al equipo (fecha reservada confirmada) y al cliente (fecha reservada confirmada).
  - Registro de la reserva en el sistema con timestamp y datos del proyecto.
  - Disparo desde EP-010 (activación) o desde reserva manual por administración.
- **Excluye:**
  - Activación automática del proyecto (EP-010).
  - Preparación de bodas (EP-015) y gestión del día de la boda (EP-016) — requieren fecha ya reservada.
  - Agendamiento de reuniones comerciales (EP-004).

**KPIs (éxito):**
- 100% de fechas reservadas automáticamente al activar proyecto (cuando fecha disponible).
- Integración correcta con Google Calendar sin comportamientos erráticos.
- 0% de solapamientos de fechas.
- Notificación automática de reserva confirmada.

**Actores y permisos (RBAC):**
- **Sistema centralizado:** Obtener fecha, validar disponibilidad, reservar, sincronizar con Google Calendar, notificar, registrar.
- **Administración:** Reserva manual de fecha si es necesario; ajuste de fechas.
- **Equipo de proyecto:** Recibe notificación de fecha reservada (solo lectura).
- **Cliente:** Recibe confirmación de fecha reservada.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-011-reserva-automatica-fechas.md`
- Bloque funcional: Reserva en calendario integrado con validación e integración Google Calendar.
- Pasos: 1–7 del flujo principal (obtención de fecha hasta notificaciones y registro).

**Nota:** Este epic se ejecuta dentro del flujo de EP-010 (activación automática de proyectos); también puede invocarse de forma independiente para reserva manual de fecha.

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-011-US-001 | Obtención de fecha del proyecto desde contrato | Como sistema centralizado, quiero obtener automáticamente la fecha del evento/proyecto desde el contrato firmado, para poder validar disponibilidad y reservar sin intervención manual | Definida | Alta |
| EP-011-US-002 | Validación automática de disponibilidad | Como sistema centralizado, quiero validar automáticamente la disponibilidad de la fecha consultando el calendario de fechas reservadas y verificando que no esté ya bloqueada, para evitar solapamientos; si hay conflicto, notificar y requerir resolución | Definida | Alta |
| EP-011-US-003 | Reserva en calendario interno e integración Google Calendar | Como sistema centralizado, quiero reservar automáticamente la fecha bloqueándola en el calendario interno y creando el evento en Google Calendar correctamente (sin comportamientos erráticos), y marcar la fecha como "Reservada", para que la fecha quede bloqueada y sincronizada | Definida | Alta |
| EP-011-US-004 | Notificación de reserva confirmada y registro | Como sistema centralizado, quiero notificar automáticamente al equipo de proyecto y al cliente que la fecha ha sido reservada y confirmada, y registrar la reserva en el sistema con timestamp y datos del proyecto, para visibilidad y trazabilidad | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Estado de fecha:** Disponible, Reservada (vinculada a proyecto).
- **Reserva:** proyecto_id, fecha, timestamp de reserva, sincronización Google Calendar (éxito/fallo).
- **Conflicto de disponibilidad:** fecha ya reservada por otro proyecto; requiere resolución manual.

### Reglas de numeración/ID específicas
- Reserva vinculada por proyecto_id y fecha del evento.
- Evento en Google Calendar: título/concepto según convención (ej. nombre proyecto + cliente).
