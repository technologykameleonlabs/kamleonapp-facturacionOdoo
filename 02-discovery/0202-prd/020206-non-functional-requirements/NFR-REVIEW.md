# Revisión de requisitos no funcionales (NFR)

**Fecha de revisión:** 2025-01-29  
**Alcance:** availability-scalability, compliance, performance, security, usability-accessibility, other.

---

## 1. Resumen ejecutivo

| Categoría | Estado | Completitud | Alineación EP-001 a EP-027 | Acción |
|-----------|--------|-------------|----------------------------|--------|
| Availability & Scalability | ✅ Completo | Alta | ✅ Alineado | Ninguna |
| Compliance | ✅ Completo | Alta | ✅ Alineado | Ninguna |
| Performance | ✅ Completo | Alta | ✅ Alineado | Unificar rate (ver §3) |
| Security | ✅ Completo | ⚠️ Parcial | ⚠️ Referencias EP obsoletas | Actualizar trazabilidad y tabla activos (§2) |
| Usability & Accessibility | ✅ Completo | Alta | ✅ Alineado | Rutas en trazabilidad (§4) |
| Other | ✅ Completo | Alta | ✅ Alineado | Ninguna |

Los seis documentos NFR están completos y siguen las plantillas. Se detectan **inconsistencias menores** y **referencias en Security** que corresponden a otro contexto de EP; se recomienda alinear y unificar criterios según sección 3.

---

## 2. Security: alineación con EP de ONGAKU

El documento **security.md** fue generado en un contexto donde los EP tenían otros nombres. En ONGAKU los EP son:

- **EP-001** = Captación automática de leads (formulario, contactos) — *no* configuración maestros.
- **EP-003** = Respuesta automática inicial (correos) — *no* tareas/asignaciones.
- **EP-005** = Registro de información durante reunión — *no* control accesos/permisos.
- **EP-007** = Negociación de presupuestos — *no* registro diario tiempo.
- **EP-012** = Registro de tiempo por proyecto (datos sensibles de tiempo).
- **EP-016 a EP-018** = Día boda, postproducción, material RRSS (no “integración Discord” como épica única).

**Acción realizada:** Se actualiza la tabla “Activos y datos críticos por épica” y la sección “Trazabilidad (fuentes)” en `security.md` para que las referencias a EP coincidan con EPICS-INDEX de ONGAKU. Las **excepciones y controles** de Security siguen siendo válidos; solo se corrigen las referencias a EP y archivos.

---

## 3. Inconsistencias detectadas

### 3.1 Rate limit formulario leads (EP-001)

| Documento | Valor | Unidad |
|-----------|--------|--------|
| Availability-scalability | 10 | req/min |
| Performance | 50 | req/min por IP |

**Recomendación:** Unificar en un único criterio (ej. 50 req/min por IP para formulario leads) y reflejarlo en ambos documentos. Availability puede referenciar: “según performance.md”.

### 3.2 Criterio de carga en pruebas (EP-001)

- **Availability:** “100 req/min durante 10 min” → disponibilidad ≥ 99,5 %, p95 ≤ 2 s.
- **Performance:** “50 RPS durante 15 min” → p95 ≤ 2 s, error rate ≤ 0,5 %.

50 RPS = 3000 req/min, no 100 req/min. Son escenarios distintos (estrés vs. carga moderada).

**Recomendación:** Dejar explícito: (1) **Load test de referencia:** 50–100 req/min durante 10–15 min para SLO de disponibilidad y latencia; (2) **Stress test:** hasta 50 RPS para validar degradación. Actualizar Availability para que el criterio “100 req/min” se entienda como carga de referencia y no como 50 RPS.

### 3.3 Rutas de trazabilidad (usability-accessibility)

En `usability-accessibility.md`, la sección final “Trazabilidad (fuentes)” usa rutas sin backticks y sin prefijo de repo (ej. `02-discovery/...`). El resto de NFR usan backticks.

**Recomendación:** Usar el mismo formato que en compliance/performance/other: rutas entre backticks y consistentes con el resto del PRD.

---

## 4. Completitud por plantilla

| Sección esperada (PROMPT) | Availability | Compliance | Performance | Security | Usability | Other |
|---------------------------|--------------|------------|-------------|----------|-----------|-------|
| Alcance / supuestos | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Objetivos / SLO-SLI / controles | ✅ | ✅ | ✅ | ✅ | ✅ | N/A |
| Continuidad / RTO-RPO / retención | ✅ | ✅ | N/A | ✅ | N/A | N/A |
| Escalabilidad / capacidad | ✅ | N/A | ✅ | N/A | N/A | N/A |
| Estrategias / arquitectura | ✅ | N/A | ✅ | ✅ | N/A | ✅ |
| Observabilidad / evidencias | ✅ | ✅ | ✅ | ✅ | N/A | ✅ |
| Pruebas / validación | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Matriz trazabilidad | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Riesgos / excepciones / TODOs | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Trazabilidad (fuentes) | ✅ | ✅ | ✅ | ✅ | ⚠️ formato | ✅ |

Todas las secciones relevantes están cubiertas. Solo se sugiere unificar formato de trazabilidad en usability-accessibility.

---

## 5. Trazabilidad cruzada NFR ↔ EP

Épicas con **cobertura explícita** en varios NFR:

| EP | Availability | Compliance | Performance | Security | Usability | Other |
|----|--------------|------------|-------------|----------|------------|-------|
| EP-001 | ✅ SLO, RTO | ✅ Consentimiento, RAT | ✅ Latencia, load | ✅ (tras corrección) | ✅ KPIs, A11y | ✅ Observabilidad |
| EP-004 | ✅ SLO, chaos | — | ✅ Latencia | — | ✅ A11y calendario | ✅ Dashboards |
| EP-005 | — | ✅ Datos reunión | ✅ Latencia | ✅ (tras corrección) | ✅ Formulario | — |
| EP-006, EP-008 | ✅ API | ✅ Presupuestos/contratos | ✅ PDF, stress | ✅ Cifrado, rate | ✅ Vista PDF | ✅ Dashboards |
| EP-009 | — | ✅ Firma, eIDAS | — | ✅ Controles datos | ✅ Firma cliente | — |
| EP-012, EP-013 | — | ✅ Tiempo/RRHH | — | ✅ (EP-012 tiempo) | — | — |
| EP-019, EP-020 | ✅ Portal | ✅ Entregas | ✅ Portal, spike | ✅ Rate, input | ✅ Portal, comentarios | ✅ Dashboards |
| EP-023 | — | — | — | — | ✅ Feedback | — |
| EP-025 a EP-027 | ✅ Archivos, RPO | ✅ Retención, borrado | ✅ Subida | ✅ File upload | — | — |

No se identifican EP sin ninguna referencia en NFR; los EP más “internos” (ej. EP-014 rentabilidad, EP-024 cierre) quedan cubiertos de forma genérica por SLO global, compliance (datos) y observabilidad.

---

## 6. TODOs consolidados (por dueño sugerido)

- **Infra/DevOps:** Umbrales autoescalado; RPO 1 h EP-001; runbooks (BD, integración, disco); trace-id; alertas FinOps.
- **Product:** SLA Google/Discord para exclusiones SLO; política archivos EP-025; criterios A11y en DoD por US.
- **DPO/Legal:** RAT completo; DPAs (Supabase, Google, Discord, firma); flujo DSR; retención detallada (EP-027).
- **Backend:** Rate limits por endpoint; tamaño máximo y política de archivos.
- **Frontend:** Componentes calendario y visor WCAG 2.1 AA.
- **Tech Lead/QA:** Cobertura por tipo de código; accesibilidad en DoD.

---

## 7. Recomendaciones

1. **Security:** Aplicar las correcciones de §2 (tabla activos por épica y trazabilidad) para que todo el NFR quede alineado con EP-001 a EP-027 de ONGAKU.
2. **Unificar rate limit y escenarios de prueba:** Un solo criterio para “formulario leads” (req/min) y dejar explícito en Availability que el test de resiliencia es “carga de referencia” (ej. 100 req/min) frente al stress test de Performance (RPS).
3. **Usability-accessibility:** Ajustar formato de la sección “Trazabilidad (fuentes)” para usar backticks y rutas consistentes con el resto de NFR.
4. **Índice NFR:** Añadir un `NFR-INDEX.md` en `020206-non-functional-requirements/` con enlaces a los seis documentos y un resumen por categoría para facilitar navegación y auditoría.

---

**Trazabilidad (fuentes):**  
EPICS-INDEX.md, PROMPT-*.md en cada carpeta NFR, y los seis documentos NFR en `02-discovery/0202-prd/020206-non-functional-requirements/`.
