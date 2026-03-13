# EP-024-US-004 — Generación de reporte final y notificaciones

### Epic padre
EP-024 — Cierre automático de proyecto

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** generar el reporte final del proyecto y notificar al equipo de proyecto, al cliente y a administración (con reporte final), **para** que todas las partes tengan constancia del cierre.

### Alcance
**Incluye:** Generación de reporte final; notificación al equipo (proyecto cerrado); notificación al cliente (confirmación cierre); notificación a administración (con reporte final). **Excluye:** Cierre efectivo (EP-024-US-002); archivo (EP-024-US-003).

### Precondiciones
- Proyecto cerrado (EP-024-US-002); datos del proyecto disponibles.

### Postcondiciones
- Reporte final generado; equipo, cliente y administración han recibido notificación.

### Flujo principal
1. Sistema genera reporte final del proyecto.
2. Sistema notifica al equipo de proyecto (proyecto cerrado).
3. Sistema notifica al cliente (confirmación de cierre).
4. Sistema notifica a administración (con reporte final adjunto o enlace).

### Criterios BDD
- *Dado* que el proyecto está cerrado  
- *Cuando* el sistema genera el reporte y envía notificaciones  
- *Entonces* equipo, cliente y administración reciben notificación

### Trazabilidad
- TO-BE-024.
