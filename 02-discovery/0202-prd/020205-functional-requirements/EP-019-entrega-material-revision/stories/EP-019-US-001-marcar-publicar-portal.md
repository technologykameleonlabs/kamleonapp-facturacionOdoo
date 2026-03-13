# EP-019-US-001 — Marcar material listo para entrega y publicar en portal

### Epic padre
EP-019 — Entrega de material para revisión

### Contexto/Descripción y valor
**Como** responsable o equipo de postproducción, **quiero** marcar el material como "Listo para entrega" y publicarlo en el portal de cliente, **para** que el cliente pueda verlo sin salir de página.

### Alcance
**Incluye:** Marcar material como listo para entrega; publicar en portal de cliente; material visible para cliente. **Excluye:** Visualización integrada (EP-019-US-002); notificación (EP-019-US-003).

### Precondiciones
- Material editado/postproducido listo; usuario es responsable o equipo de postproducción; portal de cliente disponible.

### Postcondiciones
- Material publicado en portal; cliente puede acceder (EP-019-US-005); sistema notifica (EP-019-US-003) y registra fecha (EP-019-US-004).

### Flujo principal
1. Usuario marca material como "Listo para entrega".
2. Sistema publica material en portal de cliente (visualización integrada).
3. Material queda visible para cliente; sistema dispara notificación y registro de fecha.

### Criterios BDD
- *Dado* que el material está listo para entrega  
- *Cuando* lo marco y publico en el portal  
- *Entonces* el material queda publicado y visible para el cliente

### Trazabilidad
- TO-BE-019.
