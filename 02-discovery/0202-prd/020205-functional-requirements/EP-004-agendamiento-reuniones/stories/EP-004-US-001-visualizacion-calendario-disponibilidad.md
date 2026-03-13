# EP-004-US-001 — Visualización de calendario con disponibilidad en tiempo real

### Epic padre
EP-004 — Agendamiento de reuniones

### Contexto/Descripción y valor
**Como** cliente potencial,  
**quiero** ver un calendario con disponibilidad visible en tiempo real mostrando solo horarios y fechas disponibles,  
**para** poder identificar rápidamente los huecos libres y seleccionar fácilmente cuándo puedo tener la reunión sin tener que coordinar por email o WhatsApp.

### Alcance
**Incluye:**
- Página de acceso al sistema de agendamiento a través de un enlace único recibido en el correo de respuesta inicial o portal.
- Visualización de calendario con:
  - Días disponibles y no disponibles (festivos, fines de semana si se desea bloquear, días sin atención).
  - Horas disponibles dentro de cada día según horarios laborales configurados.
  - Bloques ya ocupados por otras reuniones u otros compromisos (no seleccionables).
  - Diferenciación visual clara entre huecos disponibles para modalidad presencial y online (si aplica).
- Actualización en tiempo real de la disponibilidad al cargar la página.
- Soporte para distintos dispositivos (móvil, tablet, desktop) con diseño responsive.

**Excluye:**
- Selección de fecha/hora y modalidad (EP-004-US-002).
- Validación y bloqueo definitivo de disponibilidad (EP-004-US-003).
- Generación y envío de convocatorias (EP-004-US-004 y EP-004-US-005).
- Programación de recordatorios (EP-004-US-006).

### Precondiciones
- Lead está cualificado (TO-BE-002) y tiene acceso al enlace de agendamiento (incluido en respuesta inicial o portal).
- Calendario de disponibilidad está configurado (horarios laborales, días disponibles, reglas de bloqueo).
- Integración con Google Calendar está activa y sincronizada (para tomar en cuenta reuniones ya existentes).
- Sistema de autenticación del enlace (token único) está operativo para identificar al lead.

### Postcondiciones
- Calendario mostrado al cliente con la disponibilidad vigente en el momento de acceso.
- Cliente entiende, de un vistazo, qué días y franjas horarias están disponibles.
- No se han realizado aún cambios de estado en el sistema de reservas (solo lectura de disponibilidad).

### Flujo principal
1. Cliente potencial hace clic en el enlace único de agendamiento recibido en el correo inicial o accede al portal y selecciona “Agendar reunión”.
2. Sistema valida el enlace (token) y asocia la sesión al lead correspondiente.
3. Sistema carga configuración de disponibilidad:
   - Horarios laborales configurados.
   - Días bloqueados (festivos, vacaciones, indisponibilidad).
   - Reuniones ya agendadas.
4. Sistema consulta Google Calendar (y/o calendario interno) para incorporar eventos ya existentes y evitar solapamientos.
5. Sistema construye la matriz de slots disponibles (día/hora) según reglas de negocio.
6. Sistema muestra al cliente un calendario con:
   - Días disponibles resaltados.
   - Días no disponibles atenuados/no seleccionables.
   - Horas disponibles dentro del día seleccionado.
   - Horas bloqueadas/ocupadas no seleccionables.
7. Sistema diferencia visualmente (si aplica) slots disponibles para presencial y online (por ejemplo, mediante iconos o etiquetas).
8. Cliente ve el calendario con la disponibilidad actualizada y puede pasar al siguiente paso para seleccionar fecha/hora (EP-004-US-002).

### Flujos alternos y excepciones

**Flujo alterno 1: No hay disponibilidad en el rango visible**
- Si, al cargar el calendario, no hay ningún slot disponible en el mes actual:
  - Sistema muestra mensaje: “En este periodo no hay horarios disponibles. Prueba a cambiar de mes o contacta con nosotros.”
  - Cliente puede navegar a meses siguientes para buscar disponibilidad.

**Flujo alterno 2: Diferentes vistas de calendario**
- Cliente puede cambiar entre vista mensual, semanal o de lista de slots:
  - Vista mensual: muestra disponibilidad por día.
  - Vista semanal: permite ver mejor las horas disponibles en una semana.
  - Vista de lista: muestra una lista de próximos slots disponibles (ej. “Próximas 10 opciones”).

**Excepción 1: Enlace de agendamiento caducado o inválido**
- Si el token del enlace ha caducado o es inválido:
  - Sistema muestra mensaje: “Este enlace ya no es válido. Solicita un nuevo enlace de agendamiento.”
  - No se muestra calendario.
  - Sistema registra intento fallido con motivo.

**Excepción 2: Error al consultar disponibilidad (integración externa)**
- Si falla la consulta a Google Calendar o al calendario interno:
  - Sistema muestra mensaje: “No hemos podido cargar la disponibilidad en este momento. Intenta de nuevo más tarde.”
  - Sistema registra error técnico y notifica al equipo.

**Excepción 3: Cliente sin permisos para usar el enlace**
- Si el enlace está asociado a otro lead o no se encuentra:
  - Sistema muestra mensaje: “No hemos podido identificar tu invitación. Verifica el enlace o contacta con nosotros.”
  - Sistema no muestra calendario.

### Validaciones y reglas de negocio
- Solo se muestran slots que:
  - Están dentro de horarios laborales configurados.
  - No están bloqueados por vacaciones/festivos.
  - No están ocupados por otras reuniones/eventos.
- Slots deben tener una duración mínima estandarizada (por ejemplo, 30 o 60 minutos).
- El sistema debe soportar zona horaria configurada (ej. zona horaria de ONGAKU).
- Se respeta un posible “tiempo mínimo de antelación” (ej. no se puede agendar con menos de 24h).
- Vista debe ser usable en dispositivos móviles.

### Criterios BDD
- **Escenario 1: Visualización correcta de disponibilidad**
  - *Dado* que un lead cualificado accede al enlace de agendamiento válido
  - *Cuando* el sistema carga la disponibilidad
  - *Entonces* se muestran solo días y horas disponibles, con días/horas bloqueadas no seleccionables.

- **Escenario 2: No hay disponibilidad en el mes actual**
  - *Dado* que el calendario no tiene slots disponibles en el mes actual
  - *Cuando* el cliente accede al calendario
  - *Entonces* el sistema muestra mensaje informativo sobre falta de disponibilidad y permite navegar a meses siguientes.

- **Escenario 3 (negativo): Enlace de agendamiento caducado**
  - *Dado* que el link de agendamiento ha caducado
  - *Cuando* el cliente intenta acceder
  - *Entonces* el sistema muestra mensaje de error indicando que el enlace no es válido y no muestra el calendario.

### Notificaciones
- **Equipo interno (opcional):** Notificación/alerta si se producen errores recurrentes al cargar disponibilidad (fallos de integración).

### Seguridad
- Validación de token de enlace para evitar que terceros accedan al calendario asociado a otro lead.
- Protección contra enumeración de tokens (tokens suficientemente largos y aleatorios).
- Uso obligatorio de HTTPS.

### Analítica/KPIs
- Porcentaje de accesos al enlace de agendamiento que llegan a ver el calendario correctamente.
- Tiempo medio de carga del calendario.
- Porcentaje de sesiones con “sin disponibilidad” en el mes actual.
- Dispositivo más usado (móvil/desktop) para ajustar diseño.

### Definition of Ready
- [ ] Configuración de horarios laborales y días disponibles definida.
- [ ] Integración con Google Calendar (o calendario interno) disponible.
- [ ] Diseño de UI de calendario aprobado.
- [ ] Especificación de zona horaria confirmada.

### Definition of Done
- [ ] Calendario se muestra correctamente con datos reales de disponibilidad.
- [ ] Se ocultan slots no disponibles o bloqueados.
- [ ] Manejo de enlaces caducados o inválidos implementado.
- [ ] Manejo de errores de integración implementado.
- [ ] Pruebas de aceptación (escenarios BDD) superadas.
- [ ] Comportamiento responsive verificado.

### Riesgos y supuestos
- **Riesgo:** Calendario lento en cargar si hay muchos eventos → Mitigación: caché y paginación de rangos de fechas.
- **Riesgo:** Diferencias de zona horaria entre cliente y ONGAKU → Mitigación: mostrar siempre la zona horaria utilizada y ajustar mensajes.
- **Supuesto:** El lead accede siempre a través de enlace válido incluido en comunicaciones oficiales.

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-004-agendamiento-reuniones.md`
- Bloque funcional: Calendario con disponibilidad visible en tiempo real.
- Paso(s): 1–2 del flujo principal (cliente accede al enlace, sistema muestra calendario con disponibilidad).

