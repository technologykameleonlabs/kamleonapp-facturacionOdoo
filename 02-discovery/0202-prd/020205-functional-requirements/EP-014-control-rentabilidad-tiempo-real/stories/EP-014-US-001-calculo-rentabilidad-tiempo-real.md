# EP-014-US-001 — Cálculo automático de rentabilidad en tiempo real

### Epic padre
EP-014 — Control de rentabilidad en tiempo real

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** calcular automáticamente la rentabilidad en tiempo real (ingresos previstos del presupuesto, gastos actuales de EP-013, tiempo empleado vs presupuestado de EP-012, rentabilidad = ingresos - gastos), **para** tener datos siempre actualizados.

### Alcance
**Incluye:** Obtención de ingresos previstos del presupuesto; obtención de gastos actuales (EP-013); obtención de tiempo empleado vs presupuestado (EP-012); cálculo rentabilidad = ingresos - gastos. **Excluye:** Visualización (EP-014-US-002); alertas (EP-014-US-004, EP-014-US-005).

### Precondiciones
- Proyecto activado (EP-010); ingresos previstos definidos en presupuesto; tiempo y/o gastos registrados (EP-012, EP-013).

### Postcondiciones
- Rentabilidad actual calculada y disponible para dashboard y alertas.

### Flujo principal
1. Sistema obtiene ingresos previstos del presupuesto del proyecto.
2. Sistema obtiene gastos actuales (EP-013).
3. Sistema obtiene tiempo empleado vs presupuestado (EP-012).
4. Sistema calcula rentabilidad actual = ingresos previstos - gastos actuales.
5. Sistema expone resultado para visualización (EP-014-US-002) y evaluación de umbral (EP-014-US-004).

### Criterios BDD
- *Dado* que hay ingresos previstos, gastos y tiempo registrados  
- *Cuando* se calcula la rentabilidad  
- *Entonces* se obtiene rentabilidad actual = ingresos - gastos

### Trazabilidad
- TO-BE-014, pasos 1–4.
