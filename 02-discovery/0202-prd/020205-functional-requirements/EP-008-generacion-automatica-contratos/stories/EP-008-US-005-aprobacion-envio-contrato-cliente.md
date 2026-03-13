# EP-008-US-005 — Aprobación y envío del contrato al cliente

### Epic padre
EP-008 — Generación automática de contratos

### Contexto/Descripción y valor
**Como** Fátima/Paz,  
**quiero** aprobar el contrato (marcándolo como Aprobado) y enviarlo al cliente por acción explícita,  
**para** que el contrato quede listo para firma digital (EP-009) sin enviarse nunca sin revisión.

### Alcance
**Incluye:**
- Contrato ya en estado "Aprobado" (tras EP-008-US-004); solo entonces la acción de envío está disponible.
- Envío del contrato al cliente por acción explícita de Fátima/Paz (no automático): email y/o portal.
- Registro del envío (fecha, destinatario, canal) para trazabilidad.
- Cambio de estado del contrato a "Enviado" (opcional, según modelo de estados).
- Contrato listo para firma digital (EP-009): cliente recibe documento para firmar.

**Excluye:**
- Generación, personalización y revisión del contrato (EP-008-US-001 a EP-008-US-004).
- Gestión de firmas digitales (EP-009).

### Precondiciones
- Contrato en estado "Aprobado" (EP-008-US-004).
- Datos de contacto del cliente disponibles (email y/o acceso al portal).
- Fátima/Paz tiene permisos para enviar contratos según línea de negocio.

### Postcondiciones
- Cliente ha recibido el contrato (email o portal).
- Envío registrado con fecha y canal.
- Contrato disponible para proceso de firma digital (EP-009).

### Flujo principal
1. Fátima/Paz accede al contrato en estado "Aprobado" (listo para enviar).
2. Sistema muestra la acción "Enviar contrato al cliente" (habilitada solo si estado = Aprobado).
3. Fátima/Paz selecciona canal de envío (email y/o notificación en portal) y confirma.
4. Sistema envía el contrato por email y/o lo publica en el portal del cliente con notificación.
5. Sistema registra el envío (fecha, hora, canal, destinatario).
6. Sistema actualiza el estado del contrato a "Enviado" si aplica.
7. Contrato queda disponible para EP-009 (firma digital por el cliente).

### Flujos alternos y excepciones

**Excepción 1: Email inválido o fallo de envío**
- Si el email falla o no hay email válido:
- Sistema no marca como enviado, muestra error y permite indicar otro email o usar solo portal.

**Excepción 2: Envío solo por portal**
- Si el cliente solo usa el portal:
- Sistema publica el contrato en el portal y envía notificación "Tiene un contrato pendiente de firma"; registra envío por canal portal.

### Validaciones y reglas de negocio
- Solo se puede enviar un contrato en estado "Aprobado".
- El envío es siempre por acción explícita; nunca automático tras aprobación.
- Al menos un canal válido (email con dirección válida o portal con cliente identificado).

### Criterios BDD
- **Escenario 1: Envío por email**
  - *Dado* que un contrato está Aprobado y el cliente tiene email válido
  - *Cuando* Fátima envía el contrato al cliente por email
  - *Entonces* el sistema envía el email con el contrato, registra fecha/canal y deja el contrato listo para firma (EP-009)

- **Escenario 2 (negativo): Envío sin aprobar**
  - *Dado* que un contrato está en "Pendiente de revisión"
  - *Cuando* el usuario intenta enviar el contrato al cliente
  - *Entonces* el sistema no permite el envío y muestra que debe aprobarse antes

### Notificaciones
- **Cliente:** Recibe email y/o notificación en portal con el contrato y mensaje para proceder a la firma (EP-009).

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-008-generacion-automatica-contratos.md`
- Paso(s): Pasos 8–9 del flujo principal (aprobación ya en US-004; envío al cliente aquí).
