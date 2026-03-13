# EP-023-US-003 — Seguimiento de completitud de feedback

### Epic padre
EP-023 — Solicitud automática de feedback

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** hacer seguimiento de si el cliente ha completado el feedback (completado o no), **para** saber si enviar recordatorios.

### Alcance
**Incluye:** Estado de feedback (pendiente, completado); consulta o webhook cuando cliente completa; actualización de estado. **Excluye:** Recordatorios (EP-023-US-004); registro (EP-023-US-005).

### Precondiciones
- Solicitud de feedback enviada (EP-023-US-001); proyecto con feedback pendiente o completado.

### Postcondiciones
- Estado de feedback actualizado; si pendiente tras X días se disparan recordatorios (EP-023-US-004).

### Flujo principal
1. Sistema mantiene estado de feedback por proyecto (pendiente/completado).
2. Cuando cliente completa feedback (EP-023-US-002), sistema actualiza estado a "Completado" (EP-023-US-005).
3. Si estado sigue "Pendiente" tras tiempo configurado, sistema dispara recordatorio (EP-023-US-004).

### Criterios BDD
- *Dado* que la solicitud de feedback fue enviada  
- *Cuando* el cliente completa el feedback  
- *Entonces* el estado pasa a "Completado"; si no, tras X días se envía recordatorio

### Trazabilidad
- TO-BE-023.
