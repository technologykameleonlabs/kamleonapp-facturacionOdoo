# PROMPT Maestro · 020202 — AS-IS Processes (aprobación previa, iterativo, idempotente)

> Propósito: Levantar únicamente los procesos vigentes en la empresa que formarán parte de la aplicación, someterlos a aprobación explícita del cliente y, tras aprobación, generar documentación AS-IS uno por carpeta dentro de 020202-as-is/processes/, más un índice con trazabilidad de cambios del cliente.
> 
> 
> Incluye **control de sobrescritura** por *hash*, **etapas con detención** (“gates”) y **salida estructurada** para Cursor.
> 

---

## 0) Parámetros de ejecución (variables)

> Sustituye {…} al ejecutar el prompt.
> 
- **{PRODUCT_NAME}** · **{RELEASE_TAG}** · **{AUTHOR}** · **{ORG}** · **{DEFAULT_LOCALE}** (p.e. `es-ES`).
- **{FOLDER_ROOT}**: `020202-as-is/processes`
- **{OVERWRITE_POLICY}**: `none | safe | all`
    - `none`: no reescribe nada si existe.
    - `safe`: reescribe sólo si cambia el *hash* previo con sello `GEN-BY:ASIS-PROMPT`.
    - `all`: fuerza reescritura.
- **Fuentes para descubrimiento**
    - **{DISCOVERY_ROOT}**: `02-discovery/`
    - **{PROC_DIR}**: `02-discovery/docs/Procedimientos/`
    - **{NOTES_DIR}**: `02-discovery/docs/Notas/`
- **{PROC_FILTER?}**: lista opcional de *slugs* o patrones a considerar (si vacío → todos los candidatos).
- **{STOP_TOKEN_CONTINUE}**: `CONTINUE-ASIS` *(gated)*
- **{STOP_TOKEN_APPROVE_BLOCK}**: etiqueta del bloque de aprobación: `APPROVE-LIST`

---

## 1) Objetivo

1. **Detectar** procesos realmente ejecutados hoy (AS-IS) y **relevantes para la app**.
2. **Solicitar aprobación explícita** (con posibilidad de renombrar/combinar/excluir).
3. **Generar iterativamente** una carpeta por proceso aprobado: `AS-IS-###-{slug}/AS-IS-###-{slug}.md`.
4. **Construir/actualizar** `AS-IS-INDEX.md` con el listado, decisiones del cliente y trazabilidad.

> Nota: En esta etapa no se discute “alcance” futuro. Sólo se documenta lo que hoy existe y será reflejado en la aplicación.
> 

---

## 2) Criterios de inclusión (qué es un proceso AS-IS válido)

Se incluye un proceso si cumple **≥2** de los siguientes:

- Se **ejecuta hoy** de forma periódica o *ad-hoc* por la organización (empresa o proveedor).
- Toca **datos** o artefactos que estarán en la aplicación (p.ej. documentos, evidencias, flujos).
- Involucra **roles/audiencias** que serán usuarios del sistema.
- Tiene **reglas**, **controles** o **registros** con trazabilidad (calidad, riesgo, cumplimiento).
- **Duele**: presenta fricciones reportadas en notas/entrevistas (oportunidad clara de digitalización).

---

## 3) Estructura de carpetas y archivos

```
{FOLDER_ROOT}/
├─ AS-IS-INDEX.md                                  (inventario + decisiones del cliente)
├─ APPROVAL_REQUEST.md                        (lista de candidatos propuesta)
├─ APPROVAL_RESPONSE.md                       (decisiones del cliente)
└─ AS-IS-001-{slug}.md
   ...

```

- **ID**: `AS-IS-###` (003 dígitos, consecutivo).
- **slug**: `kebab-case` breve y semántico (ej.: `contratacion-personal`).
- **Sello**: todos los archivos incluyen `GEN-BY:ASIS-PROMPT` + `hash:` (SHA-256) al final.

---

## 4) Plantilla de documento por proceso (`AS-IS-###-{slug}.md`)

```markdown
---
id: AS-IS-###
name: {NOMBRE_CORTO}
slug: {slug}
status: {DRAFT|READY}
owner: {AUTHOR}@{ORG}
product: {PRODUCT_NAME}
release: {RELEASE_TAG}
locale: {DEFAULT_LOCALE}
gen_by: ASIS-PROMPT
hash: {DOC_HASH}
---

# {NOMBRE CORTO DEL PROCESO}

## 1. Descripción (AS-IS)
- **Propósito:** {por qué existe hoy}
- **Frecuencia:** {diaria/semanal/ad-hoc}
- **Actores/roles:** {rol1, rol2}
- **Herramientas actuales:** {excel, email, portal, etc.}
- **Entradas → Salidas:** {insumos y entregables}

## 2. Flujo actual paso a paso
1) {paso}
2) {paso}
n) {fin}

## 3. Problemas observados (desde entrevistas/notas. No te limites, registra cualquier problema detectado, empezando por los más relevantes, pero siempre dentro del proceso correspondiente)
- P1: {resumen} _(Fuente: {ref-nota/acta})_
- P2: ...

## 4. Oportunidades de mejora (sin diseñar solución. No te limites, registra cualquier oportunidad detectada, empezando por las más relevantes, pero siempre dentro del proceso correspondiente)
- O1 (derivada de P1): {enunciado concreto de mejora}
- O2: ...

## 5. Artefactos y datos manipulados
- {objeto/tabla (si ya existe en DM/MDS)}: {campos críticos}, {reglas}
- Retención/auditoría: {si aplica}

## 6. Indicadores actuales (si existen)
- Métrica: {definición} · **hoy**: {valor/estimación} · Origen: {planillas/sistema}

## 7. Consideraciones de accesibilidad e inclusión (si aplica)
- Ajustes de comunicación/IA para TEA u otras necesidades: {detalle}

## 8. Observaciones del cliente
- {cambios de nombre, fusiones con otro proceso, exclusiones parciales}

---

**Fuentes**: {PROC_DIR}/{archivo}, {NOTES_DIR}/{nota}
*GEN-BY:ASIS-PROMPT · hash:{DOC_HASH} · {DATETIME_ISO}*

```

---

## 5) Salidas a generar

1. **`APPROVAL_REQUEST.md`** con tabla de *candidatos*.
2. **Detención** hasta recibir **bloque de aprobación** del cliente.
3. **Un fichero `.md` por proceso aprobado** (plantilla §4).
4. **`AS-IS-INDEX.md`** con tabla de: `ID | Nombre | slug | Estado | Decisión cliente | Cambios | Ruta`.

---

## 6) Política de sobrescritura

- `none`: si existe, **no** reescribe (marca *skipped* en reporte).
- `safe`: reescribe **sólo si** cambia el *hash* respecto al último `GEN-BY:ASIS-PROMPT`.
- `all`: reescribe siempre.

---

## 7) Algoritmo de ejecución (con *gates* de aprobación)

1. **Descubrir candidatos**
    - Parsear `{PROC_DIR}` y `{NOTES_DIR}`; cruzar título/tema/actor; aplicar **criterios de inclusión** (§2) y `{PROC_FILTER?}` si existe.
    - Proponer **nombre corto**, **slug**, **motivo de inclusión** y **fuentes**.
2. **Escribir `APPROVAL_REQUEST.md`**
    - Formato con tabla: `Nombre sugerido | slug | Motivo | Fuentes | Recom. ID`.
    - **Imprimir** con encabezado Cursor:
        
        ```
        === WRITE {FOLDER_ROOT}/APPROVAL_REQUEST.md (mode:{OVERWRITE_POLICY}) ===
        
        ```
        
    - Luego **detenerse** e **instruir al cliente** a responder con un **bloque**:
        
        ```markdown
        ```APPROVE-LIST
        + {Nombre o slug}  -> APPROVE   [opcional: nuevo-nombre | merge-with:{slug}]
        + {Nombre o slug}  -> REJECT    [motivo]
        + {Nombre o slug}  -> DEFER     [motivo]
        
        ```
        
        ```
        
        ```
        
    - También se acepta **aprobación masiva**:
        
        `APPROVE-LIST: APPROVE ALL` *(opcionalmente con renombres en líneas siguientes)*.
        
3. **Esperar señal de avance**
    - **No** generar procesos hasta recibir un bloque `APPROVE-LIST` **válido** o el token `{STOP_TOKEN_CONTINUE}` junto con la lista aprobada.
4. **Persistir `APPROVAL_RESPONSE.md`**
    - Normalizar decisiones (incluye **renombres**, **fusiones** y **exclusiones**); enumerar en orden (AS-IS-001…).
5. **Generar por cada aprobado (iterativo)**
    - Crear carpeta `AS-IS-###-{slug}/` y archivo `AS-IS-###-{slug}.md` con plantilla §4.
    - Calcular **hash** y añadir sello `GEN-BY`.
    - Respetar **{OVERWRITE_POLICY}**.
6. **Generar/Reescribir `AS-IS-INDEX.md`**
    - Tabla con columnas: `ID | Nombre | slug | Aprobado | Cambios cliente | Ruta`.
    - Estadísticas: propuestos, aprobados, rechazados, fusionados, renombrados.
    - Sello `GEN-BY` + *hash*.
7. **Imprimir reporte final**
    - Totales (created/overwritten/skipped) + hashes.

---

## 8) Formato de impresión (para Cursor)

Para cada archivo, imprimir:

```
=== WRITE {path} (mode:{OVERWRITE_POLICY}) ===
```markdown
...contenido...

```

```
> Usa ```markdown para `.md`. El generador **no** debe mezclar múltiples archivos en un mismo bloque.

---

## 9) Plantilla `APPROVAL_REQUEST.md`

```markdown
# AS-IS · Solicitud de aprobación de procesos ({PRODUCT_NAME}) — {RELEASE_TAG}

A continuación, lista de procesos **vigentes** propuestos para documentar AS-IS (aptos para la aplicación).

| Nombre sugerido | slug | Motivo de inclusión | Fuentes (proc/notas) | ID sugerido |
|---|---|---|---|---|
{CANDIDATE_ROWS}

## ¿Cómo aprobar?
Responda en este chat con un bloque:

```APPROVE-LIST
+ {slug-o-nombre} -> APPROVE         [opcional: nuevo-nombre | merge-with:{slug}]
+ {slug-o-nombre} -> REJECT          [motivo]
+ {slug-o-nombre} -> DEFER           [motivo]

```

También puede aprobar todo:

`APPROVE-LIST: APPROVE ALL`

---

*GEN-BY:ASIS-PROMPT · hash:{REQ_HASH} · {DATETIME_ISO}*

```
---

## 10) Plantilla `AS-IS-INDEX.md`

```markdown
# AS-IS · Índice de procesos aprobados ({PRODUCT_NAME}) — {RELEASE_TAG}

## Resumen
- Propuestos: **{N_PROP}** · Aprobados: **{N_OK}** · Rechazados: **{N_REJ}** · Diferidos: **{N_DEF}**
- Renombrados: **{N_REN}** · Fusionados: **{N_MERGE}**

## Inventario
| ID | Nombre | slug | Aprobado | Cambios cliente (rename/merge) | Ruta |
|---|---|---|---|---|---|
{INDEX_ROWS}

## Trazabilidad
- `APPROVAL_REQUEST.md` y `APPROVAL_RESPONSE.md` conservan el historial de decisiones del cliente.

---
*GEN-BY:ASIS-PROMPT · hash:{INDEX_HASH} · {DATETIME_ISO}*

```

---

## 11) Validaciones automáticas

- **Consistencia de IDs**: carpeta y archivo comparten `AS-IS-###-{slug}`.
- **Hash & Sello** presente en cada archivo.
- **Referencias a fuentes** (procedimientos y notas) incluidas por proceso.
- **Accesibilidad/Inclusión**: sección presente cuando aplica.
- **Política `{OVERWRITE_POLICY}`** respetada (reportar *skipped/overwritten*).

---

## 12) Ejecución — Instrucción al asistente (sistema)

> Copiar/pegar en el System Prompt al ejecutar:
> 

```
Actúa como generador de documentación AS-IS para {PRODUCT_NAME}.
Sigue estrictamente el “PROMPT Maestro · 020202 — AS-IS Processes (aprobación previa)”.
Detecta candidatos desde {DISCOVERY_ROOT}, cruzando {PROC_DIR} + {NOTES_DIR}.
Imprime primero APPROVAL_REQUEST.md y DETENTE hasta recibir un bloque válido `APPROVE-LIST`
o el token {STOP_TOKEN_CONTINUE} acompañado del bloque.
Sólo tras la aprobación, genera carpetas por proceso aprobado dentro de {FOLDER_ROOT},
conforme a plantillas y política de sobrescritura {OVERWRITE_POLICY}.
Incluye sellos GEN-BY:ASIS-PROMPT y hash SHA-256 por archivo.

```

---

## 13) Qué NO hacer

- No generar procesos **sin** aprobación del cliente.
- No mezclar más de **un** proceso por carpeta/archivo.
- No omitir **fuentes** (procedimiento/nota) cuando existan.
- No ignorar `{OVERWRITE_POLICY}`.

---

## 14) Acciones claras para Cursor (paso a paso)

1. **Descubrir candidatos**: escanea `{PROC_DIR}` y `{NOTES_DIR}`; aplica criterios (§2) y `{PROC_FILTER?}` si existe.
2. **Escribir y mostrar** `=== WRITE {FOLDER_ROOT}/APPROVAL_REQUEST.md (mode:{OVERWRITE_POLICY}) ===` con la tabla de candidatos.
3. **Detenerse** y **esperar** el bloque:
    
    ```
    ```APPROVE-LIST
    + {slug} -> APPROVE [nuevo-nombre | merge-with:{slug2}]
    + {slug} -> REJECT  [motivo]
    + {slug} -> DEFER   [motivo]
    
    ```
    
    ```
    (o `APPROVE-LIST: APPROVE ALL`).
    
    ```
    
4. **Normalizar decisiones** y **escribir** `APPROVAL_RESPONSE.md` en `{FOLDER_ROOT}`.
5. **Enumerar** aprobados: `AS-IS-001`, `AS-IS-002`, …; aplicar **renombres** y **fusiones** según respuesta.
6. **Iterar** por cada aprobado:
    - Crear carpeta `{FOLDER_ROOT}/AS-IS-###-{slug}/`
    - Escribir `AS-IS-###-{slug}.md` con la **plantilla §4** y sello `GEN-BY` + `hash`.
7. **Generar/Reescribir** `AS-IS-INDEX.md` con tabla consolidada y estadísticas (§10).
8. **Imprimir reporte** final en consola: totales `created / overwritten / skipped` y hashes.
9. **Fin**.