# EP-014-US-003 — Indicador de rentabilidad y progreso del proyecto

### Epic padre
EP-014 — Control de rentabilidad en tiempo real

### Contexto/Descripción y valor
**Como** CEO o responsable, **quiero** ver un indicador de rentabilidad (positiva/negativa) y el progreso del proyecto en el dashboard, **para** evaluar rápidamente el estado.

### Alcance
**Incluye:** Indicador visual de rentabilidad (positiva/negativa); progreso del proyecto; métricas de éxito visibles. **Excluye:** Gráfico detallado (EP-014-US-002); alertas (EP-014-US-004).

### Precondiciones
- Rentabilidad calculada (EP-014-US-001); usuario con acceso al dashboard.

### Postcondiciones
- Usuario ve indicador de rentabilidad y progreso.

### Flujo principal
1. Usuario accede al dashboard del proyecto o de rentabilidad.
2. Sistema muestra indicador de rentabilidad (positiva/negativa) y progreso del proyecto.
3. Usuario puede evaluar estado de un vistazo.

### Criterios BDD
- *Dado* que hay rentabilidad calculada  
- *Cuando* se visualiza el proyecto  
- *Entonces* se muestra indicador de rentabilidad y progreso

### Trazabilidad
- TO-BE-014, paso 5.
