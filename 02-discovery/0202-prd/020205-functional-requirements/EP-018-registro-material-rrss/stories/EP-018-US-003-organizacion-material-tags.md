# EP-018-US-003 — Sistema organiza material con tags y categorías

### Epic padre
EP-018 — Registro de material RRSS

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** organizar el material registrado con tags y categorías para búsqueda y disponibilidad para RRSS antes de entrega final, **para** que el equipo de marketing pueda localizarlo fácilmente.

### Alcance
**Incluye:** Indexación del material por tags y categorías; material disponible para búsqueda; organización automática. **Excluye:** Registro por usuario (EP-018-US-002); acceso por marketing (EP-018-US-004).

### Precondiciones
- Al menos un registro de material guardado (EP-018-US-002).

### Postcondiciones
- Material indexado por tags y categorías; búsqueda disponible (EP-018-US-004).

### Flujo principal
1. Sistema recibe nuevo registro de material (EP-018-US-002).
2. Sistema indexa material por tags y categorías.
3. Material queda disponible para búsqueda por equipo de marketing (EP-018-US-004).

### Criterios BDD
- *Dado* que hay material registrado con tags y categoría  
- *Cuando* el sistema organiza  
- *Entonces* el material queda disponible para búsqueda por tags y categorías

### Trazabilidad
- TO-BE-018, paso 7.
