# EP-023 — Solicitud automática de feedback

**Descripción:** Envío automático de solicitud de valoración tras aceptación de segunda entrega, seguimiento de completitud, recordatorios si no se completa e integración con Google para publicación de valoraciones.

**Proceso TO-BE origen:** TO-BE-023: Proceso de solicitud automática de feedback

**Bloque funcional:** Solicitud y seguimiento — Desde aceptación de segunda entrega hasta feedback recibido o timeout.

**Objetivo de negocio:** Solicitar automáticamente feedback al cliente tras aceptación, hacer seguimiento y recordatorios, e integrar con Google para valoraciones (objetivo 5 estrellas).

**Alcance y exclusiones:**
- **Incluye:**
  - Solicitud automática de feedback al cliente tras aceptación de segunda entrega (EP-021); enlace a formulario o portal de valoración.
  - Seguimiento de completitud (cliente ha completado o no); recordatorios automáticos si no se completa en tiempo razonable.
  - Integración con Google para publicación de valoraciones (enlace o formulario).
  - Registro de feedback recibido (valoración, comentarios) para EP-024 y reportes.
- **Excluye:**
  - Incorporación de cambios y segunda entrega (EP-021).
  - Cierre automático de proyecto (EP-024) — puede incluir feedback recibido.
  - Publicación en Google (gestión externa).

**KPIs (éxito):**
- 100% de clientes reciben solicitud automática de feedback.
- Seguimiento de completitud; recordatorios automáticos si no se completa.
- Integración con Google para valoraciones; objetivo valoración 5 estrellas.

**Actores y permisos (RBAC):**
- **Sistema centralizado:** Enviar solicitud, hacer seguimiento, enviar recordatorios.
- **Cliente:** Completar feedback y publicar valoración (Google si aplica).
- **Equipo comercial:** Revisar feedback recibido.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-023-solicitud-automatica-feedback.md`

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-023-US-001 | Solicitud automática de feedback tras aceptación segunda entrega | Como sistema centralizado, quiero enviar automáticamente solicitud de feedback al cliente cuando acepta la segunda entrega (EP-021), para que el cliente pueda valorar el servicio | Definida | Alta |
| EP-023-US-002 | Enlace a formulario o portal de valoración e integración Google | Como cliente, quiero recibir un enlace al formulario o portal de valoración (e integración con Google si aplica), para poder completar el feedback y publicar valoración | Definida | Alta |
| EP-023-US-003 | Seguimiento de completitud de feedback | Como sistema centralizado, quiero hacer seguimiento de si el cliente ha completado el feedback (completado o no), para saber si enviar recordatorios | Definida | Alta |
| EP-023-US-004 | Recordatorios automáticos si no se completa feedback | Como sistema centralizado, quiero enviar recordatorios automáticos al cliente si no completa el feedback en tiempo razonable, para aumentar la tasa de respuesta | Definida | Alta |
| EP-023-US-005 | Registro de feedback recibido | Como sistema centralizado, quiero registrar el feedback recibido (valoración, comentarios) cuando el cliente lo completa, para EP-024 y reportes | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`
