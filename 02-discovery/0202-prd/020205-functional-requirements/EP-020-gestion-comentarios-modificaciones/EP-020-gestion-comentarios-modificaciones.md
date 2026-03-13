# EP-020 — Gestión de comentarios y modificaciones

**Descripción:** Sistema centralizado de comentarios (chat/foro integrado) en portal de cliente, indicaciones por minuto (corporativo) o por escrito, control automático de límites de modificaciones (3 corporativo, 2 bodas), notificaciones automáticas al responsable y registro estructurado.

**Proceso TO-BE origen:** TO-BE-020: Proceso de gestión de comentarios y modificaciones

**Bloque funcional:** Sistema centralizado de comentarios — Desde material entregado hasta comentarios registrados y listos para incorporación (EP-021).

**Objetivo de negocio:** Centralizar comentarios del cliente, controlar límites de modificaciones y notificar automáticamente al responsable para EP-021.

**Alcance y exclusiones:**
- **Incluye:**
  - Cliente hace comentarios en portal (indicaciones por minuto en vídeo — corporativo — o por escrito); sistema registra comentarios centralizadamente.
  - Control automático de límites de modificaciones: 3 rondas corporativo, 2 bodas; aviso cuando se alcanza o supera el límite.
  - Notificación automática al responsable cuando el cliente hace comentarios.
  - Responsable gestiona y responde comentarios; registro estructurado de comentarios.
- **Excluye:**
  - Entrega de material (EP-019).
  - Incorporación de cambios y segunda entrega (EP-021).

**KPIs (éxito):**
- 100% de comentarios registrados centralizadamente.
- Control automático de límites de modificaciones.
- Notificaciones automáticas al responsable.
- Tiempo de registro de comentarios < 2 minutos.

**Actores y permisos (RBAC):**
- **Cliente:** Hacer comentarios en portal (por minuto o por escrito).
- **Responsable del proyecto:** Recibir notificaciones, gestionar y responder comentarios.
- **Sistema centralizado:** Registrar comentarios, controlar límites, notificar.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-020-gestion-comentarios-modificaciones.md`

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-020-US-001 | Cliente hace comentarios en portal (por minuto o por escrito) | Como cliente, quiero hacer comentarios en el portal sobre el material entregado (indicaciones por minuto en vídeo — corporativo — o por escrito), para que queden registrados centralizadamente | Definida | Alta |
| EP-020-US-002 | Sistema registra comentarios centralizadamente | Como sistema centralizado, quiero registrar todos los comentarios del cliente centralizadamente con timestamp y vinculación al material/minuto, para trazabilidad y EP-021 | Definida | Alta |
| EP-020-US-003 | Control automático de límites de modificaciones | Como sistema centralizado, quiero controlar automáticamente los límites de modificaciones (3 corporativo, 2 bodas) y avisar cuando se alcanza o supera el límite, para cumplir con la política de rondas | Definida | Alta |
| EP-020-US-004 | Notificación automática al responsable cuando hay comentarios | Como sistema centralizado, quiero notificar automáticamente al responsable del proyecto cuando el cliente hace comentarios, para que pueda gestionarlos sin depender del email | Definida | Alta |
| EP-020-US-005 | Responsable gestiona y responde comentarios | Como responsable del proyecto, quiero ver los comentarios del cliente en el sistema y poder responder o gestionarlos, para coordinar la incorporación de cambios (EP-021) | Definida | Alta |
| EP-020-US-006 | Registro estructurado de comentarios | Como sistema centralizado, quiero mantener un registro estructurado de todos los comentarios (cliente, responsable, timestamp, minuto si aplica), para trazabilidad y reportes | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`
