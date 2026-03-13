# EP-017 — Seguimiento de postproducción de bodas

**Descripción:** Visibilidad del estado de edición (teaser, película, fotografías, álbumes) para novios en portal, comunicación proactiva mensual con progreso, estimaciones de entrega actualizadas y notificaciones automáticas cuando material está listo.

**Proceso TO-BE origen:** TO-BE-017: Proceso de seguimiento de postproducción de bodas

**Bloque funcional:** Visibilidad y comunicación proactiva — Desde inicio de postproducción hasta primera entrega (4–6 meses desde boda).

**Objetivo de negocio:** Dar visibilidad del estado de postproducción a novios, reducir consultas y expectativas no gestionadas mediante comunicación proactiva y notificaciones automáticas.

**Alcance y exclusiones:**
- **Incluye:**
  - Equipo de postproducción actualiza estado de edición: teaser (en edición, listo), película (en edición, listo), fotografías (en edición, listo), álbumes (en preparación, listo).
  - Portal de novios con estado visible 24/7, progreso visual (porcentaje), estimación de entrega actualizada.
  - Comunicación proactiva mensual con progreso y estimaciones de entrega.
  - Notificación automática a novios cuando material está listo (teaser, película, fotos, álbumes).
  - Novios acceden al portal para ver estado e historial de actualizaciones.
- **Excluye:**
  - Día de boda (EP-016).
  - Entrega de material para revisión (EP-019) — cuando material está listo.
  - Edición en sí (proceso interno).

**KPIs (éxito):**
- 100% de novios con visibilidad del estado de postproducción.
- Comunicación proactiva cada mes durante postproducción.
- Estimaciones de entrega actualizadas; notificaciones automáticas cuando material listo.
- Reducción de consultas de novios sobre estado.

**Actores y permisos (RBAC):**
- **Equipo de postproducción:** Actualizar estado de edición (teaser, película, fotos, álbumes).
- **Novios:** Ver estado en portal 24/7; recibir notificaciones.
- **Sistema centralizado:** Mostrar estado, enviar comunicación mensual, notificar cuando material listo.
- **Paz:** Supervisar postproducción.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-017-seguimiento-postproduccion-bodas.md`
- Pasos: 1–8 del flujo principal.

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-017-US-001 | Equipo actualiza estado de edición (teaser, película, fotos, álbumes) | Como equipo de postproducción, quiero actualizar el estado de edición de cada elemento (teaser, película, fotografías, álbumes) en el sistema (en edición, listo), para que novios vean el progreso en el portal | Definida | Alta |
| EP-017-US-002 | Portal de novios con estado visible y estimación de entrega | Como novio/novia, quiero ver en el portal el estado de postproducción (teaser, película, fotos, álbumes) y la estimación de entrega actualizada 24/7, para tener visibilidad sin tener que preguntar | Definida | Alta |
| EP-017-US-003 | Comunicación proactiva mensual con progreso | Como sistema centralizado, quiero enviar comunicación proactiva mensual a novios con progreso y estimación de entrega actualizada, para reducir expectativas no gestionadas durante el plazo de 4–6 meses | Definida | Alta |
| EP-017-US-004 | Notificación automática cuando material está listo | Como sistema centralizado, quiero notificar automáticamente a novios cuando teaser, película, fotografías o álbumes pasan a estado "Listo", para que sepan que el material está disponible (EP-019) | Definida | Alta |
| EP-017-US-005 | Novios acceden al portal 24/7 para ver estado | Como novio/novia, quiero acceder al portal en cualquier momento para ver el estado de postproducción y el historial de actualizaciones, para tener visibilidad continua | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Estado de edición:** En edición, Listo (teaser, película, fotografías, álbumes).
- **Estimación de entrega:** Actualizada según progreso; plazo estándar 4–6 meses desde boda.
- **Comunicación mensual:** Progreso, estimación de entrega.

### Reglas de numeración/ID específicas
- Estado vinculado por proyecto_id (boda) y tipo de elemento (teaser, película, fotos, álbumes).
