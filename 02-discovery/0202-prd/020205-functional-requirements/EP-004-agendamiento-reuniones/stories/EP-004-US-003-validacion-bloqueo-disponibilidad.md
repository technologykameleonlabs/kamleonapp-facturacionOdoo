# EP-004-US-003 — Validación y bloqueo de disponibilidad para evitar solapamientos

### Epic padre
EP-004 — Agendamiento de reuniones

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** validar que la fecha/hora seleccionada sigue disponible y bloquearla inmediatamente,  
**para** evitar solapamientos de reuniones y garantizar que solo una reunión pueda agendarse en cada slot.

### Alcance
**Incluye:**
- Validación en backend de que el slot (fecha/hora) seleccionado sigue libre en el momento de la confirmación.
- Bloqueo inmediato del slot en el calendario interno/Google Calendar para evitar que otros clientes lo seleccionen.
- Manejo de reservas temporales (si se requiere): bloqueo corto mientras se completa el proceso.
- Liberación de bloqueo si el proceso de agendamiento no se completa (timeout o cancelación).

**Excluye:**
- Generación de convocatorias (EP-004-US-004).
- Envío de convocatorias y sincronización final con Google Calendar (EP-004-US-005).
- Programación de recordatorios (EP-004-US-006).

### Precondiciones
- Cliente ha seleccionado fecha, hora y modalidad (EP-004-US-002).
- Sistema tiene acceso a la fuente de verdad de disponibilidad (calendario interno + Google Calendar).

### Postcondiciones
- Slot (fecha/hora) queda bloqueado para la reunión del lead (reserva firme o temporal, según diseño).
- Si el slot ya no estaba disponible, el cliente es informado y debe seleccionar otro horario.

### Flujo principal
1. Cliente confirma su selección de fecha, hora y modalidad.
2. Sistema recibe la selección en backend con los datos necesarios (lead, fecha, hora, modalidad).
3. Sistema consulta disponibilidad actualizada para ese slot:
   - Eventos/reuniones ya agendadas.
   - Bloqueos temporales activos.
4. Sistema evalúa si el slot sigue disponible:
   - Si está libre, continúa.
   - Si no está libre, activa flujo de error.
5. Sistema bloquea el slot para el lead:
   - Crea una reserva en el calendario interno.
   - Opcionalmente crea un evento preliminar en Google Calendar (según diseño).
6. Sistema marca internamente el slot como no disponible para futuros clientes.
7. Sistema registra la reserva asociada al lead (estado “Pendiente de convocatoria/confirmación”).
8. Sistema devuelve confirmación al frontend para continuar con generación de convocatoria (EP-004-US-004).

### Flujos alternos y excepciones

**Flujo alterno 1: Reserva temporal con timeout**
- Sistema realiza un bloqueo temporal (ej. 10 minutos) mientras se genera convocatoria y se completa el proceso.
- Si el proceso no se completa en ese tiempo, sistema libera el slot automáticamente.

**Flujo alterno 2: Reintento de validación ante fallo de integración**
- Si la consulta a Google Calendar falla puntualmente:
  - Sistema reintenta la validación N veces.
  - Si tras reintentos sigue fallando, sistema informa al cliente que no puede confirmar y pide reintentar más tarde.

**Excepción 1: Slot ya ocupado**
- Si en el paso de validación se detecta que el slot ya está ocupado:
  - Sistema no bloquea el slot.
  - Sistema informa al cliente que el horario ya no está disponible.
  - Sistema actualiza disponibilidad mostrada y pide al cliente seleccionar otro horario.

**Excepción 2: Error en el bloqueo del slot**
- Si, tras validar que el slot está libre, falla la operación de bloqueo:
  - Sistema registra error técnico.
  - Sistema informa al cliente que no se ha podido confirmar la reserva.
  - Proceso se detiene y se sugiere intentar con otro horario.

### Validaciones y reglas de negocio
- Validación de disponibilidad debe ser transaccional: no suficiente con lo visto en la UI.
- En caso de alta concurrencia, se debe garantizar consistencia (bloqueo atómico del slot).
- Tiempo máximo de reserva temporal configurable.
- Debe existir lógica clara para liberar slots bloqueados si el proceso no termina.

### Criterios BDD
- **Escenario 1: Bloqueo exitoso del slot disponible**
  - *Dado* que un cliente ha seleccionado fecha/hora/modalidad y el slot está libre
  - *Cuando* el sistema valida la disponibilidad
  - *Entonces* el sistema bloquea el slot para ese lead, registra la reserva y devuelve confirmación para continuar.

- **Escenario 2 (negativo): Slot ya ocupado en el momento de confirmar**
  - *Dado* que otro cliente ha reservado el mismo slot justo antes
  - *Cuando* el sistema valida la disponibilidad
  - *Entonces* el sistema detecta que el slot está ocupado, no lo bloquea, informa al cliente y le pide elegir otro horario.

- **Escenario 3 (negativo): Error técnico al bloquear slot**
  - *Dado* que el slot está libre
  - *Cuando* el sistema intenta bloquearlo pero falla la operación de calendario
  - *Entonces* el sistema no marca el slot como reservado, informa al cliente del error y registra el incidente.

### Notificaciones
- **Equipo técnico (opcional):** Notificación/alerta si se acumulan errores de bloqueo o integración con calendario.

### Seguridad
- Control de acceso: solo el sistema puede bloquear slots, no el cliente directamente.
- Protección frente a ataques de fuerza bruta o uso malicioso de la API de bloqueo.

### Analítica/KPIs
- Ratio de intentos de reserva que fallan por slot ocupado.
- Tiempo medio de validación y bloqueo.
- Número de reservas temporales expiradas sin completar.

### Definition of Ready
- [ ] Fuente de verdad de disponibilidad identificada y accesible.
- [ ] Reglas de bloqueo y su duración definidas.
- [ ] Diseño de modelo de datos para reservas definido.

### Definition of Done
- [ ] Función de validación y bloqueo implementada y probada.
- [ ] Manejo de concurrencia probado (casos de alta demanda).
- [ ] Manejo de errores de integración implementado.
- [ ] Escenarios BDD pasados.

### Riesgos y supuestos
- **Riesgo:** Condiciones de carrera en alta concurrencia → Mitigación: bloqueos atómicos y pruebas de carga.
- **Supuesto:** La API de Google Calendar (o el calendario interno) soporta las operaciones de bloqueo de forma consistente.

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-004-agendamiento-reuniones.md`
- Bloque funcional: Validación y bloqueo de disponibilidad.
- Paso(s): 3–4 del flujo principal (validación de que fecha/hora sigue disponible, bloqueo en calendario).

