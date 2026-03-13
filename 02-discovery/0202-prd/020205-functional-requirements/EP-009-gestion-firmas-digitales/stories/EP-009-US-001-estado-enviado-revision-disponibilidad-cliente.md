# EP-009-US-001 — Estado Enviado para revisión y disponibilidad para el cliente

### Epic padre
EP-009 — Gestión de firmas digitales

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** marcar el contrato como "Enviado para revisión" y ponerlo a disposición del cliente (portal o enlace) cuando Fátima/Paz lo envía,  
**para** que el cliente pueda revisar y firmar.

### Alcance
**Incluye:**
- Detección del envío del contrato al cliente (acción de Fátima/Paz en EP-008-US-005).
- Cambio de estado del contrato a "Enviado para revisión".
- Puesta a disposición del contrato en portal del cliente o mediante enlace seguro (email).
- Registro de fecha/hora de puesta a disposición para trazabilidad.

**Excluye:**
- Envío explícito del contrato por Fátima/Paz (EP-008-US-005).
- Firma digital del cliente (EP-009-US-002).
- Notificaciones y recordatorios posteriores (EP-009-US-003 a EP-009-US-006).

### Precondiciones
- Contrato en estado "Aprobado" o "Enviado" (según modelo) tras EP-008-US-005.
- Fátima/Paz ha ejecutado la acción de envío al cliente (email y/o portal).
- Cliente identificado y con acceso a portal o email válido.

### Postcondiciones
- Contrato en estado "Enviado para revisión".
- Contrato visible/descargable por el cliente en portal o mediante enlace.
- Fecha de puesta a disposición registrada.
- Flujo listo para firma del cliente (EP-009-US-002).

### Flujo principal
1. Sistema detecta que Fátima/Paz ha enviado el contrato al cliente (trigger desde EP-008-US-005).
2. Sistema actualiza el estado del contrato a "Enviado para revisión".
3. Sistema pone el contrato a disposición en portal del cliente y/o genera/envía enlace seguro por email.
4. Sistema registra fecha y hora de puesta a disposición.
5. Cliente puede acceder al contrato para revisar y firmar (EP-009-US-002).

### Flujos alternos y excepciones

**Excepción 1: Portal no disponible**
- Si el portal del cliente no está operativo: sistema prioriza enlace por email; si falla, notifica a Fátima/Paz para reenvío manual.

**Excepción 2: Cliente sin email válido**
- Si no hay email válido: contrato solo en portal; sistema notifica a Fátima/Paz que informe al cliente del acceso al portal.

### Validaciones y reglas de negocio
- Solo se marca "Enviado para revisión" tras envío efectivo por Fátima/Paz (EP-008).
- Al menos un canal de acceso (portal o enlace por email) debe quedar disponible para el cliente.

### Criterios BDD
- **Escenario 1: Contrato disponible en portal**
  - *Dado* que Fátima ha enviado el contrato al cliente por portal
  - *Cuando* el sistema procesa el envío
  - *Entonces* el contrato pasa a "Enviado para revisión", queda visible en el portal del cliente y se registra la fecha de puesta a disposición

- **Escenario 2: Contrato disponible por enlace**
  - *Dado* que el contrato se envía por email con enlace
  - *Cuando* el sistema procesa el envío
  - *Entonces* el contrato pasa a "Enviado para revisión" y el enlace permite al cliente acceder al documento para revisar y firmar

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-009-gestion-firmas-digitales.md`
- Paso(s): Pasos 2–4 del flujo principal (estado Enviado para revisión, disponibilidad para el cliente).
