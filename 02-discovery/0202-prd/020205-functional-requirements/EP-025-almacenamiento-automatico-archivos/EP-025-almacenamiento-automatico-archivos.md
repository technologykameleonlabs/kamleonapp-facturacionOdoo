# EP-025 — Almacenamiento automático de archivos

**Descripción:** Subida automática de archivos a nube cuando el proyecto está cerrado o el material está listo, con nombrado estructurado (proyecto/boda, tipo, fecha, versión), organización por carpetas (PROYECTOS/BODAS, BRUTOS, DRON, FINALES), registro de fecha de subida y notificación al equipo y administración.

**Proceso TO-BE origen:** TO-BE-025: Proceso de subida y organización automática de archivos

**Bloque funcional:** Subida y organización automática — Desde proyecto cerrado o material listo hasta archivos en nube con estructura y trazabilidad.

**Objetivo de negocio:** Archivar automáticamente el material de proyectos cerrados en nube con estructura clara para EP-026 (ubicación discos físicos) y EP-027 (retención).

**Alcance y exclusiones:**
- **Incluye:**
  - Identificación de material para archivar (en bruto, final, documentos) cuando proyecto cerrado (EP-024) o material listo.
  - Subida automática a nube con progreso visible y validación de integridad.
  - Nombrado estructurado (proyecto/boda, tipo, fecha, versión).
  - Organización por carpetas (PROYECTOS/BODAS, BRUTOS, DRON, FINALES).
  - Registro de fecha de subida (timestamp) para EP-027.
  - Notificación al equipo y administración cuando archivos archivados.
- **Excluye:**
  - Cierre de proyecto (EP-024).
  - Registro de ubicación en discos físicos (EP-026); gestión de retención (EP-027).

**KPIs (éxito):**
- 100% de proyectos cerrados con material archivado automáticamente en nube.
- Nombrado y organización según convención; fecha de subida registrada; notificaciones enviadas.
- Tiempo de archivado automático < 15 minutos por proyecto (según volumen).

**Actores y permisos (RBAC):**
- **Sistema centralizado:** Identificar material, subir a nube, nombrar, organizar, registrar fecha, notificar.
- **Equipo de proyecto:** Recibir notificación de archivos archivados.
- **Administración:** Recibir notificación de archivos disponibles (para EP-026 si aplica).

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-025-almacenamiento-automatico-archivos.md`

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-025-US-001 | Identificación de material para archivar | Como sistema centralizado, quiero identificar el material para archivar (en bruto, final, documentos) cuando el proyecto está cerrado o el material está listo, para iniciar la subida automática | Definida | Alta |
| EP-025-US-002 | Subida automática de archivos a nube | Como sistema centralizado, quiero subir automáticamente los archivos a la nube con progreso visible y validación de integridad, para tener el material archivado sin intervención manual | Definida | Alta |
| EP-025-US-003 | Nombrado estructurado automático | Como sistema centralizado, quiero nombrar los archivos estructuradamente (proyecto/boda, tipo, fecha, versión), para evitar errores de nombrado y facilitar búsqueda | Definida | Alta |
| EP-025-US-004 | Organización automática por carpetas | Como sistema centralizado, quiero organizar automáticamente los archivos por carpetas (PROYECTOS/BODAS, BRUTOS, DRON, FINALES), para estructura clara y EP-026 | Definida | Alta |
| EP-025-US-005 | Registro de fecha de subida | Como sistema centralizado, quiero registrar automáticamente la fecha de subida (timestamp) de cada archivo o proyecto archivado, para EP-027 (retención) y trazabilidad | Definida | Alta |
| EP-025-US-006 | Notificación al equipo y administración | Como sistema centralizado, quiero notificar automáticamente al equipo y a administración cuando los archivos están archivados en la nube, para que sepan que el material está disponible | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`
