# EP-010-US-003 — Activación automática del proyecto

### Epic padre
EP-010 — Activación automática de proyectos

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** activar automáticamente el proyecto (estado "Activo", fecha de activación registrada) cuando el pago es válido y la factura generada,  
**para** que el proyecto quede disponible para gestión de recursos y tiempo (EP-012, EP-013).

### Alcance
**Incluye:**
- Cambio de estado del proyecto a "Activo" tras factura proforma generada (EP-010-US-002).
- Registro de fecha y hora de activación.
- Proyecto visible y disponible para registro de tiempo (EP-012) y gestión de recursos (EP-013).
- Disparo del flujo de reserva automática de fecha (EP-010-US-004).

**Excluye:**
- Reserva de fecha en calendario (EP-010-US-004).
- Notificaciones (EP-010-US-005).
- Registro de tiempo y recursos (EP-012, EP-013).

### Precondiciones
- Factura proforma generada correctamente (EP-010-US-002).
- Proyecto en estado "Contrato firmado" o equivalente.
- Pago validado (monto 50% correcto).

### Postcondiciones
- Proyecto en estado "Activo".
- Fecha de activación registrada (timestamp).
- Proyecto disponible para EP-012, EP-013 y resto de flujos posteriores.
- Flujo listo para reserva automática de fecha (EP-010-US-004).

### Flujo principal
1. Sistema recibe confirmación de factura proforma generada (EP-010-US-002).
2. Sistema actualiza el estado del proyecto a "Activo".
3. Sistema registra fecha y hora de activación.
4. Sistema hace el proyecto visible en listados de proyectos activos para equipo y administración.
5. Sistema dispara reserva automática de fecha (EP-010-US-004).

### Flujos alternos y excepciones

**Excepción 1: Error al actualizar estado**
- Si falla la actualización en base de datos: sistema registra incidencia, no continúa con reserva de fecha y notifica a administración.

### Validaciones y reglas de negocio
- Solo se puede pasar a "Activo" si la factura proforma del 50% está generada y asociada.
- La fecha de activación debe ser la fecha/hora en que se ejecuta el cambio de estado.

### Criterios BDD
- **Escenario 1: Activación correcta**
  - *Dado* que la factura proforma ha sido generada para el proyecto
  - *Cuando* el sistema ejecuta la activación del proyecto
  - *Entonces* el estado del proyecto pasa a "Activo", se registra la fecha de activación y el proyecto queda disponible para registro de tiempo y recursos

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-010-activacion-automatica-proyectos.md`
- Paso(s): Paso 4 del flujo principal (activación automática del proyecto).
