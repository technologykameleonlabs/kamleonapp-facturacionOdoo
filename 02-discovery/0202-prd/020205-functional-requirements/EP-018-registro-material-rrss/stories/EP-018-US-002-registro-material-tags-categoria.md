# EP-018-US-002 — Registro de material con tags y categorización

### Epic padre
EP-018 — Registro de material RRSS

### Contexto/Descripción y valor
**Como** responsable o equipo, **quiero** registrar el material seleccionado añadiendo tags (sector, tipo, tema) y categorización (corporativo, boda, behind the scenes, etc.) y descripción opcional, **para** que quede organizado y localizable en menos de 2 minutos.

### Alcance
**Incluye:** Selección de material (vídeo, foto, clip); añadir tags (sector, tipo, tema) predefinidos o nuevos; categorizar (corporativo, boda, behind the scenes, etc.); descripción opcional; guardado con timestamp y proyecto_id. **Excluye:** Organización por sistema (EP-018-US-003); búsqueda marketing (EP-018-US-004).

### Precondiciones
- Material identificado (EP-018-US-001); acceso al formulario de registro de material RRSS.

### Postcondiciones
- Material registrado con tags y categoría; sistema organiza (EP-018-US-003); disponible para búsqueda (EP-018-US-004).

### Flujo principal
1. Usuario selecciona material (vídeo, foto, clip) a registrar.
2. Usuario añade tags (sector, tipo, tema); categoría (corporativo, boda, behind the scenes, etc.); descripción opcional.
3. Usuario guarda registro; sistema guarda con timestamp y proyecto_id.
4. Sistema organiza material (EP-018-US-003).

### Criterios BDD
- *Dado* que tengo material identificado  
- *Cuando* registro con tags y categoría y guardo  
- *Entonces* el material queda registrado y organizado para búsqueda

### Trazabilidad
- TO-BE-018, pasos 2–6.
