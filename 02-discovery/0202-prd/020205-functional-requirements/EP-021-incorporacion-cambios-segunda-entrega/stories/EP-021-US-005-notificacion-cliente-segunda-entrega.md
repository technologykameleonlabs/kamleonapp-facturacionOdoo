# EP-021-US-005 — Notificación al cliente cuando segunda entrega lista

### Epic padre
EP-021 — Incorporación de cambios y segunda entrega

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** notificar automáticamente al cliente cuando la segunda entrega está publicada (enlace al portal), **para** que sepa que puede revisar y aceptar.

### Alcance
**Incluye:** Detección de publicación segunda entrega (EP-021-US-004); notificación al cliente (email y/o portal) con enlace al portal. **Excluye:** Publicación (EP-021-US-004); aceptación (EP-021-US-006).

### Precondiciones
- Segunda entrega publicada (EP-021-US-004); cliente con canal de notificación.

### Postcondiciones
- Cliente ha recibido notificación con enlace al portal; puede aceptar (EP-021-US-006).

### Flujo principal
1. Sistema detecta publicación de segunda entrega (EP-021-US-004).
2. Sistema prepara notificación para cliente (segunda entrega disponible, enlace al portal).
3. Sistema envía notificación por email y/o portal.

### Criterios BDD
- *Dado* que la segunda entrega está publicada  
- *Cuando* el sistema envía la notificación  
- *Entonces* el cliente recibe notificación con enlace al portal

### Trazabilidad
- TO-BE-021.
