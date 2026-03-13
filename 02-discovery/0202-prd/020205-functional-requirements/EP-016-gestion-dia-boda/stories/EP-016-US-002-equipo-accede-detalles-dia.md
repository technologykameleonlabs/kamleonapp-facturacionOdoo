# EP-016-US-002 — Equipo accede a detalles del día

### Epic padre
EP-016 — Gestión del día de la boda

### Contexto/Descripción y valor
**Como** miembro del equipo de producción, **quiero** acceder a los detalles del día desde el sistema (horarios, ubicaciones, música bloqueada, detalles especiales), **para** tener toda la información para la cobertura.

### Alcance
**Incluye:** Portal o vista del equipo con horarios (inicio 2.5h antes ceremonia, ceremonia, fiesta, final 60 min después inicio fiesta), ubicaciones (domicilio novios, ceremonia, fiesta), música bloqueada, detalles del formulario. **Excluye:** Asignación (EP-016-US-001); registro de material (EP-016-US-003).

### Precondiciones
- Equipo asignado (EP-016-US-001); preparación completada (EP-015); usuario es miembro del equipo asignado.

### Postcondiciones
- Equipo puede consultar detalles en cualquier momento durante el día.

### Flujo principal
1. Profesional accede al portal del equipo o a la ficha del proyecto (boda).
2. Sistema muestra horarios, ubicaciones, música bloqueada y detalles especiales de la preparación (EP-015).
3. Equipo tiene toda la información para la cobertura.

### Criterios BDD
- *Dado* que soy miembro del equipo asignado  
- *Cuando* accedo a los detalles del día  
- *Entonces* veo horarios, ubicaciones, música bloqueada y detalles especiales

### Trazabilidad
- TO-BE-016, paso 2.
