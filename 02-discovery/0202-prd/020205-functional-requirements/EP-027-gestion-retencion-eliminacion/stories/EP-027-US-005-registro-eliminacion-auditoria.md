# EP-027-US-005 — Registro de eliminación para auditoría

### Epic padre
EP-027 — Gestión de retención y eliminación

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** registrar qué archivos/proyectos se eliminaron, cuándo y por qué política, **para** auditoría y cumplimiento.

### Alcance
**Incluye:** Registro de identificador archivo/proyecto, fecha de eliminación, política aplicada, resultado (eliminado/archivado). **Excluye:** Eliminación física (EP-027-US-004); avisos (EP-027-US-003).

### Precondiciones
- Eliminación o archivado ejecutado (EP-027-US-004); política conocida.

### Postcondiciones
- Registro de eliminación persistido; consultable para auditoría.

### Flujo principal
1. Sistema recibe confirmación de eliminación/archivado (EP-027-US-004).
2. Sistema registra: archivo/proyecto, fecha, política, resultado.
3. Registro queda disponible para consultas y reportes de auditoría.

### Criterios BDD
- *Dado* que se ha ejecutado una eliminación o archivado  
- *Cuando* el sistema registra la eliminación  
- *Entonces* queda constancia de qué, cuándo y por qué política para auditoría

### Trazabilidad
- TO-BE-027.
