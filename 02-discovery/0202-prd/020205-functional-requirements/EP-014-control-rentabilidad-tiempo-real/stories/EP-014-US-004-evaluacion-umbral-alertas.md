# EP-014-US-004 — Evaluación de umbral y alertas cuando se supera

### Epic padre
EP-014 — Control de rentabilidad en tiempo real

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** evaluar si la rentabilidad o los gastos/tiempo superan un umbral configurable y mostrar alertas visuales en el dashboard, **para** que se detecten desvíos a tiempo.

### Alcance
**Incluye:** Umbral configurable (rentabilidad negativa, gastos superan X, tiempo supera presupuestado); evaluación automática; alerta visual en dashboard. **Excluye:** Notificación a CEO (EP-014-US-005); cálculo (EP-014-US-001).

### Precondiciones
- Rentabilidad calculada (EP-014-US-001); umbral configurado (si aplica).

### Postcondiciones
- Si se supera umbral: alerta visual visible en dashboard; disparo de notificación (EP-014-US-005).

### Flujo principal
1. Sistema evalúa rentabilidad actual y datos de gastos/tiempo (EP-014-US-001).
2. Sistema compara con umbral configurado (rentabilidad negativa, gastos, tiempo).
3. Si se supera umbral: sistema muestra alerta visual en dashboard (destacado, color, icono).
4. Sistema dispara notificación a CEO si aplica (EP-014-US-005).

### Criterios BDD
- *Dado* que la rentabilidad es negativa o se supera el umbral  
- *Cuando* el sistema evalúa  
- *Entonces* se muestra alerta visual en el dashboard

### Trazabilidad
- TO-BE-014, pasos 6–7.
