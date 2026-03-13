# EP-022-US-003 — Registro de factura y estado de pago

### Epic padre
EP-022 — Generación automática de factura final

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** registrar la factura generada y el estado de pago (pendiente/recibido según confirmación de administración), **para** trazabilidad y EP-024 (cierre).

### Alcance
**Incluye:** Registro de factura (número, monto, proyecto_id); estado de pago (pendiente, recibido); vinculación al proyecto. **Excluye:** Confirmación por administración (EP-022-US-004); cierre (EP-024).

### Precondiciones
- Factura generada (EP-022-US-001).

### Postcondiciones
- Factura y estado de pago registrados; cuando "recibido" (EP-022-US-004) proyecto puede cerrarse (EP-024).

### Flujo principal
1. Sistema registra factura generada (EP-022-US-001) con estado de pago "Pendiente".
2. Administración puede confirmar recepción de pago (EP-022-US-004); sistema actualiza estado a "Recibido".
3. Estado disponible para EP-024 (cierre automático cuando pago recibido y feedback si aplica).

### Criterios BDD
- *Dado* que la factura está generada  
- *Cuando* el sistema registra  
- *Entonces* la factura y el estado de pago quedan registrados

### Trazabilidad
- TO-BE-022.
