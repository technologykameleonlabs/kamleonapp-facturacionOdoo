# EP-016-US-005 — Registro de incidencias

### Epic padre
EP-016 — Gestión del día de la boda

### Contexto/Descripción y valor
**Como** profesional del equipo o Paz, **quiero** registrar incidencias durante el día de boda, **para** que queden documentadas y se puedan tener en cuenta en postproducción.

### Alcance
**Incluye:** Registro de incidencias (descripción, momento opcional); vinculación al proyecto; visibilidad para Paz y equipo de postproducción. **Excluye:** Registro de material (EP-016-US-003); confirmación final (EP-016-US-006).

### Precondiciones
- Día de boda en curso o finalizado; usuario es profesional asignado o Paz.

### Postcondiciones
- Incidencias registradas y visibles para Paz y postproducción.

### Flujo principal
1. Usuario (profesional o Paz) accede al registro de incidencias del proyecto.
2. Usuario añade incidencia: descripción, momento opcional.
3. Sistema guarda con timestamp y proyecto_id.
4. Incidencias visibles en resumen del día y para EP-016-US-006 (confirmación Paz).

### Criterios BDD
- *Dado* que soy profesional o Paz  
- *Cuando* registro una incidencia  
- *Entonces* queda guardada y visible para el proyecto

### Trazabilidad
- TO-BE-016, paso 7.
