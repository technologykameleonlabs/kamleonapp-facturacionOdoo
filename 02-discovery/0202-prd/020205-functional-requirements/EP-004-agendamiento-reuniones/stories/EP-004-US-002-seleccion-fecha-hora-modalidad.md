# EP-004-US-002 — Selección de fecha, hora y modalidad de reunión

### Epic padre
EP-004 — Agendamiento de reuniones

### Contexto/Descripción y valor
**Como** cliente potencial,  
**quiero** seleccionar fecha, hora y modalidad (presencial/online) de entre las opciones disponibles en el calendario,  
**para** agendar la reunión según mis preferencias y disponibilidad, sin tener que coordinar por email o WhatsApp.

### Alcance
**Incluye:**
- Interacción del cliente con el calendario de disponibilidad mostrado (EP-004-US-001).
- Selección de:
  - Día disponible.
  - Hora disponible dentro del día seleccionado.
  - Modalidad de reunión (presencial/online).
- Visualización clara de la selección actual (día, hora, modalidad).
- Validaciones de front (no permitir seleccionar slots no disponibles).
- Botón/acción de “Confirmar selección” que pasa a validación y bloqueo (EP-004-US-003).

**Excluye:**
- Validación final de disponibilidad y bloqueo (EP-004-US-003).
- Generación y envío de convocatoria (EP-004-US-004 y EP-004-US-005).
- Programación de recordatorios (EP-004-US-006).

### Precondiciones
- Cliente está viendo el calendario con disponibilidad en tiempo real (EP-004-US-001 completada en la sesión).
- Hay al menos un slot disponible en el rango visible.
- Navegador del cliente soporta la UI de calendario (JS habilitado).

### Postcondiciones
- Cliente ha seleccionado un día, una hora y una modalidad de reunión válidos (pero aún no confirmados a nivel de sistema).
- Sistema tiene en memoria la selección pendiente para pasar al flujo de validación y bloqueo (EP-004-US-003).

### Flujo principal
1. Cliente potencial ve el calendario con días y horas disponibles.
2. Cliente selecciona un día disponible (click/tap en el día).
3. Sistema muestra las horas disponibles de ese día en una lista o rejilla.
4. Cliente selecciona una hora disponible (slot) de la lista.
5. Sistema muestra opciones de modalidad:
   - Presencial (en oficina de ONGAKU).
   - Online (videollamada Google Meet).
6. Cliente selecciona modalidad preferida.
7. Sistema muestra un resumen de selección:
   - Fecha seleccionada.
   - Hora seleccionada.
   - Modalidad seleccionada.
8. Cliente revisa el resumen y pulsa “Continuar” o “Confirmar selección”.
9. Sistema guarda selección pendiente y pasa a validación/bloqueo (EP-004-US-003).

### Flujos alternos y excepciones

**Flujo alterno 1: Cambio de selección antes de confirmar**
- Cliente, antes de confirmar, decide cambiar de día/hora o modalidad.
- Cliente hace clic en otro slot o cambia de modalidad.
- Sistema actualiza el resumen de selección con los nuevos valores.
- No se realiza aún bloqueo de disponibilidad.

**Flujo alterno 2: Modalidad fija preconfigurada**
- En algunos casos, ONGAKU puede decidir que solo se ofrezca modalidad online (o presencial) por configuración.
- Sistema solo muestra la modalidad disponible (sin opción de selección).
- Cliente solo elige día y hora.

**Excepción 1: Cliente intenta seleccionar slot no disponible**
- Si, por cualquier motivo, se muestra un slot que ya no está disponible (error de sincronización puntual):
  - Sistema muestra mensaje: “Este horario ya no está disponible. Por favor, selecciona otro.”
  - Sistema actualiza la lista de horas disponibles.

**Excepción 2: Cliente intenta continuar sin seleccionar los tres elementos (día, hora, modalidad)**
- Si cliente pulsa “Continuar” sin haber seleccionado día, hora o modalidad:
  - Sistema muestra mensaje de error indicando qué falta (ej. “Selecciona una hora” o “Selecciona una modalidad”).
  - Sistema no permite continuar.

### Validaciones y reglas de negocio
- Debe seleccionarse exactamente:
  - Un día disponible.
  - Una hora disponible dentro de ese día.
  - Una modalidad (salvo que solo exista una por configuración).
- No se permite seleccionar slots fuera de horarios laborales o días bloqueados.
- Debe respetarse cualquier “tiempo mínimo de antelación” configurado.
- Modalidad puede estar restringida según ciertos días/horas (ej. solo online a partir de cierta hora).

### Criterios BDD
- **Escenario 1: Selección exitosa de día, hora y modalidad**
  - *Dado* que un cliente ve un calendario con días y horas disponibles
  - *Cuando* selecciona un día disponible, una hora disponible y la modalidad “Online”
  - *Entonces* el sistema muestra un resumen con la fecha, hora y modalidad seleccionadas y permite continuar.

- **Escenario 2 (negativo): Intentar continuar sin seleccionar modalidad**
  - *Dado* que un cliente ha seleccionado día y hora pero no ha seleccionado modalidad
  - *Cuando* pulsa “Continuar”
  - *Entonces* el sistema muestra mensaje de error indicando que debe seleccionar una modalidad y no permite avanzar.

- **Escenario 3 (negativo): Slot ya no disponible en el momento de selección**
  - *Dado* que un cliente ve un slot como disponible pero este ha sido ocupado justo antes por otro cliente
  - *Cuando* intenta seleccionarlo
  - *Entonces* el sistema indica que el slot ya no está disponible y actualiza la lista de horas disponibles.

### Notificaciones
- No se generan notificaciones externas en esta US (solo interacción en pantalla).

### Seguridad
- Validar en backend que el slot seleccionado es válido antes de continuar con validación/bloqueo (aunque la UI ya lo haya bloqueado).

### Analítica/KPIs
- Tasa de abandono durante la selección (clientes que ven el calendario pero no completan selección).
- Tiempo medio que tarda un cliente en seleccionar día/hora/modalidad.
- Distribución de elecciones de modalidad (presencial vs online).

### Definition of Ready
- [ ] US EP-004-US-001 implementada (visualización de calendario con disponibilidad).
- [ ] Reglas de validación de slots y modalidad definidas.
- [ ] Diseño de UI para selección y resumen aprobado.

### Definition of Done
- [ ] Clientes pueden seleccionar día, hora y modalidad desde el calendario.
- [ ] Validaciones de campos obligatorios implementadas (no se puede continuar sin los tres).
- [ ] Manejo de slots que se vuelven no disponibles implementado.
- [ ] Pruebas de aceptación (escenarios BDD) superadas.

### Riesgos y supuestos
- **Riesgo:** Experiencia confusa si hay demasiadas opciones horarias → Mitigación: lista de “próximas X opciones” y filtros.
- **Supuesto:** Cliente entiende la diferencia entre presencial y online; textos de ayuda pueden aclararlo.

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-004-agendamiento-reuniones.md`
- Bloque funcional: Selección de fecha, hora y modalidad.
- Paso(s): 2–3 del flujo principal (cliente selecciona fecha/hora y modalidad).

