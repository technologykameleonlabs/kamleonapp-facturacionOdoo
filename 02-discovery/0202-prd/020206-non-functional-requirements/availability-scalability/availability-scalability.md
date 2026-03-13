# Availability & Scalability

<!-- AUTO:BEGIN -->
Documento de requisitos no funcionales de disponibilidad y escalabilidad para ONGAKU.
<!-- AUTO:END -->

## 1. Alcance y supuestos

- **Módulos/épicas cubiertas:** EP-001 a EP-027 (captación de leads, cualificación, respuesta automática, agendamiento, reuniones, presupuestos, contratos, firmas, activación, reserva fechas, tiempo, recursos, rentabilidad, preparación bodas, día boda, postproducción, material RRSS, entrega revisión, comentarios, segunda entrega, factura final, feedback, cierre, almacenamiento archivos, ubicación discos, retención y eliminación).
- **Supuestos (infra, regiones, data centers, proveedores):** Despliegue en cloud (Supabase/AWS o equivalente EU), región primaria EU (ej. eu-west-1), CDN para estáticos, integraciones con Google Calendar y Discord como dependencias externas.
- **Restricciones (regulatorias/técnicas):** Datos personales en UE (GDPR); disponibilidad de terceros (Google, Discord) fuera de control directo; presupuesto inicial sin multi-región activa-activa.

## 2. Objetivos de disponibilidad (SLO) y error budget

- **SLO global (% mensual):** 99,5 % (≈ 3,6 h indisponibilidad/mes).
- **SLO por capacidad/épica (tabla):**

| Capacidad | SLI | SLO | Método de medición | Error budget mensual |
|-----------|-----|-----|--------------------|----------------------|
| Formulario leads (EP-001) | Disponibilidad HTTP 2xx/3xx | 99,9 % | Health check + synthetic | ~43 min |
| Agendamiento (EP-004) | Disponibilidad endpoint calendario | 99,5 % | Synthetic + uptime | ~3,6 h |
| Portal cliente / entrega (EP-019, EP-020) | Disponibilidad HTTP 2xx | 99,5 % | Synthetic + RUM | ~3,6 h |
| API presupuestos/contratos (EP-006, EP-008) | Disponibilidad API | 99,5 % | API monitor | ~3,6 h |
| Resto aplicación | Disponibilidad HTTP 2xx/3xx | 99,5 % | Health check agregado | ~3,6 h |

- **Calendario de mantenimiento permitido:** Ventana domingo 02:00–06:00 UTC, máx. 2 ventanas/mes, excluidas del SLO si se comunican con 72 h.
- **Exclusiones explícitas:** Indisponibilidad de Google Calendar o Discord; ataques DDoS no mitigables en tiempo; fuerza mayor.

## 3. Continuidad y recuperación

- **RTO/RPO por capacidad:**

| Capacidad | RTO | RPO | Notas |
|-----------|-----|-----|--------|
| Formulario leads (EP-001) | 4 h | 1 h | Captación crítica; backups horarios |
| Datos transaccionales (EP-005 a EP-024) | 8 h | 4 h | Backup diario + WAL/log replay |
| Archivos y almacenamiento (EP-025, EP-026) | 24 h | 24 h | Objeto storage con versionado |

- **Estrategia de backup/restore:** Backups automáticos de BD (diario completo, retención 30 días); WAL/log continuo para PITR; backups de objetos (archivos) con versionado; pruebas de restore trimestrales.
- **Estrategia de DR:** Activo-pasivo (cold-standby) en región secundaria EU; failover manual con runbook; RTO 8 h para aplicación crítica.
- **Procedimientos:** Runbook de failover (DNS/config, BD réplica, verificación); runbook de failback; comunicación a usuarios según severidad.
- **Dependencias críticas y MTTD/MTTR objetivo:** Supabase/DB MTTD ≤ 5 min, MTTR ≤ 2 h; integraciones externas (Google, Discord) monitoreo de estado y MTTR según SLA del proveedor.

## 4. Escalabilidad y capacidad

- **Perfil de carga:** Usuarios internos (10–30 concurrentes); clientes (picos en temporada bodas, estimado 50–200 sesiones concurrentes); TPS moderado (formularios, APIs de presupuesto/contrato, subida de archivos).
- **Modelos de capacidad por componente:** App: 2–4 instancias bajo carga normal; BD: conexiones pool (ej. 20–50); colas: workers para envío email/notificaciones (2–4); almacenamiento: crecimiento según archivos por proyecto.
- **Políticas de autoescalado:** Escalar por CPU > 70 % o requests/s > umbral; cooldown 5 min; mínimo 2 instancias en producción.
- **Backpressure y degradación graciosa:** Cola de envío de emails/notificaciones con límite; respuestas 429/503 en APIs bajo sobrecarga; mensaje amigable en formulario leads si servicio temporalmente no disponible; colas prioritarias (notificaciones de firma/contrato > newsletter).
- **Límites/quotas por tenant/usuario:** Límite de subida por proyecto (ej. 500 archivos); rate limit por IP en formulario leads según performance.md (ej. 50 req/min); límite de envío de emails por día por cliente.
- **Estimación de costos (FinOps):** Presupuesto mensual por ambiente; alertas al 80 % y 100 %; revisión trimestral de coste por transacción/journey.

## 5. Arquitectura de alta disponibilidad

- **Multi-AZ/region:** Primario multi-AZ si el proveedor lo permite; DR en segunda región (cold).
- **Eliminación de SPoF:** Mínimo 2 instancias de aplicación; BD gestionada con réplicas; almacenamiento con redundancia; sin nodo único para colas críticas.
- **Estrategias de datos:** Réplicas de lectura para reportes si aplica; particionamiento por tenant/proyecto en tablas grandes; leader/follower para BD.
- **Cachés y invalidación:** Caché de sesión y datos maestros (TTL corto); invalidación por evento en actualizaciones críticas.
- **Colas/mensajería:** Cola para trabajos asíncronos (emails, generación PDF); reintentos con backoff e idempotencia en consumidores.
- **Circuit breakers y retries:** Circuit breaker hacia Google Calendar y Discord; reintentos limitados con exponential backoff.

## 6. Observabilidad para SLO/SLI

- **SLIs medidos:** Disponibilidad = (requests exitosos / total requests) en ventana 1 min, agregación 5 min; latencia p95 por endpoint crítico.
- **Fuentes de métricas y retención:** Métricas de aplicación e infra (30 días); logs de errores (90 días); eventos de disponibilidad (1 año).
- **Alertas basadas en error budget:** Alerta cuando error budget consumido > 50 % en el mes; alertas de latencia p95 > umbral por journey crítico; multi-nivel (warning → critical) con tiempos de respuesta definidos.

## 7. Pruebas de resiliencia y validación

- **Tipos de prueba:** Load (carga sostenida), stress (por encima de capacidad), soak (resistencia en el tiempo), chaos (fallo de dependencia/instancia) en staging; game-days opcionales.
- **Escenarios mínimos por épica:** EP-001: formulario leads bajo carga; EP-004: agendamiento con calendario; EP-006/EP-008: generación presupuesto/contrato; EP-019: portal de entrega; fallo de BD o de integración externa.
- **Criterios de aceptación (Given/When/Then):**
  - *Dado* el formulario de leads (EP-001), *cuando* carga de referencia 100 req/min durante 10 min (ver performance.md para stress test en RPS), *entonces* disponibilidad ≥ 99,5 % y p95 ≤ 2 s.
  - *Dado* el servicio de agendamiento (EP-004), *cuando* la API de Google Calendar no responde, *entonces* el sistema devuelve mensaje controlado y no cae; cola de reintentos activa.

## 8. Matriz de trazabilidad

| EP (muestra) | SLO/SLI | Prueba | Runbook |
|--------------|---------|--------|---------|
| EP-001 | Disponibilidad 99,9 % | Load test formulario | Runbook failover app |
| EP-004 | Disponibilidad 99,5 % | Chaos test integración | Runbook degradación calendario |
| EP-006, EP-008 | Disponibilidad 99,5 % | Stress test API | Runbook recuperación BD |
| EP-019 | Disponibilidad 99,5 % | Load test portal | Runbook failover app |

## 9. Riesgos y mitigaciones

| Riesgo | Impacto | Mitigación | Dueño |
|--------|---------|------------|--------|
| Indisponibilidad Google/Discord | Degradación agendamiento/notificaciones | Circuit breaker, cola de reintentos, mensaje al usuario | Dev/Infra |
| Pico de demanda en temporada | Lentitud o errores 503 | Autoescalado, backpressure, límites por usuario | Infra |
| Fallo único en BD | Pérdida de servicio | Réplicas, backups, runbook failover | Infra/DBA |
| Coste cloud por crecimiento | Desvío presupuesto | Alertas FinOps, revisión de cuotas | Product/FinOps |

## 10. TODOs / Preguntas abiertas

- **TODO:** Definir umbrales exactos de autoescalado (CPU, RPS) tras pruebas de carga. Dueño: Infra.
- **TODO:** Validar RPO 1 h para EP-001 con proveedor de BD (backup/WAL). Dueño: Infra.
- **TODO:** Documentar SLA de Google Calendar y Discord para exclusiones de SLO. Dueño: Product.

---

**Trazabilidad (fuentes):**
- Functional requirements: EP-001 a EP-027 en `02-discovery/0202-prd/020205-functional-requirements/`
- TO-BE procesos: `02-discovery/0202-prd/020203-to-be/processes/`
- Scope diagrams: `02-discovery/0202-prd/020204-scope/`
