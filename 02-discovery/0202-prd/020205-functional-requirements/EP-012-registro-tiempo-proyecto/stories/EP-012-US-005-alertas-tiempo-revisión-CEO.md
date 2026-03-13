# EP-012-US-005 — Alertas cuando tiempo supera presupuestado y revisión CEO

### Epic padre
EP-012 — Registro de tiempo por proyecto

### Contexto/Descripción y valor
**Como** sistema centralizado, quiero mostrar alertas cuando el tiempo real supere el presupuestado o se acerque al límite, y notificar al CEO si aplica; y **como** CEO, quiero revisar el tiempo registrado por fase y proyecto en el dashboard, para detectar desvíos y tomar decisiones.

### Alcance
**Incluye:** Evaluación de umbral (tiempo real > presupuestado o cercanía al límite); alerta visual en dashboard; notificación a CEO cuando se supera umbral; dashboard de revisión para CEO (tiempo por fase, comparación, análisis).  
**Excluye:** Registro de tiempo (EP-012-US-001, EP-012-US-002); control de rentabilidad (EP-014).

### Precondiciones
- Comparación tiempo real vs presupuestado disponible (EP-012-US-004); CEO con acceso al dashboard.

### Postcondiciones
- Alerta visible si se supera umbral; CEO notificado si aplica; CEO puede revisar tiempo por fase y proyecto.

### Flujo principal
1. Sistema evalúa si tiempo real supera presupuestado o se acerca al límite (umbral configurable).
2. Si supera: sistema muestra alerta visual en dashboard y notifica a CEO.
3. CEO accede al dashboard y ve tiempo por fase, comparación con presupuestado y progreso.
4. CEO puede tomar decisiones correctivas según la información.

### Criterios BDD
- *Dado* que el tiempo real supera el presupuestado  
- *Cuando* el sistema evalúa  
- *Entonces* se muestra alerta y se notifica al CEO

### Trazabilidad
- TO-BE-012, pasos 8–9.
