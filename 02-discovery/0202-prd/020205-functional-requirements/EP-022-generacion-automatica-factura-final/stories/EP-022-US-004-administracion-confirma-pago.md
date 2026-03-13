# EP-022-US-004 — Administración confirma recepción de pago final

### Epic padre
EP-022 — Generación automática de factura final

### Contexto/Descripción y valor
**Como** administración, **quiero** confirmar manualmente la recepción del pago final cuando el cliente ha pagado fuera del sistema, **para** que el proyecto pueda cerrarse (EP-024).

### Alcance
**Incluye:** Acción de confirmación de recepción de pago final por administración; actualización de estado de pago a "Recibido"; disparo para EP-024. **Excluye:** Generación factura (EP-022-US-001); cierre (EP-024).

### Precondiciones
- Factura final generada y registrada (EP-022-US-001, EP-022-US-003); administración ha recibido pago fuera del sistema; usuario con rol administración.

### Postcondiciones
- Estado de pago "Recibido"; proyecto listo para cierre (EP-024) si segunda entrega aceptada y feedback si aplica.

### Flujo principal
1. Administración accede al proyecto o a la factura final.
2. Administración ejecuta acción de confirmar recepción de pago final.
3. Sistema actualiza estado de pago a "Recibido" (EP-022-US-003).
4. Sistema evalúa condiciones para cierre (EP-024): pago final recibido y segunda entrega aceptada.

### Criterios BDD
- *Dado* que administración ha recibido el pago final  
- *Cuando* confirma la recepción en el sistema  
- *Entonces* el estado de pago pasa a "Recibido" y el proyecto puede cerrarse

### Trazabilidad
- TO-BE-022.
