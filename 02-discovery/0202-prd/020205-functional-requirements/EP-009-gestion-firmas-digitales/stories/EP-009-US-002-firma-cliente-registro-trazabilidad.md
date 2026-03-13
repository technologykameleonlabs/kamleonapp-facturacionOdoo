# EP-009-US-002 — Firma digital del cliente con registro y trazabilidad

### Epic padre
EP-009 — Gestión de firmas digitales

### Contexto/Descripción y valor
**Como** cliente,  
**quiero** firmar el contrato digitalmente en portal o enlace,  
**para** dar mi consentimiento de forma válida; el sistema registra quién, cuándo, IP y dispositivo.

### Alcance
**Incluye:**
- Acceso del cliente al contrato en estado "Enviado para revisión" (portal o enlace).
- Acción de firma digital del cliente (aceptación/confirmación según sistema de firma).
- Registro automático: firmante (cliente/contacto), fecha y hora, IP, dispositivo (opcional).
- Cambio de estado del contrato a "Firmado por cliente".
- Contrato listo para firma de ONGAKU (EP-009-US-004).

**Excluye:**
- Firma de ONGAKU (EP-009-US-004).
- Notificación a ONGAKU (EP-009-US-003).
- Rechazo del contrato por el cliente (variante; puede documentarse como excepción).

### Precondiciones
- Contrato en estado "Enviado para revisión" (EP-009-US-001).
- Cliente identificado (sesión portal o token de enlace válido).
- Sistema de firma digital operativo (integrado o externo).

### Postcondiciones
- Contrato firmado por el cliente; estado "Firmado por cliente".
- Registro de firma guardado (quién, cuándo, IP, dispositivo).
- Sistema dispara notificación a ONGAKU (EP-009-US-003).

### Flujo principal
1. Cliente accede al contrato (portal o enlace) y lo revisa.
2. Cliente ejecuta la acción de firma digital (botón/confirmación según UX).
3. Sistema valida la identidad/consentimiento y registra la firma (firmante, fecha/hora, IP, dispositivo).
4. Sistema actualiza el estado del contrato a "Firmado por cliente".
5. Sistema almacena el registro de firma para trazabilidad.
6. Flujo continúa con notificación a ONGAKU (EP-009-US-003).

### Flujos alternos y excepciones

**Excepción 1: Falla en firma digital**
- Si el proceso de firma falla: sistema permite reintentar; si persiste, opción de notificar a ONGAKU para alternativa (ej. firma manual).

**Excepción 2: Cliente rechaza**
- Si el cliente rechaza el contrato: estado opcional "Rechazado"; sistema notifica a ONGAKU (fuera de flujo estándar de firmas).

**Excepción 3: Enlace expirado**
- Si el enlace ha expirado: sistema informa al cliente y sugiere contactar a ONGAKU para nuevo envío.

### Validaciones y reglas de negocio
- Solo se puede firmar un contrato en estado "Enviado para revisión".
- La firma del cliente debe registrarse con al menos: firmante, fecha/hora; IP y dispositivo son recomendados.
- Orden de firmas: primero cliente, después ONGAKU.

### Criterios BDD
- **Escenario 1: Firma exitosa en portal**
  - *Dado* un contrato en "Enviado para revisión" y el cliente autenticado en el portal
  - *Cuando* el cliente confirma la firma digital
  - *Entonces* el sistema registra la firma (quién, cuándo, IP, dispositivo), cambia el estado a "Firmado por cliente" y deja el contrato listo para firma de ONGAKU

- **Escenario 2: Firma mediante enlace**
  - *Dado* un contrato accesible por enlace válido
  - *Cuando* el cliente firma desde el enlace
  - *Entonces* el sistema registra la firma y actualiza el estado a "Firmado por cliente"

- **Escenario 3 (negativo): Firma sin estado correcto**
  - *Dado* un contrato que no está en "Enviado para revisión"
  - *Cuando* el cliente intenta firmar
  - *Entonces* el sistema no permite la firma y muestra mensaje apropiado

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-009-gestion-firmas-digitales.md`
- Paso(s): Pasos 5–6 del flujo principal (cliente firma, registro de firma, estado Firmado por cliente).
