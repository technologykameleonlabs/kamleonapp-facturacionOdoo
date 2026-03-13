# EP-004 — Agendamiento de reuniones

**Descripción:** Sistema de agendamiento autónomo que permite al cliente potencial elegir fecha/hora disponible para reunión, modalidad (presencial/online), con generación automática de convocatorias y recordatorios, eliminando completamente los olvidos de convocatorias y solapamientos de reuniones, mejorando la experiencia del cliente y acelerando el ciclo comercial.

**Proceso TO-BE origen:** TO-BE-004: Agendamiento de reuniones con clientes

**Bloque funcional:** Agendamiento autónomo por cliente - Flujo completo desde acceso al sistema de agendamiento hasta confirmación de reunión agendada con convocatoria generada y recordatorios programados

**Objetivo de negocio:** Eliminar completamente los olvidos de convocatorias y solapamientos de reuniones, permitiendo al cliente agendar reunión autónomamente en menos de 2 minutos, con generación automática de convocatorias y recordatorios, garantizando que el 100% de las reuniones agendadas tengan convocatoria generada automáticamente y recordatorios enviados 24h y 1h antes, mejorando la experiencia del cliente y acelerando el ciclo comercial.

**Alcance y exclusiones:**  
- **Incluye:** Calendario con disponibilidad visible en tiempo real; selección de fecha, hora y modalidad (presencial/online) por cliente; validación y bloqueo de disponibilidad para evitar solapamientos; generación automática de convocatorias según modalidad (presencial con dirección, online con enlace Google Meet); envío automático de convocatorias al cliente y notificación al equipo; sincronización con Google Calendar; programación de recordatorios automáticos (24h y 1h antes); gestión de reuniones (CRUD, cancelación, reagendamiento); configuración de horarios laborales y días disponibles
- **Excluye:** Integración con sistemas de videollamada alternativos (Zoom, Teams) además de Google Meet; pre-agendamiento con solicitud de fechas preferidas; recordatorios por SMS; portal completo de cliente con todas sus reuniones; registro de información durante reunión (EP-005); gestión de disponibilidad de recursos (EP-011)

**KPIs (éxito):**  
- 100% de reuniones agendadas tienen convocatoria generada automáticamente - Fecha objetivo: v1.0.0
- 0% de olvidos de convocatorias - Fecha objetivo: v1.0.0
- 0% de solapamientos de reuniones - Fecha objetivo: v1.0.0
- Recordatorios automáticos enviados 24h y 1h antes de la reunión (100% de cobertura) - Fecha objetivo: v1.0.0
- Tiempo de agendamiento < 2 minutos para el cliente - Fecha objetivo: v1.0.0

**Actores y permisos (RBAC):**  
- **Cliente potencial:** Acceso al sistema de agendamiento mediante enlace único, selección de fecha/hora/modalidad, cancelación y reagendamiento de sus propias reuniones (solo lectura/escritura en sus propias reuniones)
- **Sistema centralizado:** Visualización de disponibilidad, validación, bloqueo de fechas, generación de convocatorias, envío automático, sincronización con Google Calendar, programación de recordatorios (sin permisos, proceso automático)
- **Usuario de ONGAKU:** Visualización de todas las reuniones agendadas, gestión de reuniones (CRUD), cancelación y reagendamiento de cualquier reunión, configuración de horarios y disponibilidad (lectura/escritura en todas las reuniones según permisos)

**Trazabilidad (fuentes):**  
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-004-agendamiento-reuniones.md` - Bloque: Pasos 1-10 (acceso al sistema de agendamiento hasta registro de reunión agendada)

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-004-US-001 | Visualización de calendario con disponibilidad en tiempo real | Como cliente potencial, quiero ver un calendario con disponibilidad visible en tiempo real mostrando solo horarios y fechas disponibles, para poder seleccionar fácilmente cuándo puedo tener la reunión | Pendiente | Alta |
| EP-004-US-002 | Selección de fecha, hora y modalidad de reunión | Como cliente potencial, quiero seleccionar fecha, hora y modalidad (presencial/online) de entre las opciones disponibles, para agendar la reunión según mis preferencias y disponibilidad | Pendiente | Alta |
| EP-004-US-003 | Validación y bloqueo de disponibilidad para evitar solapamientos | Como sistema centralizado, quiero validar que la fecha/hora seleccionada sigue disponible y bloquearla inmediatamente, para evitar solapamientos de reuniones y garantizar que solo una reunión pueda agendarse en cada slot | Pendiente | Alta |
| EP-004-US-004 | Generación automática de convocatorias según modalidad | Como sistema centralizado, quiero generar automáticamente la convocatoria según modalidad elegida (presencial con dirección o online con enlace Google Meet), para que el cliente y el equipo tengan todos los detalles necesarios sin intervención manual | Pendiente | Alta |
| EP-004-US-005 | Envío de convocatorias y sincronización con Google Calendar | Como sistema centralizado, quiero enviar automáticamente la convocatoria al cliente y notificar al equipo, y sincronizar correctamente con Google Calendar sin comportamientos erráticos, para garantizar que todos tengan la información y el calendario esté actualizado | Pendiente | Alta |
| EP-004-US-006 | Programación de recordatorios automáticos y gestión de reuniones | Como sistema centralizado, quiero programar recordatorios automáticos 24h y 1h antes de la reunión, y como usuario de ONGAKU quiero gestionar reuniones (CRUD, cancelación, reagendamiento) y configurar horarios laborales, para garantizar que nadie olvide la reunión y tener control sobre el proceso | Pendiente | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Reunión agendada:** Cita programada con cliente potencial con fecha, hora, modalidad y convocatoria generada
- **Disponibilidad:** Horarios y fechas en los que es posible agendar reuniones según configuración de horarios laborales y días disponibles
- **Modalidad:** Tipo de reunión - Presencial (en oficina) u Online (videollamada)
- **Convocatoria:** Documento/email con detalles de la reunión (fecha, hora, modalidad, dirección o enlace Meet)
- **Bloqueo de disponibilidad:** Reserva temporal de fecha/hora para evitar que otro cliente la seleccione simultáneamente
- **Solapamiento:** Situación en la que dos o más reuniones están agendadas en el mismo horario
- **Recordatorio:** Notificación automática enviada antes de la reunión (24h y 1h antes)

### Reglas de numeración/ID específicas
- Formato de ID de reunión: `REU-{ID_LEAD}-{TIMESTAMP}`
- Formato de ID de convocatoria: `CONV-{ID_REUNION}-{TIMESTAMP}`
- Formato de enlace de agendamiento: `https://ongaku.com/agendar/{TOKEN_UNICO}`

### Mockups o enlaces a UI
- [Pendiente de diseño] Calendario con disponibilidad visible en tiempo real para cliente
- [Pendiente de diseño] Formulario de selección de fecha, hora y modalidad
- [Pendiente de diseño] Vista de gestión de reuniones para usuarios de ONGAKU
- [Pendiente de diseño] Configuración de horarios laborales y días disponibles
- [Pendiente de diseño] Vista de detalle de reunión con información completa y opciones de cancelación/reagendamiento
