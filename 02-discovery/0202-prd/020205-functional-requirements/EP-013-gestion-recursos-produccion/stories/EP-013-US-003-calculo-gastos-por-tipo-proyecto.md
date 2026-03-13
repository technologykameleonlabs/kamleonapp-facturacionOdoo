# EP-013-US-003 — Cálculo automático de total de gastos por tipo y proyecto

### Epic padre
EP-013 — Gestión de recursos de producción

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** calcular automáticamente el total de gastos por tipo de recurso y el total del proyecto a partir de los registros guardados, **para** tener visibilidad actualizada sin cálculos manuales.

### Alcance
**Incluye:** Suma de gastos por tipo; suma total del proyecto; actualización al guardar nuevo registro. **Excluye:** Integración con rentabilidad (EP-013-US-004); revisión CEO (EP-013-US-005).

### Precondiciones
- Al menos un registro de recurso/gasto guardado (EP-013-US-002).

### Postcondiciones
- Total por tipo y total del proyecto disponibles para EP-014 y dashboard CEO.

### Flujo principal
1. Sistema recibe nuevo registro o consulta de totales.
2. Sistema suma todos los gastos por tipo de recurso.
3. Sistema calcula total de gastos del proyecto.
4. Sistema expone totales para EP-014 y dashboard (EP-013-US-005).

### Criterios BDD
- *Dado* que hay registros de gastos para el proyecto  
- *Cuando* se calculan los totales  
- *Entonces* se muestra total por tipo y total del proyecto

### Trazabilidad
- TO-BE-013, paso 6.
