PRD — Product Requirements Document
1) Propósito

Este PRD consolida qué construir, bajo qué límites y cómo validarlo. Organiza el descubrimiento, alcance, requisitos funcionales por épicas e historias, requisitos no funcionales y artefactos de gobierno (constraints, assumptions, dependencies, glosario y open-questions como catálogos consolidados).

Sirve como fuente de verdad única para producto, UX, arquitectura, desarrollo, QA, seguridad y cumplimiento.

2) Alcance

Cubre el ciclo completo de desarrollo:
AS-IS → TO-BE → Scope → Requisitos (funcionales/NFR) → Artefactos transversales → Trazabilidad.

Todo el contenido se genera y mantiene en Cursor usando prompts maestros que sobrescriben archivos existentes para evitar duplicados, preservando zonas editables fuera de las marcas `<!-- AUTO:BEGIN/END -->`.

3) Estructura del PRD (mapa de carpetas)

**Raíz del proyecto:**
```
@/02-discovery/0202-prd/
```

**Estructura detallada:**

- **020201-context/** - Contexto y alcance general
  - `company-info.md`
  - `prd-context.md`
  - `PROMPT-prd-context.md`

- **020202-as-is/** - Situación actual
  - `processes/`
    - `index.md`
    - `APPROVAL_REQUEST.md`
    - `APPROVAL_RESPONSE.md`
    - `AS-IS-###-[slug].md` - Procesos actuales documentados
  - `PROMPT-as-is.md`

- **020203-to-be/** - Catálogo de procesos objetivo
  - `processes/` - TO-BE-###-[slug].md
  - `TO-BE-INDEX.md`
  - `PROMPT-to-be.md`
  - `to-be-guidelines.md`

- **020204-scope/** - Diagrama(s) y alcance
  - `SCOPE.md`
  - `PROMPT-scope.md`

- **020205-functional-requirements/** - Requisitos funcionales por Épica
  - `EP-***/` - Una carpeta por épica
    - `EP-***-[slug].md` - Documento maestro de la épica
    - `stories/EP-***–US-***-[slug].md` - Historias de usuario
  - `EPICS-INDEX.md`
  - `TRAZA.md`

- **020206-non-functional-requirements/** - NFR por categoría
  - `availability-scalability/`
  - `compliance/`
  - `other/`
  - `performance/`
  - `security/`
  - `usability-accessibility/`

- **020207-constraints/** - Restricciones (C-###) - catálogo consolidado
- **020208-assumptions/** - Suposiciones (A-###) - catálogo consolidado por categorías
- **020209-dependencies/** - Dependencias (D-###) - catálogo consolidado sin fechas
- **020210-glossary/** - Glosario (G-###) - catálogo consolidado por categorías
- **020211-open-questions/** - Preguntas abiertas (OQ-###) - catálogo consolidado sin fechas

5) Cambios recientes en la estructura

- **Consolidación de catálogos**: Los artefactos de gobierno (constraints, assumptions, dependencies, glossary, open-questions) ahora generan un único archivo consolidado por carpeta en lugar de múltiples archivos separados por épica.
- **Eliminación de construcción por épicas**: Se eliminaron los comandos `GENERAR: EPICA "Nombre exacto"` y los archivos `by-epic/` de todos los prompts de gobierno.
- **Simplificación de fechas**: Se eliminaron referencias específicas a años y fechas en dependencies y open-questions, reemplazándolas por prioridades y criterios de severidad.
- **Optimización de tablas**: Se eliminaron columnas innecesarias como "Fecha objetivo" en dependencies y "Fecha límite" en open-questions para simplificar la estructura.

7) Convenciones e identificadores
Artefacto | ID | Estados/Notas
---|---|---
Épica | EP-###-[slug] | Documento maestro + historias anidadas; historias duplicadas en /stories/
Historia de usuario | EP-###–US-###-[slug] | BDD (Given/When/Then), flujos, validaciones, errores, etc.
Constraint | C-### | Hard/Soft; vigencia; fuente; convierte en límite vinculante
Assumption | A-### | Propuesto/En validación/Validado/Refutado/Obsoleto + plan de validación
Dependency | D-### | Identificada/Comprometida/En riesgo/Bloqueante/Resuelta; DoR y contrato
Término del glosario | G-### | Propuesto/Aprobado/Deprecado; clave i18n glossary.slug
Open-question | OQ-### | Abierta/En curso/Resuelta/Diferida/Won’t fix; criterio de cierre

Los slugs siguen el formato kebab-case, sin tildes ni ñ. Todos los archivos generados incluyen las siguientes marcas de protección:

<!-- AUTO:BEGIN -->
…contenido generado automáticamente…
<!-- AUTO:END -->

Puedes editar fuera de esas marcas sin riesgo al regenerar.

8) Flujo de trabajo (resumen)

**TO-BE**: Modelar procesos objetivo y documentarlos según las pautas establecidas.

**Scope**: Delimitar alcance y crear diagramas de referencia.

**Funcionales**: Generar Épicas como super-estructura; cada épica contiene sus US anidadas y una copia independiente por US.

**NFR**: Definir disponibilidad/escalabilidad, performance, seguridad, compliance, usabilidad/accesibilidad y otros transversales.

**Gobierno**: Generar catálogos consolidados de constraints, assumptions, dependencies, glossary y open-questions organizados por categorías.

**Trazabilidad**: Mantener EPICS-INDEX.md, TRAZA.md, TO-BE-INDEX.md y las matrices por categoría (NFR, constraints, etc.).

9) Trazabilidad (cómo se enlaza todo)

**Funcionales**:
EP ↔ US ↔ BDD ↔ Pruebas en 020205-functional-requirements/TRAZA.md.

**NFR**:
Cada SLO/SLI, control o KPI mapea a EP/US específicos y sus pruebas correspondientes.

**Artefactos de gobierno**:
Constraints, Assumptions, Dependencies y Open-questions: cada ítem en los catálogos consolidados referencia EP/US/NFR afectados y su fuente (ruta + sección).

**Glosario**:
Cada término mapea a entidades, estados, eventos y claves de UI; relaciones documentadas en las matrices por categoría.

10) Prompts y automatización (Cursor)

Todos los prompts sobrescriben el archivo destino si existe (no crean copias duplicadas). Comandos habituales: `GENERAR: TODO`, `ACTUALIZAR: INDICES`, `LISTAR: TODOs`, y específicos de cada tema.

**Archivos generados por sección:**

- **TO-BE**: Genera TO-BE-INDEX.md, processes/TO-BE-###.md, PROMPT-to-be.md, to-be-guidelines.md.

- **Scope**: Crea SCOPE.md y PROMPT-scope.md para definir alcance y diagramas.

- **Funcionales**: Crea carpetas EP-***/, documento maestro por épica, /stories/ por US, EPICS-INDEX.md y TRAZA.md.

- **NFR**: Cada categoría (availability-scalability, performance, security, compliance, usability-accessibility, other) tiene su PROMPT-*.md que genera/actualiza el archivo correspondiente.

- **Artefactos de gobierno**: Constraints, Assumptions, Dependencies, Glossary y Open-questions generan catálogos consolidados únicos organizados por categorías (rutas 020207–020211).

**Fuentes autorizadas**: Los prompts usan exclusivamente requisitos de TO-BE y scope como fuente primaria. Entrevistas y contexto se usan solo como referencia (marcados como "por confirmar" si se incluyen).

11) Definiciones mínimas por documento
Épicas e Historias (020205)

Cada US incluye: contexto/valor, alcance, pre y postcondiciones, flujo principal, flujos alternos, validaciones, BDD, datos/metadatos, estados y transiciones afectadas, errores/mensajes exactos, auditoría, notificaciones, UX/a11y, seguridad, integraciones, analítica, DoR/DoD, riesgos/supuestos y trazabilidad a TO-BE/scope.

NFR (020206)

Availability & Scalability: SLO/SLI, error budget, DR (RTO/RPO), autoescalado, degradación graciosa, pruebas de resiliencia.

Performance: presupuestos de latencia por capa, throughput, planes de carga/estrés/spike/soak.

Security: modelo de amenazas, controles por capa, SDLC seguro, monitoreo/IR, plan de pruebas (SAST/DAST/pentest).

Compliance: marcos aplicables, controles y evidencias, retención/borrado, terceros.

Usability & Accessibility: KPIs de UX, WCAG 2.1 AA, pruebas manuales/automáticas, i18n.

Other: mantenibilidad, observabilidad, portabilidad, soporte, FinOps/GreenOps.

Artefactos de gobierno

Constraints (020207): límites Hard/Soft con vigencia, dueño, evidencia y EP/US/NFR afectados.

Assumptions (020208): hipótesis con plan de validación (método, criterio, dueño), estado y conversión a constraint si aplica.

Dependencies (020209): dueños/contactos, contrato/interfaz, DoR, prioridad, estado, plan B.

Glossary (020210): términos canónicos (G-###) con definición, sinónimos/anti-términos, i18n, relaciones a dominio/UI.

Open-questions (020211): preguntas con dueño, criterio de cierre, severidad e impacto; relación con A/C/D/R.

12) Roles y responsabilidades (orientativo)

Producto: Epics/US, decisiones de alcance, OQ de producto.

UX: flujos, mensajes, a11y, glosario en UI.

Arquitectura/Tech Lead: NFR, decisiones técnicas, constraints/dep. técnicas.

QA: BDD, planes de pruebas funcionales/NFR, evidencia de aceptación.

Seguridad/Compliance: controles y evidencias, DPIA/PIA, excepciones.

SRE/Plataforma: SLO/SLI, DR, observabilidad, runbooks.

13) Contribución y gobierno del documento

Edita contenido manual fuera de AUTO:BEGIN/END.

Regenera con el prompt correspondiente (los archivos se sobrescriben).

Corre ACTUALIZAR: INDICES del tema para refrescar índices y matrices.

Abre OQ si hay ambigüedad; crea A/C/D según corresponda.

Exige trazabilidad (ruta + sección) para cada regla/requisito/control.

14) Definition of Ready / Done (PRD)

DoR (PRD listo para diseño/desarrollo):
a) Todas las épicas con US completas y BDD;
b) NFR mínimos definidos y trazados a EP/US;
c) C/A/D críticos identificados y validados;
d) OQ sin severidad Blocking o con plan de resolución;
e) Glosario aprobado para términos clave.

DoD (PRD listo para release):
a) Evidencia de pruebas contra BDD y NFR;
b) Logs de decisiones (ADR/actas) enlazados a OQ cerradas;
c) Índices y matrices sin TODOs críticos.

15) Versionado y cambios

Cambios estructurales: registrar en un ADR y enlazar a OQ/Constraint si aplica.

Archivos generados: sobrescritura segura respetando zonas manuales.

Mantener tags o ramas por hitos (ej.: prd/v1.0-scope-freeze).

16) Atajos útiles (Cursor)

TO-BE: ejecuta GENERAR: TODO (en 020203-to-be)

Scope: ejecuta GENERAR: TODO (en 020204-scope)

Funcionales: ejecuta GENERAR: TODO (en 020205-functional-requirements)

NFR: ejecuta PROMPT-*.md de cada categoría → GENERAR: TODO

Constraints/Assumptions/Dependencies/Glossary/Open-questions: ejecuta GENERAR: TODO para generar catálogo consolidado único

Actualizar índices y matrices de cualquier categoría: ejecuta ACTUALIZAR: INDICES