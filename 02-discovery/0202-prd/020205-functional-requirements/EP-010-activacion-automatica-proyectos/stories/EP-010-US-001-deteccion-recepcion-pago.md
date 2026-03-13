# EP-010-US-001 — Detección de recepción de pago (justificante o confirmación manual)

### Epic padre
EP-010 — Activación automática de proyectos

### Contexto/Descripción y valor
**Como** cliente o administración,  
**quiero** registrar la recepción del primer pago (cliente subiendo justificante en portal o administración confirmando manualmente),  
**para** que el sistema pueda validar y activar el proyecto automáticamente.

### Alcance
**Incluye:**
- Cliente sube justificante de pago en portal del cliente (documento/imagen válido).
- Administración confirma recepción de pago manualmente desde dashboard.
- Registro de monto indicado y fecha de recepción.
- Trigger para validación de monto (EP-010-US-002) y flujo posterior.

**Excluye:**
- Validación del monto 50% (EP-010-US-002).
- Generación de factura y activación del proyecto (EP-010-US-002 a EP-010-US-005).
- Pasarela de pago integrada (el pago se realiza fuera del sistema).

### Precondiciones
- Contrato firmado por ambas partes (EP-009 completado).
- Proyecto en estado "Contrato firmado" o equivalente.
- Cliente o administración con acceso al portal o dashboard según rol.

### Postcondiciones
- Recepción de pago registrada en el sistema (justificante asociado o confirmación manual).
- Monto y fecha de recepción registrados.
- Flujo listo para validación de monto (EP-010-US-002).

### Flujo principal
1. Cliente accede al portal del proyecto y sube justificante de pago (o administración confirma recepción manualmente).
2. Sistema valida que el justificante es un archivo válido (formato, tamaño) o que la confirmación manual está autorizada.
3. Usuario indica monto recibido (o sistema lo extrae si está definido).
4. Sistema registra la recepción de pago con timestamp y datos asociados.
5. Sistema dispara el flujo de validación de monto (EP-010-US-002).

### Flujos alternos y excepciones

**Excepción 1: Justificante inválido**
- Si el archivo no es válido (formato no permitido, tamaño excesivo): sistema muestra error y solicita nuevo justificante.

**Excepción 2: Confirmación manual sin permisos**
- Si el usuario no tiene rol de administración: no puede confirmar recepción manual; solo cliente puede subir justificante.

### Validaciones y reglas de negocio
- Al menos un método de registro debe estar disponible (justificante en portal o confirmación manual por administración).
- El contrato debe estar firmado por ambas partes para permitir registro de pago.

### Criterios BDD
- **Escenario 1: Cliente sube justificante**
  - *Dado* que el contrato está firmado y el cliente ha realizado el pago
  - *Cuando* el cliente sube el justificante de pago en el portal e indica el monto
  - *Entonces* el sistema registra la recepción del pago y dispara la validación de monto

- **Escenario 2: Administración confirma recepción**
  - *Dado* que administración ha recibido el justificante por otro canal (email, etc.)
  - *Cuando* administración confirma manualmente la recepción del pago e indica el monto
  - *Entonces* el sistema registra la recepción del pago y dispara la validación de monto

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-010-activacion-automatica-proyectos.md`
- Paso(s): Pasos 1–2 del flujo principal (detección de recepción de pago).
