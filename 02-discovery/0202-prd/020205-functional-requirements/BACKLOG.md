# Backlog — Epics y priorización

**Origen:** EPICS-INDEX.md, 27 epics, 133 historias de usuario.  
**Uso:** Refinamiento de backlog, priorización y planificación de sprints/fases.

---

## 1. Resumen

| Métrica | Valor |
|--------|--------|
| Epics | 27 |
| Historias de usuario | 133 |
| Orden | Por dependencias (EPICS-INDEX roadmap) |
| SP total (sugerido) | ~266 (placeholders: 2 SP/US; revisar en refinamiento) |

Las columnas **SP** incluyen una estimación inicial sugerida (2 SP por US). Ajustar en sesión de refinamiento. **Sprint/Fase** y **MVP** para completar según plan de releases.

---

## 2. Backlog por fases sugeridas

El orden respeta las dependencias del EPICS-INDEX. Las fases agrupan epics por valor entregable.

### Fase 1 — De lead a contrato (EP-001 → EP-009)

| Orden | Epic | Nombre | # US | SP (sug.) | Prioridad | MVP |
|-------|------|--------|------|-----------|-----------|-----|
| 1 | EP-001 | Captación automática de leads | 3 | 6 | Alta | Sí |
| 2 | EP-002 | Registro y cualificación de leads | 2 | 4 | Alta | Sí |
| 3 | EP-003 | Respuesta automática inicial | 4 | 8 | Alta | Sí |
| 4 | EP-004 | Agendamiento de reuniones | 6 | 12 | Alta | Sí |
| 5 | EP-005 | Registro de información durante reunión | 5 | 10 | Alta | Sí |
| 6 | EP-006 | Generación automática de presupuestos | 6 | 12 | Alta | Sí |
| 7 | EP-007 | Negociación de presupuestos | 5 | 10 | Alta | Sí |
| 8 | EP-008 | Generación automática de contratos | 5 | 10 | Alta | Sí |
| 9 | EP-009 | Gestión de firmas digitales | 6 | 12 | Alta | Sí |

**Entregable Fase 1:** Lead capturado → cualificado → reunión agendada → información reunión → presupuesto → negociación → contrato → firma.

---

### Fase 2 — Activación y producción (EP-010 → EP-019)

| Orden | Epic | Nombre | # US | SP (sug.) | Prioridad | MVP |
|-------|------|--------|------|-----------|-----------|-----|
| 10 | EP-010 | Activación automática de proyectos | 5 | 10 | Alta | Sí |
| 11 | EP-011 | Reserva automática de fechas | 4 | 8 | Alta | Sí |
| 12 | EP-012 | Registro de tiempo por proyecto | 5 | 10 | Media | Opc. |
| 13 | EP-013 | Gestión de recursos de producción | 5 | 10 | Media | Opc. |
| 14 | EP-014 | Control de rentabilidad en tiempo real | 6 | 12 | Media | Opc. |
| 15 | EP-015 | Preparación de bodas | 5 | 10 | Alta (bodas) | Sí (bodas) |
| 16 | EP-016 | Gestión del día de la boda | 6 | 12 | Alta (bodas) | Sí (bodas) |
| 17 | EP-017 | Seguimiento de postproducción de bodas | 5 | 10 | Alta (bodas) | Sí (bodas) |
| 18 | EP-018 | Registro de material RRSS | 4 | 8 | Media | Opc. |
| 19 | EP-019 | Entrega de material para revisión | 5 | 10 | Alta | Sí |

**Entregable Fase 2:** Proyecto activado, fecha reservada, tiempo/recursos registrados, rentabilidad visible; flujo bodas (preparación → día boda → postproducción); material RRSS; entrega a cliente para revisión.

**Nota:** EP-012, EP-013, EP-014 y EP-018 pueden priorizarse en paralelo según necesidad (rentabilidad vs. producción).

---

### Fase 3 — Revisión, segunda entrega y cierre (EP-020 → EP-024)

| Orden | Epic | Nombre | # US | SP (sug.) | Prioridad | MVP |
|-------|------|--------|------|-----------|-----------|-----|
| 20 | EP-020 | Gestión de comentarios y modificaciones | 6 | 12 | Alta | Sí |
| 21 | EP-021 | Incorporación de cambios y segunda entrega | 6 | 12 | Alta | Sí |
| 22 | EP-022 | Generación automática de factura final | 4 | 8 | Alta | Sí |
| 23 | EP-023 | Solicitud automática de feedback | 5 | 10 | Media | Opc. |
| 24 | EP-024 | Cierre automático de proyecto | 5 | 10 | Alta | Sí |

**Entregable Fase 3:** Comentarios del cliente → incorporación → segunda entrega → factura final → feedback → cierre de proyecto.

---

### Fase 4 — Archivo y retención (EP-025 → EP-027)

| Orden | Epic | Nombre | # US | SP (sug.) | Prioridad | MVP |
|-------|------|--------|------|-----------|-----------|-----|
| 25 | EP-025 | Almacenamiento automático de archivos | 6 | 12 | Media | No (fase 2) |
| 26 | EP-026 | Registro de ubicación en discos físicos | 4 | 8 | Media | No (fase 2) |
| 27 | EP-027 | Gestión de retención y eliminación | 5 | 10 | Media | No (fase 2) |

**Entregable Fase 4:** Archivos en nube, ubicación en discos físicos, políticas de retención y eliminación.

**Nota:** Según decisiones de validación, esta fase puede implementarse en paralelo o después de tener el funnel estable.

---

## 3. Listado plano para herramienta de backlog

Orden de implementación sugerido (respetando dependencias):

```
EP-001, EP-002, EP-003, EP-004, EP-005, EP-006, EP-007, EP-008, EP-009,
EP-010, EP-011, EP-012, EP-013, EP-014, EP-015, EP-016, EP-017, EP-018, EP-019,
EP-020, EP-021, EP-022, EP-023, EP-024,
EP-025, EP-026, EP-027
```

Epics que **no** tienen dependencia de orden entre sí (se pueden priorizar en paralelo dentro de la fase):
- Tras EP-010: EP-011, EP-012, EP-013, EP-018 (y luego EP-014 con 012+013).
- Tras EP-021: EP-022 y EP-023 en paralelo.
- Tras EP-024: EP-025; luego EP-026 y EP-027 (027 requiere 025 y 026).

---

## 4. Dónde están las historias de usuario

Cada epic tiene documento maestro e historias en:

- **Documento maestro:** `020205-functional-requirements/EP-XXX-nombre-epic/EP-XXX-nombre-epic.md`
- **Historias (US):** `020205-functional-requirements/EP-XXX-nombre-epic/stories/EP-XXX-US-NNN-*.md`

Ejemplo: EP-001 → `EP-001-captacion-automatica-leads/` (maestro + 3 US en `stories/`).

---

## 5. Cómo usar este backlog

1. **Estimar:** Asignar SP (o t-shirt) por epic o por US en sesión de refinamiento.
2. **Prioridad:** Ajustar columna Prioridad si hay cambios de negocio (ej. EP-018 antes que EP-014).
3. **Sprints/Fases:** Asignar epic o US a sprint/fase según capacidad y dependencias.
4. **Herramienta:** Copiar filas o el listado plano a Jira, Linear, Notion, etc., y enlazar a los `.md` de cada epic/US.
5. **MVP:** Para un primer release, suele bastar Fase 1 + EP-010, EP-011 y parte de Fase 2 (p. ej. EP-019, EP-020, EP-021); Fase 4 puede dejarse para después.

---

## 6. Exportación y plan de sprints

- **BACKLOG-export.csv** — CSV listo para importar a Jira, Linear o Notion (Epic, Nombre, US, SP, Fase, MVP, Prioridad, Orden).
- **SPRINT-PLAN.md** — Asignación sugerida de epics a sprints (20 SP/sprint), checklist de refinamiento e instrucciones de exportación.

## 7. Referencias

- **EPICS-INDEX.md** — Índice de epics, dependencias y roadmap.
- **EPICS-REVIEW.md** — Revisión de documentos maestros y US, nomenclatura y decisiones de validación.
