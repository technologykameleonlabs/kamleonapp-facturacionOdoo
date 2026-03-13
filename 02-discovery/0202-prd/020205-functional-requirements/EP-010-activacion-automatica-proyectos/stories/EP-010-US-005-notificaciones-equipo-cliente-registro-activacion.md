# EP-010-US-005 — Notificaciones a equipo y cliente y registro de activación

### Epic padre
EP-010 — Activación automática de proyectos

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** notificar automáticamente al equipo de proyecto (proyecto activado, fecha reservada) y al cliente (pago recibido, factura generada, proyecto activado), y registrar la activación con timestamp y datos del pago,  
**para** que todas las partes tengan visibilidad y trazabilidad.

### Alcance
**Incluye:**
- Notificación automática al equipo de proyecto: proyecto activado, fecha reservada, datos del cliente/proyecto relevantes.
- Notificación automática al cliente: pago recibido, factura generada (acceso o adjunto según configuración), proyecto activado.
- Registro en sistema de la activación completa: timestamp, datos del pago, factura generada, fecha reservada, destinatarios de notificaciones.
- Trazabilidad para auditoría y consultas posteriores.

**Excluye:**
- Reserva de fecha (EP-010-US-004).
- Contenido de la factura (generada en EP-010-US-002).
- Recordatorios posteriores (no aplican en este epic).

### Precondiciones
- Proyecto activado (EP-010-US-003).
- Fecha reservada (EP-010-US-004).
- Factura proforma generada y asociada al proyecto.
- Datos de contacto del equipo de proyecto y del cliente disponibles.

### Postcondiciones
- Equipo de proyecto ha recibido notificación de activación y fecha reservada.
- Cliente ha recibido notificación de pago recibido, factura y proyecto activado.
- Registro de activación guardado con timestamp, datos de pago, factura, fecha reservada.
- Proceso EP-010 completado; proyecto listo para EP-012, EP-013, EP-015 según tipo.

### Flujo principal
1. Sistema recibe confirmación de reserva de fecha (EP-010-US-004).
2. Sistema prepara notificación para equipo de proyecto (proyecto activado, fecha reservada, datos cliente/proyecto).
3. Sistema envía notificación al equipo de proyecto (email y/o canal configurado).
4. Sistema prepara notificación para cliente (pago recibido, factura generada — enlace o adjunto —, proyecto activado).
5. Sistema envía notificación al cliente.
6. Sistema registra la activación completa: timestamp, datos del pago, factura generada, fecha reservada, envío de notificaciones.
7. Proceso de activación finalizado.

### Flujos alternos y excepciones

**Excepción 1: Fallo en envío de notificación a equipo**
- Si falla el envío: sistema reintenta según política; si persiste, registra incidencia y notifica a administración para aviso manual.

**Excepción 2: Fallo en envío de notificación a cliente**
- Si falla el envío al cliente: sistema reintenta; si persiste, registra incidencia y notifica a administración para reenviar o contactar al cliente.

**Excepción 3: Cliente sin email válido**
- Si no hay email válido: notificación solo a equipo; sistema registra que cliente no recibió notificación y alerta a administración.

### Validaciones y reglas de negocio
- El registro de activación debe incluir al menos: timestamp, monto y fecha de pago, referencia de factura, fecha reservada.
- Las notificaciones deben enviarse tras reserva de fecha para incluir "fecha reservada" en el mensaje.

### Criterios BDD
- **Escenario 1: Notificaciones enviadas correctamente**
  - *Dado* que el proyecto está activado y la fecha reservada
  - *Cuando* el sistema envía las notificaciones y registra la activación
  - *Entonces* el equipo recibe notificación de proyecto activado y fecha reservada, el cliente recibe notificación de pago recibido y factura, y el sistema guarda el registro de activación con todos los datos

- **Escenario 2: Registro de activación completo**
  - *Dado* que se han enviado las notificaciones
  - *Cuando* se consulta el registro de activación del proyecto
  - *Entonces* se muestra timestamp, datos del pago, factura generada, fecha reservada y estado de envío de notificaciones

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-010-activacion-automatica-proyectos.md`
- Paso(s): Pasos 6–8 del flujo principal (notificaciones y registro de activación).
