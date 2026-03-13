# EP-023-US-004 — Recordatorios automáticos si no se completa feedback

### Epic padre
EP-023 — Solicitud automática de feedback

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** enviar recordatorios automáticos al cliente si no completa el feedback en tiempo razonable, **para** aumentar la tasa de respuesta.

### Alcance
**Incluye:** Evaluación de estado (EP-023-US-003); envío de recordatorio (email y/o portal) tras días configurados; número máximo de recordatorios configurable. **Excluye:** Solicitud inicial (EP-023-US-001); registro (EP-023-US-005).

### Precondiciones
- Feedback pendiente (EP-023-US-003); han pasado X días desde solicitud; número de recordatorios por debajo del máximo.

### Postcondiciones
- Cliente ha recibido recordatorio; si completa, estado pasa a "Completado" (EP-023-US-005).

### Flujo principal
1. Sistema evalúa proyectos con feedback pendiente (EP-023-US-003).
2. Si han pasado X días y no se ha alcanzado máximo de recordatorios, sistema envía recordatorio (email y/o portal).
3. Sistema registra envío de recordatorio; repite según política hasta completitud o timeout.

### Criterios BDD
- *Dado* que el feedback está pendiente y han pasado X días  
- *Cuando* el sistema envía recordatorio  
- *Entonces* el cliente recibe recordatorio con enlace a valoración

### Trazabilidad
- TO-BE-023.
