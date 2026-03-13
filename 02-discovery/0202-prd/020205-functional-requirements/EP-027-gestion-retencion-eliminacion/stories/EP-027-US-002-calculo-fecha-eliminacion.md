# EP-027-US-002 — Cálculo automático de fecha de eliminación

### Epic padre
EP-027 — Gestión de retención y eliminación

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** calcular automáticamente la fecha de eliminación de cada archivo/proyecto a partir de la fecha de subida (EP-025) y la política de retención, **para** aplicar la política sin intervención manual.

### Alcance
**Incluye:** Uso de fecha de subida (EP-025); aplicación de política configurada (EP-027-US-001); registro de fecha de eliminación calculada. **Excluye:** Avisos (EP-027-US-003); eliminación (EP-027-US-004).

### Precondiciones
- Archivos/proyectos con fecha de subida registrada (EP-025); política de retención configurada (EP-027-US-001).

### Postcondiciones
- Cada archivo/proyecto tiene fecha de eliminación calculada; disponible para avisos (EP-027-US-003) y eliminación (EP-027-US-004).

### Flujo principal
1. Sistema obtiene fecha de subida por archivo/proyecto (EP-025).
2. Sistema aplica política de retención (EP-027-US-001) y calcula fecha de eliminación.
3. Sistema registra fecha de eliminación; dispara avisos y eliminación cuando corresponda.

### Criterios BDD
- *Dado* que hay archivos con fecha de subida y política de retención  
- *Cuando* el sistema calcula la fecha de eliminación  
- *Entonces* cada archivo/proyecto tiene una fecha de eliminación registrada

### Trazabilidad
- TO-BE-027.
