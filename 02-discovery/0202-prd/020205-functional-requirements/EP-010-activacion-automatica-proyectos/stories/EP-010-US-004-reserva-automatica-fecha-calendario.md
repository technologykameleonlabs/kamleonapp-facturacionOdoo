# EP-010-US-004 — Reserva automática de fecha en calendario

### Epic padre
EP-010 — Activación automática de proyectos

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** reservar automáticamente la fecha del proyecto en el calendario integrado (bloqueo, integración Google Calendar) tras la activación,  
**para** que la fecha quede bloqueada y confirmada sin pasos manuales (TO-BE-011).

### Alcance
**Incluye:**
- Obtención de la fecha del evento/proyecto (desde datos del contrato o reunión).
- Bloqueo de la fecha en el calendario integrado del sistema.
- Integración con Google Calendar para reflejar la reserva.
- Registro de la reserva asociada al proyecto.
- Si la fecha ya está reservada: notificar conflicto y permitir resolución (flujo excepcional).

**Excluye:**
- Activación del proyecto (EP-010-US-003).
- Notificaciones de reserva confirmada (EP-010-US-005).
- Agendamiento de reuniones (EP-004) — es otro flujo (reuniones comerciales).

### Precondiciones
- Proyecto recién activado (EP-010-US-003).
- Fecha del evento/proyecto disponible (bodas: fecha de boda; corporativo: fecha acordada).
- Calendario integrado y/o Google Calendar configurado y accesible.

### Postcondiciones
- Fecha reservada y bloqueada en calendario.
- Reserva visible en Google Calendar (si aplica).
- Reserva asociada al proyecto en el sistema.
- Flujo listo para notificaciones (EP-010-US-005).

### Flujo principal
1. Sistema recibe trigger de proyecto activado (EP-010-US-003).
2. Sistema obtiene la fecha del evento desde datos del proyecto/contrato.
3. Sistema comprueba disponibilidad de la fecha en el calendario.
4. Si fecha disponible: sistema bloquea la fecha en calendario integrado y sincroniza con Google Calendar.
5. Sistema asocia la reserva al proyecto (registro de fecha reservada).
6. Sistema dispara notificaciones (EP-010-US-005).

### Flujos alternos y excepciones

**Excepción 1: Fecha ya reservada**
- Si la fecha ya está bloqueada por otro proyecto o evento: sistema notifica conflicto a administración/equipo, no bloquea automáticamente y permite resolución manual (cambiar fecha, excepción, etc.).

**Excepción 2: Fecha del evento no disponible**
- Si no hay fecha definida en el proyecto: sistema registra advertencia, no bloquea y notifica a equipo para definir fecha y reservar manualmente si aplica.

**Excepción 3: Error de integración con Google Calendar**
- Si falla la sincronización con Google: sistema mantiene la reserva en calendario interno, registra incidencia y notifica para revisión manual de Calendar.

### Validaciones y reglas de negocio
- La fecha a reservar debe ser la fecha del evento (boda, evento corporativo).
- No se puede reservar dos veces la misma fecha para el mismo recurso/calendario si ya está ocupada.

### Criterios BDD
- **Escenario 1: Fecha disponible — reserva correcta**
  - *Dado* que el proyecto está activado y la fecha del evento es D
  - *Cuando* el sistema ejecuta la reserva automática de fecha
  - *Entonces* la fecha D queda bloqueada en el calendario y sincronizada con Google Calendar, y la reserva queda asociada al proyecto

- **Escenario 2: Fecha ya reservada**
  - *Dado* que la fecha del evento D ya está reservada por otro proyecto
  - *Cuando* el sistema intenta reservar la fecha
  - *Entonces* el sistema no bloquea la fecha, notifica conflicto y permite resolución manual

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-010-activacion-automatica-proyectos.md`
- TO-BE-011: Reserva automática de fechas (se ejecuta en este proceso).
- Paso(s): Paso 5 del flujo principal (reserva automática de fecha).
