# EP-004-US-006 — Programación de recordatorios automáticos y gestión de reuniones

### Epic padre
EP-004 — Agendamiento de reuniones

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** programar recordatorios automáticos 24h y 1h antes de la reunión,  
**y como** usuario de ONGAKU  
**quiero** gestionar reuniones (CRUD, cancelación, reagendamiento) y configurar horarios laborales,  
**para** garantizar que nadie olvide la reunión y tener control operativo sobre el calendario de reuniones.

### Alcance
**Incluye (parte sistema):**
- Programación automática de recordatorios:
  - 24h antes de la reunión.
  - 1h antes de la reunión.
- Recordatorios enviados por email (y/o notificación interna) a:
  - Cliente.
  - Fátima/Paz.
- Contenido de recordatorios:
  - Fecha y hora.
  - Modalidad.
  - Dirección o enlace Meet.

**Incluye (parte usuario ONGAKU):**
- Vista de listado de reuniones:
  - Filtro por fecha, estado, lead, modalidad.
- Detalle de reunión:
  - Datos del lead.
  - Fecha/hora/modalidad.
  - Estado (Agendada, Cancelada, Reagendada, Completada).
- Acciones sobre la reunión:
  - Cancelar reunión (liberando el slot).
  - Reagendar reunión (seleccionando nuevo slot, reutilizando gran parte del flujo).
- Configuración de horarios laborales y días disponibles:
  - Horas de inicio/fin de jornada.
  - Días de la semana disponibles.
  - Bloqueos puntuales (vacaciones, eventos internos).

**Excluye:**
- Registro de información de la reunión (EP-005).
- Detalles de facturación o presupuestos.

### Precondiciones
- Reunión está agendada en estado “Agendada” (EP-004-US-005).
- Sistema de envío de emails y/o notificaciones está operativo.
- Hay un mecanismo de planificación de tareas (scheduler/cron) disponible.

### Postcondiciones
- Recordatorios quedan programados para todas las reuniones agendadas.
- Usuarios de ONGAKU pueden ver, cancelar y reagendar reuniones.
- Configuración de horarios laborales impacta en la disponibilidad mostrada y futuras reservas.

### Flujo principal (recordatorios)
1. Al marcar una reunión como “Agendada”, el sistema calcula:
   - Fecha/hora para recordatorio de 24h antes.
   - Fecha/hora para recordatorio de 1h antes.
2. Sistema registra tareas programadas para ambos recordatorios.
3. En el momento correspondiente (24h antes):
   - Sistema envía recordatorio al cliente y al equipo con detalles de la reunión.
4. En el momento correspondiente (1h antes):
   - Sistema envía segundo recordatorio al cliente y al equipo.
5. Sistema registra que los recordatorios se han enviado (para trazabilidad).

### Flujo principal (gestión de reuniones por ONGAKU)
1. Usuario de ONGAKU accede a la vista de “Reuniones”.
2. Sistema muestra listado de reuniones con filtros (fecha, estado, modalidad, lead).
3. Usuario selecciona una reunión para ver su detalle.
4. Usuario puede:
   - Cancelar reunión:
     - Sistema cambia estado a “Cancelada”.
     - Sistema libera el slot en el calendario/Google Calendar.
     - Sistema notifica al cliente la cancelación (y opcionalmente sugiere reagendar).
   - Reagendar reunión:
     - Usuario inicia un flujo similar al de agendamiento (selección de nuevo slot).
     - Sistema valida y bloquea el nuevo slot.
     - Sistema actualiza evento en Google Calendar.
     - Sistema notifica al cliente el cambio de fecha/hora.

### Flujo principal (configuración de horarios laborales)
1. Usuario de ONGAKU accede a la sección de “Configuración de disponibilidad”.
2. Sistema muestra configuración actual:
   - Horas de inicio/fin por día.
   - Días activos/inactivos.
   - Bloqueos puntuales (vacaciones, etc.).
3. Usuario ajusta la configuración (por ejemplo, añade un bloqueo de vacaciones).
4. Sistema guarda configuración y recalcula disponibilidad para futuras reservas.

### Flujos alternos y excepciones

**Flujo alterno 1: Recordatorios opcionales por tipo de cliente**
- Configuración permite desactivar el recordatorio de 1h para ciertos tipos de reuniones (ej. corporativo).

**Excepción 1: Reunión cancelada antes de los recordatorios**
- Si la reunión se cancela antes de que se envíen los recordatorios:
  - Sistema cancela las tareas programadas.
  - No se envían recordatorios para esa reunión.

**Excepción 2: Error al enviar recordatorio**
- Si el envío del recordatorio falla:
  - Sistema reintenta según política.
  - Si no se consigue, notifica al equipo y registra el error.

**Excepción 3: Error al liberar el slot en cancelación**
- Si al cancelar reunión no se consigue liberar slot (error de calendario):
  - Sistema registra error.
  - Sistema notifica al equipo para corrección manual.

### Validaciones y reglas de negocio
- Recordatorios solo se programan para reuniones en estado “Agendada”.
- Si la hora actual es menor que el momento del recordatorio (p.ej. reunión de menos de 24h), se programa solo el recordatorio de 1h (o el que siga siendo relevante).
- Al reagendar, se deben cancelar recordatorios antiguos y programar nuevos.
- Configuración de horarios laborales debe ser coherente (hora de inicio < hora de fin, etc.).

### Criterios BDD
- **Escenario 1: Programación correcta de recordatorios**
  - *Dado* que una reunión se marca como “Agendada” con más de 24h de antelación
  - *Cuando* el sistema programa los recordatorios
  - *Entonces* se crean tareas programadas para 24h y 1h antes de la reunión.

- **Escenario 2: Cancelación de reunión antes de recordatorios**
  - *Dado* que una reunión tiene recordatorios programados
  - *Cuando* se cancela la reunión
  - *Entonces* el sistema cancela las tareas de recordatorio y no envía notificaciones.

- **Escenario 3 (negativo): Error al enviar recordatorio**
  - *Dado* que un recordatorio debe ser enviado
  - *Cuando* falla el envío de email
  - *Entonces* el sistema reintenta (según política) y, si persiste el error, notifica al equipo y registra el incidente.

### Notificaciones
- **Cliente:** Emails de recordatorio 24h y 1h antes de la reunión.
- **Equipo ONGAKU:** Emails de recordatorio, notificaciones de cancelación/reagendamiento.

### Seguridad
- Evitar que usuarios no autorizados puedan cancelar o reagendar reuniones.
- Control de acceso a la configuración de horarios laborales.

### Analítica/KPIs
- Tasa de asistencia a reuniones (comparando reuniones con/ sin recordatorios).
- Número de cancelaciones y reagendamientos.
- Tasa de fallos en recordatorios enviados.

### Definition of Ready
- [ ] Modelo de reuniones y estados definido.
- [ ] Sistema de tareas programadas (scheduler) disponible.
- [ ] Política de envío de recordatorios definida.

### Definition of Done
- [ ] Recordatorios se envían automáticamente en los tiempos configurados.
- [ ] Cancelación y reagendamiento funcionan de extremo a extremo (incluyendo calendario y notificaciones).
- [ ] Configuración de horarios laborales impacta correctamente en la disponibilidad.
- [ ] Escenarios BDD pasados.

### Riesgos y supuestos
- **Riesgo:** Demasiados recordatorios pueden saturar al cliente → Mitigación: permitir ajustar frecuencia en configuración.
- **Supuesto:** Clientes consultan su email con suficiente frecuencia para ver los recordatorios.

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-004-agendamiento-reuniones.md`
- Bloque funcional: Recordatorios automáticos y gestión operativa de reuniones.
- Paso(s): 6–9 del flujo principal (programación de recordatorios, registro y seguimiento de reuniones).

