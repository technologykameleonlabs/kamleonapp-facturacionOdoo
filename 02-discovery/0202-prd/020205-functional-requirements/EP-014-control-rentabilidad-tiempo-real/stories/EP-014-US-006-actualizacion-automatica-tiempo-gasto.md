# EP-014-US-006 — Actualización automática al registrar tiempo o gasto

### Epic padre
EP-014 — Control de rentabilidad en tiempo real

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** actualizar automáticamente la visualización de rentabilidad cada vez que se registre tiempo (EP-012) o gasto (EP-013), **para** que el dashboard esté siempre actualizado en tiempo real.

### Alcance
**Incluye:** Trigger al guardar registro de tiempo (EP-012); trigger al guardar registro de gasto (EP-013); recálculo de rentabilidad (EP-014-US-001); actualización de dashboard y alertas. **Excluye:** Registro de tiempo y gastos (EP-012, EP-013).

### Precondiciones
- EP-012 y/o EP-013 operativos; nuevo registro de tiempo o gasto guardado.

### Postcondiciones
- Rentabilidad recalculada; dashboard y alertas reflejan datos actualizados (< 1 min).

### Flujo principal
1. Usuario guarda registro de tiempo (EP-012) o de gasto (EP-013).
2. Sistema dispara actualización de rentabilidad del proyecto.
3. Sistema recalcula rentabilidad (EP-014-US-001).
4. Sistema actualiza visualización en dashboard y re-evalúa umbral/alertas (EP-014-US-004, EP-014-US-005).

### Criterios BDD
- *Dado* que se acaba de registrar tiempo o gasto  
- *Cuando* el sistema actualiza  
- *Entonces* la rentabilidad y el dashboard se actualizan en menos de 1 minuto

### Trazabilidad
- TO-BE-014, paso 9.
