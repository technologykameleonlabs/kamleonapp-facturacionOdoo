# EP-023-US-001 — Solicitud automática de feedback tras aceptación segunda entrega

### Epic padre
EP-023 — Solicitud automática de feedback

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** enviar automáticamente solicitud de feedback al cliente cuando acepta la segunda entrega (EP-021), **para** que el cliente pueda valorar el servicio.

### Alcance
**Incluye:** Detección de aceptación segunda entrega (EP-021); envío automático de solicitud de feedback (email y/o portal) con enlace a formulario o valoración. **Excluye:** Enlace a Google (EP-023-US-002); seguimiento (EP-023-US-003).

### Precondiciones
- Segunda entrega aceptada por cliente (EP-021); cliente con canal de notificación.

### Postcondiciones
- Cliente ha recibido solicitud de feedback con enlace; sistema inicia seguimiento (EP-023-US-003).

### Flujo principal
1. Sistema detecta aceptación de segunda entrega (EP-021-US-006).
2. Sistema prepara solicitud de feedback (enlace a formulario o portal de valoración, integración Google si aplica).
3. Sistema envía solicitud por email y/o portal.

### Criterios BDD
- *Dado* que el cliente ha aceptado la segunda entrega  
- *Cuando* el sistema envía la solicitud de feedback  
- *Entonces* el cliente recibe solicitud con enlace a valoración

### Trazabilidad
- TO-BE-023.
