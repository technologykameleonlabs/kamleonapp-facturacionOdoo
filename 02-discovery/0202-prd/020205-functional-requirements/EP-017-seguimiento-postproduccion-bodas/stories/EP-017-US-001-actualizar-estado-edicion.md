# EP-017-US-001 — Equipo actualiza estado de edición (teaser, película, fotos, álbumes)

### Epic padre
EP-017 — Seguimiento de postproducción de bodas

### Contexto/Descripción y valor
**Como** equipo de postproducción, **quiero** actualizar el estado de edición de cada elemento (teaser, película, fotografías, álbumes) en el sistema (en edición, listo), **para** que novios vean el progreso en el portal.

### Alcance
**Incluye:** Actualización manual del estado por elemento: teaser (en edición / listo), película (en edición / listo), fotografías (en edición / listo), álbumes (en preparación / listo); vinculación al proyecto. **Excluye:** Portal de novios (EP-017-US-002); notificaciones (EP-017-US-004).

### Precondiciones
- Día de boda completado (EP-016); material capturado disponible; usuario es equipo de postproducción o Paz.

### Postcondiciones
- Estado actualizado; portal de novios y estimaciones se actualizan (EP-017-US-002); si "Listo" se dispara notificación (EP-017-US-004).

### Flujo principal
1. Usuario accede al dashboard de postproducción del proyecto (boda).
2. Usuario selecciona elemento (teaser, película, fotografías, álbumes) y actualiza estado (en edición / listo).
3. Sistema guarda estado con timestamp y proyecto_id.
4. Sistema actualiza portal de novios y recalcula estimación de entrega si aplica.

### Criterios BDD
- *Dado* que soy equipo de postproducción  
- *Cuando* actualizo el estado de un elemento  
- *Entonces* el estado queda guardado y visible en el portal de novios

### Trazabilidad
- TO-BE-017, paso 1.
