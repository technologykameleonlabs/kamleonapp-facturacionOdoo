# EP-025-US-002 — Subida automática de archivos a nube

### Epic padre
EP-025 — Almacenamiento automático de archivos

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** subir automáticamente los archivos a la nube con progreso visible y validación de integridad, **para** tener el material archivado sin intervención manual.

### Alcance
**Incluye:** Subida automática a nube; progreso visible; validación de integridad. **Excluye:** Nombrado (EP-025-US-003); organización (EP-025-US-004).

### Precondiciones
- Material identificado (EP-025-US-001); nube configurada.

### Postcondiciones
- Archivos subidos a nube; sistema nombra (EP-025-US-003) y organiza (EP-025-US-004).

### Flujo principal
1. Sistema recibe lista de archivos (EP-025-US-001).
2. Sistema sube archivos a nube; muestra progreso; valida integridad.
3. Sistema dispara nombrado (EP-025-US-003) y organización (EP-025-US-004).

### Criterios BDD
- *Dado* que hay material identificado  
- *Cuando* el sistema sube a la nube  
- *Entonces* los archivos quedan subidos con progreso visible

### Trazabilidad
- TO-BE-025.
