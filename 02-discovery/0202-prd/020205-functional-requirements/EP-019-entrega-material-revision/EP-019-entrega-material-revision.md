# EP-019 — Entrega de material para revisión

**Descripción:** Publicación automática de material editado/postproducido en portal de cliente con visualización integrada (vídeo embebido sin salir de página), notificación automática al cliente y registro de fecha de entrega.

**Proceso TO-BE origen:** TO-BE-019: Proceso de entrega de material para revisión

**Bloque funcional:** Publicación en portal integrado — Desde material listo hasta publicación en portal y notificación al cliente.

**Objetivo de negocio:** Publicar material en portal integrado con visualización directa, notificar automáticamente al cliente y registrar la entrega para EP-020 (comentarios).

**Alcance y exclusiones:**
- **Incluye:**
  - Responsable/equipo marca material como "Listo para entrega"; publicación en portal de cliente.
  - Visualización integrada (vídeo embebido sin salir de página); galería integrada.
  - Notificación automática al cliente (material disponible, enlace al portal).
  - Registro de fecha de entrega; material disponible para comentarios (EP-020).
- **Excluye:**
  - Material editado en sí (postproducción).
  - Gestión de comentarios (EP-020).
  - Incorporación de cambios y segunda entrega (EP-021).

**KPIs (éxito):**
- 100% de material publicado automáticamente en portal.
- Visualización integrada sin salir de página.
- Notificación automática al cliente.
- Registro de fecha de entrega; tiempo de publicación < 5 minutos.

**Actores y permisos (RBAC):**
- **Responsable del proyecto / Equipo de postproducción:** Marcar material listo, publicar en portal.
- **Cliente:** Acceder a material en portal.
- **Sistema centralizado:** Publicar, notificar, registrar fecha entrega.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-019-entrega-material-revision.md`

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-019-US-001 | Marcar material listo para entrega y publicar en portal | Como responsable o equipo de postproducción, quiero marcar el material como "Listo para entrega" y publicarlo en el portal de cliente, para que el cliente pueda verlo sin salir de página | Definida | Alta |
| EP-019-US-002 | Visualización integrada (vídeo embebido) en portal | Como cliente, quiero ver el material en el portal con visualización integrada (vídeo embebido sin salir de página), para una experiencia fluida de revisión | Definida | Alta |
| EP-019-US-003 | Notificación automática al cliente cuando material publicado | Como sistema centralizado, quiero notificar automáticamente al cliente cuando el material está publicado en el portal (enlace al portal), para que sepa que puede revisar | Definida | Alta |
| EP-019-US-004 | Registro de fecha de entrega | Como sistema centralizado, quiero registrar la fecha de entrega cuando el material se publica en el portal, para trazabilidad y plazos de comentarios (EP-020) | Definida | Alta |
| EP-019-US-005 | Cliente accede a material en portal | Como cliente, quiero acceder al portal para ver el material entregado y poder hacer comentarios (EP-020), para revisar y solicitar modificaciones si aplica | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`
