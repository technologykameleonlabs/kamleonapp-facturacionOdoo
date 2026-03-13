# EP-026-US-002 — Sistema registra trazabilidad (proyecto + disco)

### Epic padre
EP-026 — Registro de ubicación en discos físicos

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** registrar la trazabilidad completa (proyecto/boda vinculado a disco físico, ubicación en nube, fecha de archivo), **para** búsqueda y EP-027.

### Alcance
**Incluye:** Registro proyecto_id + disco_id; ubicación en nube; fecha de archivo. **Excluye:** Archivo físico (EP-026-US-001); búsqueda (EP-026-US-003).

### Precondiciones
- Administración ha registrado ubicación (EP-026-US-001).

### Postcondiciones
- Trazabilidad registrada; búsqueda disponible (EP-026-US-003).

### Flujo principal
1. Sistema recibe registro de ubicación (EP-026-US-001).
2. Sistema guarda proyecto_id, disco_id, ubicación nube, fecha de archivo.
3. Datos disponibles para búsqueda (EP-026-US-003) y vista (EP-026-US-004).

### Criterios BDD
- *Dado* que se ha registrado la ubicación  
- *Cuando* el sistema guarda la trazabilidad  
- *Entonces* proyecto queda vinculado a disco físico y fecha de archivo

### Trazabilidad
- TO-BE-026.
