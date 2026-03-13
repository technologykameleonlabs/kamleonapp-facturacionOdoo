# EP-025-US-006 — Notificación al equipo y administración

### Epic padre
EP-025 — Almacenamiento automático de archivos

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** notificar automáticamente al equipo y a administración cuando los archivos están archivados en la nube, **para** que sepan que el material está disponible.

### Alcance
**Incluye:** Detección de archivado completo (EP-025-US-004, EP-025-US-005); notificación al equipo (archivos archivados); notificación a administración (archivos disponibles). **Excluye:** Subida (EP-025-US-002); EP-026 (ubicación discos).

### Precondiciones
- Archivos archivados en nube (EP-025-US-004); fecha registrada (EP-025-US-005); equipo y administración con canal de notificación.

### Postcondiciones
- Equipo y administración han recibido notificación de que archivos están archivados.

### Flujo principal
1. Sistema detecta que archivado está completo (EP-025-US-004, EP-025-US-005).
2. Sistema notifica al equipo (archivos archivados).
3. Sistema notifica a administración (archivos disponibles para EP-026 si aplica).

### Criterios BDD
- *Dado* que los archivos están archivados en la nube  
- *Cuando* el sistema envía las notificaciones  
- *Entonces* equipo y administración reciben notificación de archivos archivados

### Trazabilidad
- TO-BE-025.
