# EP-021 — Incorporación de cambios y segunda entrega

**Descripción:** Notificación automática al responsable cuando hay comentarios, seguimiento de incorporación de cambios, publicación de segunda entrega en galería corporativa (estilo Vidflow), notificación al cliente y aceptación de segunda entrega para EP-022 y EP-023.

**Proceso TO-BE origen:** TO-BE-021: Proceso de incorporación de cambios y segunda entrega

**Bloque funcional:** Seguimiento y galería corporativa — Desde comentarios registrados hasta segunda entrega publicada y notificada.

**Objetivo de negocio:** Incorporar cambios según comentarios, publicar segunda entrega en galería integrada (estilo Vidflow) y notificar al cliente para EP-022 (factura final) y EP-023 (feedback).

**Alcance y exclusiones:**
- **Incluye:**
  - Notificación automática al responsable cuando hay comentarios (EP-020); responsable/equipo incorpora cambios según comentarios.
  - Seguimiento de incorporación de cambios (estado: en curso, listo).
  - Publicación de segunda entrega en galería corporativa estilo Vidflow; notificación automática al cliente cuando segunda entrega está lista.
  - Cliente acepta segunda entrega en portal; disparo para EP-022 (factura final) y EP-023 (feedback).
- **Excluye:**
  - Gestión de comentarios (EP-020).
  - Generación factura final (EP-022).
  - Solicitud de feedback (EP-023).

**KPIs (éxito):**
- 100% de modificaciones incorporadas según comentarios.
- Segunda entrega publicada en galería corporativa.
- Notificación automática al cliente.
- Tiempo de incorporación según complejidad.

**Actores y permisos (RBAC):**
- **Responsable del proyecto / Equipo de postproducción:** Incorporar cambios, publicar segunda entrega.
- **Cliente:** Recibir notificación, ver segunda entrega en galería, aceptar segunda entrega.
- **Sistema centralizado:** Notificar, seguir incorporación, publicar, notificar aceptación.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-021-incorporacion-cambios-segunda-entrega.md`

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-021-US-001 | Notificación al responsable cuando hay comentarios | Como sistema centralizado, quiero notificar automáticamente al responsable cuando el cliente hace comentarios (EP-020), para que pueda coordinar la incorporación de cambios | Definida | Alta |
| EP-021-US-002 | Responsable/equipo incorpora cambios según comentarios | Como responsable o equipo de postproducción, quiero incorporar los cambios según los comentarios registrados (EP-020), para preparar la segunda entrega | Definida | Alta |
| EP-021-US-003 | Seguimiento de incorporación de cambios | Como responsable o sistema, quiero ver el estado de incorporación de cambios (en curso, listo), para coordinar y saber cuándo publicar segunda entrega | Definida | Alta |
| EP-021-US-004 | Publicar segunda entrega en galería Vidflow | Como responsable o equipo, quiero publicar la segunda entrega en galería corporativa estilo Vidflow en el portal, para que el cliente la vea en formato integrado | Definida | Alta |
| EP-021-US-005 | Notificación al cliente cuando segunda entrega lista | Como sistema centralizado, quiero notificar automáticamente al cliente cuando la segunda entrega está publicada (enlace al portal), para que sepa que puede revisar y aceptar | Definida | Alta |
| EP-021-US-006 | Cliente acepta segunda entrega en portal | Como cliente, quiero ver la segunda entrega en el portal y aceptarla explícitamente, para que el proyecto quede listo para factura final (EP-022) y feedback (EP-023) | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`
