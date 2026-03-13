# EP-019-US-003 — Notificación automática al cliente cuando material publicado

### Epic padre
EP-019 — Entrega de material para revisión

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** notificar automáticamente al cliente cuando el material está publicado en el portal (enlace al portal), **para** que sepa que puede revisar.

### Alcance
**Incluye:** Detección de publicación (EP-019-US-001); envío de notificación al cliente (email y/o portal) con enlace al portal. **Excluye:** Publicación (EP-019-US-001); registro fecha (EP-019-US-004).

### Precondiciones
- Material publicado en portal (EP-019-US-001); cliente con email/portal configurado.

### Postcondiciones
- Cliente ha recibido notificación con enlace al portal.

### Flujo principal
1. Sistema detecta que material se ha publicado en portal (EP-019-US-001).
2. Sistema prepara notificación para cliente (material disponible, enlace al portal).
3. Sistema envía notificación por email y/o portal.

### Criterios BDD
- *Dado* que el material se ha publicado  
- *Cuando* el sistema envía la notificación  
- *Entonces* el cliente recibe notificación con enlace al portal

### Trazabilidad
- TO-BE-019.
