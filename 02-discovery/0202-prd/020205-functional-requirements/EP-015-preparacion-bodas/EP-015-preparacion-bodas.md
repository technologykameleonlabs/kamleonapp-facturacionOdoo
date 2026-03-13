# EP-015 — Preparación de bodas

**Descripción:** Digitalización del formulario de novios con acceso desde portal, coordinación de reunión previa 10 días antes de la boda, definición y bloqueo automático de música para teaser y película, confirmación de horarios y detalles logísticos.

**Proceso TO-BE origen:** TO-BE-015: Proceso de preparación de bodas (formulario y reunión previa)

**Bloque funcional:** Formulario digital y reunión previa — Desde fecha reservada hasta reunión previa completada con todos los detalles confirmados.

**Objetivo de negocio:** Digitalizar la preparación de bodas, garantizar que novios completen formulario y que música quede definida y bloqueada antes del día de la boda.

**Alcance y exclusiones:**
- **Incluye:**
  - Notificación automática a novios 10 días antes de boda para completar formulario (enlace al portal, recordatorio reunión previa).
  - Formulario digital en portal: ceremonia (hora, ubicación), horarios (inicio, ceremonia, fiesta), ubicaciones (domicilio novios, ceremonia, fiesta), preferencias y características especiales.
  - Programación automática de reunión previa 10 días antes; notificación a Paz y novios; convocatoria.
  - Reunión previa: Paz revisa formulario, confirma horarios y detalles, define música para teaser y película.
  - Bloqueo automático de música (sin cambios posteriores); registro de todos los detalles confirmados.
- **Excluye:**
  - Reserva de fecha (EP-011).
  - Gestión del día de la boda (EP-016).
  - Agendamiento de reuniones comerciales (EP-004).

**KPIs (éxito):**
- 100% de novios completan formulario digital.
- Reunión previa agendada 10 días antes de boda.
- Música definida y bloqueada antes de boda.
- Horarios y detalles logísticos confirmados.
- Tiempo de completar formulario < 15 minutos.

**Actores y permisos (RBAC):**
- **Novios:** Completar formulario en portal; asistir a reunión previa.
- **Paz (responsable línea Bodas):** Coordinar reunión previa; revisar formulario; confirmar detalles; definir música.
- **Sistema centralizado:** Notificar, programar reunión, bloquear música, registrar detalles.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-015-preparacion-bodas.md`
- Pasos: 1–10 del flujo principal.

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-015-US-001 | Notificación a novios 10 días antes para completar formulario | Como sistema centralizado, quiero notificar automáticamente a novios 10 días antes de la boda para completar el formulario digital (enlace al portal, recordatorio de reunión previa), para que novios tengan tiempo de preparar y completar los datos | Definida | Alta |
| EP-015-US-002 | Formulario digital en portal (novios completan detalles) | Como novio/novia, quiero acceder al formulario digital desde el portal de cliente y completar los detalles (ceremonia, horarios, ubicaciones, preferencias), para que ONGAKU tenga toda la información para el día de la boda en menos de 15 minutos | Definida | Alta |
| EP-015-US-003 | Programación automática reunión previa y notificación | Como sistema centralizado, quiero programar automáticamente la reunión previa 10 días antes de la boda y notificar a Paz y a novios con convocatoria, para que la reunión quede agendada sin coordinación manual | Definida | Alta |
| EP-015-US-004 | Reunión previa: Paz revisa formulario, confirma detalles y define música | Como Paz, quiero revisar el formulario completado por novios antes de la reunión previa y, en la reunión, confirmar horarios y detalles y definir la música para teaser y película, para que todo quede confirmado y la música definida antes del día de la boda | Definida | Alta |
| EP-015-US-005 | Bloqueo automático de música y registro de detalles confirmados | Como sistema centralizado, quiero bloquear automáticamente la música definida en la reunión previa (sin cambios posteriores) y registrar todos los detalles confirmados (formulario, música, horarios, logística), para que estén disponibles para el día de la boda (EP-016) | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Formulario boda:** Ceremonia (hora, ubicación), horarios (inicio, ceremonia, fiesta), ubicaciones (domicilio novios, ceremonia, fiesta), preferencias.
- **Música bloqueada:** Teaser, película; sin cambios posteriores tras reunión previa.
- **Reunión previa:** 10 días antes de boda; Paz + novios.

### Reglas de numeración/ID específicas
- Formulario y música vinculados por proyecto_id (boda).
