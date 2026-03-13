# EP-008-US-004 — Revisión y edición manual del contrato

### Epic padre
EP-008 — Generación automática de contratos

### Contexto/Descripción y valor
**Como** Fátima/Paz,  
**quiero** revisar el contrato generado y poder editar cualquier campo o añadir/modificar condiciones excepcionales antes de aprobar,  
**para** corregir casos especiales sin regenerar todo el documento.

### Alcance
**Incluye:**
- Vista de detalle del contrato (contenido completo, datos personalizados, plantilla usada).
- Editor de contrato: modificar campos de texto (nombre cliente, servicios, precio, fechas, condiciones excepcionales).
- Posibilidad de añadir o modificar el apartado de condiciones excepcionales (apartado 4 bodas u otras secciones).
- Validación básica antes de guardar (campos obligatorios si se definen).
- Guardado de cambios; contrato sigue en "Pendiente de revisión" hasta que se apruebe.
- Acción "Aprobar contrato" que cambia el estado a "Aprobado" (listo para enviar en EP-008-US-005).

**Excluye:**
- Generación o personalización automática (EP-008-US-001, EP-008-US-002).
- Envío del contrato al cliente (EP-008-US-005).

### Precondiciones
- Contrato en estado "Pendiente de revisión" (EP-008-US-003).
- Fátima/Paz tiene permisos para editar contratos según línea de negocio.
- Usuario está autenticado.

### Postcondiciones
- Contrato revisado y, si aplica, editado y guardado.
- Contrato sigue en "Pendiente de revisión" hasta que el usuario ejecute "Aprobar" (EP-008-US-005).
- Tras aprobar, contrato pasa a "Aprobado" y queda listo para envío.

### Flujo principal
1. Fátima/Paz accede al listado de contratos pendientes de revisión o al contrato desde la notificación.
2. Sistema muestra el contrato con todos los campos y secciones (datos personalizados, condiciones excepcionales).
3. Fátima/Paz revisa el contenido.
4. Si requiere cambios:
   - Fátima/Paz edita campos en el editor (nombre, servicios, precio, condiciones excepcionales, etc.).
   - Sistema guarda los cambios y mantiene el estado "Pendiente de revisión".
5. Cuando el contenido es correcto, Fátima/Paz ejecuta la acción "Aprobar contrato".
6. Sistema cambia el estado del contrato a "Aprobado"; contrato queda listo para enviar (EP-008-US-005).

### Flujos alternos y excepciones

**Flujo alterno 1: No requiere edición**
- Si Fátima/Paz considera que el contrato está correcto:
- No edita nada y aprueba directamente (paso 5–6).

**Excepción 1: Campos obligatorios vacíos**
- Si tras editar quedan campos obligatorios vacíos y el sistema los valida:
- Sistema no permite aprobar hasta completar o confirma advertencia según reglas de negocio.

**Excepción 2: Sin permisos para editar**
- Si el usuario no tiene permisos para editar ese contrato:
- Sistema muestra solo vista de solo lectura; la aprobación puede estar restringida por rol/línea.

### Validaciones y reglas de negocio
- Solo usuarios con rol Fátima/Paz (o equivalente) pueden aprobar contratos según línea de negocio.
- Contrato en "Aprobado" no debe poder volver a "Pendiente de revisión" salvo flujo excepcional de anulación si se define.

### Criterios BDD
- **Escenario 1: Edición y aprobación**
  - *Dado* que Fátima tiene un contrato pendiente de revisión abierto
  - *Cuando* edita las condiciones excepcionales y aprueba el contrato
  - *Entonces* el sistema guarda los cambios, cambia el estado a "Aprobado" y el contrato queda listo para enviar

- **Escenario 2: Aprobación sin edición**
  - *Dado* que Paz tiene un contrato pendiente de revisión
  - *Cuando* revisa y aprueba sin modificar nada
  - *Entonces* el sistema cambia el estado a "Aprobado" y el contrato queda listo para enviar

- **Escenario 3 (negativo): Sin permisos**
  - *Dado* que un usuario sin permiso de edición abre el contrato
  - *Entonces* el sistema muestra solo lectura y no permite aprobar (o solo permite según política)

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-008-generacion-automatica-contratos.md`
- Paso(s): Pasos 6–8 del flujo principal (revisión, edición manual, aprobación).
