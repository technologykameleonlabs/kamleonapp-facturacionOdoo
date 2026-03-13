# EP-018 — Registro de material RRSS

**Descripción:** Identificación y registro temprano de material aprovechable para redes sociales durante producción o postproducción, con tags (sector, tipo, tema) y categorización (corporativo, boda, behind the scenes), disponible para equipo de marketing antes de entrega final.

**Proceso TO-BE origen:** TO-BE-018: Proceso de registro de material aprovechable para RRSS

**Bloque funcional:** Registro temprano con tags — Desde inicio de producción hasta registro de material aprovechable.

**Objetivo de negocio:** Registrar material aprovechable para RRSS durante producción, no solo en entrega, con tags y categorización para búsqueda y uso por marketing.

**Alcance y exclusiones:**
- **Incluye:**
  - Identificación de material aprovechable durante producción o postproducción (vídeo, foto, clip).
  - Registro por responsable/equipo: selección de material, tags (sector, tipo, tema), categorización (corporativo, boda, behind the scenes, etc.), descripción opcional; guardado con timestamp y proyecto_id.
  - Sistema organiza material con tags y categorías; material disponible para búsqueda.
  - Equipo de marketing accede a material registrado mediante búsqueda por tags y categorías.
- **Excluye:**
  - Activación del proyecto (EP-010).
  - Entrega de material al cliente (EP-019).
  - Publicación en RRSS (fuera del sistema).

**KPIs (éxito):**
- 100% de material aprovechable registrado durante producción.
- Tags y categorización aplicados.
- Material disponible para RRSS antes de entrega final.
- Tiempo de registro < 2 minutos por material.

**Actores y permisos (RBAC):**
- **Responsable del proyecto / Equipo de producción:** Identificar y registrar material aprovechable con tags y categoría.
- **Sistema centralizado:** Organizar material con tags y categorías; búsqueda.
- **Equipo de marketing:** Acceder a material registrado por búsqueda.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-018-registro-material-rrss.md`
- Pasos: 1–8 del flujo principal.

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-018-US-001 | Identificación de material aprovechable durante producción/postproducción | Como responsable del proyecto o equipo de producción, quiero identificar material aprovechable para RRSS durante producción o postproducción (vídeo, foto, clip), para registrarlo temprano y no depender de la memoria en la entrega | Definida | Alta |
| EP-018-US-002 | Registro de material con tags y categorización | Como responsable o equipo, quiero registrar el material seleccionado añadiendo tags (sector, tipo, tema) y categorización (corporativo, boda, behind the scenes, etc.) y descripción opcional, para que quede organizado y localizable en menos de 2 minutos | Definida | Alta |
| EP-018-US-003 | Sistema organiza material con tags y categorías | Como sistema centralizado, quiero organizar el material registrado con tags y categorías para búsqueda y disponibilidad para RRSS antes de entrega final, para que el equipo de marketing pueda localizarlo fácilmente | Definida | Alta |
| EP-018-US-004 | Equipo de marketing accede a material por búsqueda | Como equipo de marketing, quiero acceder al material registrado mediante búsqueda por tags y categorías, para usar el material para RRSS sin depender de la entrega final al cliente | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Tags:** Sector, tipo, tema (predefinidos con posibilidad de añadir nuevos).
- **Categorías:** Corporativo, boda, behind the scenes, etc.
- **Material:** Vídeo, foto, clip; vinculado a proyecto_id; timestamp.

### Reglas de numeración/ID específicas
- Material vinculado por proyecto_id; búsqueda por tags y categorías.
