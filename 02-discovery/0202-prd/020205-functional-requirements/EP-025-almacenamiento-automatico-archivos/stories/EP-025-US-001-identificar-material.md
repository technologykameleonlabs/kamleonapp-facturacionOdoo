# EP-025-US-001 — Identificación de material para archivar

### Epic padre
EP-025 — Almacenamiento automático de archivos

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** identificar el material para archivar (en bruto, final, documentos del proyecto) cuando el proyecto está cerrado o el material está listo, **para** iniciar la subida automática.

### Alcance
**Incluye:** Detección de proyecto cerrado (EP-024) o material listo; identificación de material en bruto, final y documentos; disparo para subida (EP-025-US-002). **Excluye:** Subida (EP-025-US-002); nombrado (EP-025-US-003).

### Precondiciones
- Proyecto cerrado (EP-024) o material listo para archivo; material disponible.

### Postcondiciones
- Material identificado; lista de archivos lista para subida (EP-025-US-002).

### Flujo principal
1. Sistema detecta proyecto cerrado (EP-024) o material listo.
2. Sistema identifica material en bruto, final y documentos.
3. Sistema dispara subida automática (EP-025-US-002).

### Criterios BDD
- *Dado* que el proyecto está cerrado o el material está listo  
- *Cuando* el sistema identifica el material  
- *Entonces* se genera la lista de archivos para subir

### Trazabilidad
- TO-BE-025.
