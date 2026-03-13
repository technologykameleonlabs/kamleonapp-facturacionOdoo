# EP-012-US-004 — Comparación automática con tiempo presupuestado

### Epic padre
EP-012 — Registro de tiempo por proyecto

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** comparar automáticamente el tiempo real registrado con el tiempo presupuestado y mostrar la diferencia (positiva o negativa),  
**para** que el responsable y el CEO vean si el proyecto va dentro de margen.

### Alcance
**Incluye:** Obtención de tiempo presupuestado del presupuesto; comparación tiempo real vs presupuestado; diferencia (positiva o negativa); visualización en dashboard.  
**Excluye:** Alertas y notificación a CEO (EP-012-US-005).

### Precondiciones
- Tiempo total del proyecto calculado (EP-012-US-003); tiempo presupuestado definido en presupuesto (si no hay, solo se muestra tiempo real).

### Postcondiciones
- Diferencia visible; datos listos para alertas si se supera umbral (EP-012-US-005).

### Flujo principal
1. Sistema obtiene tiempo presupuestado del presupuesto del proyecto.
2. Sistema compara tiempo real (EP-012-US-003) con tiempo presupuestado.
3. Sistema calcula diferencia (real - presupuestado).
4. Sistema muestra comparación y diferencia en dashboard.

### Criterios BDD
- *Dado* que hay tiempo real y tiempo presupuestado  
- *Cuando* se consulta la comparación  
- *Entonces* se muestra tiempo real, tiempo presupuestado y diferencia

### Trazabilidad
- TO-BE-012, paso 7.
