# EP-020-US-006 — Registro estructurado de comentarios

### Epic padre
EP-020 — Gestión de comentarios y modificaciones

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** mantener un registro estructurado de todos los comentarios (cliente, responsable, timestamp, minuto si aplica), **para** trazabilidad y reportes.

### Alcance
**Incluye:** Estructura de datos: autor (cliente/responsable), contenido, timestamp, proyecto_id, material/minuto, ronda. **Excluye:** Registro inicial (EP-020-US-002); notificación (EP-020-US-004).

### Precondiciones
- Comentarios registrados (EP-020-US-002).

### Postcondiciones
- Historial de comentarios disponible para consulta, reportes y EP-021.

### Flujo principal
1. Sistema mantiene cada comentario en registro estructurado (autor, contenido, timestamp, proyecto_id, material/minuto, ronda).
2. Consultas y reportes pueden usar el registro; EP-021 puede leer comentarios para incorporación.

### Criterios BDD
- *Dado* que hay comentarios registrados  
- *Cuando* se consulta el historial  
- *Entonces* se muestra autor, contenido, timestamp, material/minuto y ronda

### Trazabilidad
- TO-BE-020.
