# EP-009-US-004 — Firma digital de ONGAKU y estado Firmado por ambas partes

### Epic padre
EP-009 — Gestión de firmas digitales

### Contexto/Descripción y valor
**Como** Fátima/Paz (ONGAKU),  
**quiero** firmar el contrato digitalmente una vez el cliente ha firmado,  
**para** completar el acuerdo; el sistema registra la firma y marca "Firmado por ambas partes".

### Alcance
**Incluye:**
- Acceso de Fátima/Paz al contrato en estado "Firmado por cliente".
- Acción de firma digital por el usuario ONGAKU (autenticado).
- Registro automático: firmante (usuario ONGAKU), fecha y hora, IP, dispositivo (opcional).
- Cambio de estado del contrato a "Firmado por ambas partes".
- Contrato listo para notificación final (EP-009-US-005) y para EP-010 (activación de proyecto).

**Excluye:**
- Firma del cliente (EP-009-US-002).
- Notificación a ONGAKU de que el cliente firmó (EP-009-US-003).
- Notificación de contrato completamente firmado (EP-009-US-005).

### Precondiciones
- Contrato en estado "Firmado por cliente" (EP-009-US-002).
- Usuario ONGAKU (Fátima/Paz) autenticado y con permiso para firmar contratos.
- Sistema de firma digital operativo.

### Postcondiciones
- Contrato firmado por ambas partes; estado "Firmado por ambas partes".
- Registro de la firma de ONGAKU guardado (quién, cuándo, IP, dispositivo).
- Sistema puede disparar notificación a cliente y ONGAKU (EP-009-US-005).
- Contrato disponible para activación de proyecto (EP-010).

### Flujo principal
1. Fátima/Paz accede al contrato (desde notificación, listado o búsqueda) en estado "Firmado por cliente".
2. Sistema muestra el contrato y la acción "Firmar contrato" (habilitada solo si estado = Firmado por cliente).
3. Fátima/Paz ejecuta la firma digital (confirmación según UX/sistema de firma).
4. Sistema valida el usuario y registra la firma (firmante, fecha/hora, IP, dispositivo).
5. Sistema actualiza el estado del contrato a "Firmado por ambas partes".
6. Sistema almacena el registro de firma para trazabilidad.
7. Flujo continúa con notificación de contrato completamente firmado (EP-009-US-005).

### Flujos alternos y excepciones

**Excepción 1: Falla en firma digital**
- Si el proceso de firma falla: sistema permite reintentar; si persiste, registrar error y notificar para alternativa manual si aplica.

**Excepción 2: Contrato no en estado correcto**
- Si por error se intenta firmar un contrato que no está "Firmado por cliente": sistema no permite la acción y muestra mensaje claro.

### Validaciones y reglas de negocio
- Solo se puede firmar por ONGAKU un contrato en estado "Firmado por cliente".
- El firmante debe ser un usuario ONGAKU con permiso para firmar contratos (según RBAC).
- Orden de firmas: cliente primero, ONGAKU después.
- Registro de firma debe incluir al menos: usuario, fecha/hora; IP y dispositivo recomendados.

### Criterios BDD
- **Escenario 1: Firma exitosa por ONGAKU**
  - *Dado* un contrato en "Firmado por cliente" y Fátima autenticada con permiso para firmar
  - *Cuando* Fátima ejecuta la firma digital del contrato
  - *Entonces* el sistema registra la firma de ONGAKU, cambia el estado a "Firmado por ambas partes" y el contrato queda listo para EP-009-US-005 y EP-010

- **Escenario 2 (negativo): Firma sin estado correcto**
  - *Dado* un contrato en "Enviado para revisión" (cliente aún no ha firmado)
  - *Cuando* Fátima intenta firmar el contrato
  - *Entonces* el sistema no permite la firma y muestra que primero debe firmar el cliente

- **Escenario 3 (negativo): Usuario sin permiso**
  - *Dado* un usuario ONGAKU sin permiso para firmar contratos
  - *Cuando* intenta acceder a la acción de firmar
  - *Entonces* el sistema no muestra la acción o la deshabilita y muestra mensaje de permisos

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-009-gestion-firmas-digitales.md`
- Paso(s): Pasos 8–9 del flujo principal (ONGAKU firma, registro de firma, estado Firmado por ambas partes).
