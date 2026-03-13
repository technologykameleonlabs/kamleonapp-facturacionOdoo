# EP-010-US-002 — Validación de monto 50% y generación automática de factura proforma

### Epic padre
EP-010 — Activación automática de proyectos

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** validar que el monto recibido corresponde al 50% del presupuesto y generar automáticamente la factura proforma (número, monto, datos cliente, concepto),  
**para** garantizar coherencia y tener factura lista sin intervención manual.

### Alcance
**Incluye:**
- Validación de que el monto registrado corresponde al 50% del presupuesto aceptado.
- Si monto incorrecto: mostrar error y no continuar (requiere corrección en EP-010-US-001 o nuevo registro).
- Generación automática de factura proforma: número automático, monto 50%, datos del cliente, concepto (nombre proyecto/boda y fecha).
- Factura disponible para descarga/visualización y para registro en activación.

**Excluye:**
- Registro inicial de recepción de pago (EP-010-US-001).
- Activación del proyecto y reserva de fecha (EP-010-US-003, EP-010-US-004).
- Factura final (50% restante) — corresponde a otro epic (EP-022).

### Precondiciones
- Recepción de pago registrada (EP-010-US-001).
- Presupuesto aceptado y contrato firmado con importe total conocido.
- Datos del cliente y del proyecto disponibles.

### Postcondiciones
- Si monto correcto: factura proforma generada y asociada al proyecto; flujo continúa a EP-010-US-003.
- Si monto incorrecto: error mostrado a usuario; no se genera factura ni se activa proyecto.
- Factura con número, monto 50%, datos cliente, concepto.

### Flujo principal
1. Sistema recibe trigger de recepción de pago (EP-010-US-001).
2. Sistema obtiene importe total del presupuesto aceptado y calcula 50%.
3. Sistema compara monto recibido con 50% (tolerancia configurable si aplica).
4. Si monto no coincide: sistema muestra error, registra intento y finaliza (usuario debe corregir).
5. Si monto coincide: sistema genera factura proforma con número automático, monto 50%, datos cliente, concepto (nombre proyecto/boda y fecha).
6. Sistema asocia factura al proyecto y dispara activación automática (EP-010-US-003).

### Flujos alternos y excepciones

**Excepción 1: Monto incorrecto**
- Sistema muestra mensaje claro (ej. "El monto indicado no corresponde al 50% del presupuesto. Importe esperado: X EUR"). No se genera factura ni se activa proyecto.

**Excepción 2: Error en generación de factura**
- Si falla la generación (plantilla, datos faltantes): sistema notifica a administración para generación manual y registra incidencia.

### Validaciones y reglas de negocio
- Monto recibido debe corresponder al 50% del presupuesto (o tolerancia definida).
- Número de factura: secuencia automática según convención del proyecto.
- Concepto debe incluir nombre del proyecto/boda y fecha del evento.

### Criterios BDD
- **Escenario 1: Monto correcto — factura generada**
  - *Dado* que se ha registrado recepción de pago con monto X y el 50% del presupuesto es X
  - *Cuando* el sistema valida el monto
  - *Entonces* el sistema genera la factura proforma y continúa con la activación del proyecto

- **Escenario 2: Monto incorrecto**
  - *Dado* que se ha registrado recepción de pago con monto Y y el 50% del presupuesto es X (Y distinto de X)
  - *Cuando* el sistema valida el monto
  - *Entonces* el sistema muestra error, no genera factura ni activa el proyecto

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-010-activacion-automatica-proyectos.md`
- Paso(s): Pasos 2–3 del flujo principal (validación monto, generación factura proforma).
