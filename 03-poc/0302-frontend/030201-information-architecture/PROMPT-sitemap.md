# Prompt Maestro · 030201 — Information Architecture (IA) - Sitemap

> **Meta-propósito**
> Diseñar de forma **INTERACTIVA e INCREMENTAL** una **Arquitectura de Información navegable** del producto, creando **pantallas cohesivas** que agrupen funcionalidades relacionadas de manera lógica y natural para el usuario.
> **🚫 NO crear vistas separadas por cada historia de usuario** - en su lugar, **diseñar flujos de navegación intuitivos** que cubran múltiples historias de usuario en pantallas integradas.
> El enfoque debe ser **UX-first**: pensar cómo navegaría realmente un usuario por la aplicación, no cómo mapear 1:1 historias a vistas.
>
> **🔑 APRENDIZAJES CLAVE DE LA EXPERIENCIA:**
> - **Funcionalidades ≠ Vistas**: Solo las **vistas navegables** tienen códigos únicos. Las **funcionalidades** (pestañas, secciones, listados) se describen **en paréntesis** junto al nombre de la vista principal.
> - **Agrupamiento inteligente**: Agrupar **múltiples historias de usuario** en **pantallas cohesivas** que sigan flujos naturales de usuario.
> - **Codificación precisa**: Solo asignar **G##-V##** a vistas reales; no a elementos dentro de vistas.
> - **Profundidad controlada**: Mantener **máximo L3** para navegación intuitiva.
> - **Validación obligatoria**: **SIEMPRE preguntar** al usuario si aprueba el diseño antes de continuar.

---

## 1) Objetivo y resultados esperados

- **Proceso INTERACTIVO**: Diseñar la **navegación de la aplicación** mediante **validaciones iterativas** con el usuario.
- **Diseño UX-CENTRIC**: Pensar en **flujos de usuario reales** en lugar de vistas técnicas.
- **Validación CONTINUA**: **Preguntar al usuario en cada paso** si aprueba los cambios en **todos los archivos**.

- **Productos finales** (solo al completar todas las épicas):
  1) `sitemap.md` — mapa de navegación con jerarquía lógica y flujos intuitivos.
  2) `nodes-table.md` — tabla de pantallas con navegación integrada y metadatos UX.
  3) `schemas-coverage.md` — **cobertura funcional** mostrando cómo las historias de usuario se agrupan en pantallas navegables.

- **Secuencia obligatoria**:
  1. Generar **los 3 archivos vacíos** iniciales
  2. Analizar EP-001 → Diseñar **pantallas navegables** → **Pedir validación**
  3. Si OK: Integrar cambios → Continuar con EP-002
  4. **Repetir hasta la última épica** → Generar versiones finales

- Cada pantalla debe:
  - **Cubrir múltiples historias de usuario** de manera lógica
  - Declarar **guardas** de visibilidad (RBAC, scope, flags)
  - Indicar propósito semántico: `list | detail | create | edit | process | dashboard`
  - Seguir convención **G##-V##** para identificadores únicos
  - **Permitir navegación fluida** entre secciones relacionadas
  - Ser **técnicamente viable** con `DATABASE.yaml`

---

## 2) Alcance y no-objetivos

- **En alcance**: diseño de navegación integrada, jerarquía de pantallas, agrupamiento lógico de funcionalidades, rutas de navegación, breadcrumbs, navegación por pestañas, reglas de visibilidad, accesibilidad desde IA.
- **Fuera de alcance**: diseño visual detallado, wireframes específicos, componentes UI concretos, micro-interacciones, flujos detallados (pasan a `030202-user-flows`), decisiones técnicas de stack (pasan a `030204-frontend-architecture`).

---

## 2.5) Flujo Interactivo Obligatorio

### 🔄 **Secuencia de Diseño de Navegación**

```
INICIO
  ↓
1. Generar los 3 archivos vacíos (sitemap.md, nodes-table.md, schemas-coverage.md)
  ↓
2. Analizar EP-001 del @020205-functional-requirements/
  ↓
3. Diseñar pantallas navegables que agrupen historias de usuario relacionadas
  ↓
4. ¿Usuario aprueba el diseño de navegación? 🤔
  ├─ ✅ SÍ → Integrar cambios + continuar con EP-002
  └─ ❌ NO → Ajustar diseño según feedback del usuario
      ↓
      ↻ Repetir validación hasta aprobación
  ↓
5. Repetir proceso con EP-002, EP-003, ... hasta EP-nnn
  ↓
6. Una vez completadas TODAS las épicas → Generar versiones finales
FIN
```

### 📋 **Reglas del Diseño de Navegación**

- **🚫 NO crear vistas 1:1 con historias de usuario**
- **✅ AGRUPAR funcionalidades relacionadas en pantallas lógicas**
- **🔄 Pensar UX-first: cómo navegaría realmente el usuario**
- **❓ Preguntar si el flujo de navegación tiene sentido intuitivo**
- **⏭️ Solo pasar a siguiente épica con aprobación del diseño**
- **📝 Documentar cómo se agrupan las historias en cada pantalla**

**🎯 APRENDIZAJES PRÁCTICOS:**
- **Diferenciar vistas vs funcionalidades**: Las vistas tienen códigos G##-V##; las funcionalidades van en paréntesis
- **Ejemplo correcto**: `G02-V01 - Dashboard de Proyectos (lista activa, métricas, pendientes, accesos rápidos, notificaciones)`
- **Ejemplo incorrecto**: ❌ `G02-V01-01 - Lista de Proyectos Activos` (esto es funcionalidad, no vista)
- **Mantener profundidad L3**: Evitar jerarquías demasiado profundas que confundan al usuario
- **Validación antes de continuar**: NUNCA asumir que el diseño está bien; SIEMPRE preguntar al usuario

---

## 3) Insumos (entradas)

El motor debe **leer/analizar**:

- **PRIMARIO**: **Requerimientos funcionales (PRD)** disponibles en `@020205-functional-requirements/` - épicas e historias de usuario que **sirven como base** para diseñar la navegación integrada.
- **SECUNDARIO**: **DATABASE.yaml** - definición de base de datos para **validar compatibilidad** de esquemas y asegurar viabilidad técnica.

> **Flujo de trabajo UX-CENTRIC**:
> 1. **Generar los 3 archivos vacíos** → Crear `sitemap.md`, `nodes-table.md`, `schemas-coverage.md` con estructura básica
> 2. **Por cada épica (EP-001 a EP-nnn)**:
>    - Analizar épica en `@020205-functional-requirements/`
>    - **Diseñar pantallas navegables** agrupando historias relacionadas lógicamente
>    - **Pedir validación**: "¿Te gusta este diseño de navegación? ¿Tiene sentido intuitivo?"
>    - **Esperar aprobación del diseño** antes de continuar
> 3. **Al completar todas las épicas** → Generar versiones finales

> 📁 **Ubicación PRD**: Los requerimientos funcionales están disponibles en la carpeta `@020205-functional-requirements/` con todas las épicas (EP-001 a EP-nnn) y sus historias de usuario correspondientes.

---

## 4) Parámetros y convenciones

### Variables recomendadas:
- `PROJECT_CODE` (ej. `mi-proyecto`)
- `OVERWRITE_FILES` (`true|false`)  
- `DATABASE_SCHEMAS`: esquemas identificados en la base de datos (ej. `auth`, `base`, `projects`, etc.)

### Convención de nomenclatura:
- **Rutas**: `/d{nn}/{recurso}/{acción?}` con `kebab-case`, IDs `:id`.  
- **IDs de nodo**: `G{nn}-V{nn}` donde:
  - `G{nn}` = Grupo de vistas (G01, G02, G03, etc.)
  - `V{nn}` = Vista específica (V01, V02, V03, etc.)
- **Profundidad**: macro IA hasta **L3** (marcar ⚠️ si >L3).

---

## 5) Estructura del archivo `sitemap.md`

### 5.1 Front-matter YAML
```yaml
---
docId: sitemap-architecture
projectCode: ${PROJECT_CODE}
version: 0.1.0
date: ${NOW_ISO}
inputsHash: ${INPUTS_HASH}
schemas: []
totalViews: 0
totalGroups: 0
maxDepth: 3
owner: product.design
reviewers: [engineering, qa, schema-leads]
status: draft
---
```

### 5.2 Estructura de navegación integrada
```
Aplicación Principal
├── G01 - Configuración de Datos Maestros
│   ├── G01-V01 - Gestión de Empleados (listado, creación, edición, eliminación)
│   ├── G01-V02 - Gestión de Maestros de Proyectos
│   │   ├── G01-V02-01 - Tipos de Proyecto ← Vista navegable con código
│   │   ├── G01-V02-02 - Etapas de Proyecto ← Vista navegable con código
│   │   └── G01-V02-03 - Plantillas de Proyecto ← Vista navegable con código
│   └── G01-V03 - Gestión de Contactos (individuales, empresas, segmentos)
├── G02 - Gestión de Proyectos
│   ├── G02-V01 - Dashboard de Proyectos (lista activa, métricas, pendientes, accesos rápidos, notificaciones)
│   ├── G02-V02 - Creación de Proyecto
│   │   ├── G02-V02-01 - Paso 1: Seleccionar Tipo/Plantilla ← Vista navegable
│   │   ├── G02-V02-02 - Paso 2: Configurar Parámetros ← Vista navegable
│   │   ├── G02-V02-03 - Paso 3: Revisar y Validar ← Vista navegable
│   │   └── G02-V02-04 - Paso 4: Crear Proyecto ← Vista navegable
│   └── G02-V03 - Detalles de Proyecto (general, config, tareas, historial, estados, acciones)
└── [continuar con navegación integrada...]
```

**🎯 EJEMPLOS APRENDIDOS:**
- ✅ **Correcto**: `G02-V01 - Dashboard de Proyectos (lista activa, métricas, pendientes...)`
- ❌ **Incorrecto**: `G02-V01-01 - Lista de Proyectos Activos` (funcionalidad ≠ vista)
- ✅ **Correcto**: `G02-V02-01 - Paso 1: Seleccionar Tipo/Plantilla` (vista navegable del wizard)
- ❌ **Incorrecto**: `G02-V03-01 - Información General` (pestaña dentro de vista, usar paréntesis)

---

## 6) Estructura del archivo `nodes-table.md`

### 6.1 Tabla principal de nodos
| nodeId | label | path | schema | level | purpose | primaryActor | dataRefs (Database Schema) | visibilityRule | groupId | viewId |
|--------|-------|------|--------|-------|---------|--------------|--------------------------|----------------|---------|--------|
| G01-V01 | Vista Principal | /schema/view | schema_name | 1 | list | User | schema.table_name | role:USER | G01 | V01 |
| G01-V02 | Vista Detalle | /schema/view/:id | schema_name | 2 | detail | User | schema.table_name | role:USER | G01 | V02 |
| G02-V01 | Vista Lista | /schema/list | schema_name | 1 | list | Admin | schema.table_name | role:ADMIN | G02 | V01 |

### 6.2 Metadatos adicionales por nodo
- **entryPoints**: Puntos de entrada (home, deep-link, búsqueda, notificaciones)
- **crossLinks**: Enlaces cruzados a otras vistas
- **breadcrumb**: Ruta de navegación
- **queryParams**: Parámetros de consulta soportados
- **emptyStates**: Estados vacíos y mensajes
- **searchFacets**: Facetas de búsqueda disponibles
- **relatedContent**: Contenido relacionado por esquema

---

## 7) Estructura del archivo `schemas-coverage.md`

### 7.1 Cobertura de esquemas de base de datos
| Esquema | Total Vistas | Vistas Principales | Cobertura % | Estado |
|---------|--------------|-------------------|-------------|--------|
| schema_1 | X | G01-V01, G01-V02 | 100% | ✅ Completo |
| schema_2 | Y | G02-V01, G02-V02 | 100% | ✅ Completo |

### 7.2 Cobertura de épicas (EP-001 a EP-nnn)
| Epic ID | Epic Nombre | Historias Total | Historias Cubiertas | Vistas Creadas | Cobertura % | Estado |
|---------|-------------|-----------------|------------------|---------------|-------------|--------|
| EP-001 | Epic 1 | N | N | G01-V01, G01-V02 | 100% | ✅ Completo |
| EP-002 | Epic 2 | M | M | G02-V01 | 100% | ✅ Completo |

### 7.3 Análisis detallado por historia de usuario
| Epic ID | Historia ID | Descripción | Vista Asociada | Estado | Comentarios |
|---------|-------------|-------------|----------------|--------|-------------|
| EP-001 | US-001-01 | Gestionar empleados | G01-V01 | ✅ Implementada | Pantalla CRUD de empleados |
| EP-001 | US-001-02 | Gestionar tipos proyecto | G01-V02 | ✅ Implementada | Subpantalla en Gestión de Maestros |

### 7.4 Métricas de cobertura global
| Métrica | Total | Cubierto | Porcentaje | Estado |
|---------|-------|----------|------------|--------|
| Esquemas BD | X | X | 100% | ✅ Completo |
| Épicas | 25 | Y | Z% | 🔄 En progreso |
| Historias de usuario | N | M | P% | 🔄 En progreso |
| Vistas creadas | W | W | 100% | ✅ Completo |

### 7.5 Análisis por grupo de vistas
| GroupId | Nombre | Esquemas Cubiertos | Épicas Cubiertos | Historias Cubiertas | Vistas |
|---------|--------|-------------------|------------------|-------------------|--------|
| G01 | Grupo Principal 1 | schema_1, schema_2 | EP-001, EP-002 | US-001-01, US-001-02 | X |
| G02 | Grupo Principal 2 | schema_3 | EP-003, EP-004 | US-003-01 | Y |

---

## 8) Reglas de diseño de navegación

1) **Agrupamiento lógico**: **AGRUPAR historias de usuario relacionadas** en pantallas cohesivas que sigan flujos de usuario naturales.
2) **UX-first approach**: **Pensar cómo navegaría el usuario real**, no cómo mapear técnicamente las historias.
3) **Cobertura completa de PRD**: **TODAS** las épicas (EP-001 a EP-nnn) e historias de usuario deben estar cubiertas por el diseño de navegación.
4) **Validación interactiva**: **Pedir aprobación del diseño de navegación** antes de integrar cualquier cambio.
5) **Tracking de agrupamiento**: **Documentar explícitamente** cómo se agrupan las historias de usuario en cada pantalla.
6) **Compatibilidad técnica**: Cada pantalla debe ser **técnicamente viable** con los esquemas/tablas/campos de DATABASE.yaml.
7) **Guardas obligatorias**: Toda pantalla con **guard** (RBAC/scope/flag); si pública, justificar.
8) **Convención G##-V##**: Identificadores únicos siguiendo patrón establecido **SOLO PARA VISTAS REALES**.
9) **Navegación fluida**: Definir **cross-links** entre pantallas relacionadas para navegación intuitiva.
10) **Preguntar UX**: **Siempre preguntar al usuario** si el flujo de navegación tiene sentido intuitivo.

**🔑 REGLAS APRENDIDAS:**
11) **Funcionalidades ≠ Vistas**: **NO asignar códigos G##-V##** a pestañas, secciones o funcionalidades dentro de una vista. Usar **paréntesis para funcionalidades**.
12) **Conteos precisos**: Contar **solo vistas navegables**, no funcionalidades. Una vista puede cubrir múltiples historias de usuario.
13) **Profundidad máxima L3**: Evitar jerarquías profundas que compliquen la navegación.
14) **Validación obligatoria**: **NUNCA continuar** sin aprobación explícita del usuario para cada épica.
15) **Agrupamiento inteligente**: Priorizar **flujos de usuario naturales** sobre estructuras técnicas.

---

## 9) Quality Gates (obligatorios)

- **GATE-1 Cobertura PRD**: **100%** de épicas (EP-001 a EP-nnn) e historias de usuario deben estar cubiertas por el diseño de navegación.
- **GATE-2 Agrupamiento lógico**: Cada pantalla debe agrupar historias relacionadas de manera intuitiva y funcional.
- **GATE-3 Validación UX**: El diseño de navegación debe tener sentido intuitivo para el usuario final.
- **GATE-4 Unicidad de rutas**: Sin colisiones de rutas; documentar `redirects`.
- **GATE-5 Navegación fluida**: Todas las pantallas deben tener cross-links apropiados para navegación intuitiva.
- **GATE-6 Profundidad**: >L3 marcado con ⚠️ y justificación de la jerarquía.
- **GATE-7 Guardas**: Todas las pantallas con RBAC/scope/flags apropiados.
- **GATE-8 Accesibilidad**: Etiquetas claras + navegación intuitiva.
- **GATE-9 Compatibilidad técnica**: Todas las pantallas viables con DATABASE.yaml.
- **GATE-10 Nomenclatura**: Todos los IDs siguen convención G##-V##.

**🎯 GATES APRENDIDOS:**
- **GATE-11 Funcionalidades**: **NO asignar códigos** a elementos que no son vistas navegables (pestañas, secciones, listados).
- **GATE-12 Conteo preciso**: Los totales deben reflejar **solo vistas reales**, no funcionalidades dentro de vistas.
- **GATE-13 Paréntesis obligatorio**: Las funcionalidades se describen **en paréntesis** junto al nombre de la vista principal.
- **GATE-14 Validación iterativa**: **Cada épica debe ser aprobada** antes de continuar con la siguiente.
- **GATE-15 UX-first obligatorio**: El diseño debe priorizar **flujos de usuario naturales** sobre estructuras técnicas.

Registrar incumplimientos en `schemas-coverage.md` (sección "Warnings & Fixes Sugeridos").

---

## 10) Procedimiento Interactivo (épica por épica)

### 🚀 **FASE INICIAL**
1. **Generar los 3 archivos vacíos** → Crear `sitemap.md`, `nodes-table.md`, `schemas-coverage.md` con estructura básica vacía

### 🔄 **BUCLE INTERACTIVO (EP-001 a EP-nnn)**
2. **Seleccionar épica actual** → Leer EP-XXX de `@020205-functional-requirements/`
3. **Analizar requerimientos** → Identificar historias de usuario y funcionalidades requeridas
4. **Revisar archivos existentes** → Buscar vistas existentes que puedan reutilizarse en los 3 archivos
5. **Proponer cambios en los 3 archivos** → Actualizar sitemap, nodes-table y schemas-coverage con nuevas vistas
6. **Actualizar métricas de cobertura** → Reflejar progreso de épicas e historias en schemas-coverage.md
7. **Validar compatibilidad** → Verificar con DATABASE.yaml que las propuestas sean viables
8. **Presentar propuestas** → Mostrar cambios propuestos en los 3 archivos con métricas actualizadas
9. **PREGUNTAR AL USUARIO** → "¿Apruebas estos cambios en TODOS los archivos para EP-XXX? ¿Tienes alguna duda o sugerencia?"
10. **Esperar respuesta** → **NO continuar hasta recibir aprobación explícita de TODOS los archivos**
11. **Si aprobado** → Integrar cambios en los 3 archivos y pasar a siguiente épica
12. **Si rechazado** → Ajustar propuestas en los 3 archivos según feedback y repetir validación

### 🎯 **FASE FINAL (solo cuando se complete EP-nnn)**
13. **Generar versiones finales** → `sitemap.md`, `nodes-table.md`, `schemas-coverage.md` completos
14. **Aplicar Quality Gates** → Validar cobertura completa y compatibilidad
15. **Emitir JSON final** → Reporte completo con los 3 archivos generados

### ⚠️ **Reglas del Bucle**
- **NO saltar épicas** → Procesar EP-001, luego EP-002, luego EP-003, etc.
- **SIEMPRE reutilizar** → Priorizar vistas existentes sobre crear nuevas
- **PREGUNTAR siempre** → Nunca asumir que las propuestas están bien
- **VALIDACIÓN explícita** → Esperar "OK" o "APRUEBO" de TODOS los archivos antes de continuar
- **ACTUALIZAR los 3 archivos** → Cada paso modifica sitemap, nodes-table y schemas-coverage

---

## 11) Comunicación con el Usuario

### 💬 **Estilo de Comunicación**
- **Presentar diseños claros**: Mostrar jerarquías de navegación, agrupamientos de funcionalidades
- **Explicar lógica**: Justificar por qué se agrupan ciertas historias en pantallas específicas
- **Usar ejemplos**: Mostrar flujos de usuario típicos
- **Preguntar específicamente**: "¿Tiene sentido este flujo de navegación?" en lugar de preguntas genéricas
- **Ser iterativo**: Estar preparado para ajustar el diseño según feedback del usuario

### 📋 **Formato de Presentación**
- **Sitemap visual**: Mostrar jerarquía con indentación clara
- **Flujos de usuario**: Describir escenarios típicos de navegación
- **Agrupamiento explicado**: Documentar qué historias van en cada pantalla y por qué
- **Beneficios destacados**: Explicar cómo mejora la UX el diseño propuesto

---

## 12) Plantillas (reutilizables)

### 12.1 Front-matter genérico para sitemap.md
```yaml
---
docId: sitemap-architecture
projectCode: ${PROJECT_CODE}
version: 0.1.0
date: ${NOW_ISO}
inputsHash: ${INPUTS_HASH}
schemas: []
totalViews: 0
totalGroups: 0
maxDepth: 3
owner: product.design
reviewers: [engineering, qa, schema-leads]
status: draft
---
```

### 12.2 Pantalla integrada de navegación
```json
{
  "nodeId": "G02-V01",
  "label": "Dashboard de Proyectos (lista activa, métricas, pendientes, accesos rápidos, notificaciones)",
  "path": "/projects",
  "schema": "projects",
  "level": 1,
  "purpose": "dashboard",
  "primaryActor": "Project Manager",
  "dataRefs": ["projects.*"],
  "visibilityRule": "role:PM",
  "groupId": "G02",
  "viewId": "V01",
  "storiesCovered": ["US-002-01", "US-002-02", "US-002-03"],
  "functionalities": ["lista activa", " métricas de portafolio", "estados pendientes", "accesos rápidos", "notificaciones"],
  "navigationType": "integrated_view"
}
```

**📝 NOTA APRENDIDA:** Las funcionalidades se documentan en el campo `"functionalities"` del JSON y se muestran en **paréntesis** en el `label`.

### 12.3 Fila tipo en nodes-table.md
```markdown
| G02-V01 | Dashboard de Proyectos (lista activa, métricas, pendientes, accesos rápidos, notificaciones) | /projects | projects | 1 | dashboard | PM | projects.* | role:PM | G02 | V01 | /projects | G02-V02,G02-V03,G03-V01 | Proyectos | ?tab=active&sort=updated | empty: "Bienvenido, crea tu primer proyecto" | facets:[status,priority,type] | US-002-01,US-002-02,US-002-03 | Vistas integradas con métricas y acciones rápidas |
```

**📋 CAMPOS APRENDIDOS:**
- **Label con funcionalidades**: Incluir funcionalidades en **paréntesis** en el nombre de la vista
- **Cross-links limpios**: Solo referenciar vistas reales, no funcionalidades
- **Funcionalidades integradas**: Documentar en el último campo cómo se agrupan las funcionalidades
- **Conteos precisos**: Una fila = una vista navegable (no una funcionalidad)

### 12.4 Checklist de pantalla navegable
```markdown
- [ ] Propósito principal (dashboard/list/detail/create/process)
- [ ] Historias de usuario agrupadas en esta pantalla
- [ ] Actor primario y permisos requeridos
- [ ] Navegación interna (pestañas, secciones, breadcrumbs)
- [ ] Cross-links a otras pantallas relacionadas
- [ ] Estados vacíos y mensajes de onboarding
- [ ] Facetas de filtrado y búsqueda
- [ ] Compatibilidad técnica con esquemas de BD
- [ ] ✅ ¿Es vista navegable o funcionalidad? (vistas = códigos G##-V##)
- [ ] ✅ Funcionalidades en paréntesis (no códigos separados)
- [ ] ✅ Agrupamiento UX-first (flujos naturales vs estructura técnica)
- [ ] ✅ Validación del usuario antes de continuar
- [ ] ✅ Profundidad máxima L3
```

**🎯 CHECKLIST APRENDIDO:**
- **Vista vs Funcionalidad**: Si es navegable → código G##-V##. Si es funcionalidad → paréntesis
- **Agrupamiento inteligente**: Múltiples historias en una vista cohesiva
- **Validación obligatoria**: Preguntar siempre al usuario antes de continuar
- **UX-first**: Priorizar navegación natural sobre estructura técnica

---

## 13) Accesibilidad e inclusión

Usar glosario/plantillas de preferencia disponibles y lenguaje claro (easy-read).

Proveer alias/labels alternativos cuando exista jerga (ej. "Dashboard" → "Panel de control").

Incluir notas de accesibilidad por vista en `schemas-coverage.md`.

---

## 14) Seguridad, privacidad y cumplimiento

Respetar visibilidad por entidad/scope/turno/ubicación (cfg_object_scopes).

No listar rutas que expongan datos sin guardas.

Declarar políticas de retención y versionamiento para objetos con hist_* y *_versions.

---

## 15) Idempotencia y sobrescritura

Si `OVERWRITE_FILES=false`, retornar `report.wouldChange=true|false` y no modificar contenidos previos.

Mantener `nodeId` estables aunque cambie el `label`.

Incluir `inputsHash` para detectar cambios de insumos.

---

## 16) Ejecución Interactiva

### 🚀 **Inicio del Proceso**
1. Establecer variables (`PROJECT_CODE`, `OVERWRITE_FILES`)
2. Cargar DATABASE.yaml y requerimientos de `@020205-functional-requirements/`
3. **Generar los 3 archivos vacíos iniciales**

### 🔄 **Bucle Interactivo**
4. **Por cada épica EP-001 a EP-nnn**:
   - Analizar épica actual del `@020205-functional-requirements/`
   - Diseñar pantallas navegables agrupando historias relacionadas
   - **Actualizar métricas de agrupamiento** en schemas-coverage.md
   - **Preguntar**: "¿Te gusta este diseño de navegación?"
   - **Esperar respuesta del usuario**
   - Si aprobado: integrar cambios y continuar
   - Si rechazado: ajustar diseño y repetir pregunta

### 🎯 **Finalización**
5. **Solo cuando EP-nnn esté aprobado**: Generar versiones finales de los 3 archivos
6. **Finalizar** con arquitectura de navegación completa

### ⚠️ **Importante**
- **NO generar archivos físicos** hasta completar todas las épicas
- **SIEMPRE actualizar los 3 archivos** en cada paso
- **Pensar UX-first** en cada diseño
- **Documentar explícitamente** cómo se agrupan las historias
- **Esperar aprobación del diseño** antes de continuar