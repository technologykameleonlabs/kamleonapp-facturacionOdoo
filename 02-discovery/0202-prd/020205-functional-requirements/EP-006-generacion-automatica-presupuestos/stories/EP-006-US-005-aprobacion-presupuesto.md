# EP-006-US-005 — Aprobación del presupuesto

### Epic padre
EP-006 — Generación automática de presupuestos

### Contexto/Descripción y valor
**Como** Fátima/Paz,  
**quiero** aprobar el presupuesto para dejarlo listo para enviar al cliente, sin que se envíe automáticamente,  
**para** mantener el control sobre qué presupuestos se envían y cuándo.

### Alcance
**Incluye:**
- Acción "Aprobar presupuesto" en la vista de detalle del presupuesto.
- Cambio de estado del presupuesto a "Aprobado" tras confirmación.
- Registro de timestamp y usuario que aprueba (auditoría).
- Presupuesto queda listo para envío al cliente (EP-006-US-006); no se envía automáticamente.
- Opción de rechazar presupuesto (estado "Rechazado") con motivo opcional, para regenerar o corregir.

**Excluye:**
- Envío del presupuesto al cliente (EP-006-US-006).
- Modificación del presupuesto una vez aprobado (según diseño: puede requerir flujo de nueva versión).

### Precondiciones
- Presupuesto en estado "Pendiente de aprobación" (EP-006-US-003).
- Fátima/Paz tiene permisos para aprobar presupuestos según línea de negocio.
- Usuario está autenticado en el sistema.

### Postcondiciones
- Presupuesto en estado "Aprobado".
- Presupuesto listo para ser enviado al cliente (acción explícita en EP-006-US-006).
- Registro de auditoría con timestamp y usuario que aprobó.

### Flujo principal
1. Fátima/Paz ha revisado (y opcionalmente modificado) el presupuesto (EP-006-US-004).
2. Fátima/Paz hace clic en "Aprobar presupuesto".
3. Sistema muestra confirmación: "¿Aprobar este presupuesto? Quedará listo para enviar al cliente."
4. Fátima/Paz confirma.
5. Sistema cambia estado del presupuesto a "Aprobado".
6. Sistema registra timestamp y usuario que aprobó.
7. Presupuesto queda visible en listado "Listos para enviar" o similar; no se envía automáticamente.
8. Fátima/Paz puede enviar el presupuesto al cliente cuando lo desee (EP-006-US-006).

### Flujos alternos y excepciones

**Flujo alterno 1: Rechazar presupuesto**
- Si Fátima/Paz considera que el presupuesto no debe aprobarse:
- Selecciona "Rechazar presupuesto" e indica motivo opcional (ej. "Regenerar con otros precios").
- Sistema cambia estado a "Rechazado", registra motivo y timestamp.
- Presupuesto no queda listo para enviar; puede regenerarse o corregirse según proceso.

**Excepción 1: Presupuesto ya aprobado**
- Si el presupuesto ya está en estado "Aprobado":
- Sistema no permite aprobar de nuevo y muestra mensaje informativo.

**Excepción 2: Sin permisos para aprobar**
- Si el usuario no tiene permisos para aprobar ese presupuesto:
- Sistema muestra error de permisos y no cambia estado.

### Validaciones y reglas de negocio
- Solo presupuestos en estado "Pendiente de aprobación" pueden aprobarse.
- Una vez "Aprobado", el presupuesto no se envía automáticamente; requiere acción explícita de envío.
- Rechazo es opcional; motivo opcional para trazabilidad.

### Criterios BDD
- **Escenario 1: Aprobación exitosa**
  - *Dado* que Fátima tiene un presupuesto pendiente de aprobación revisado
  - *Cuando* hace clic en "Aprobar presupuesto" y confirma
  - *Entonces* el sistema cambia el estado a "Aprobado", registra timestamp y usuario, y el presupuesto queda listo para enviar (sin enviarse automáticamente)

- **Escenario 2 (negativo): Envío automático no permitido**
  - *Dado* que un presupuesto ha sido aprobado
  - *Cuando* el sistema procesa el flujo posterior
  - *Entonces* el presupuesto no se envía automáticamente al cliente; solo puede enviarse mediante acción explícita de Fátima/Paz

- **Escenario 3: Rechazo de presupuesto**
  - *Dado* que Paz considera que el presupuesto no debe aprobarse
  - *Cuando* selecciona "Rechazar presupuesto" e indica motivo
  - *Entonces* el sistema cambia el estado a "Rechazado", registra motivo y timestamp, y el presupuesto no queda listo para enviar

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-006-generacion-automatica-presupuestos.md`
- Paso(s): Paso 8 del flujo principal (Fátima/Paz aprueba presupuesto; presupuesto listo para enviar, no automático).
