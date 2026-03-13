# EP-026-US-004 — Vista de discos físicos con proyectos

### Epic padre
EP-026 — Registro de ubicación en discos físicos

### Contexto/Descripción y valor
**Como** equipo o administración, **quiero** ver una vista de los discos físicos (TABLERO, ALFIL, etc.) con los proyectos archivados en cada uno, **para** tener visibilidad de qué hay en cada disco.

### Alcance
**Incluye:** Vista por disco físico; listado de proyectos/bodas en cada disco. **Excluye:** Registro (EP-026-US-001, EP-026-US-002); búsqueda (EP-026-US-003).

### Precondiciones
- Trazabilidad registrada (EP-026-US-002); usuario con acceso a vista.

### Postcondiciones
- Usuario ve discos físicos y proyectos archivados en cada uno.

### Flujo principal
1. Usuario accede a vista de discos físicos.
2. Sistema muestra lista de discos (TABLERO, ALFIL, etc.) y, por cada disco, los proyectos/bodas archivados (EP-026-US-002).

### Criterios BDD
- *Dado* que hay trazabilidad registrada  
- *Cuando* accedo a la vista de discos  
- *Entonces* veo cada disco con los proyectos archivados en él

### Trazabilidad
- TO-BE-026.
