# Plan de sprints — Asignación sugerida

**Origen:** BACKLOG.md, ROADMAP.md.  
**Uso:** Asignar epics a sprints según capacidad; ajustar en refinamiento.

---

## 1. Supuestos de capacidad

| Concepto | Valor sugerido | Ajustar |
|----------|----------------|---------|
| **SP por sprint** | 20 | Según equipo y ritmo |
| **Duración sprint** | 2 semanas | |
| **Release 1 (MVP)** | ~186 SP | 20 epics |
| **Sprints Release 1** | ~10 sprints | 186 ÷ 20 ≈ 9–10 |

---

## 2. Asignación de epics a sprints (Release 1 — MVP)

Orden secuencial por dependencias. Cada fila es un epic; el acumulado indica fin de sprint.

| Sprint | Epics | SP | Acumulado | Entregable clave |
|--------|--------|-----|-----------|-------------------|
| **S1** | EP-001, EP-002, EP-003 | 6+4+8 = 18 | 18 | Captación, cualificación, respuesta automática |
| **S2** | EP-004 | 12 | 30 | Agendamiento reuniones |
| **S3** | EP-005, EP-006 | 10+12 = 22 | 52 | Registro reunión, presupuestos |
| **S4** | EP-007, EP-008 | 10+10 = 20 | 72 | Negociación, contratos |
| **S5** | EP-009 | 12 | 84 | Firmas digitales |
| **S6** | EP-010, EP-011 | 10+8 = 18 | 102 | Activación, reserva fechas |
| **S7** | EP-015, EP-016 | 10+12 = 22 | 124 | Preparación bodas, día boda |
| **S8** | EP-017, EP-019 | 10+10 = 20 | 144 | Postproducción, entrega revisión |
| **S9** | EP-020, EP-021 | 12+12 = 24 | 168 | Comentarios, segunda entrega |
| **S10** | EP-022, EP-024 | 8+10 = 18 | 186 | Factura final, cierre |

**Opcionales en MVP (añadir según prioridad):** EP-012, EP-013, EP-014, EP-018, EP-023. Si se incluyen, sumar ~50 SP (2–3 sprints más).

---

## 3. Release 2 — Archivo y retención

| Sprint | Epics | SP | Entregable |
|--------|--------|-----|------------|
| **S11** | EP-025, EP-026 | 12+8 = 20 | Almacenamiento nube, ubicación discos |
| **S12** | EP-027 | 10 | Retención y eliminación |

---

## 4. Checklist de refinamiento

Usar en sesión de refinamiento antes de fijar sprints definitivos.

### Por epic
- [ ] SP por epic revisados (o estimar por US y sumar).
- [ ] Prioridad confirmada (Alta/Media; bodas vs. corporativo).
- [ ] MVP confirmado (Sí / Opc. / No).
- [ ] Dependencias claras; no hay bloqueos inesperados.

### Por US (opcional, mayor precisión)
- [ ] Abrir cada `stories/EP-XXX-US-NNN-*.md` del epic.
- [ ] Asignar SP por US (1, 2, 3, 5, 8, 13).
- [ ] Sumar SP del epic y comparar con estimación por epic.
- [ ] Ajustar si hay US muy grandes (dividir o marcar riesgo).

### Planificación
- [ ] Capacidad por sprint acordada (SP/sprint).
- [ ] Asignación de epics a sprints revisada (tabla sección 2).
- [ ] Fechas de sprint definidas (inicio/fin S1, S2, …).
- [ ] Backlog exportado a Jira/Linear/Notion (usar BACKLOG-export.csv).

### Herramienta
- [ ] CSV importado o epics creados a mano desde BACKLOG-export.csv.
- [ ] Enlaces a documentos maestro o US en la herramienta (ruta `020205-functional-requirements/EP-XXX-...`).

---

## 5. Exportar a Jira / Linear / Notion

1. **CSV:** Usar `BACKLOG-export.csv` (columnas: Epic, Nombre, US, SP, Fase, MVP, Prioridad, Orden).
2. **Jira:** Importar CSV como proyectos/epics o crear epics y mapear campos (Summary ← Nombre, Story Points ← SP, Labels ← Fase, MVP).
3. **Linear:** Crear proyectos/cycles; importar o crear issues desde CSV; asignar a cycles según SPRINT-PLAN.
4. **Notion:** Crear tabla desde CSV (paste o import); añadir propiedad "Sprint" y rellenar desde SPRINT-PLAN.

---

## 6. Referencias

- **BACKLOG.md** — Backlog por fases, SP, MVP.
- **BACKLOG-export.csv** — Exportación lista para importar.
- **ROADMAP.md** — Fases, releases, hitos.
