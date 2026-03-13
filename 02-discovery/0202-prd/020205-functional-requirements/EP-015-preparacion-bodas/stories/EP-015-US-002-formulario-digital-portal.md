# EP-015-US-002 — Formulario digital en portal (novios completan detalles)

### Epic padre
EP-015 — Preparación de bodas

### Contexto/Descripción y valor
**Como** novio/novia, **quiero** acceder al formulario digital desde el portal de cliente y completar los detalles (ceremonia, horarios, ubicaciones, preferencias), **para** que ONGAKU tenga toda la información para el día de la boda en menos de 15 minutos.

### Alcance
**Incluye:** Formulario estructurado en portal: ceremonia (hora, ubicación), horarios (inicio, ceremonia, fiesta), ubicaciones (domicilio novios, ceremonia, fiesta), preferencias y características especiales; validación; guardado con timestamp y vinculación a boda. **Excluye:** Reunión previa (EP-015-US-004); bloqueo música (EP-015-US-005).

### Precondiciones
- Novios han recibido notificación (EP-015-US-001); acceso al portal de cliente.

### Postcondiciones
- Formulario guardado; datos disponibles para Paz y reunión previa (EP-015-US-004).

### Flujo principal
1. Novios acceden al formulario desde el portal (enlace de EP-015-US-001).
2. Novios completan campos: ceremonia (hora, ubicación), horarios, ubicaciones, preferencias.
3. Sistema valida campos obligatorios.
4. Novios guardan formulario; sistema guarda con timestamp y proyecto_id (boda).

### Criterios BDD
- *Dado* que novios tienen acceso al portal  
- *Cuando* completan y guardan el formulario  
- *Entonces* los datos quedan guardados y vinculados a la boda

### Trazabilidad
- TO-BE-015, pasos 2–4.
