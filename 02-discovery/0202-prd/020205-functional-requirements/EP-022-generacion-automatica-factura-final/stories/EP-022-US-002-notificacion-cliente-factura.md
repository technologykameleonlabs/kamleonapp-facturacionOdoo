# EP-022-US-002 — Notificación al cliente de factura generada

### Epic padre
EP-022 — Generación automática de factura final

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** notificar automáticamente al cliente cuando la factura final está generada (acceso o adjunto según configuración), **para** que sepa que debe realizar el pago.

### Alcance
**Incluye:** Detección de factura generada (EP-022-US-001); notificación al cliente (email y/o portal) con acceso o adjunto a factura. **Excluye:** Generación (EP-022-US-001); registro pago (EP-022-US-003).

### Precondiciones
- Factura final generada (EP-022-US-001); cliente con canal de notificación.

### Postcondiciones
- Cliente ha recibido notificación de factura generada; puede acceder a factura o adjunto.

### Flujo principal
1. Sistema detecta factura generada (EP-022-US-001).
2. Sistema prepara notificación para cliente (factura disponible, acceso o adjunto).
3. Sistema envía notificación por email y/o portal.

### Criterios BDD
- *Dado* que la factura final está generada  
- *Cuando* el sistema envía la notificación  
- *Entonces* el cliente recibe notificación con acceso o adjunto a la factura

### Trazabilidad
- TO-BE-022.
