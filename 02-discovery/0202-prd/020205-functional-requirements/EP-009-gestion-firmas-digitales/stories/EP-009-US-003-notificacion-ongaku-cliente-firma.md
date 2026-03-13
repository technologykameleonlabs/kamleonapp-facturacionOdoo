# EP-009-US-003 — Notificación automática a ONGAKU cuando el cliente firma

### Epic padre
EP-009 — Gestión de firmas digitales

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** notificar automáticamente a ONGAKU cuando el cliente firma el contrato,  
**para** que ONGAKU proceda a firmar y no se olvide.

### Alcance
**Incluye:**
- Detección de que el contrato ha pasado a estado "Firmado por cliente" (EP-009-US-002).
- Envío automático de notificación a Fátima/Paz (ONGAKU): email y/o notificación en sistema.
- Inclusión en la notificación de enlace o indicación clara para acceder al contrato y firmar.
- Registro de que la notificación fue enviada (opcional, para auditoría).

**Excluye:**
- Firma digital de ONGAKU (EP-009-US-004).
- Recordatorios si ONGAKU no firma en tiempo (EP-009-US-006).
- Contenido y canal exactos de notificación (configurables).

### Precondiciones
- Contrato en estado "Firmado por cliente" (EP-009-US-002).
- Destinatarios ONGAKU (Fátima/Paz) configurados y con canal de notificación válido (email y/o sistema).
- Sistema de notificaciones operativo.

### Postcondiciones
- ONGAKU ha recibido notificación de que el cliente ha firmado.
- ONGAKU puede acceder al contrato para firmar (EP-009-US-004).
- Si no se firma en tiempo, aplican recordatorios (EP-009-US-006).

### Flujo principal
1. Sistema detecta cambio de estado del contrato a "Firmado por cliente" (trigger tras EP-009-US-002).
2. Sistema identifica destinatarios ONGAKU (Fátima/Paz según configuración/permisos).
3. Sistema genera y envía notificación (email y/o in-app) indicando que el cliente ha firmado y que el contrato está pendiente de firma por ONGAKU.
4. La notificación incluye enlace o ruta para acceder al contrato y ejecutar la firma.
5. Sistema registra el envío de la notificación (opcional).
6. ONGAKU puede proceder a firmar (EP-009-US-004).

### Flujos alternos y excepciones

**Excepción 1: Fallo de envío de notificación**
- Si el email falla: sistema reintenta según política; si persiste, registrar fallo y permitir que ONGAKU vea el estado en el listado/dashboard (EP-009-US-006).

**Excepción 2: Múltiples usuarios ONGAKU**
- Si hay varios destinatarios: notificación a todos los configurados con permiso para firmar, o al primero según regla de negocio (ej. asignación por lead/proyecto).

### Validaciones y reglas de negocio
- La notificación se envía solo cuando el estado pasa a "Firmado por cliente".
- Al menos un canal de notificación debe estar configurado para ONGAKU.
- La notificación debe permitir acceder al contrato para firmar (enlace o ruta clara).

### Criterios BDD
- **Escenario 1: Notificación enviada por email**
  - *Dado* un contrato que acaba de pasar a "Firmado por cliente"
  - *Cuando* el sistema procesa la notificación
  - *Entonces* se envía un email a Fátima/Paz indicando que el cliente ha firmado y con enlace para firmar el contrato

- **Escenario 2: Notificación en sistema**
  - *Dado* un contrato en "Firmado por cliente"
  - *Cuando* el sistema envía la notificación
  - *Entonces* Fátima/Paz recibe una notificación en el sistema (bandeja/alert) con acceso al contrato para firmar

- **Escenario 3 (negativo): Sin destinatario**
  - *Dado* que no hay destinatario ONGAKU configurado
  - *Cuando* el cliente firma el contrato
  - *Entonces* el sistema registra el fallo de notificación y el contrato sigue visible en listados para que un admin asigne o configure destinatario

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-009-gestion-firmas-digitales.md`
- Paso(s): Paso 7 del flujo principal (notificación automática a ONGAKU cuando el cliente firma).
