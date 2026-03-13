# EP-007-US-004 — Envío de respuesta al cliente

### Epic padre
EP-007 — Negociación de presupuestos

### Contexto/Descripción y valor
**Como** Fátima/Paz/Javi,  
**quiero** enviar al cliente la respuesta (nueva versión del presupuesto o decisión de rechazo/mantenimiento) con explicación si aplica,  
**para** que el cliente pueda aceptar, rechazar o hacer una nueva contrapropuesta.

### Alcance
**Incluye:**
- Envío de la respuesta al cliente según la decisión tomada (EP-007-US-003):
  - Si se aceptó contrapropuesta o se generó contrapropuesta alternativa: envío de la nueva versión del presupuesto (PDF o enlace a portal).
  - Si se rechazó la contrapropuesta: envío de comunicación indicando que se mantiene la versión original (con o sin adjunto de la versión vigente).
- Campo opcional de mensaje o explicación para el cliente.
- Canal de envío: email y/o notificación en portal de cliente (según configuración).
- Registro de envío (fecha, destinatario, canal) para trazabilidad.
- Uso de plantillas de mensaje si están configuradas (ej. "Hemos actualizado el presupuesto según su solicitud...").

**Excluye:**
- Generación del contenido del presupuesto (EP-006, EP-007-US-003).
- Registro de acuerdo final o rechazo definitivo cuando el cliente responda (EP-007-US-005).

### Precondiciones
- Decisión registrada en EP-007-US-003 (Aceptar, Rechazar o Contrapropuesta alternativa).
- Presupuesto en estado "En negociación".
- Datos de contacto del cliente disponibles (email y/o acceso al portal).
- Usuario tiene permisos para enviar respuestas de negociación según línea de negocio.

### Postcondiciones
- Cliente ha recibido la respuesta (nueva versión o comunicación de rechazo/mantenimiento).
- Envío registrado con fecha, canal y referencia al presupuesto/versión.
- Presupuesto sigue en "En negociación" hasta que el cliente responda (EP-007-US-001 o acuerdo/rechazo en EP-007-US-005).

### Flujo principal
1. Tras tomar la decisión (EP-007-US-003), Fátima/Paz/Javi accede a la acción "Enviar respuesta al cliente".
2. Sistema muestra el resumen de la decisión y el contenido a enviar:
   - Si hay nueva versión: adjunto o enlace al presupuesto actualizado.
   - Si rechazo: texto/mensaje indicando que se mantiene la versión original; opción de adjuntar versión vigente.
3. Usuario puede añadir un mensaje o explicación opcional (o elegir plantilla si existe).
4. Usuario confirma el envío y selecciona canal (email y/o portal).
5. Sistema envía el email y/o publica en el portal la respuesta y el presupuesto si aplica.
6. Sistema registra el envío (fecha, hora, canal, destinatario, versión enviada).
7. Cliente puede entonces aceptar, rechazar o hacer nueva contrapropuesta (vuelta a EP-007-US-001 o cierre en EP-007-US-005).

### Flujos alternos y excepciones

**Flujo alterno 1: Solo notificación en portal**
- Si el cliente solo usa el portal:
- Sistema publica la nueva versión y el mensaje en el portal y registra el envío; opcionalmente envía email de aviso "Tiene una actualización en el presupuesto".

**Excepción 1: Error de envío de email**
- Si el email falla (dirección inválida, error de servidor):
- Sistema muestra error y no marca como enviado; permite reintentar o usar solo portal.

**Excepción 2: Sin datos de contacto**
- Si no hay email ni acceso al portal del cliente:
- Sistema avisa y no permite envío hasta completar datos o elegir otro canal (ej. envío manual registrado).

### Validaciones y reglas de negocio
- Solo se puede enviar respuesta después de haber registrado una decisión (EP-007-US-003).
- Al menos un canal debe ser válido (email con dirección válida o portal con cliente identificado).
- El contenido enviado debe corresponder a la última decisión y versión vigente.

### Criterios BDD
- **Escenario 1: Envío de nueva versión por email**
  - *Dado* que se ha registrado una contrapropuesta alternativa con nueva versión
  - *Cuando* Paz confirma el envío por email con un mensaje opcional
  - *Entonces* el sistema envía el email con la nueva versión adjunta (o enlace), registra fecha/canal y deja el presupuesto en "En negociación"

- **Escenario 2: Envío de rechazo (mantener original)**
  - *Dado* que se ha registrado la decisión "Rechazar y mantener versión original"
  - *Cuando* Fátima envía la respuesta al cliente con explicación
  - *Entonces* el sistema envía la comunicación indicando el mantenimiento de la versión original, registra el envío y mantiene estado "En negociación"

- **Escenario 3 (negativo): Email inválido**
  - *Dado* que el cliente no tiene email válido configurado
  - *Cuando* el usuario intenta enviar solo por email
  - *Entonces* el sistema no envía y muestra que debe indicar un email válido o usar otro canal

### Notificaciones
- **Cliente:** Recibe email y/o notificación en portal con la respuesta (nueva versión o mensaje de rechazo/mantenimiento).

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-007-negociacion-presupuestos.md`
- Paso(s): Paso 6 del flujo principal (Fátima/Paz/Javi envía respuesta al cliente).
