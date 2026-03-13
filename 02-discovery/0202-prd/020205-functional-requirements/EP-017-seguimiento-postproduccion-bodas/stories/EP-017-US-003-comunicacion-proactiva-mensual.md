# EP-017-US-003 — Comunicación proactiva mensual con progreso

### Epic padre
EP-017 — Seguimiento de postproducción de bodas

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** enviar comunicación proactiva mensual a novios con progreso y estimación de entrega actualizada, **para** reducir expectativas no gestionadas durante el plazo de 4–6 meses.

### Alcance
**Incluye:** Envío mensual de mensaje a novios (email y/o portal) con progreso actual y estimación de entrega; programación automática mensual mientras postproducción esté en curso. **Excluye:** Notificación cuando material listo (EP-017-US-004); actualización de estado (EP-017-US-001).

### Precondiciones
- Proyecto en postproducción (estado no todos "Listo"); novios con email/portal; estimación de entrega calculada.

### Postcondiciones
- Novios reciben mensaje mensual con progreso y estimación.

### Flujo principal
1. Sistema programa envío mensual (mientras haya elementos en edición).
2. Sistema prepara mensaje con estado actual (teaser, película, fotos, álbumes) y estimación de entrega.
3. Sistema envía a novios por email y/o notificación en portal.
4. Se repite cada mes hasta que todo esté listo o se cancele.

### Criterios BDD
- *Dado* que la postproducción está en curso  
- *Cuando* llega el envío mensual programado  
- *Entonces* novios reciben mensaje con progreso y estimación de entrega

### Trazabilidad
- TO-BE-017, paso 6.
