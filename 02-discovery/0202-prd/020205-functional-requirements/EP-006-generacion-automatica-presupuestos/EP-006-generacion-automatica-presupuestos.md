# EP-006 — Generación automática de presupuestos

**Descripción:** Motor que genera automáticamente presupuestos desde plantillas configuradas (packs por sector corporativo, servicios bodas) con personalización según datos capturados en reunión, permitiendo a ONGAKU modificar y aprobar antes de enviar al cliente. No se envía automáticamente sin aprobación.

**Proceso TO-BE origen:** TO-BE-006: Proceso de generación automática de presupuestos

**Bloque funcional:** Generación desde plantillas — Flujo completo desde información de reunión completada hasta presupuesto aprobado por ONGAKU y listo para enviar (el envío al cliente es acción explícita).

**Objetivo de negocio:** Eliminar la generación manual lenta y propensa a errores, generando automáticamente presupuestos desde plantillas en menos de 5 minutos tras la reunión, manteniendo el control de ONGAKU mediante aprobación obligatoria antes de enviar y permitiendo modificación si es necesario.

**Alcance y exclusiones:**
- **Incluye:**
  - Detección de reunión completada (trigger desde EP-005).
  - Generación automática desde plantillas según línea de negocio (Corporativo: packs por sector; Bodas: servicios, provincia, extras).
  - Personalización con datos capturados en reunión (cliente, servicios, extras, precios actualizados).
  - Marcado como "Pendiente de aprobación" y notificación a Fátima/Paz.
  - Revisión y modificación del presupuesto por Fátima/Paz (editor, recalcular totales).
  - Aprobación del presupuesto (marcar como "Aprobado"); no se envía automáticamente.
  - Envío del presupuesto al cliente (acción explícita de Fátima/Paz).
  - Gestión de plantillas de presupuesto (CRUD) y precios.
- **Excluye:**
  - Negociación de presupuestos / contrapropuestas (EP-007).
  - Generación de contratos (EP-008).
  - Registro de información durante reunión (EP-005).

**KPIs (éxito):**
- 100% de presupuestos generados automáticamente desde plantillas.
- Tiempo de generación < 5 minutos desde reunión completada.
- 0% de presupuestos enviados sin aprobación de ONGAKU.
- Personalización correcta con datos capturados en reunión.

**Actores y permisos (RBAC):**
- **Sistema centralizado:** Genera presupuesto automáticamente, marca Pendiente de aprobación, notifica (proceso automático).
- **Fátima/Paz:** Revisar, modificar y aprobar presupuestos; enviar presupuesto al cliente (lectura/escritura en presupuestos según línea de negocio).
- **Usuario administrador (opcional):** Gestión de plantillas y precios (CRUD).
- **Cliente potencial:** Recibe presupuesto solo tras envío explícito por ONGAKU.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-006-generacion-automatica-presupuestos.md`
- Bloque funcional: Generación desde plantillas con personalización y aprobación de ONGAKU.
- Pasos: 1–9 del flujo principal (detección reunión completada hasta envío al cliente).

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-006-US-001 | Generación automática desde plantilla según reunión | Como sistema centralizado, quiero generar automáticamente un presupuesto desde la plantilla correspondiente (Corporativo: pack; Bodas: servicios, provincia, extras) cuando una reunión pasa a Completada, para tener el presupuesto listo en menos de 5 minutos sin pasos manuales | Pendiente | Alta |
| EP-006-US-002 | Personalización del presupuesto con datos de reunión | Como sistema centralizado, quiero personalizar el presupuesto generado con los datos capturados en reunión (cliente, servicios, extras, precios actualizados) y calcular totales automáticamente, para que el presupuesto refleje exactamente lo acordado | Pendiente | Alta |
| EP-006-US-003 | Marcado Pendiente de aprobación y notificación | Como sistema centralizado, quiero marcar el presupuesto como "Pendiente de aprobación" y notificar a Fátima/Paz con enlace al presupuesto y resumen, para que revisen y aprueben antes de enviar al cliente | Pendiente | Alta |
| EP-006-US-004 | Revisión y modificación del presupuesto por ONGAKU | Como Fátima/Paz, quiero revisar el presupuesto generado y poder modificar precios, servicios o notas, con recálculo automático de totales, para ajustar el presupuesto antes de aprobar | Pendiente | Alta |
| EP-006-US-005 | Aprobación del presupuesto | Como Fátima/Paz, quiero aprobar el presupuesto para dejarlo listo para enviar al cliente, sin que se envíe automáticamente, para mantener el control sobre qué presupuestos se envían y cuándo | Pendiente | Alta |
| EP-006-US-006 | Envío del presupuesto al cliente y gestión de plantillas | Como Fátima/Paz, quiero enviar el presupuesto aprobado al cliente mediante acción explícita (email o portal), y como administrador quiero gestionar plantillas de presupuesto y precios (CRUD), para cerrar el ciclo y tener plantillas actualizadas | Pendiente | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Presupuesto:** Documento con servicios, precios y total, vinculado a lead y reunión.
- **Plantilla de presupuesto:** Estructura base (packs corporativos, servicios bodas) con variables y precios por defecto.
- **Estado de presupuesto:** Borrador, Pendiente de aprobación, Aprobado, Enviado, Rechazado.
- **Pack (Corporativo):** Conjunto de servicios predefinido por sector (colegios, empresas).

### Reglas de numeración/ID específicas
- Formato de ID de presupuesto: `PRES-{ID_REUNION}-{VERSION}`

### Mockups o enlaces a UI
- [Pendiente de diseño] Listado de presupuestos pendientes de aprobación.
- [Pendiente de diseño] Vista/editor de presupuesto con opciones de modificación.
- [Pendiente de diseño] Configuración de plantillas y precios.
