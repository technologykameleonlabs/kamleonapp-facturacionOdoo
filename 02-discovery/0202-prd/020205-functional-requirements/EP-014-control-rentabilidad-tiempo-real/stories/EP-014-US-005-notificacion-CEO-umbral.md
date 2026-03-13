# EP-014-US-005 — Notificación a CEO cuando rentabilidad supera umbral

### Epic padre
EP-014 — Control de rentabilidad en tiempo real

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** notificar automáticamente al CEO cuando la rentabilidad sea negativa o se supere el umbral configurado, **para** que pueda tomar decisiones correctivas.

### Alcance
**Incluye:** Detección de superación de umbral (EP-014-US-004); envío de notificación al CEO (email y/o canal configurado); contenido: proyecto, rentabilidad, detalles del problema. **Excluye:** Visualización en dashboard (EP-014-US-002); evaluación de umbral (EP-014-US-004).

### Precondiciones
- Umbral superado (EP-014-US-004); CEO con canal de notificación configurado.

### Postcondiciones
- CEO ha recibido notificación con detalles del proyecto y del desvío.

### Flujo principal
1. Sistema detecta que rentabilidad es negativa o se supera umbral (EP-014-US-004).
2. Sistema prepara notificación para CEO (proyecto, rentabilidad actual, gastos/tiempo, detalle del problema).
3. Sistema envía notificación por email y/o canal configurado.
4. CEO puede acceder al dashboard para revisar y tomar decisiones.

### Criterios BDD
- *Dado* que la rentabilidad supera el umbral configurado  
- *Cuando* el sistema envía la notificación  
- *Entonces* el CEO recibe notificación con proyecto y detalles del desvío

### Trazabilidad
- TO-BE-014, paso 7.
