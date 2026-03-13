# EP-024-US-001 — Detección de condiciones de cierre (pago final y segunda entrega aceptada)

### Epic padre
EP-024 — Cierre automático de proyecto

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** detectar cuando se cumplen las condiciones de cierre (pago final recibido EP-022 y segunda entrega aceptada EP-021; feedback opcional EP-023), **para** ejecutar cierre automático.

### Alcance
**Incluye:** Evaluación de pago final recibido (EP-022); segunda entrega aceptada (EP-021); feedback recibido (opcional EP-023); disparo de cierre cuando se cumplen condiciones. **Excluye:** Cierre efectivo (EP-024-US-002); archivo (EP-024-US-003).

### Precondiciones
- Pago final recibido (EP-022); segunda entrega aceptada (EP-021); feedback opcional según configuración.

### Postcondiciones
- Si condiciones cumplidas: sistema dispara cierre (EP-024-US-002).

### Flujo principal
1. Sistema evalúa proyecto: pago final recibido (EP-022-US-004) y segunda entrega aceptada (EP-021-US-006).
2. Si feedback es obligatorio: sistema comprueba feedback recibido (EP-023-US-005).
3. Si todas las condiciones se cumplen: sistema dispara cierre automático (EP-024-US-002).

### Criterios BDD
- *Dado* que el pago final está recibido y la segunda entrega está aceptada  
- *Cuando* el sistema evalúa las condiciones  
- *Entonces* se dispara el cierre automático del proyecto

### Trazabilidad
- TO-BE-024.
