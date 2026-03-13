# Performance

<!-- AUTO:BEGIN -->
Requisitos de rendimiento, presupuestos de latencia y plan de pruebas para ONGAKU.
<!-- AUTO:END -->

## 1. Alcance y perfiles de uso

- **Journeys/épicas críticas:** EP-001 (formulario leads), EP-004 (agendamiento), EP-005 (registro reunión), EP-006 (generación presupuesto), EP-008 (generación contrato), EP-019 (portal entrega material), EP-020 (comentarios y modificaciones).
- **Perfiles:** p50/p95 usuarios concurrentes: internos 10–30, clientes 20–100 (picos temporada bodas hasta ~200); TPS/req/s: formulario leads 1–5, APIs presupuesto/contrato 0,5–2, portal entrega 2–10; tamaños de payload: formularios < 100 KB, presupuestos/contratos PDF 1–10 MB, subida archivos hasta 500 MB por proyecto; mix R/W: mayor lectura (dashboards, listados), escritura en formularios y generación de documentos.

## 2. Presupuestos de latencia (end-to-end y por capa)

- **E2E objetivo por journey:**

| Journey | p50 | p95 | p99 | Notas |
|---------|-----|-----|-----|-------|
| Carga formulario leads (EP-001) | ≤ 1 s | ≤ 2 s | ≤ 3 s | Primera impresión |
| Envío formulario leads | ≤ 1,5 s | ≤ 3 s | ≤ 5 s | Incluye validación y respuesta |
| Carga vista agendamiento (EP-004) | ≤ 1,5 s | ≤ 3 s | ≤ 5 s | Incluye datos calendario |
| Generación presupuesto (EP-006) | ≤ 3 s | ≤ 6 s | ≤ 10 s | Incluye PDF |
| Generación contrato (EP-008) | ≤ 3 s | ≤ 6 s | ≤ 10 s | Incluye PDF |
| Carga portal entrega (EP-019) | ≤ 2 s | ≤ 4 s | ≤ 6 s | Listado + preview |
| Subida archivo (EP-025) | Según tamaño | ≤ 60 s para 50 MB | ≤ 120 s | Depende de red |

- **Presupuesto por capa (suma ≤ E2E):** Cliente (JS, render): 20 %; CDN/edge: 10 %; app (API + lógica): 40 %; BD: 25 %; integraciones (Google, Discord, firma): 5 % (o excluidas si asíncronas).
- **Límites de tamaño:** Request body API 10 MB (excepto uploads); response JSON 2 MB; archivos por subida según política (ej. 100 MB por archivo, 500 archivos por proyecto).

## 3. Throughput y concurrencia

- **Límite objetivo por servicio/endpoint:** Formulario leads 50 req/min por IP; APIs autenticadas 200 req/min por usuario; generación presupuesto/contrato 10 req/min por usuario; subida archivos 5 concurrentes por usuario.
- **Conexiones máximas, poolings, colas:** Pool de conexiones BD 20–50; cola de jobs (generación PDF, envío email) con workers 2–4; límite de conexiones simultáneas por instancia.
- **Paginación/streaming/chunking:** Listados paginados (máx. 50 ítems por página); descarga de archivos grandes por chunk/stream; subida de archivos por chunk (multipart).

## 4. Estrategias de rendimiento

- **Caching:** Sesión y datos maestros (roles, config) en caché con TTL 5–15 min; invalidación en actualizaciones; CDN para estáticos y assets; caché de respuestas de listados no críticos (TTL corto).
- **Consultas/índices:** Índices en BD por filtros frecuentes (proyecto, lead, fecha); evitar N+1 (eager load o batch); particionamiento en tablas grandes (por proyecto o fecha).
- **Compresión:** Gzip/Brotli para respuestas HTTP; compresión en tránsito (TLS).
- **Precomputación y jobs batch:** Reportes y dashboards pesados vía jobs asíncronos; agregados precalculados para rentabilidad (EP-014) si es necesario.

## 5. Plan de pruebas de rendimiento

- **Tipos:** Carga (carga sostenida al objetivo), estrés (por encima del objetivo hasta fallo), endurance/soak (varias horas), spike (aumento brusco de carga).
- **Dataset sintético y anonimización:** Datos de prueba sin PII; volumen representativo de leads, proyectos y archivos; anonimización si se usan copias de producción.
- **Ambiente de prueba:** Staging con datos y configuración representativos; mismo proveedor de BD y storage que producción.
- **Criterios BDD (ejemplos):**
  - *Dado* el endpoint del formulario de leads (EP-001), *cuando* 50 RPS durante 15 min, *entonces* p95 ≤ 2 s y error rate ≤ 0,5 %.
  - *Dado* el endpoint de generación de presupuesto (EP-006), *cuando* 5 RPS durante 10 min, *entonces* p95 ≤ 6 s y sin timeouts.
  - *Dado* un spike 5× en 60 s en el portal de entrega (EP-019), *cuando* se aplica backpressure, *entonces* la cola se estabiliza y no hay timeouts > 1 %.
  - *Dado* listado de proyectos con 1000 ítems, *cuando* se solicita primera página, *entonces* p95 ≤ 1,5 s.

## 6. Observabilidad y tuning

- **Métricas obligatorias:** Latencia por endpoint (p50, p95, p99); tasa de error; colas de jobs (longitud, tiempo en cola); uso de conexiones BD; uso de memoria/CPU por instancia; en BD: locks, queries lentas.
- **Profiler/heap-dumps:** En staging ante degradación; no en producción salvo incidente controlado.
- **Procedimiento de ajuste:** Identificación de cuello de botella (APM, logs, métricas); iteración en índices, caché o código; dueño por capa (frontend, backend, BD); validación con pruebas de carga.

## 7. Trazabilidad

| EP (muestra) | Endpoint/Job | SLI | Prueba |
|--------------|--------------|-----|--------|
| EP-001 | GET/POST formulario leads | p95 ≤ 2 s | Load test 50 RPS 15 min |
| EP-004 | API calendario / agendamiento | p95 ≤ 3 s | Load test agendamiento |
| EP-006 | Generación presupuesto (PDF) | p95 ≤ 6 s | Stress test 5 RPS |
| EP-019 | Portal entrega (listado + preview) | p95 ≤ 4 s | Load test portal |
| EP-025 | Subida archivo | p95 ≤ 60 s (50 MB) | Upload test por tamaño |

## 8. Riesgos y TODOs

- **Riesgos:** Dependencia de integraciones externas (Google, Discord) puede aumentar latencia E2E; generación de PDFs pesados puede requerir workers dedicados.
- **TODO:** Fijar umbrales exactos de rate limit por endpoint tras pruebas. Dueño: Backend.
- **TODO:** Definir tamaño máximo y política de archivos por proyecto (EP-025) para no impactar almacenamiento y tiempo de subida. Dueño: Product/Infra.

---

**Trazabilidad (fuentes):** EP-* en `02-discovery/0202-prd/020205-functional-requirements/`; TO-BE en `02-discovery/0202-prd/020203-to-be/processes/`; Scope en `02-discovery/0202-prd/020204-scope/`.
