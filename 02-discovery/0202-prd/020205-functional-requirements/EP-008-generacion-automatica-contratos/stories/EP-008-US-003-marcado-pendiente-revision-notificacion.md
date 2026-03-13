# EP-008-US-003 — Marcado Pendiente de revisión y notificación

### Epic padre
EP-008 — Generación automática de contratos

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** marcar el contrato como "Pendiente de revisión" y notificar a Fátima/Paz que está listo para revisión,  
**para** que nadie envíe el contrato sin revisión previa.

### Alcance
**Incluye:**
- Cambio de estado del contrato a "Pendiente de revisión" tras la personalización (EP-008-US-002).
- Regla de negocio: no se puede enviar el contrato al cliente mientras no esté en estado "Aprobado".
- Notificación a Fátima/Paz (según línea de negocio y permisos): contrato listo para revisión, con enlace directo al contrato y resumen de datos personalizados.
- Listado o dashboard donde Fátima/Paz ve contratos pendientes de revisión.

**Excluye:**
- Revisión y edición del contenido (EP-008-US-004).
- Aprobación y envío (EP-008-US-005).

### Precondiciones
- Contrato generado y personalizado (EP-008-US-001, EP-008-US-002).
- Contrato en estado "Borrador" o equivalente tras personalización.
- Fátima/Paz tienen permisos y canal de notificación configurado.

### Postcondiciones
- Contrato en estado "Pendiente de revisión".
- Fátima/Paz han recibido notificación y pueden acceder al contrato para revisar (EP-008-US-004).
- El sistema no permite enviar el contrato al cliente hasta que pase a "Aprobado" (EP-008-US-005).

### Flujo principal
1. Tras personalizar el contrato (EP-008-US-002), el sistema actualiza el estado del contrato a "Pendiente de revisión".
2. Sistema comprueba que la regla "no enviar sin Aprobado" está activa (bloqueo de envío si estado ≠ Aprobado).
3. Sistema envía notificación a Fátima/Paz (según línea de negocio del contrato): "Contrato listo para revisión", con enlace al contrato y resumen (cliente, servicios, precio).
4. Fátima/Paz pueden ver el contrato en el listado de "Pendientes de revisión" y abrirlo para revisar y editar (EP-008-US-004).

### Flujos alternos y excepciones

**Excepción 1: Notificación fallida**
- Si la notificación no se puede enviar (ej. usuario sin email):
- El contrato sigue en "Pendiente de revisión"; Fátima/Paz pueden verlo en el dashboard al entrar al sistema.

**Excepción 2: Múltiples revisores**
- Si tanto Fátima como Paz pueden revisar según línea de negocio:
- La notificación se envía a los responsables de esa línea (configuración por rol/línea).

### Validaciones y reglas de negocio
- Contrato solo puede pasar a "Aprobado" por acción explícita de Fátima/Paz (EP-008-US-005).
- Contrato en "Pendiente de revisión" no puede ser enviado al cliente; el botón/acción de envío debe estar deshabilitado o requerir primero aprobación.

### Criterios BDD
- **Escenario 1: Marcado y notificación correctos**
  - *Dado* que un contrato acaba de ser personalizado
  - *Cuando* el sistema ejecuta el marcado y notificación
  - *Entonces* el contrato pasa a "Pendiente de revisión", Fátima/Paz reciben notificación con enlace y el sistema no permite envío al cliente

- **Escenario 2 (negativo): Envío bloqueado sin aprobación**
  - *Dado* que un contrato está en "Pendiente de revisión"
  - *Cuando* un usuario intenta enviar el contrato al cliente
  - *Entonces* el sistema no permite el envío y muestra que debe aprobarse antes

### Notificaciones
- **Fátima/Paz:** Notificación "Contrato listo para revisión" con enlace al contrato y resumen de datos (cliente, servicios, precio).

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-008-generacion-automatica-contratos.md`
- Paso(s): Pasos 4–5 del flujo principal (marcado Pendiente de revisión, notificación a Fátima/Paz).
