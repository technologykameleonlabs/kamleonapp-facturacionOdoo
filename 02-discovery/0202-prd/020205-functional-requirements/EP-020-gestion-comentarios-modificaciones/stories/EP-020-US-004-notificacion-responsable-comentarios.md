# EP-020-US-004 — Notificación automática al responsable cuando hay comentarios

### Epic padre
EP-020 — Gestión de comentarios y modificaciones

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** notificar automáticamente al responsable del proyecto cuando el cliente hace comentarios, **para** que pueda gestionarlos sin depender del email.

### Alcance
**Incluye:** Detección de nuevo comentario (EP-020-US-002); envío de notificación al responsable (email y/o portal) con resumen o enlace a comentarios. **Excluye:** Registro (EP-020-US-002); gestión por responsable (EP-020-US-005).

### Precondiciones
- Comentario registrado (EP-020-US-002); responsable asignado al proyecto; canal de notificación configurado.

### Postcondiciones
- Responsable ha recibido notificación de que hay comentarios nuevos.

### Flujo principal
1. Sistema detecta nuevo comentario registrado (EP-020-US-002).
2. Sistema prepara notificación para responsable (proyecto, resumen o enlace a comentarios).
3. Sistema envía notificación por email y/o portal.

### Criterios BDD
- *Dado* que el cliente ha hecho un comentario  
- *Cuando* el sistema envía la notificación  
- *Entonces* el responsable recibe notificación con enlace o resumen de comentarios

### Trazabilidad
- TO-BE-020.
