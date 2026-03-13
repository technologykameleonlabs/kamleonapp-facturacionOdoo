# PROMPT Maestro · 030202 — User Flows (con gestión automática de brechas)

*(reutilizable para cualquier aplicación / proyecto)*

> **Propósito:** Generar una **biblioteca de User Flows** lista para ingeniería y diseño dentro de `030202-user-flows/`, con carpetas por flujo e **idempotencia + control de sobrescritura**.
> Para cada flujo: `README (md)`, `diagrama (mermaid)`, `prototipo-min (html)`; y re-escribir el índice `UF-flows-index.md`.
> **Nuevo:** si se detectan **brechas IA→UF**, el generador **actúa automáticamente**: crea flujos nuevos o *stubs*, extiende/mergea flujos existentes y emite un **reporte de autofix** sin romper la trazabilidad.

---

## 0) Parámetros de ejecución (variables)

> Sustituye valores entre `{…}` al ejecutar el prompt.

* **{PRODUCT\_NAME}**: nombre del producto/app.
* **{RELEASE\_TAG}**: etiqueta de versión (p.e. `MVP-0.1`).
* **{AUTHOR}** / **{ORG}**.
* **{DEFAULT\_LOCALE}**: p.e. `es-ES`.
* **{FOLDER\_ROOT}**: `030202-user-flows`.
* **{OVERWRITE\_POLICY}**: `none | safe | all`.

  * `none`: no sobrescribe nada.
  * `safe`: reescribe sólo si cambia el *hash* del contenido generado por este prompt (añade pie `GEN-BY:UF-PROMPT` + `hash:`).
  * `all`: fuerza reescritura.
* **{IA\_SITEMAP}**: ruta al sitemap IA (`030201-information-architecture/sitemap.md`).
* **{IA\_NAV\_MATRIX}**: ruta a la matriz de navegación (`030201-information-architecture/SM-navigation-matrix.md`).
* **{PRD\_PATH?}**, **{FDM\_PATH?}**, **{DM\_PATH?}**, **{MDS\_ROOT?}**.
* **{FLOW\_FILTER?}**: lista opcional de *slugs* a generar (si vacío → todo).

---

## 1) Objetivo

Construir **User Flows canónicos** por **dominio/épica** que describan **intención del usuario, precondiciones, caminos principal/alternos/errores, datos tocados, permisos, eventos analíticos y criterios de salida**, dejando artefactos autosuficientes:

* `flows/UF-xxx-{slug}/UF-xxx-{slug}.md` (especificación narrativa & técnica)
* `flows/UF-xxx-{slug}/UF-xxx-{slug}.mermaid` (diagrama)
* `flows/UF-xxx-{slug}/UF-xxx-{slug}.html` (render liviano con Mermaid)
* `UF-flows-index.md` (inventario completo y descripciones)

---

## 2) Entradas & precedencias

1. **IA (obligatorio)**: `sitemap.md` + `SM-navigation-matrix.md` → **fuente primaria** de nodos y relaciones.
2. **PRD (opcional pero recomendado)** → objetivos, NFRs, KPIs.
3. **FDM (opcional)** → límites de features y triggers.
4. **DM + MDS (opcional)** → entidades/atributos tocados por cada paso.

**Regla de oro:** si IA y PRD discrepan, prevalece **IA** para navegación; **PRD** para objetivos/NFR. Registrar conflictos en el `index`.

---

## 3) Criterios para detectar “un flujo”

Genera un flujo si el nodo/función en IA cumple **≥1**:

* Tiene **estado** antes/después y **cambia** algo (datos o sesión).
* Requiere **permiso/rol** o **scope**.
* Tiene **decisiones** (ramas) o **puntos de error** recuperables.
* Es **cross-dominio** (handoff entre G1–G8).
* Es **crítico** para KPIs, compliance o seguridad.

---

## 4) Convenciones de nombrado & carpetas

```
{FOLDER_ROOT}/
├─ PROMPT-user-flows.md
├─ UF-flows-index.md
├─ UF-autofix-report.md              (nuevo: reporte de brechas/acciones)
└─ flows/
   ├─ UF-001-{slug}/
   │  ├─ UF-001-{slug}.md
   │  ├─ UF-001-{slug}.mermaid
   │  └─ UF-001-{slug}.html
   ├─ UF-002-{slug}/
   └─ …
```

* **ID**: `UF-###` consecutivo (relleno 3 cifras).
* **slug**: `kebab-case` corto (ej. `login`, `publish-procedure`).
* **Meta** (`front-matter` en `.md`): dominio `G#`, estado (`STUB|DRAFT|READY`), origen (`IA node id`), `GEN-BY:UF-PROMPT`, `hash:`.
* **Trazabilidad ampliada**: `lineage_id` (UUID estable), `aliases`, `supersedes`, `superseded_by` (ver §21).

---

## 5) Anatomía mínima de un User Flow (contenido del `.md`)

Secciones **en este orden**:

1. **Título + Meta** (front-matter YAML).
2. **Propósito**.
3. **Actores & roles**.
4. **Gatillos**.
5. **Precondiciones**.
6. **Postcondiciones / Resultado**.
7. **Camino principal (happy path)**.
8. **Caminos alternos**.
9. **Manejo de errores**.
10. **Datos y objetos tocados** (map a **DM** + ejemplos **MDS**).
11. **Permisos / scopes**.
12. **Accesibilidad & inclusión**.
13. **Seguridad & compliance**.
14. **Instrumentación & eventos**.
15. **NFRs relevantes**.
16. **Dependencias**.
17. **Diagrama** (refs a `.mermaid` y `.html`).
18. **Notas de implementación**.

---

## 6) Guía para el diagrama (`.mermaid`)

* **Formato**: `flowchart TD` (o `LR` si mejora lectura).
* **Convenciones**:

  * Inicio/fin: `([Inicio])` / `([Fin])`
  * Acción: `[Rectángulo]`
  * Decisión: `{Rombo}` (siempre dos salidas `Sí/No` o equivalentes)
  * Subproceso/llamada: `[[Subproceso]]` con link al `UF-xxx`
  * Estado/BD: `[(Entidad/Tabla)]` con etiqueta CRUD `C/R/U/D`
* Anotaciones con `%%` para permisos/NFR.

---

## 7) Plantilla HTML (`.html`)

*(igual que versión anterior; se mantiene para portabilidad con Mermaid inline)*

---

## 8) Generación del índice `UF-flows-index.md`

* **Fuente:** listar `flows/UF-*/UF-*.md`.
* **Contenido mínimo**:

  * Tabla: `UF_ID | Nombre | Dominio(G#) | Propósito | Actor principal | Estado | Ruta`.
  * “Mapa por dominio” (G1–G8).
  * “Cobertura de IA” (nodos cubiertos vs pendientes).
  * “Riesgos / huecos”.
  * **Nuevo:** “Acciones automáticas aplicadas” (ver §8bis).
  * **Sello** `GEN-BY:UF-PROMPT` + `hash`.

---

## 8bis) **Gestión automática de brechas IA→UF (crear/patch/merge) — sin romper trazabilidad**

Cuando el análisis detecte **brechas** (nodos IA transaccionales **sin** flujo o cobertura **parcial/ambigua**):

1. **Crear nuevo flujo (FULL)**

   * Generar carpeta `UF-###-{slug}` con estado `DRAFT` (o `READY` si hay evidencia suficiente).
   * `lineage_id`: UUID nuevo; `ia_source`: id del nodo IA; `coverage: full`.

2. **Crear *STUB*** *(esqueleto mínimo cuando hay alta incertidumbre)*

   * `status: STUB`, secciones 1–6 y 17 obligatorias; 7–16 como TODO.
   * `stub_reason`: `insufficient-IA | awaiting-PRD | cross-domain-contract`.
   * Se añade a index y al **UF-autofix-report.md**.

3. **Extender flujo existente (PATCH)**

   * Añadir **subflujo** o **ramas** faltantes (sin renumerar el UF).
   * Registrar `prev_hash` en encabezado y `patch_reason` en **changelog** del `.md`.

4. **Merge de duplicados (MERGE)**

   * Elegir **canónico** (el más completo/estable).
   * En el *no canónico*: marcar `status: DEPRECATED`, añadir `superseded_by: UF-XYZ`, mantener archivos con nota y redirección.
   * **Nunca** renumerar UF existentes.

5. **Acciones de soporte**

   * Generar/actualizar **subflujos comunes** (`login`, `upload`, `assign`, `sign`) y referenciarlos con `[[Subproceso]]`.
   * Si la brecha es **cross-dominio**, generar un **bridge UF** con contrato de datos (request/response) y scopes.

6. **Evidencia y reporte**

   * Escribir/actualizar `UF-autofix-report.md` con:

     * Lista de brechas detectadas (por nodo IA).
     * Acción ejecutada (NEW | STUB | PATCH | MERGE | BRIDGE).
     * Artefactos creados/actualizados (rutas + hashes).
     * Impacto en cobertura IA (% antes/después).

---

## 9) Heurísticas de calidad

*(sin cambios; mantener lista de claridad, ramas completas, errores, permisos, datos, a11y, analítica, NFRs, cross-dominio)*

---

## 10) Algoritmo de generación

1. **Parsear IA**: extraer nodos `L2/L3` transaccionales de `{IA_SITEMAP}` y relaciones `{IA_NAV_MATRIX}`.
2. **Derivar candidatos**: mapear a features (si `{FDM_PATH}`) y priorizar navegación **crítica**.
3. **Construir lista final**: aplicar `{FLOW_FILTER?}`; asignar `UF-###`.
4. **Para cada flujo**:

   * Ensamblar **front-matter** + secciones 1–18 (ver §5) usando IA/PRD/FDM/DM/MDS.
   * Generar `.mermaid` (§6) y HTML (§7).
   * Calcular **hash** SHA-256 y marcar `GEN-BY`.
   * Escribir según **política de sobrescritura** (§12).
5. **Detección de brechas**:

   * Nodos IA sin UF ↦ **NEW** o **STUB** según certidumbre.
   * UF parcial ↦ **PATCH**; UF duplicados ↦ **MERGE**; cross-dominio ↦ **BRIDGE**.
   * Registrar todo en `UF-autofix-report.md`.
6. **Generar `UF-flows-index.md`** (tabla, dominios, cobertura, brechas y **acciones automáticas aplicadas**).
7. **Validaciones** (§11) y salida.

---

## 11) Validaciones automáticas

* **Consistencia de IDs** (carpeta/md/mermaid/html).
* **Referencias**: todos los `[[Subproceso]]` apuntan a un `UF-xxx` existente (**o STUB** documentado).
* **RBAC** presente en flujos con mutación.
* **CRUD** anotado si se tocan datos.
* **Mermaid** compilable.
* **Accesibilidad**: errores con texto claro y acción sugerida.
* **Trazabilidad**: `lineage_id` presente; si `MERGE`, existe `superseded_by` / `supersedes` bidireccional.

---

## 12) Política de sobrescritura (detallada)

* `none`: si existe → *omitido* (`skipped` en reporte).
* `safe`: si `hash` coincide con último `GEN-BY:UF-PROMPT` → *omitido*; si difiere → *reescribir* y guardar `prev_hash`.
* `all`: siempre reescribe.
* **Nota:** *STUB → DRAFT/READY* **sí** puede reescribirse en `safe` (promoción de estado).

---

## 13) Plantilla de archivo `.md` por flujo

```markdown
---
id: {UF_ID}
slug: {slug}
name: {UF_TITLE}
domain: {G#-NOMBRE}
status: {STUB|DRAFT|READY|DEPRECATED}
owner: {AUTHOR}@{ORG}
ia_source: {IA_NODE_ID}
lineage_id: {UUID}
aliases: [{ALT_SLUGS}]
supersedes: [{UF_IDS}]
superseded_by: {UF_ID|null}
coverage: {full|partial|bridge|unknown}
stub_reason: {insufficient-IA|awaiting-PRD|cross-domain-contract|null}
prd_refs: [{PRD_KEYS}]
dm_entities: [{TABLES}]
gen_by: UF-PROMPT
hash: {DOC_HASH}
prev_hash: {PREV_HASH|null}
---

## Propósito
{WHY}

## Actores & roles
- Primario: {ROLE_MAIN}
- Secundarios/servicios: {ROLES_OTHERS}

## Gatillos
- {TRIGGER_1}
- {TRIGGER_2}

## Precondiciones
- {PRE_1}

## Postcondiciones / Resultado
- {POST_1}

## Camino principal (happy path)
1) {STEP_1}
2) {STEP_2}
…

## Caminos alternos
- A1: {ALT_DESC}

## Manejo de errores
- E1: {ERROR} → {MENSAJE_ES} → {RECUPERACION}

## Datos y objetos tocados (CRUD)
- `{table}`: C/R/U/D — campos: {fields} — ejemplo MDS: `{example}`

## Permisos / scopes
- Rol requerido: {ROLE} — regla: `{expr}` — errores: 401/403

## Accesibilidad & comunicación inclusiva
- {pautas}

## Seguridad & compliance
- {datos sensibles, retención, auditoría}

## Instrumentación & eventos
- `{area}.{flow}.{step}.{action}` — dims: {dims} — KPI: {kpi}

## NFRs relevantes
- {SLA, offline, i18n}

## Dependencias
- {UF-0xx} · {dominio}

## Diagrama
- Mermaid: [`UF-xxx-{slug}.mermaid`](./UF-xxx-{slug}.mermaid)
- HTML: [`UF-xxx-{slug}.html`](./UF-xxx-{slug}.html)

## Notas de implementación
- {observaciones}
```

---

## 14) Puntos fundamentales de un buen User Flow

*(igual que versión anterior)*

---

## 15) Salida esperada (artefactos)

1. **N carpetas de flujo** bajo `flows/`.
2. **`UF-flows-index.md`** reescrito (con acciones automáticas).
3. **`UF-autofix-report.md`** con brechas detectadas y acciones ejecutadas.
4. **`UF-PROMPT-report.json`** (opcional) con totales, skipped/overwritten, hashes, gaps IA.

---

## 16) Ejecución — Instrucción al asistente

> **Rol:** Generador determinista de User Flows.
> **Tarea:** Con las entradas (§2) y parámetros (§0), producir artefactos (§15) cumpliendo validaciones (§11) y sobrescritura (§12).
> **Formato de respuesta:**
>
> * Imprime **contenido final** de cada archivo a crear con encabezado:
>
>   * `=== WRITE {path} (mode:{OVERWRITE_POLICY}) ===`
>   * seguido del contenido entre bloques `markdown` / `mermaid` / `html` según corresponda.
> * Al final, imprime un **resumen** con conteos y hashes.

**Prompt de sistema sugerido (copiar/pegar al ejecutar):**

```
Actúa como generador de artefactos de User Flows para {PRODUCT_NAME}.
Sigue estrictamente el “PROMPT Maestro · 030202 — User Flows”.
Respeta {OVERWRITE_POLICY}.
Deriva los flujos desde {IA_SITEMAP} y {IA_NAV_MATRIX}; usa {PRD_PATH}, {FDM_PATH}, {DM_PATH}, {MDS_ROOT} si existen.
Si detectas brechas IA→UF, ejecuta la gestión automática (NEW/STUB/PATCH/MERGE/BRIDGE) y emite UF-autofix-report.md sin romper trazabilidad.
Produce archivos y el índice conforme a la estructura y plantillas indicadas.
Incluye sello GEN-BY:UF-PROMPT y hash SHA-256 por archivo.
Valida enlaces y sintaxis Mermaid.
```

---

## 17) Ejemplo mínimo (UF-001 — login) *\[ilustrativo]*

*(idéntico al anterior; mantener Mermaid y HTML de ejemplo)*

---

## 18) Re-escritura de `UF-flows-index.md` (plantilla)

```markdown
# User Flows · Índice ({PRODUCT_NAME}) — {RELEASE_TAG}

> Fuente: IA `{IA_SITEMAP}` + `{IA_NAV_MATRIX}` · Política de sobrescritura: `{OVERWRITE_POLICY}`

## Resumen ejecutivo
- Total flujos: **{COUNT}**
- Cobertura IA (nodos transaccionales con flujo): **{COVERAGE_PCT}%**
- Estados: READY **{N_READY}**, DRAFT **{N_DRAFT}**, STUB **{N_STUB}**, DEPRECATED **{N_DEPR}**

## Inventario
| UF_ID | Nombre | Dominio | Propósito | Actor principal | Estado | Ruta |
|---|---|---|---|---|---|---|
{TABLE_ROWS}

## Por dominio (G1–G8)
{BY_DOMAIN_LIST}

## Brechas detectadas (IA → sin flujo)
{IA_GAPS}

## Acciones automáticas aplicadas
- NEW: {N_NEW} · STUB: {N_STUB_NEW} · PATCH: {N_PATCH} · MERGE: {N_MERGE} · BRIDGE: {N_BRIDGE}
- Ver detalle en [`UF-autofix-report.md`](./UF-autofix-report.md)

## Notas
- Criterios de diseño: claridad, recuperabilidad, accesibilidad, trazabilidad, medición.
- Conflictos IA/PRD: {CONFLICTS}

---
*GEN-BY:UF-PROMPT* · *hash:{INDEX_HASH}* · *{DATETIME_ISO}*
```

---

## 19) Qué NO hacer

*(igual que antes +)*

* No renumerar UFs existentes al crear/mergear.
* No eliminar UFs: usar `DEPRECATED` + `superseded_by`.

---

## 20) Checklist de salida

* [ ] `flows/UF-###-slug/` por flujo.
* [ ] `.md`, `.mermaid`, `.html` con `hash`.
* [ ] `UF-flows-index.md` reescrito.
* [ ] `UF-autofix-report.md` creado/actualizado.
* [ ] Sin enlaces rotos.
* [ ] A11y validada (mensajes claros).
* [ ] Telemetría definida.
* [ ] Trazabilidad (`lineage_id`, `supersedes/superseded_by`) correcta.

---

## 21) **Trazabilidad y versionado (lineage estable)**

* **IDs inmutables:** nunca renumerar `UF-###` ya asignados.
* **`lineage_id` (UUID):** persiste a través de *patch/merge*.
* **`supersedes` / `superseded_by`:** listas bidireccionales para cambios estructurales.
* **Promoción de estado:** `STUB → DRAFT → READY` manteniendo `hash/prev_hash`.
* **Alias seguro:** si cambia el *slug*, añadir a `aliases` (no borrar slug antiguo).
* **Deprecación controlada:** `status: DEPRECATED`, conservar archivos con banner y enlaces.

---

## 22) Plantilla `UF-autofix-report.md` (contenido inicial)

```markdown
# UF · AutoFix Report ({PRODUCT_NAME}) — {RELEASE_TAG}

> Resultado de la gestión automática de brechas IA→UF.

## Resumen
- Brechas detectadas: {GAPS_COUNT}
- Acciones: NEW {N_NEW} · STUB {N_STUB} · PATCH {N_PATCH} · MERGE {N_MERGE} · BRIDGE {N_BRIDGE}
- Cobertura IA antes/después: {COV_BEFORE}% → {COV_AFTER}%

## Detalle por brecha
{POR_BRECHA_LIST:
- IA node: {IA_NODE_ID} · Dominio {G#} · Motivo: {reason}
  - Acción: {NEW|STUB|PATCH|MERGE|BRIDGE}
  - Artefactos: {paths + hashes}
  - Notas: {notes}
}

---
*GEN-BY:UF-PROMPT* · *hash:{REPORT_HASH}* · *{DATETIME_ISO}*
```

---

**Fin del PROMPT Maestro · 030202 — User Flows (con gestión automática de brechas)**
