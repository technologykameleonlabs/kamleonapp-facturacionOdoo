# Revisión de Epics (EP-001 a EP-027)

**Fecha de revisión:** 2025-01-29  
**Alcance:** Documentos maestros y historias de usuario de los 27 epics en `020205-functional-requirements`.

---

## 1. Resumen ejecutivo

| Métrica | Valor |
|--------|--------|
| Epics en EPICS-INDEX | 27 |
| Documentos maestros (EP-XXX-nombre.md) | 27 ✅ |
| Carpetas de epic con `/stories` | 27 ✅ |
| Total historias de usuario (archivos en `/stories`) | 133 ✅ |
| Duplicados o incoherencias corregidos | 6 (EP-001 a EP-005, EP-027) |

**Estado:** Todos los epics tienen documento maestro y carpeta `stories`. El conteo de historias coincide con el índice (# US Est.).

---

## 2. Comprobación por epic

Cada epic debe tener:
- **1** documento maestro: `EP-XXX-nombre-epic/EP-XXX-nombre-epic.md`
- **N** historias en `EP-XXX-nombre-epic/stories/` según la columna "# US Est." del EPICS-INDEX.

| EP | Nombre (resumen) | US Índice | Doc. maestro | Historias | Estado |
|----|-------------------|-----------|--------------|-----------|--------|
| EP-001 | Entrada estandarizada y registro automático de leads | 3 | ✅ | 3 | ✅ |
| EP-002 | Registro y cualificación de leads | 2 | ✅ | 2 | ✅ |
| EP-003 | Respuesta automática inicial | 4 | ✅ | 4 | ✅ |
| EP-004 | Agendamiento de reuniones | 6 | ✅ | 6 | ✅ |
| EP-005 | Registro de información durante reunión | 5 | ✅ | 5 | ✅ |
| EP-006 | Generación automática de presupuestos | 6 | ✅ | 6 | ✅ |
| EP-007 | Negociación de presupuestos | 5 | ✅ | 5 | ✅ |
| EP-008 | Generación automática de contratos | 5 | ✅ | 5 | ✅ |
| EP-009 | Gestión de firmas digitales | 6 | ✅ | 6 | ✅ |
| EP-010 | Activación automática de proyectos | 5 | ✅ | 5 | ✅ |
| EP-011 | Reserva automática de fechas | 4 | ✅ | 4 | ✅ |
| EP-012 | Registro de tiempo por proyecto | 5 | ✅ | 5 | ✅ |
| EP-013 | Gestión de recursos de producción | 5 | ✅ | 5 | ✅ |
| EP-014 | Control de rentabilidad en tiempo real | 6 | ✅ | 6 | ✅ |
| EP-015 | Preparación de bodas | 5 | ✅ | 5 | ✅ |
| EP-016 | Gestión del día de la boda | 6 | ✅ | 6 | ✅ |
| EP-017 | Seguimiento de postproducción de bodas | 5 | ✅ | 5 | ✅ |
| EP-018 | Registro de material RRSS | 4 | ✅ | 4 | ✅ |
| EP-019 | Entrega de material para revisión | 5 | ✅ | 5 | ✅ |
| EP-020 | Gestión de comentarios y modificaciones | 6 | ✅ | 6 | ✅ |
| EP-021 | Incorporación de cambios y segunda entrega | 6 | ✅ | 6 | ✅ |
| EP-022 | Generación automática de factura final | 4 | ✅ | 4 | ✅ |
| EP-023 | Solicitud automática de feedback | 5 | ✅ | 5 | ✅ |
| EP-024 | Cierre automático de proyecto | 5 | ✅ | 5 | ✅ |
| EP-025 | Almacenamiento automático de archivos | 6 | ✅ | 6 | ✅ |
| EP-026 | Registro de ubicación en discos físicos | 4 | ✅ | 4 | ✅ |
| EP-027 | Gestión de retención y eliminación | 5 | ✅ | 5 | ✅ |

---

## 3. Correcciones aplicadas en esta revisión

1. **EP-005 — Duplicado de historia US-001**
   - **Problema:** Existían dos archivos para la misma historia: `EP-005-US-001-apertura-formulario-reunion.md` y `EP-005-US-001-apertura-formulario-reunion-vinculado-lead.md`.
   - **Acción:** Se eliminó `EP-005-US-001-apertura-formulario-reunion.md` y se mantuvo `EP-005-US-001-apertura-formulario-reunion-vinculado-lead.md` (alineado con el título del documento maestro).

2. **EP-001, EP-002, EP-003, EP-004, EP-005 — Texto de prompt en documento maestro**
   - **Problema:** En la sección "Historias de usuario (índice)" había un bloque de instrucciones/prompt (criterios de US, formato, etc.) que no forma parte del contenido definitivo.
   - **Acción:** Se eliminó ese bloque en EP-001, EP-002, EP-003, EP-004 y EP-005; la tabla de historias queda directamente bajo el encabezado de la sección.

3. **EP-027 — Referencia TO-BE incorrecta**
   - **Problema:** El documento maestro referenciaba `TO-BE-027-gestion-retencion-eliminacion.md`, pero el archivo existente en `020203-to-be/processes/` es `TO-BE-027-gestion-retencion-eliminacion-archivos.md`.
   - **Acción:** Se actualizó la referencia en EP-027 para apuntar al archivo existente: `TO-BE-027-gestion-retencion-eliminacion-archivos.md`.

---

## 4. Estructura esperada de cada epic

```
EP-XXX-nombre-epic/
├── EP-XXX-nombre-epic.md          # Documento maestro (descripción, alcance, KPIs, tabla de US)
└── stories/
    ├── EP-XXX-US-001-titulo-kebab-case.md
    ├── EP-XXX-US-002-...
    └── ...
```

Cada historia en `/stories` debe incluir al menos: Epic padre, Contexto/Descripción y valor (Como/quiero/para), Alcance, Precondiciones, Postcondiciones, Flujo principal, Criterios BDD, Trazabilidad.

---

## 5. Trazabilidad con EPICS-INDEX

- **EPICS-INDEX.md** define los 27 epics, # US estimado, dependencias y roadmap.
- Cada documento maestro referencia su proceso TO-BE (`020203-to-be/processes/TO-BE-XXX-...`).
- Las historias referencian el epic padre y, cuando aplica, el TO-BE.

---

## 6. Trazabilidad TO-BE

- **Procesos TO-BE:** Los 27 archivos TO-BE-001 a TO-BE-027 existen en `02-discovery/0202-prd/020203-to-be/processes/`.
- **Nota:** El archivo del proceso 027 se llama `TO-BE-027-gestion-retencion-eliminacion-archivos.md`; los epics referencian correctamente este nombre tras la corrección aplicada.

## 7. Nomenclatura: títulos EPICS-INDEX vs nombres de carpeta

Tabla para validar con negocio si se desea alinear el nombre del epic (EPICS-INDEX) con el nombre de la carpeta. Solo EP-001 tiene discrepancia clara; el resto es equivalente en kebab-case.

| EP | Título en EPICS-INDEX | Nombre de carpeta | ¿Coincide? |
|----|------------------------|-------------------|------------|
| EP-001 | Captación automática de leads | EP-001-captacion-automatica-leads | ✅ Sí (alineado tras validación) |
| EP-002 | Registro y cualificación de leads | EP-002-registro-cualificacion-leads | ✅ Sí |
| EP-003 | Respuesta automática inicial | EP-003-respuesta-automatica-inicial | ✅ Sí |
| EP-004 | Agendamiento de reuniones | EP-004-agendamiento-reuniones | ✅ Sí |
| EP-005 | Registro de información durante reunión | EP-005-registro-informacion-reunion | ✅ Sí |
| EP-006 | Generación automática de presupuestos | EP-006-generacion-automatica-presupuestos | ✅ Sí |
| EP-007 | Negociación de presupuestos | EP-007-negociacion-presupuestos | ✅ Sí |
| EP-008 | Generación automática de contratos | EP-008-generacion-automatica-contratos | ✅ Sí |
| EP-009 | Gestión de firmas digitales | EP-009-gestion-firmas-digitales | ✅ Sí |
| EP-010 | Activación automática de proyectos | EP-010-activacion-automatica-proyectos | ✅ Sí |
| EP-011 | Reserva automática de fechas | EP-011-reserva-automatica-fechas | ✅ Sí |
| EP-012 | Registro de tiempo por proyecto | EP-012-registro-tiempo-proyecto | ✅ Sí |
| EP-013 | Gestión de recursos de producción | EP-013-gestion-recursos-produccion | ✅ Sí |
| EP-014 | Control de rentabilidad en tiempo real | EP-014-control-rentabilidad-tiempo-real | ✅ Sí |
| EP-015 | Preparación de bodas | EP-015-preparacion-bodas | ✅ Sí |
| EP-016 | Gestión del día de la boda | EP-016-gestion-dia-boda | ✅ Sí |
| EP-017 | Seguimiento de postproducción de bodas | EP-017-seguimiento-postproduccion-bodas | ✅ Sí |
| EP-018 | Registro de material RRSS | EP-018-registro-material-rrss | ✅ Sí |
| EP-019 | Entrega de material para revisión | EP-019-entrega-material-revision | ✅ Sí |
| EP-020 | Gestión de comentarios y modificaciones | EP-020-gestion-comentarios-modificaciones | ✅ Sí |
| EP-021 | Incorporación de cambios y segunda entrega | EP-021-incorporacion-cambios-segunda-entrega | ✅ Sí |
| EP-022 | Generación automática de factura final | EP-022-generacion-automatica-factura-final | ✅ Sí |
| EP-023 | Solicitud automática de feedback | EP-023-solicitud-automatica-feedback | ✅ Sí |
| EP-024 | Cierre automático de proyecto | EP-024-cierre-automatico-proyecto | ✅ Sí |
| EP-025 | Almacenamiento automático de archivos | EP-025-almacenamiento-automatico-archivos | ✅ Sí |
| EP-026 | Registro de ubicación en discos físicos | EP-026-registro-ubicacion-discos-fisicos | ✅ Sí |
| EP-027 | Gestión de retención y eliminación | EP-027-gestion-retencion-eliminacion | ✅ Sí |

**Estado EP-001:** Tras validación se alineó el título en EPICS-INDEX y en el documento maestro EP-001 a "Captación automática de leads" (coincide con la carpeta).

---

## 8. TODOs del EPICS-INDEX — contexto para validación

Los siguientes TODOs están en **EPICS-INDEX.md** y requieren decisión de negocio o equipo. Se documentan aquí con contexto y recomendación para usar en una sesión de validación.

| # | TODO | Contexto | Recomendación para validación |
|---|------|-----------|-------------------------------|
| 1 | Confirmar si EP-011 (Reserva automática de fechas) debe ser un epic separado o parte de EP-010 (Activación automática de proyectos), ya que se ejecuta dentro del proceso de activación | EP-011 se dispara tras activación (EP-010); las US de reserva de fechas podrían vivir dentro del documento maestro de EP-010. Mantenerlo como epic separado permite priorizar/desarrollar la integración con calendario de forma independiente. | Decidir: epic separado (mejor trazabilidad y backlog) vs. fusionar en EP-010 (menos epics). Si se fusiona, habría que mover las 4 US de EP-011 a EP-010 y actualizar dependencias/roadmap. |
| 2 | Validar si EP-018 (Registro de material RRSS) puede desarrollarse en paralelo con otros epics de producción | EP-018 solo requiere EP-010 (proyecto activado). No depende de EP-015/016/017 (bodas). Por tanto, técnicamente puede desarrollarse en paralelo a preparación/día boda/postproducción. | Confirmar con producto: si el registro de material RRSS se hace en una fase distinta del flujo, el desarrollo en paralelo es viable. |
| 3 | Confirmar si EP-023 (Solicitud automática de feedback) es opcional o requerido para el cierre del proyecto | Hoy EP-024 (Cierre) requiere EP-022 y EP-023 en el roadmap; en el texto se menciona feedback como "opcional" en algunas US. Si es opcional, el cierre podría ejecutarse sin esperar feedback. | Decidir: feedback obligatorio para cerrar (entonces EP-023 debe completarse antes de EP-024) vs. opcional (EP-024 puede cerrar sin feedback; EP-023 se ejecuta en paralelo o después). |
| 4 | Validar si EP-025, EP-026 y EP-027 pueden implementarse de forma independiente y en paralelo con otras fases | EP-025/026/027 forman la cola del flujo (archivo, discos, retención). No bloquean a otros epics. Podrían implementarse cuando el resto del funnel esté estable. | Confirmar prioridad de negocio: si el archivo/retención es necesario desde el primer release, mantener en roadmap; si es fase 2, se pueden planificar en paralelo o después. |

**Estado:** Validación confirmada. Los 4 TODOs se cerraron en EPICS-INDEX (sección "Decisiones de validación") y la nomenclatura EP-001 se alineó.

---

## 9. Próximos pasos sugeridos

- [x] **Validación negocio:** Nomenclatura EP-001 alineada a "Captación automática de leads" (sección 7).
- [x] **Validación equipo:** TODOs del EPICS-INDEX cerrados; decisiones reflejadas en EPICS-INDEX (sección "Decisiones de validación").
- [x] EPICS-INDEX actualizado: TODOs sustituidos por tabla de decisiones; texto "ESPERANDO VALIDACIÓN" sustituido por "Estructura validada".
- [ ] **Siguiente:** Usar los 27 epics y 133 historias de usuario para refinamiento de backlog, estimación o diseño técnico según el plan del proyecto.
