# EP-026-US-003 — Búsqueda avanzada por disco, proyecto, fecha

### Epic padre
EP-026 — Registro de ubicación en discos físicos

### Contexto/Descripción y valor
**Como** equipo o administración, **quiero** buscar archivos por disco físico, proyecto/boda o fecha, **para** localizar rápidamente dónde está cada archivo.

### Alcance
**Incluye:** Búsqueda por disco; búsqueda por proyecto/boda; búsqueda por fecha; listado de resultados con ubicación. **Excluye:** Registro (EP-026-US-001, EP-026-US-002); vista discos (EP-026-US-004).

### Precondiciones
- Trazabilidad registrada (EP-026-US-002); usuario con acceso a búsqueda.

### Postcondiciones
- Usuario ve resultados con ubicación (disco, proyecto, fecha).

### Flujo principal
1. Usuario accede a búsqueda avanzada.
2. Usuario filtra por disco, proyecto/boda o fecha.
3. Sistema muestra proyectos/archivos que coinciden con ubicación registrada (EP-026-US-002).

### Criterios BDD
- *Dado* que hay trazabilidad registrada  
- *Cuando* busco por disco, proyecto o fecha  
- *Entonces* veo los proyectos/archivos que coinciden con su ubicación

### Trazabilidad
- TO-BE-026.
