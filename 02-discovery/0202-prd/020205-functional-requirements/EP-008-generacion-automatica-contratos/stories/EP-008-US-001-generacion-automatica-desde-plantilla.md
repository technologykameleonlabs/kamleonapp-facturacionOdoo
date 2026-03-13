# EP-008-US-001 — Generación automática desde plantilla

### Epic padre
EP-008 — Generación automática de contratos

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** generar automáticamente un contrato desde la plantilla correspondiente (Bodas: Anexo 4; Corporativo: plantilla corporativa) cuando un presupuesto pasa a Aceptado,  
**para** tener el contrato listo en menos de 2 minutos.

### Alcance
**Incluye:**
- Detección automática cuando un presupuesto pasa a estado "Aceptado" (trigger desde EP-007).
- Identificación de la línea de negocio del presupuesto aceptado (Bodas / Corporativo).
- Selección de la plantilla de contrato según línea de negocio:
  - Bodas: Anexo 4 como plantilla base.
  - Corporativo: plantilla corporativa configurada.
- Generación del borrador de contrato desde la plantilla seleccionada.
- Vinculación del contrato al presupuesto aceptado y al lead.

**Excluye:**
- Personalización con datos del presupuesto (EP-008-US-002).
- Marcado Pendiente de revisión y notificación (EP-008-US-003).
- Revisión, edición y aprobación (EP-008-US-004, EP-008-US-005).

### Precondiciones
- Presupuesto en estado "Aceptado" (EP-007-US-005).
- Plantillas de contrato configuradas para Bodas (Anexo 4) y Corporativo.
- No existe ya un contrato generado para ese presupuesto aceptado (evitar duplicados).

### Postcondiciones
- Borrador de contrato generado desde la plantilla correcta.
- Contrato vinculado al presupuesto aceptado y al lead.
- Contrato listo para personalización (EP-008-US-002).

### Flujo principal
1. Sistema detecta que un presupuesto ha pasado a estado "Aceptado" (trigger).
2. Sistema identifica la línea de negocio del presupuesto (Bodas / Corporativo).
3. Sistema selecciona la plantilla de contrato: Bodas → Anexo 4; Corporativo → plantilla corporativa.
4. Sistema carga la plantilla y genera el borrador de contrato.
5. Sistema guarda el contrato con estado "Borrador" o "En generación" y lo vincula al presupuesto y lead.
6. Sistema pasa control a personalización (EP-008-US-002).

### Flujos alternos y excepciones

**Excepción 1: Plantilla no encontrada**
- Si no existe plantilla para la línea de negocio indicada:
- Sistema marca contrato como "Datos incompletos" o "Plantilla no encontrada".
- Sistema notifica a Fátima/Paz para generación manual o configuración de plantilla.

**Excepción 2: Presupuesto ya tiene contrato**
- Si ya existe un contrato vinculado a ese presupuesto aceptado:
- Sistema no genera duplicado; puede notificar o dejar que el usuario acceda al existente.

**Excepción 3: Datos del presupuesto insuficientes**
- Si el presupuesto aceptado no tiene línea de negocio identificable:
- Sistema marca error y notifica a Fátima/Paz para completar datos o generar manualmente.

### Validaciones y reglas de negocio
- Solo se genera contrato para presupuestos en estado "Aceptado".
- Plantilla debe existir y estar activa para la línea de negocio (Bodas / Corporativo).
- Un presupuesto aceptado debe tener como máximo un contrato generado automáticamente por este flujo (evitar duplicados por re-ejecución).

### Criterios BDD
- **Escenario 1: Generación exitosa Bodas**
  - *Dado* que un presupuesto de bodas está Aceptado
  - *Cuando* el sistema ejecuta la generación automática
  - *Entonces* el sistema selecciona la plantilla Anexo 4, genera el borrador de contrato y lo vincula al presupuesto y lead

- **Escenario 2: Generación exitosa Corporativo**
  - *Dado* que un presupuesto corporativo está Aceptado
  - *Cuando* el sistema ejecuta la generación automática
  - *Entonces* el sistema selecciona la plantilla corporativa, genera el borrador y lo vincula al presupuesto y lead

- **Escenario 3 (negativo): Plantilla no encontrada**
  - *Dado* que la línea de negocio no tiene plantilla configurada
  - *Cuando* el sistema intenta generar el contrato
  - *Entonces* el sistema marca error "Plantilla no encontrada", no genera contrato y notifica a Fátima/Paz

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-008-generacion-automatica-contratos.md`
- Paso(s): Pasos 1–2 del flujo principal (detección presupuesto Aceptado, generación desde plantilla).
