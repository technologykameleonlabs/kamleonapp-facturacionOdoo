# EP-019-US-004 — Registro de fecha de entrega

### Epic padre
EP-019 — Entrega de material para revisión

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** registrar la fecha de entrega cuando el material se publica en el portal, **para** trazabilidad y plazos de comentarios (EP-020).

### Alcance
**Incluye:** Registro de timestamp/fecha de entrega al publicar material; vinculación al proyecto y al material. **Excluye:** Publicación (EP-019-US-001); notificación (EP-019-US-003).

### Precondiciones
- Material publicado en portal (EP-019-US-001).

### Postcondiciones
- Fecha de entrega registrada; disponible para plazos de comentarios (EP-020) y reportes.

### Flujo principal
1. Sistema detecta publicación de material en portal (EP-019-US-001).
2. Sistema registra fecha de entrega (timestamp) vinculada al proyecto y al material.
3. Dato disponible para EP-020 (plazos de comentarios) y reportes.

### Criterios BDD
- *Dado* que el material se ha publicado  
- *Cuando* el sistema registra la entrega  
- *Entonces* la fecha de entrega queda registrada

### Trazabilidad
- TO-BE-019.
