# EP-012-US-003 — Cálculo automático de tiempo total por fase y proyecto

### Epic padre
EP-012 — Registro de tiempo por proyecto

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** calcular automáticamente el tiempo total por fase y el tiempo total del proyecto a partir de los registros guardados,  
**para** tener visibilidad actualizada sin cálculos manuales.

### Alcance
**Incluye:** Suma de registros por fase; suma total del proyecto; actualización al guardar nuevo registro.  
**Excluye:** Comparación con presupuesto (EP-012-US-004); alertas (EP-012-US-005).

### Precondiciones
- Al menos un registro de tiempo guardado para el proyecto (EP-012-US-002).

### Postcondiciones
- Tiempo total por fase y tiempo total del proyecto disponibles para dashboard y comparación.

### Flujo principal
1. Sistema recibe nuevo registro de tiempo o consulta de totales.
2. Sistema suma todos los registros por fase (planificación, rodaje, edición).
3. Sistema calcula tiempo total del proyecto.
4. Sistema expone totales para comparación (EP-012-US-004) y visualización (EP-012-US-005).

### Criterios BDD
- *Dado* que hay registros de tiempo para el proyecto  
- *Cuando* se calculan los totales  
- *Entonces* se muestra tiempo total por fase y tiempo total del proyecto

### Trazabilidad
- TO-BE-012, paso 6.
