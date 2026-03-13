# EP-027-US-004 — Eliminación programada o archivado definitivo

### Epic padre
EP-027 — Gestión de retención y eliminación

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** ejecutar la eliminación programada (eliminar de nube y/o marcar en disco según política) o archivado definitivo en la fecha calculada, **para** cumplir la política de retención.

### Alcance
**Incluye:** Ejecución en fecha de eliminación (EP-027-US-002); eliminación en nube y/o marcado en disco (EP-026); opción de archivado definitivo según política. **Excluye:** Avisos (EP-027-US-003); registro de eliminación (EP-027-US-005).

### Precondiciones
- Fecha de eliminación alcanzada (EP-027-US-002); política define eliminación o archivado; archivos en nube (EP-025) y/o ubicación disco (EP-026).

### Postcondiciones
- Archivos eliminados de nube y/o marcados en disco según política; o archivado definitivo aplicado; sistema registra eliminación (EP-027-US-005).

### Flujo principal
1. Sistema detecta que la fecha de eliminación ha llegado para uno o más archivos/proyectos.
2. Sistema ejecuta según política: elimina de nube, marca en disco, o aplica archivado definitivo.
3. Sistema dispara registro de eliminación (EP-027-US-005).

### Criterios BDD
- *Dado* que la fecha de eliminación ha llegado  
- *Cuando* el sistema ejecuta la eliminación programada  
- *Entonces* los archivos se eliminan o archivan según política y se registra (EP-027-US-005)

### Trazabilidad
- TO-BE-027.
