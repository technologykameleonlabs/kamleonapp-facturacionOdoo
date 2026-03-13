# EP-013-US-005 — Revisión de gastos por CEO en dashboard

### Epic padre
EP-013 — Gestión de recursos de producción

### Contexto/Descripción y valor
**Como** CEO, **quiero** revisar los gastos del proyecto en el dashboard (gastos por tipo, total, comparación con presupuesto), **para** análisis de rentabilidad y toma de decisiones.

### Alcance
**Incluye:** Dashboard con gastos por tipo; total del proyecto; comparación con presupuesto; análisis de rentabilidad (enlace a EP-014). **Excluye:** Registro de gastos (EP-013-US-001, EP-013-US-002); cálculo (EP-013-US-003).

### Precondiciones
- Gastos calculados (EP-013-US-003); usuario con rol CEO.

### Postcondiciones
- CEO puede ver gastos por tipo, total y comparación con presupuesto.

### Flujo principal
1. CEO accede al dashboard de rentabilidad o al dashboard del proyecto.
2. Sistema muestra gastos por tipo de recurso, total del proyecto y comparación con presupuesto.
3. CEO puede analizar y tomar decisiones; puede profundizar en EP-014 para rentabilidad completa.

### Criterios BDD
- *Dado* que soy CEO y hay gastos registrados  
- *Cuando* accedo al dashboard  
- *Entonces* veo gastos por tipo, total y comparación con presupuesto

### Trazabilidad
- TO-BE-013, paso 8.
