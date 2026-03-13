# EP-022-US-001 — Detección de aceptación segunda entrega y generación factura 50%

### Epic padre
EP-022 — Generación automática de factura final

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** detectar cuando el cliente acepta la segunda entrega (EP-021) y generar automáticamente la factura del 50% restante (número, monto, datos cliente, concepto), **para** tener factura lista en menos de 2 minutos.

### Alcance
**Incluye:** Detección de aceptación segunda entrega (EP-021); generación automática de factura 50% restante; número, monto, datos cliente, concepto. **Excluye:** Notificación (EP-022-US-002); registro pago (EP-022-US-003).

### Precondiciones
- Segunda entrega aceptada por cliente (EP-021); primer pago (50%) ya recibido; datos cliente y presupuesto disponibles.

### Postcondiciones
- Factura final generada; sistema notifica (EP-022-US-002) y registra (EP-022-US-003).

### Flujo principal
1. Sistema detecta aceptación de segunda entrega (EP-021-US-006).
2. Sistema genera factura del 50% restante (número automático, monto, datos cliente, concepto).
3. Sistema dispara notificación (EP-022-US-002) y registro (EP-022-US-003).

### Criterios BDD
- *Dado* que el cliente ha aceptado la segunda entrega  
- *Cuando* el sistema genera la factura  
- *Entonces* la factura del 50% restante queda generada en menos de 2 minutos

### Trazabilidad
- TO-BE-022.
