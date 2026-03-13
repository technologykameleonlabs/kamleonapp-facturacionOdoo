# EP-025-US-004 — Organización automática por carpetas

### Epic padre
EP-025 — Almacenamiento automático de archivos

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** organizar automáticamente los archivos por carpetas (PROYECTOS/BODAS, BRUTOS, DRON, FINALES), **para** estructura clara y EP-026.

### Alcance
**Incluye:** Carpetas PROYECTOS/BODAS; BRUTOS, DRON, FINALES por proyecto. **Excluye:** Subida (EP-025-US-002); registro fecha (EP-025-US-005).

### Precondiciones
- Archivos subidos y nombrados (EP-025-US-002, EP-025-US-003).

### Postcondiciones
- Archivos organizados por carpetas; registro fecha (EP-025-US-005) y notificación (EP-025-US-006).

### Flujo principal
1. Sistema organiza archivos en PROYECTOS/BODAS, BRUTOS, DRON, FINALES.
2. Sistema registra fecha (EP-025-US-005) y notifica (EP-025-US-006).

### Criterios BDD
- *Dado* que hay archivos subidos y nombrados  
- *Cuando* el sistema organiza por carpetas  
- *Entonces* los archivos quedan en BRUTOS, DRON, FINALES según tipo

### Trazabilidad
- TO-BE-025.
