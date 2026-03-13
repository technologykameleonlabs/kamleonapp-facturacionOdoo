# EP-007-US-001 — Registro de respuesta del cliente (contrapropuesta)

### Epic padre
EP-007 — Negociación de presupuestos

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** registrar la respuesta del cliente al presupuesto (contrapropuesta de precio, modificación de servicios, ajustes o extras) con tipo, cambios solicitados y fecha,  
**para** tener trazabilidad de la negociación.

### Alcance
**Incluye:**
- Recepción de la respuesta del cliente al presupuesto enviado (portal de cliente, email o registro manual).
- Clasificación del tipo de respuesta: contrapropuesta de precio, modificación de servicios, ajustes, extras o aceptación/rechazo.
- Registro de los cambios solicitados (precio propuesto, servicios a añadir/quitar, descripción de ajustes).
- Registro de fecha y hora de la respuesta.
- Vinculación de la respuesta al presupuesto y versión actual.
- Estado de negociación actualizado (ej. "En negociación" si es contrapropuesta).

**Excluye:**
- Revisión de la contrapropuesta por Fátima/Paz/Javi (EP-007-US-002).
- Decisión y registro de nueva versión (EP-007-US-003).
- Envío de respuesta al cliente (EP-007-US-004).

### Precondiciones
- Presupuesto enviado al cliente (EP-006-US-006).
- Presupuesto en estado "Enviado" o "En negociación".
- Cliente ha respondido (portal, email o se va a registrar manualmente).

### Postcondiciones
- Respuesta del cliente registrada con tipo, cambios solicitados y fecha.
- Presupuesto/negociación actualizada con estado "En negociación" (si es contrapropuesta).
- Trazabilidad disponible para revisión (EP-007-US-002).

### Flujo principal
1. Cliente responde al presupuesto (portal, email o Fátima/Paz/Javi registra manualmente).
2. Sistema recibe o se introduce la respuesta (tipo: contrapropuesta precio, modificación servicios, ajustes, extras, aceptación, rechazo).
3. Sistema registra los cambios solicitados (precio propuesto, líneas a modificar, descripción).
4. Sistema registra fecha y hora de la respuesta.
5. Sistema vincula la respuesta al presupuesto y a la versión actual.
6. Sistema actualiza el estado de negociación (ej. "En negociación" si aplica).
7. Sistema deja el registro listo para revisión (EP-007-US-002).

### Flujos alternos y excepciones

**Flujo alterno 1: Cliente acepta directamente**
- Si el tipo de respuesta es "Aceptación":
- Sistema registra la aceptación y pasa a EP-007-US-005 (registro de acuerdo final y marcado Aceptado).

**Flujo alterno 2: Cliente rechaza directamente**
- Si el tipo de respuesta es "Rechazo":
- Sistema registra el rechazo y pasa a EP-007-US-005 (registro de rechazo definitivo).

**Excepción 1: Datos incompletos**
- Si no se puede determinar el tipo o los cambios solicitados:
- Sistema solicita completar tipo y al menos descripción o campos mínimos antes de guardar.

**Excepción 2: Presupuesto no encontrado o estado inválido**
- Si el presupuesto no está "Enviado" o "En negociación":
- Sistema no permite registrar respuesta y muestra mensaje de estado inválido.

### Validaciones y reglas de negocio
- Solo se puede registrar respuesta sobre presupuestos en estado "Enviado" o "En negociación".
- Tipo de respuesta es obligatorio (contrapropuesta precio, modificación servicios, ajustes, extras, aceptación, rechazo).
- Fecha de respuesta se registra automáticamente; no puede ser anterior al envío del presupuesto.

### Criterios BDD
- **Escenario 1: Registro de contrapropuesta de precio**
  - *Dado* que existe un presupuesto enviado al cliente
  - *Cuando* se registra una respuesta tipo "Contrapropuesta de precio" con precio propuesto y fecha
  - *Entonces* el sistema guarda la respuesta vinculada al presupuesto, actualiza estado a "En negociación" y deja listo para revisión

- **Escenario 2: Registro de modificación de servicios**
  - *Dado* que existe un presupuesto en negociación
  - *Cuando* se registra una respuesta tipo "Modificación de servicios" con descripción de cambios
  - *Entonces* el sistema guarda la respuesta con tipo, cambios y fecha y deja listo para revisión

- **Escenario 3 (negativo): Estado inválido**
  - *Dado* que el presupuesto está en estado "Borrador"
  - *Cuando* se intenta registrar una respuesta del cliente
  - *Entonces* el sistema no guarda y muestra que el presupuesto no está en estado válido para registrar respuesta

### Notificaciones
- **Fátima/Paz/Javi:** Notificación opcional cuando el cliente responde (portal/email integrado), para revisar contrapropuesta en dashboard.

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-007-negociacion-presupuestos.md`
- Paso(s): Pasos 1–2 del flujo principal (cliente responde, sistema registra respuesta).
