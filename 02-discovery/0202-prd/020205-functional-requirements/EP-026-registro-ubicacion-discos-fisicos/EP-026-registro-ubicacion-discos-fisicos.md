# EP-026 — Registro de ubicación en discos físicos

**Descripción:** Registro de en qué disco duro físico (TABLERO, ALFIL, etc.) se archiva cada proyecto/boda, trazabilidad completa de ubicación y búsqueda avanzada por disco, proyecto y fecha.

**Proceso TO-BE origen:** TO-BE-026: Proceso de registro de ubicación en discos físicos

**Bloque funcional:** Trazabilidad de ubicación física — Desde archivo en disco físico hasta registro de ubicación y búsqueda.

**Objetivo de negocio:** Registrar automáticamente la ubicación en discos físicos y proporcionar búsqueda avanzada para EP-027 (retención) y localización de archivos.

**Alcance y exclusiones:**
- **Incluye:** Administración/equipo archiva en disco físico (TABLERO, ALFIL, etc.); registro de ubicación en sistema (proyecto + disco); trazabilidad completa (proyecto vinculado a disco, ubicación nube, fecha); búsqueda avanzada por disco, proyecto, fecha; vista de discos físicos con proyectos.
- **Excluye:** Almacenamiento en nube (EP-025); gestión retención (EP-027).

**KPIs (éxito):** 100% de proyectos con ubicación en disco físico registrada; trazabilidad completa; búsqueda avanzada funcional; tiempo de registro < 2 minutos por proyecto.

**Actores:** Administración/equipo (archivar y registrar ubicación); sistema centralizado (registrar y búsqueda); equipo (buscar archivos).

**Trazabilidad:** TO-BE-026.

---

## Historias de usuario (índice)

| ID | Título | Estado | Prioridad |
|----|--------|--------|-----------|
| EP-026-US-001 | Archivo en disco físico y registro de ubicación | Definida | Alta |
| EP-026-US-002 | Sistema registra trazabilidad (proyecto + disco) | Definida | Alta |
| EP-026-US-003 | Búsqueda avanzada por disco, proyecto, fecha | Definida | Alta |
| EP-026-US-004 | Vista de discos físicos con proyectos | Definida | Alta |

> Las historias de usuario detalladas se encuentran en la carpeta `/stories`
