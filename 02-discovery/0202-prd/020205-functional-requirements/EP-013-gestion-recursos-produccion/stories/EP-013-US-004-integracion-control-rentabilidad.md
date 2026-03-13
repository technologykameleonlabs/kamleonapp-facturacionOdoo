# EP-013-US-004 — Integración con control de rentabilidad

### Epic padre
EP-013 — Gestión de recursos de producción

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** exponer los gastos registrados al control de rentabilidad (EP-014) para que ingresos vs gastos se calculen en tiempo real, **para** análisis de rentabilidad.

### Alcance
**Incluye:** Exposición de gastos por proyecto a EP-014; actualización en tiempo real cuando se registra nuevo gasto. **Excluye:** Cálculo de rentabilidad y dashboard (EP-014); revisión CEO (EP-013-US-005).

### Precondiciones
- Gastos del proyecto calculados (EP-013-US-003); EP-014 operativo.

### Postcondiciones
- Gastos disponibles para EP-014; rentabilidad se actualiza al registrar gasto.

### Flujo principal
1. Sistema mantiene total de gastos por proyecto actualizado (EP-013-US-003).
2. EP-014 obtiene gastos actuales del proyecto para calcular rentabilidad (ingresos - gastos).
3. Cada nuevo registro de gasto actualiza el total y EP-014 refleja el cambio.

### Criterios BDD
- *Dado* que hay gastos registrados para el proyecto  
- *Cuando* EP-014 consulta los gastos  
- *Entonces* recibe el total actualizado de gastos del proyecto

### Trazabilidad
- TO-BE-013, paso 7.
