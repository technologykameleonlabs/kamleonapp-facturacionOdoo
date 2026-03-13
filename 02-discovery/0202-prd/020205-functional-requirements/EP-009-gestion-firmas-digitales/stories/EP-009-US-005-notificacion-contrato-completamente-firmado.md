# EP-009-US-005 — Notificación de contrato completamente firmado

### Epic padre
EP-009 — Gestión de firmas digitales

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** notificar automáticamente a cliente y ONGAKU cuando el contrato está firmado por ambas partes,  
**para** que ambas partes tengan constancia y el contrato quede listo para EP-010.

### Alcance
**Incluye:**
- Detección de que el contrato ha pasado a estado "Firmado por ambas partes" (EP-009-US-004).
- Envío automático de notificación al cliente: email y/o notificación en portal.
- Envío automático de notificación a ONGAKU (Fátima/Paz): email y/o notificación en sistema.
- Inclusión en las notificaciones de que el contrato está completamente firmado y, si aplica, enlace para descarga o acceso al documento.
- Contrato listo para activación de proyecto (EP-010); no se activa automáticamente en esta historia.

**Excluye:**
- Activación automática del proyecto (EP-010).
- Seguimiento de estado y recordatorios (EP-009-US-006).
- Contenido exacto y canales (configurables).

### Precondiciones
- Contrato en estado "Firmado por ambas partes" (EP-009-US-004).
- Cliente y ONGAKU con canales de notificación válidos (email y/o portal/sistema).
- Sistema de notificaciones operativo.

### Postcondiciones
- Cliente ha recibido notificación de que el contrato está firmado por ambas partes.
- ONGAKU ha recibido notificación de que el contrato está completamente firmado.
- Ambas partes pueden tener constancia y, si aplica, descargar el documento.
- Contrato disponible para EP-010 (activación de proyecto).

### Flujo principal
1. Sistema detecta cambio de estado del contrato a "Firmado por ambas partes" (trigger tras EP-009-US-004).
2. Sistema identifica al cliente (contacto/email asociado al contrato/lead) y a los destinatarios ONGAKU.
3. Sistema genera y envía notificación al cliente: contrato firmado por ambas partes, opción de descarga o acceso si aplica.
4. Sistema genera y envía notificación a ONGAKU: contrato completamente firmado, listo para activación (EP-010), opción de acceso/descarga si aplica.
5. Sistema registra el envío de las notificaciones (opcional).
6. Contrato queda listo para EP-010 (activación automática de proyectos).

### Flujos alternos y excepciones

**Excepción 1: Fallo de notificación al cliente**
- Si falla el envío al cliente: reintento según política; contrato sigue listo para EP-010; ONGAKU puede reenviar manualmente si se desea.

**Excepción 2: Fallo de notificación a ONGAKU**
- Si falla el envío a ONGAKU: reintento según política; el estado del contrato y el listado/dashboard (EP-009-US-006) permiten ver que está firmado por ambas partes.

### Validaciones y reglas de negocio
- Las notificaciones se envían solo cuando el estado es "Firmado por ambas partes".
- Tanto cliente como ONGAKU deben ser notificados (ambos canales según configuración).
- El contrato no se activa como proyecto en esta historia; eso corresponde a EP-010.

### Criterios BDD
- **Escenario 1: Notificaciones enviadas a cliente y ONGAKU**
  - *Dado* un contrato que acaba de pasar a "Firmado por ambas partes"
  - *Cuando* el sistema procesa las notificaciones
  - *Entonces* el cliente recibe notificación (email o portal) y ONGAKU recibe notificación (email o sistema), ambas indicando que el contrato está completamente firmado

- **Escenario 2: Contrato listo para EP-010**
  - *Dado* un contrato en "Firmado por ambas partes" y notificaciones enviadas
  - *Cuando* se consulta el contrato o el flujo de activación
  - *Entonces* el contrato está disponible para el proceso de activación de proyecto (EP-010)

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-009-gestion-firmas-digitales.md`
- Paso(s): Paso 10 del flujo principal (notificación automática a cliente y ONGAKU de contrato completamente firmado); contrato disponible para TO-BE-010.
