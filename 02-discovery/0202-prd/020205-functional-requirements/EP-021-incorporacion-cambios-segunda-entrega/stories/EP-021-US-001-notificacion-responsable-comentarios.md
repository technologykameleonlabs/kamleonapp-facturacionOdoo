# EP-021-US-001 — Notificación al responsable cuando hay comentarios

### Epic padre
EP-021 — Incorporación de cambios y segunda entrega

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** notificar automáticamente al responsable cuando el cliente hace comentarios (EP-020), **para** que pueda coordinar la incorporación de cambios.

### Alcance
**Incluye:** Detección de comentarios (EP-020); notificación al responsable (email y/o portal). **Excluye:** Incorporación de cambios (EP-021-US-002); publicación segunda entrega (EP-021-US-004).

### Precondiciones
- Comentarios registrados (EP-020); responsable asignado al proyecto.

### Postcondiciones
- Responsable ha recibido notificación de comentarios nuevos.

### Flujo principal
1. Sistema detecta nuevo comentario (EP-020).
2. Sistema notifica al responsable con enlace o resumen de comentarios.
3. Responsable puede coordinar incorporación (EP-021-US-002).

### Criterios BDD
- *Dado* que el cliente ha hecho comentarios  
- *Cuando* el sistema envía la notificación  
- *Entonces* el responsable recibe notificación

### Trazabilidad
- TO-BE-021.
