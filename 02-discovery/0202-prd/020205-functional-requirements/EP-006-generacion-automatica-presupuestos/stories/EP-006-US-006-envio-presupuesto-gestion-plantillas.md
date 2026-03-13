# EP-006-US-006 — Envío del presupuesto al cliente y gestión de plantillas

### Epic padre
EP-006 — Generación automática de presupuestos

### Contexto/Descripción y valor
**Como** Fátima/Paz,  
**quiero** enviar el presupuesto aprobado al cliente mediante acción explícita (email o portal),  
**y como** administrador  
**quiero** gestionar plantillas de presupuesto y precios (CRUD),  
**para** cerrar el ciclo de presupuesto y tener plantillas y precios actualizados.

### Alcance
**Incluye (envío al cliente):**
- Acción "Enviar presupuesto al cliente" solo para presupuestos en estado "Aprobado".
- Envío por email al cliente (destinatario: email del lead) con presupuesto adjunto o enlace a portal.
- Opción de envío mediante portal (cliente accede con enlace único para ver presupuesto).
- Registro de envío (timestamp, destinatario, método).
- Cambio de estado del presupuesto a "Enviado" tras envío exitoso.
- Presupuesto queda disponible para negociación (EP-007).

**Incluye (gestión de plantillas y precios):**
- CRUD de plantillas de presupuesto (Corporativo: packs; Bodas: servicios, provincia, extras).
- CRUD de precios asociados a conceptos (servicios, extras, desplazamientos por provincia).
- Asociación plantilla–precios y estructura de líneas (descripción, precio por defecto).
- Validación básica (plantilla con al menos una línea; precios numéricos).

**Excluye:**
- Negociación de presupuestos / contrapropuestas (EP-007).
- Generación automática desde plantilla (EP-006-US-001).

### Precondiciones (envío)
- Presupuesto en estado "Aprobado" (EP-006-US-005).
- Email del lead válido (para envío por email).
- Fátima/Paz tiene permisos para enviar presupuestos.

### Precondiciones (gestión plantillas)
- Usuario con rol administrador (o permisos de gestión de plantillas).
- Estructura de plantillas y precios definida.

### Postcondiciones (envío)
- Presupuesto enviado al cliente por el método elegido (email o portal).
- Presupuesto en estado "Enviado".
- Registro de envío con timestamp y destinatario.
- Presupuesto disponible para negociación (EP-007).

### Postcondiciones (gestión plantillas)
- Plantilla o precios creados/actualizados/eliminados según acción.
- Cambios aplicados a futuras generaciones de presupuestos.

### Flujo principal (envío al cliente)
1. Fátima/Paz accede al presupuesto aprobado (listado "Listos para enviar" o detalle).
2. Fátima/Paz hace clic en "Enviar presupuesto al cliente".
3. Sistema valida que el presupuesto está en estado "Aprobado".
4. Sistema muestra opciones: Enviar por email / Generar enlace para portal.
5. Si envío por email:
   - Sistema prepara email con presupuesto (PDF adjunto o enlace a vista).
   - Sistema envía email al destinatario (email del lead).
6. Si enlace portal:
   - Sistema genera enlace único para que el cliente vea el presupuesto.
   - Fátima/Paz copia/comparte el enlace con el cliente.
7. Sistema registra envío (timestamp, destinatario, método).
8. Sistema cambia estado del presupuesto a "Enviado".
9. Presupuesto queda disponible para negociación (EP-007).

### Flujo principal (gestión de plantillas)
1. Administrador accede a configuración de plantillas de presupuesto.
2. Administrador puede:
   - Crear nueva plantilla (nombre, línea de negocio, estructura de líneas, precios por defecto).
   - Editar plantilla existente (añadir/quitar líneas, actualizar precios por defecto).
   - Eliminar o desactivar plantilla (con validación: no en uso por presupuestos recientes).
3. Administrador accede a configuración de precios (conceptos: servicios, extras, provincias).
4. Administrador puede crear/editar/eliminar precios por concepto.
5. Sistema valida coherencia (plantillas referencian conceptos con precio).
6. Cambios se aplican a futuras generaciones de presupuestos.

### Flujos alternos y excepciones

**Excepción 1 (envío): Presupuesto no aprobado**
- Si se intenta enviar un presupuesto que no está "Aprobado":
- Sistema no permite el envío y muestra mensaje: "Debe aprobar el presupuesto antes de enviarlo."

**Excepción 2 (envío): Email del lead inválido**
- Si el email del lead está vacío o es inválido:
- Sistema muestra error y pide corregir el email del lead o usar otro método (enlace portal).

**Excepción 3 (gestión): Eliminar plantilla en uso**
- Si se intenta eliminar una plantilla usada por presupuestos recientes:
- Sistema muestra advertencia y puede bloquear eliminación o permitir desactivación.

### Validaciones y reglas de negocio
- Solo presupuestos "Aprobado" pueden enviarse al cliente.
- Envío es siempre acción explícita; no hay envío automático.
- Plantillas deben tener al menos una línea y precios coherentes para generación automática.

### Criterios BDD
- **Escenario 1: Envío exitoso por email**
  - *Dado* que un presupuesto está aprobado y el lead tiene email válido
  - *Cuando* Fátima selecciona "Enviar por email" y confirma
  - *Entonces* el sistema envía el email al cliente, registra el envío, cambia el estado a "Enviado" y el presupuesto queda disponible para negociación

- **Escenario 2 (negativo): Envío sin aprobar**
  - *Dado* que un presupuesto está en estado "Pendiente de aprobación"
  - *Cuando* Paz intenta enviar el presupuesto al cliente
  - *Entonces* el sistema no permite el envío y muestra mensaje indicando que debe aprobarse antes

- **Escenario 3: Crear plantilla de presupuesto**
  - *Dado* que un administrador accede a la gestión de plantillas
  - *Cuando* crea una nueva plantilla con nombre, línea de negocio y líneas con precios
  - *Entonces* el sistema guarda la plantilla y la hace disponible para la generación automática de presupuestos

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-006-generacion-automatica-presupuestos.md`
- Paso(s): Paso 9 del flujo principal (Fátima/Paz envía presupuesto al cliente); gestión de plantillas y precios (soporte del proceso).
