# EP-023-US-005 — Registro de feedback recibido

### Epic padre
EP-023 — Solicitud automática de feedback

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** registrar el feedback recibido (valoración, comentarios) cuando el cliente lo completa, **para** EP-024 y reportes.

### Alcance
**Incluye:** Registro de valoración (estrellas si aplica), comentarios, timestamp, proyecto_id; estado "Completado"; datos disponibles para EP-024 y equipo comercial. **Excluye:** Solicitud y recordatorios (EP-023-US-001, EP-023-US-004); cierre (EP-024).

### Precondiciones
- Cliente ha completado feedback (EP-023-US-002); datos recibidos por formulario o integración.

### Postcondiciones
- Feedback registrado; estado "Completado"; datos disponibles para cierre (EP-024) y reportes.

### Flujo principal
1. Sistema recibe datos de feedback completado (formulario portal o integración Google).
2. Sistema registra valoración, comentarios, timestamp, proyecto_id; actualiza estado a "Completado" (EP-023-US-003).
3. Datos disponibles para EP-024 (cierre) y para equipo comercial (reportes).

### Criterios BDD
- *Dado* que el cliente ha completado el feedback  
- *Cuando* el sistema registra  
- *Entonces* la valoración y comentarios quedan registrados y el estado pasa a "Completado"

### Trazabilidad
- TO-BE-023.
