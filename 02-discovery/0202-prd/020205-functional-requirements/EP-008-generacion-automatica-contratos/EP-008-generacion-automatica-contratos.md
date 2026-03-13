# EP-008 — Generación automática de contratos

**Descripción:** Creación automática de contrato personalizado desde plantilla (Anexo 4 bodas, plantilla corporativa), rellenando datos del cliente, condiciones del servicio, precio y condiciones excepcionales, con edición manual permitida por ONGAKU antes de enviar al cliente.

**Proceso TO-BE origen:** TO-BE-008: Proceso de generación automática de contratos

**Bloque funcional:** Generación desde plantillas — Desde presupuesto aceptado hasta contrato editado y listo para enviar (no se envía automáticamente).

**Objetivo de negocio:** Acelerar la generación de contratos y eliminar olvidos de cambios, generando automáticamente desde plantilla con datos del presupuesto aceptado y permitiendo revisión/edición manual antes de enviar.

**Alcance y exclusiones:**
- **Incluye:**
  - Detección automática cuando un presupuesto pasa a "Aceptado" (EP-007).
  - Generación automática del contrato desde plantilla según línea de negocio (Bodas: Anexo 4; Corporativo: plantilla corporativa).
  - Personalización con datos del presupuesto aceptado (cliente, servicios, precio, condiciones excepcionales).
  - Marcado del contrato como "Pendiente de revisión" y notificación a Fátima/Paz.
  - Revisión y edición manual por Fátima/Paz (campos, condiciones excepcionales).
  - Aprobación del contrato (estado "Aprobado"); contrato listo para enviar.
  - Envío del contrato al cliente por acción explícita (no automático); listo para EP-009 (firma digital).
- **Excluye:**
  - Negociación de presupuestos (EP-007).
  - Gestión de firmas digitales (EP-009).
  - Envío automático sin revisión de ONGAKU.

**KPIs (éxito):**
- 100% de contratos generados automáticamente desde plantilla.
- Tiempo de generación < 2 minutos desde presupuesto aceptado.
- 0% de contratos enviados sin revisión/aprobación de ONGAKU.

**Actores y permisos (RBAC):**
- **Sistema centralizado:** Generar contrato desde plantilla, personalizar, marcar Pendiente de revisión, notificar.
- **Fátima/Paz:** Revisar contrato generado, editar manualmente si es necesario, aprobar, enviar al cliente (según línea de negocio y permisos).
- **Cliente:** Recibe contrato solo tras envío explícito por ONGAKU.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-008-generacion-automatica-contratos.md`
- Bloque funcional: Generación desde plantillas con edición manual permitida.
- Pasos: 1–9 del flujo principal (presupuesto aceptado hasta contrato enviado).

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-008-US-001 | Generación automática desde plantilla | Como sistema centralizado, quiero generar automáticamente un contrato desde la plantilla correspondiente (Bodas: Anexo 4; Corporativo: plantilla corporativa) cuando un presupuesto pasa a Aceptado, para tener el contrato listo en menos de 2 minutos | Definida | Alta |
| EP-008-US-002 | Personalización con datos del presupuesto aceptado | Como sistema centralizado, quiero personalizar el contrato generado con los datos del presupuesto aceptado (cliente, servicios, precio acordado, condiciones excepcionales), para que el documento refleje exactamente lo acordado | Definida | Alta |
| EP-008-US-003 | Marcado Pendiente de revisión y notificación | Como sistema centralizado, quiero marcar el contrato como "Pendiente de revisión" y notificar a Fátima/Paz que está listo para revisión, para que nadie envíe el contrato sin revisión previa | Definida | Alta |
| EP-008-US-004 | Revisión y edición manual del contrato | Como Fátima/Paz, quiero revisar el contrato generado y poder editar cualquier campo o añadir/modificar condiciones excepcionales antes de aprobar, para corregir casos especiales sin regenerar todo el documento | Definida | Alta |
| EP-008-US-005 | Aprobación y envío del contrato al cliente | Como Fátima/Paz, quiero aprobar el contrato (marcándolo como Aprobado) y enviarlo al cliente por acción explícita, para que el contrato quede listo para firma digital (EP-009) sin enviarse nunca sin revisión | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Plantilla de contrato:** Bodas = Anexo 4; Corporativo = plantilla corporativa configurada.
- **Estado de contrato:** Borrador/En generación, Pendiente de revisión, Aprobado, Enviado.
- **Condiciones excepcionales:** Apartado 4 (bodas) o secciones equivalentes; opcional.

### Reglas de numeración/ID específicas
- Formato de contrato: `CONT-{ID_PRESUPUESTO}` o según convención del proyecto.
