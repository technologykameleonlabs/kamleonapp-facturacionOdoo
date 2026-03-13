# EP-027-US-003 — Avisos antes de la fecha de eliminación

### Epic padre
EP-027 — Gestión de retención y eliminación

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** enviar avisos automáticos a administración antes de la fecha de eliminación (ej. 30 días antes), **para** que puedan revisar o posponer si aplica.

### Alcance
**Incluye:** Configuración de antelación (ej. 30 días); envío de aviso con listado de archivos/proyectos a eliminar y fecha; canal de notificación. **Excluye:** Eliminación (EP-027-US-004); registro eliminación (EP-027-US-005).

### Precondiciones
- Fecha de eliminación calculada (EP-027-US-002); antelación configurada; administración con canal de notificación.

### Postcondiciones
- Administración ha recibido aviso con listado y fecha de eliminación; puede posponer o aprobar (si el flujo lo permite).

### Flujo principal
1. Sistema identifica archivos/proyectos cuya fecha de eliminación está a X días (ej. 30).
2. Sistema genera listado y envía notificación a administración.
3. Administración recibe aviso; puede actuar antes de la fecha (posponer o dejar que se ejecute EP-027-US-004).

### Criterios BDD
- *Dado* que hay archivos con fecha de eliminación en 30 días  
- *Cuando* el sistema envía el aviso  
- *Entonces* administración recibe notificación con listado y fecha

### Trazabilidad
- TO-BE-027.
