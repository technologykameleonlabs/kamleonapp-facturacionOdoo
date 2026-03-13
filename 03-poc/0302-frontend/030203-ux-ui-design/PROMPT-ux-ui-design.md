
# PROMPT Maestro · 030203 — UX/UI Design *(v2 — iterativo y reparador)*

*(reutilizable para cualquier app; 100% idempotente; garantiza iterar **todos** los SCR y crear sus wireframes/HTML)*

> **Propósito:** Generar **pantallas (SCR)** a partir de los **User Flows** (030202), creando por **cada** pantalla:
>
> * `SCR-xxx-{slug}/SCR-xxx-{slug}-definition.md`
> * `SCR-xxx-{slug}/SCR-xxx-{slug}.html` *(prototipo estático, estilo neutral “shadcn/ui-like” con Tailwind CDN)*
> * `SCR-xxx-{slug}/wireframes/` con **estados mínimos**: `loading`, `empty`, `success`, `error` en **ASCII** y **HTML**:
>
>   * `WF-xxx-001-loading.ascii` + `WF-xxx-001-loading.html`
>   * `WF-xxx-002-empty.ascii` + `WF-xxx-002-empty.html`
>   * `WF-xxx-003-success.ascii` + `WF-xxx-003-success.html`
>   * `WF-xxx-004-error.ascii` + `WF-xxx-004-error.html`
>
> Re-escribe índices: `SCR-screens-index.md` y `UX-gaps-backlog.md`.

---

## 0) Parámetros de ejecución

Sustituye `{…}` al ejecutar.

* **{PRODUCT\_NAME}**, **{RELEASE\_TAG}**, **{AUTHOR}** / **{ORG}**, **{DEFAULT\_LOCALE}** (`es-ES`).
* **{FOLDER\_ROOT}**: `030203-ux-ui-design`.
* **{OVERWRITE\_POLICY}**: `none | safe | all`.

  * `none`: nunca reescribe.
  * `safe`: reescribe si cambia el `hash` y **solo** si fue generado por este prompt (`GEN-BY:UX-PROMPT`).
  * `all`: fuerza reescritura.
* **{UF\_INDEX}**: `030202-user-flows/UF-flows-index.md`.
* **{UF\_FLOWS\_DIR}**: `030202-user-flows/flows/`.
* **{IA\_SITEMAP?}**, **{IA\_NAV\_MATRIX?}** *(opcional; para enriquecer contexto)*.
* **{PRD\_PATH?}**, **{FDM\_PATH?}**, **{DM\_PATH?}**, **{MDS\_ROOT?}** *(opcional)*.
* **{SCREENS\_FILTER?}**: lista opcional de slugs a generar (si vacío → **todos**).
* **{REPAIR\_MODE}**: `off | on`

  * `on`: **escanea y rellena** subcarpetas/assets faltantes en *todos* los `SCR-*` existentes.

---

## 1) Objetivo

Construir un **catálogo coherente de pantallas** (SCR) alineadas con los **UF**, con estructura homogénea, tokens visuales neutral-shadcn/ui, y **wireframes multiestado**. Las pantallas deben ser **iterables** (mismas secciones y estilos), **accesibles**, y con trazabilidad a UF/IA/PRD/DM.

---

## 2) Entradas & precedencia

1. **UFs** (obligatorio): `{UF_INDEX}` + carpetas `{UF_FLOWS_DIR}`.
2. **IA** (opcional): sitemap/matrix para labels y agrupación.
3. **PRD/FDM** (opcional): objetivos, NFR, límites de feature.
4. **DM/MDS** (opcional): datos tocados → decide widgets/campos.

> Si hay conflicto **nomenclatura/títulos**: prevalece UF para *intención y tareas*; IA para *navegación*; PRD para *objetivos/NFR*. Registra conflictos en índices.

---

## 3) Criterios para derivar **una pantalla (SCR)** desde los UF

Crear SCR si el flujo incluye uno o más de:

* Lista/tablero (browse/búsqueda/filtros/paginación).
* Formulario de **crear/editar** (con validación y estados).
* Visor/detalle con acciones (descargar/compartir/firmar).
* Paso modal/confirmación que tenga lógica autónoma.
* Vistas *cross-dominio* (handoff G1–G8) o con permisos específicos.

> Heurística: *un paso de UF con interacción de más de 2 controles o un resultado con representación visual independiente = 1 pantalla*.

---

## 4) Convenciones de nombres & carpetas

```
{FOLDER_ROOT}/
├─ PROMPT-ux-ui-design.md                 (este archivo)
├─ SCR-screens-index.md                   (inventario generado)
├─ UX-gaps-backlog.md                     (brechas IA/UF → sin SCR)
└─ screens/
   ├─ SCR-001-{slug}/
   │  ├─ SCR-001-{slug}-definition.md
   │  ├─ SCR-001-{slug}.html
   │  └─ wireframes/
   │     ├─ WF-001-001-loading.ascii
   │     ├─ WF-001-001-loading.html
   │     ├─ WF-001-002-empty.ascii
   │     ├─ WF-001-002-empty.html
   │     ├─ WF-001-003-success.ascii
   │     └─ WF-001-003-success.html
   ├─ SCR-002-{slug}/
   └─ …
```

* **ID**: `SCR-###` consecutivo (3 dígitos).
* **Slug**: `kebab-case` (ej. `user-list`, `procedure-editor`).
* **WF**: `WF-###-NNN-{state}` donde `###` = `SCR` y `NNN` = ordinal del *state*.
* **GEN-BY** y `hash` SHA-256 en cada archivo.

---

## 5) Anatomía del `SCR-xxx-*-definition.md`

1. Front-matter (YAML): `id, slug, name, domain(G#), status(DRAFT|READY), owner, uf_refs, ia_refs, nfr, gen_by, hash`.
2. **Propósito & escenario** (qué resuelve, desde qué UF llega).
3. **Personas & roles** (RBAC / scopes).
4. **Contenidos & datos** (campos/columnas, vacíos aceptables, límites).
5. **Estados UI** (loading/empty/success/error y cuándo aparecen).
6. **Acciones & atajos** (teclado, focus, accesibilidad).
7. **Componentes** *(tokens neutral-shadcn/ui)* y layout.
8. **Mensajería** (microcopy, lectura fácil, i18n).
9. **Validación** (sincronía/asincronía, feedback).
10. **NFR** (rendimiento, offline, tamaño payload, skeletons).
11. **Telemetría** (eventos `{area}.{screen}.{action}`).
12. **Dependencias** (APIs/UF/SCR relacionados).
13. **Notas de implementación**.

---

## 6) Wireframes (ASCII + HTML)

**Estados mínimos por pantalla:**

* `loading` (skeletons + placeholders)
* `empty` (sin resultados + CTA)
* `success` (list/detalle o form lleno)
* `error` (mensaje accesible + retry)

**ASCII**: rejilla simple, jerarquías, nombres de componentes.
**HTML**: prototipo estático con CDN **Tailwind** y estilo **neutral shadcn/ui-like** (cards, inputs, tables, modals). Mantener consistencia cross-SCR.

---

## 7) Prototipo HTML de pantalla (`SCR-xxx-{slug}.html`)

* `<html lang="{DEFAULT_LOCALE}">` + `<meta viewport>`.
* **Tailwind CDN** + layout contenedor 1200px, `mx-auto`, `p-4`.
* **Header** con título, migas (si IA la provee), search/filtros (si aplica).
* **Zona principal**:

  * *Listas*: tabla responsive con toolbar (buscar/filtrar, paginación).
  * *Form*: 2–3 columnas (sm→1 col), label/ayuda/validación inline.
* **Tokens neutral shadcn/ui-like**: `card`, `button`, `input`, `textarea`, `select`, `badge`, `table`, `modal`.
* **A11y**: `aria-*`, foco visible, tamaño target 44px, mensajes lectura fácil.
* **Estados**: switches en DOM (divs con `data-state` para emular `loading/empty/success/error`).
* **Sin JS externo** (opcionalmente 10–20 líneas inline para toggles demo).

---

## 8) **Algoritmo de generación (garantía de iteración completa)**

1. **Cargar `{UF_INDEX}`** y listar **todos** los UF (`UF_ID`, `slug`, `dominio`, `propósito`).
2. **Derivar candidatos de SCR**:

   * Mapear reglas:

     * UF con *browse/list/search* → `*-list`.
     * UF *create/edit* → `*-form` o `*-editor`.
     * UF *review/approve* → `*-assignment`, `*-review`.
     * UF *report/analytics* → `*-dashboard`.
     * UF *knowledge/help* → `*-knowledge-search` o `*-detail`.
   * Normalizar nombres y **de-duplicar** por `slug` (misma vista usada por varios UF).
   * Si `{SCREENS_FILTER?}` existe → filtra la lista final.
3. **Asignar IDs `SCR-###`** consecutivos estables.
4. **Iterar SOBRE TODOS los SCR** *(no romper en el primero)*:

   * Crear carpeta `screens/SCR-###-{slug}/` si no existe.
   * Generar/actualizar `*-definition.md` con front-matter y secciones.
   * Generar/actualizar `*-*.html` de la pantalla con estilo neutral.
   * Crear `wireframes/` y **por cada `state`** (`loading|empty|success|error`):

     * Render `WF-###-NNN-{state}.ascii`
     * Render `WF-###-NNN-{state}.html`
   * Calcular `hash` y estampar `GEN-BY:UX-PROMPT`.
5. **Modo reparación `{REPAIR_MODE}=on`**:

   * Escanear **todas** las carpetas `SCR-*` existentes.
   * Para cada una, si falta `wireframes/` o algún `state` → **crear/recuperar**.
   * Si falta `*-definition.md` o `*.html` → **generar** respetando `OVERWRITE_POLICY`.
6. **Regenerar índices**:

   * `SCR-screens-index.md`: tabla (ID, Nombre, Dominio, Origen UF, Estado, Ruta).
   * `UX-gaps-backlog.md`:

     * **UF sin pantalla** (nodo transaccional sin SCR).
     * **IA nodos relevantes sin UF/SCR** (si `{IA_*}` presente).
     * **Acciones recomendadas**: crear nueva SCR o fusionar con existente.
7. **Validaciones** (ver §11) y salida.

> **Clave de iteración:** usar un **bucle for** sobre la lista completa de SCR y un **bucle interno** sobre la lista fija de `states = [loading, empty, success, error]`. No detenerse si un archivo existe; respetar `OVERWRITE_POLICY`.

---

## 9) Política de sobrescritura

* `none`: omitir archivos existentes → registrar `skipped`.
* `safe`: reescribe si `hash` previo ≠ `hash` nuevo y `GEN-BY:UX-PROMPT`.
* `all`: reescribe siempre.

---

## 10) Validaciones automáticas

* `screens/` contiene **N** carpetas `SCR-*` = **N** pantallas planeadas.
* Cada `SCR-*` tiene `wireframes/` y **4 estados** (`ascii` + `html`).
* `definition.md` incluye `uf_refs` y `domain`.
* HTML pasa *lint* básico (doctype, lang, meta viewport, h1 único).
* A11y: todos los formularios con `label for`, mensajes de error con `role="alert"`.
* Consistencia de tokens UI y spacing (`gap-4`, `p-4`, `rounded-xl`).

---

## 11) Plantillas

### 11.1 `SCR-xxx-{slug}-definition.md`

```markdown
---
id: {SCR_ID}
slug: {slug}
name: {SCR_TITLE}
domain: {G#-NOMBRE}
status: {DRAFT|READY}
owner: {AUTHOR}@{ORG}
uf_refs: [{UF_IDS}]
ia_refs: [{IA_NODE_IDS}]
nfr: [rendimiento<2s>, offline?, i18n]
gen_by: UX-PROMPT
hash: {DOC_HASH}
---

## Propósito & escenario
{WHY}

## Personas & roles (RBAC)
- Primario: {ROLE}
- Secundarios: {ROLES}

## Contenidos & datos
- Campos/columnas: {FIELDS}
- Origen DM/MDS: {TABLES}
- Reglas de visibilidad: {SCOPES}

## Estados UI
- loading: {cuando}
- empty: {cuando}
- success: {cuando}
- error: {cuando}

## Acciones & atajos
- {Enter para buscar, Esc para cerrar modal, etc.}

## Componentes y layout (neutral shadcn/ui-like)
- Header (title, breadcrumbs, actions)
- Toolbar (search, filters, actions)
- Body (table/form/cards)
- Footer (pagination/primary-actions)

## Mensajería & A11y
- Lectura fácil: {mensaje}
- role="alert" para errores
- Foco visible y orden tab

## Validación
- Sincrónica: {reglas}
- Asincrónica: {reglas}

## Telemetría
- `{area}.{screen}.{action}` con dims {user_id, role, entity_id}

## NFR
- {SLA, tamaño respuesta, skeletons}

## Dependencias
- UF: {UF-0xx}
- APIs: {apis}

## Notas
- {observaciones}
```

### 11.2 Wireframe **ASCII** (`WF-###-NNN-{state}.ascii`)

```
[Header: Title | Breadcrumbs | Actions]
[Toolbar: Search ______________  [Filter] (Add)]
------------------------------------------------
| Table Header  | …                                  |
| Row (…)       | …                                  |
------------------------------------------------
[Footer: Pagination  « < 1 2 3 > » ]
STATE: {state}
NOTES: {microcopy / a11y / vacíos}
```

### 11.3 Wireframe **HTML** (`WF-###-NNN-{state}.html`)

HTML mínimo con Tailwind CDN; bloque principal que **simula** el estado `{state}` (skeletons en `loading`, `empty` con CTA, etc.).

### 11.4 Prototipo **Screen HTML** (`SCR-xxx-{slug}.html`)

Estructura completa con secciones `header/toolbar/main/footer`, tokens “shadcn/ui-like” y toggles de estado (data-attrs) para demo.

---

## 12) Índices

`SCR-screens-index.md`

```markdown
# Screens · Índice ({PRODUCT_NAME}) — {RELEASE_TAG}

> Fuente: UF `{UF_INDEX}` · Overwrite: `{OVERWRITE_POLICY}` · Repair: `{REPAIR_MODE}`

| SCR_ID | Nombre | Dominio | Origen UF | Estado | Ruta |
|---|---|---|---|---|---|
{TABLE_ROWS}

## Por dominio (G1–G8)
{BY_DOMAIN_LIST}

---
*GEN-BY:UX-PROMPT* · *hash:{INDEX_HASH}* · *{DATETIME_ISO}*
```

`UX-gaps-backlog.md`

```markdown
# UX Gaps Backlog

## UF sin pantalla (pendientes)
{UF_WITHOUT_SCR}

## IA nodos sin UF/SCR
{IA_GAPS}

## Acciones recomendadas
- Crear nueva SCR: {propuesta}
- Fusionar con SCR existente: {propuesta}
- Ajustar IA/UF para consistencia de navegación
```

---

## 13) Ejecución — Instrucción al asistente

> **Rol:** Generador determinista de pantallas UX/UI.
> **Tarea:** Con las entradas (§0–§2), **derivar y generar TODAS las pantallas**, con wireframes y HTML por estado, reparar faltantes si `{REPAIR_MODE}=on`, y actualizar índices. Respetar `OVERWRITE_POLICY`.

**Formato de salida:**

* Para **cada archivo**:
  `=== WRITE {path} (mode:{OVERWRITE_POLICY}) ===`
  seguido del contenido (`markdown` / `html` / `text`).
* Al final: **resumen** con conteos, hashes y listado de reparaciones.

**Prompt de sistema sugerido:**

```
Actúa como generador de pantallas UX/UI para {PRODUCT_NAME}.
Sigue estrictamente el “PROMPT Maestro · 030203 — UX/UI Design (v2)”.
Deriva TODAS las pantallas desde {UF_INDEX} y {UF_FLOWS_DIR}; usa {IA_SITEMAP}, {IA_NAV_MATRIX}, {PRD_PATH}, {FDM_PATH}, {DM_PATH}, {MDS_ROOT} si existen.
Itera sobre toda la lista resultante; por cada pantalla crea wireframes (ASCII+HTML) en estados loading, empty, success, error, y un prototipo HTML neutral shadcn/ui-like.
Habilita {REPAIR_MODE} para rellenar subcarpetas/estados faltantes en SCR existentes.
Respeta {OVERWRITE_POLICY}. Añade GEN-BY:UX-PROMPT y hash SHA-256.
Valida estructura, accesibilidad básica y consistencia de tokens.
```

---

## 14) Qué resolvimos (respecto al problema de iteración)

* **Bucle explícito** sobre **todas** las pantallas derivadas + **bucle interno** sobre estados → evita cortar tras el primer SCR.
* **Modo reparación** para **rellenar** wireframes/HTML faltantes en SCR ya creados.
* **Validaciones** que fallan si un SCR no tiene `wireframes/` o si falta algún `state`.
* **Política de sobrescritura** clara para evitar “atascos” por existencia previa.

---

Con esto, al volver a ejecutar el generador con `REPAIR_MODE=on` y `OVERWRITE_POLICY=safe` deberías ver **todas** las carpetas `wireframes/` y sus `wf.ascii/html` en **cada SCR**, además de los prototipos `SCR-xxx-*.html` consistentes.

