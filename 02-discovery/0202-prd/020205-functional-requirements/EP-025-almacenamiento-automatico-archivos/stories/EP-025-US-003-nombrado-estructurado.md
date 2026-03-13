# EP-025-US-003 — Nombrado estructurado automático

### Epic padre
EP-025 — Almacenamiento automático de archivos

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** nombrar los archivos estructuradamente (proyecto/boda, tipo, fecha, versión), **para** evitar errores de nombrado y facilitar búsqueda.

### Alcance
**Incluye:** Nombrado automático según proyecto/boda; formato estructurado (Proyecto/Boda_Tipo_Fecha_Versión). **Excluye:** Subida (EP-025-US-002); organización (EP-025-US-004).

### Precondiciones
- Archivos subidos o en proceso (EP-025-US-002); convención de nombrado definida.

### Postcondiciones
- Archivos con nombre estructurado; organización por carpetas (EP-025-US-004).

### Flujo principal
1. Sistema aplica convención de nombrado a archivos (proyecto/boda, tipo, fecha, versión).
2. Archivos quedan con nombre estructurado; sistema organiza por carpetas (EP-025-US-004).

### Criterios BDD
- *Dado* que hay archivos subidos  
- *Cuando* el sistema aplica el nombrado estructurado  
- *Entonces* los archivos quedan con nombre según convención (proyecto, tipo, fecha, versión)

### Trazabilidad
- TO-BE-025.
