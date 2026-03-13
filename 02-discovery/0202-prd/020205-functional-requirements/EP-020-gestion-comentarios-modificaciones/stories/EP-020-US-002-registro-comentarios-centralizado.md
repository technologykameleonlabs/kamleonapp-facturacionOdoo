# EP-020-US-002 — Sistema registra comentarios centralizadamente

### Epic padre
EP-020 — Gestión de comentarios y modificaciones

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** registrar todos los comentarios del cliente centralizadamente con timestamp y vinculación al material/minuto, **para** trazabilidad y EP-021.

### Alcance
**Incluye:** Registro de comentarios con timestamp, proyecto_id, material/minuto, autor. **Excluye:** Control límites (EP-020-US-003); notificación (EP-020-US-004).

### Precondiciones
- Cliente ha enviado comentario (EP-020-US-001).

### Postcondiciones
- Comentario registrado; disponible para responsable (EP-020-US-005) y EP-021; sistema evalúa límites (EP-020-US-003).

### Flujo principal
1. Sistema recibe comentario del cliente (EP-020-US-001).
2. Sistema registra comentario con timestamp, proyecto_id, material/minuto, autor.
3. Sistema dispara notificación al responsable (EP-020-US-004) y evalúa límites (EP-020-US-003).

### Criterios BDD
- *Dado* que el cliente ha hecho un comentario  
- *Cuando* el sistema registra  
- *Entonces* el comentario queda con timestamp y vinculación al material/minuto

### Trazabilidad
- TO-BE-020.
