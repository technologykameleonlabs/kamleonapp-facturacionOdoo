# EP-011-US-002 — Validación automática de disponibilidad

### Epic padre
EP-011 — Reserva automática de fechas

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** validar automáticamente la disponibilidad de la fecha consultando el calendario de fechas reservadas y verificando que no esté ya bloqueada,  
**para** evitar solapamientos; si hay conflicto, notificar y requerir resolución.

### Alcance
**Incluye:**
- Consulta del calendario de fechas reservadas (calendario interno y/o Google Calendar según configuración).
- Verificación de que la fecha no esté ya bloqueada por otro proyecto o evento.
- Si fecha disponible: disparar reserva (EP-011-US-003).
- Si fecha no disponible: notificar conflicto a administración/equipo y requerir resolución (no reservar automáticamente).

**Excluye:**
- Reserva efectiva de la fecha (EP-011-US-003).
- Obtención de la fecha (EP-011-US-001).
- Resolución manual del conflicto (acción de administración fuera de este epic).

### Precondiciones
- Fecha del proyecto obtenida (EP-011-US-001).
- Calendario de fechas reservadas accesible (interno y/o integración Google Calendar).

### Postcondiciones
- Si disponible: flujo listo para reserva (EP-011-US-003).
- Si no disponible: conflicto notificado; no se reserva; administración/equipo debe resolver (cambiar fecha, excepción, etc.).

### Flujo principal
1. Sistema recibe la fecha del proyecto (EP-011-US-001).
2. Sistema consulta el calendario de fechas reservadas (calendario interno y, si aplica, Google Calendar).
3. Sistema verifica si la fecha está ya bloqueada por otro proyecto o evento.
4. Si la fecha no está bloqueada: sistema dispara reserva (EP-011-US-003).
5. Si la fecha está bloqueada: sistema notifica conflicto a administración/equipo, registra el intento y no reserva; requiere resolución manual.

### Flujos alternos y excepciones

**Excepción 1: Error al consultar calendario**
- Si falla la consulta (calendario no disponible, integración caída): sistema notifica a administración, no reserva automáticamente y permite reserva manual tras revisión.

### Validaciones y reglas de negocio
- No se puede reservar una fecha ya bloqueada sin resolución explícita (cambio de fecha o excepción aprobada).
- La consulta debe considerar el mismo recurso/calendario que se usará para la reserva.

### Criterios BDD
- **Escenario 1: Fecha disponible**
  - *Dado* que la fecha D no está reservada en el calendario
  - *Cuando* el sistema valida la disponibilidad
  - *Entonces* el sistema confirma que la fecha está disponible y dispara la reserva

- **Escenario 2: Fecha ya reservada**
  - *Dado* que la fecha D ya está reservada por otro proyecto
  - *Cuando* el sistema valida la disponibilidad
  - *Entonces* el sistema notifica conflicto, no reserva y requiere resolución manual

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-011-reserva-automatica-fechas.md`
- Paso(s): Paso 2 del flujo principal (validación de disponibilidad automática).
