# EP-011-US-003 — Reserva en calendario interno e integración Google Calendar

### Epic padre
EP-011 — Reserva automática de fechas

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** reservar automáticamente la fecha bloqueándola en el calendario interno y creando el evento en Google Calendar correctamente (sin comportamientos erráticos), y marcar la fecha como "Reservada",  
**para** que la fecha quede bloqueada y sincronizada.

### Alcance
**Incluye:**
- Bloqueo de la fecha en el calendario interno del sistema.
- Creación del evento en Google Calendar con detalles del proyecto (título, fecha, datos relevantes); sincronización correcta sin errores.
- Marcado de la fecha como "Reservada" en el sistema y vinculación al proyecto.
- Registro de la reserva (timestamp, proyecto, fecha) en base de datos.
- Disparo de notificaciones (EP-011-US-004).

**Excluye:**
- Validación de disponibilidad (EP-011-US-002).
- Notificaciones a equipo y cliente (EP-011-US-004).
- Edición manual de eventos en Google Calendar fuera del sistema.

### Precondiciones
- Fecha del proyecto obtenida (EP-011-US-001).
- Disponibilidad validada (EP-011-US-002 — fecha disponible).
- Calendario interno y, si aplica, integración con Google Calendar configurados y accesibles.

### Postcondiciones
- Fecha bloqueada en calendario interno.
- Evento creado en Google Calendar (o incidencia registrada si falla integración).
- Fecha marcada como "Reservada" y vinculada al proyecto.
- Flujo listo para notificaciones (EP-011-US-004).

### Flujo principal
1. Sistema recibe confirmación de fecha disponible (EP-011-US-002).
2. Sistema bloquea la fecha en el calendario interno (estado "Reservada", vinculada al proyecto).
3. Sistema crea el evento en Google Calendar con detalles del proyecto (título, fecha, cliente, proyecto).
4. Si la creación en Google Calendar es exitosa: sistema registra sincronización correcta.
5. Si falla la creación en Google Calendar: sistema mantiene la reserva en calendario interno, registra incidencia y notifica a administración para sincronización manual.
6. Sistema registra la reserva en base de datos (timestamp, proyecto_id, fecha, estado Google Calendar).
7. Sistema dispara notificaciones (EP-011-US-004).

### Flujos alternos y excepciones

**Excepción 1: Error en integración Google Calendar**
- Sistema mantiene la reserva en calendario interno, registra incidencia (fallo de sincronización) y notifica a administración para revisar o sincronizar manualmente.

**Excepción 2: Error al bloquear en calendario interno**
- Si falla el bloqueo interno: sistema no crea evento en Google Calendar, notifica error y no continúa con notificaciones.

### Validaciones y reglas de negocio
- La reserva en calendario interno es la fuente de verdad; Google Calendar es sincronización.
- El evento en Google Calendar debe reflejar el proyecto (título/concepto según convención).

### Criterios BDD
- **Escenario 1: Reserva e integración correctas**
  - *Dado* que la fecha está disponible
  - *Cuando* el sistema reserva la fecha
  - *Entonces* la fecha queda bloqueada en el calendario interno, el evento se crea en Google Calendar correctamente y la fecha queda marcada como "Reservada"

- **Escenario 2: Fallo en Google Calendar**
  - *Dado* que la integración con Google Calendar falla
  - *Cuando* el sistema intenta crear el evento
  - *Entonces* la reserva se mantiene en el calendario interno, se registra la incidencia y se notifica a administración

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-011-reserva-automatica-fechas.md`
- Paso(s): Pasos 3–5 del flujo principal (reserva en calendario interno, creación en Google Calendar, marcado como Reservada).
