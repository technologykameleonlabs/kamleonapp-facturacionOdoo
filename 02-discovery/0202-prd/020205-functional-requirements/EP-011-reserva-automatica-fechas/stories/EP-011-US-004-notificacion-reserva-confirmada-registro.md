# EP-011-US-004 — Notificación de reserva confirmada y registro

### Epic padre
EP-011 — Reserva automática de fechas

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** notificar automáticamente al equipo de proyecto y al cliente que la fecha ha sido reservada y confirmada, y registrar la reserva en el sistema con timestamp y datos del proyecto,  
**para** visibilidad y trazabilidad.

### Alcance
**Incluye:**
- Notificación automática al equipo de proyecto: fecha reservada confirmada, proyecto, cliente.
- Notificación automática al cliente: fecha reservada confirmada.
- Registro en el sistema de la reserva con timestamp y datos del proyecto (proyecto_id, fecha, estado, sincronización Google Calendar si aplica).
- Trazabilidad para consultas y reportes.

**Excluye:**
- Reserva efectiva en calendario (EP-011-US-003).
- Contenido detallado del evento en Google Calendar (EP-011-US-003).
- Notificaciones de activación de proyecto (EP-010-US-005) — pueden incluir reserva; este epic se centra en la reserva de fecha como tal.

### Precondiciones
- Fecha reservada en calendario interno (EP-011-US-003).
- Datos de contacto del equipo de proyecto y del cliente disponibles.
- Reserva registrada en base de datos (timestamp, proyecto, fecha).

### Postcondiciones
- Equipo de proyecto ha recibido notificación de fecha reservada confirmada.
- Cliente ha recibido notificación de fecha reservada confirmada.
- Reserva registrada con todos los datos necesarios para trazabilidad.
- Proceso EP-011 completado; fecha disponible para EP-015 (preparación de bodas) o flujos corporativos.

### Flujo principal
1. Sistema recibe confirmación de reserva efectuada (EP-011-US-003).
2. Sistema prepara notificación para equipo de proyecto (fecha reservada, proyecto, cliente).
3. Sistema envía notificación al equipo de proyecto (email y/o canal configurado).
4. Sistema prepara notificación para cliente (fecha reservada confirmada).
5. Sistema envía notificación al cliente.
6. Sistema asegura que el registro de la reserva incluye timestamp, proyecto_id, fecha, estado y resultado de sincronización Google Calendar.
7. Proceso de reserva automática de fechas finalizado.

### Flujos alternos y excepciones

**Excepción 1: Fallo en envío de notificación a equipo**
- Sistema reintenta según política; si persiste, registra incidencia y notifica a administración para aviso manual.

**Excepción 2: Fallo en envío de notificación a cliente**
- Sistema reintenta; si persiste, registra incidencia y notifica a administración para reenviar o contactar al cliente.

**Excepción 3: Cliente sin email válido**
- Notificación solo a equipo; sistema registra que el cliente no recibió notificación y alerta a administración.

### Validaciones y reglas de negocio
- El registro de la reserva debe incluir al menos: timestamp, proyecto_id, fecha reservada, estado (Reservada), resultado de sincronización con Google Calendar (éxito/fallo).
- Las notificaciones se envían tras confirmar que la reserva está registrada.

### Criterios BDD
- **Escenario 1: Notificaciones enviadas correctamente**
  - *Dado* que la fecha ha sido reservada correctamente
  - *Cuando* el sistema envía las notificaciones
  - *Entonces* el equipo recibe notificación de fecha reservada confirmada y el cliente recibe notificación de fecha reservada confirmada

- **Escenario 2: Registro completo de la reserva**
  - *Dado* que se ha completado la reserva
  - *Cuando* se consulta el registro de la reserva del proyecto
  - *Entonces* se muestra timestamp, fecha reservada, estado y resultado de sincronización con Google Calendar

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-011-reserva-automatica-fechas.md`
- Paso(s): Pasos 6–7 del flujo principal (notificaciones y registro de la reserva).
