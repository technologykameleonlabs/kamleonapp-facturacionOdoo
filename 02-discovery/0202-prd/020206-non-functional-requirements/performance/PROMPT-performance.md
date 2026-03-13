ROL GENERAL
Actúa como Performance Engineer y Arquitecto. Define **presupuestos de latencia**, throughput, concurrencia y tamaños de datos por journey/épica, y un plan de pruebas reproducible.

FUENTES AUTORIZADAS
1) Functional requirements (épicas): @/02-discovery/0202-prd/020205-functional-requirements/**/EP-*/EP-*.md
2) TO-BE procesos (flujos, datos): @/02-discovery/0202-prd/020203-to-be/processes/TOBE-*.md
3) Scope diagrams (caminos críticos): @/02-discovery/0202-prd/020204-scope/**

OBJETIVO
Establecer objetivos de rendimiento con **SLIs** y **presupuestos de latencia** por capa, además de un **plan de pruebas** (load/stress/soak/spike) y criterios de aceptación.

SALIDA
@/02-discovery/0202-prd/020206-non-functional-requirements/performance/performance.md

PLANTILLA — performance.md
# Performance

## 1. Alcance y perfiles de uso
- Journeys/épicas críticas (lista EP-*)
- Perfiles: p50/p95 usuarios concurrentes, TPS/req/s, tamaños de payload, mix de operaciones (R/W)

## 2. Presupuestos de latencia (end-to-end y por capa)
- E2E objetivo (p50/p95/p99) por journey
- Presupuesto por capa: cliente → CDN → edge → app → DB → integraciones
- Límites de tamaño (request/response, archivos)

## 3. Throughput y concurrencia
- Límite objetivo por servicio/endpoint
- Conexiones máximas, poolings, colas
- Políticas de paginación/streaming/chunking

## 4. Estrategias de rendimiento
- Caching (qué, dónde, TTL, invalidación)
- Consultas/índices, N+1, particionamiento
- Compresión, HTTP/2/3, gRPC si aplica
- Precomputación y jobs batch

## 5. Plan de pruebas de rendimiento
- Tipos: carga, estrés, endurance/soak, spike
- Dataset sintético y anonimización
- Ambiente de prueba y representatividad
- Criterios BDD (ejemplos):
  - *Dado* el endpoint X, *cuando* 500 RPS durante 15 min, *entonces* p95 ≤ 250 ms y error rate ≤ 0.5%.
  - *Dado* un spike 10× en 60 s, *cuando* se aplica backpressure, *entonces* la cola se estabiliza en ≤ N y no hay timeouts > 1%.

## 6. Observabilidad y tuning
- Métricas obligatorias (latencia, colas, GC, locks)
- Profiler/heap-dumps en staging
- Procedimiento de ajuste (iteraciones, owners)

## 7. Trazabilidad
- EP-* ↔ Endpoint/Job ↔ SLI ↔ Prueba

## 8. Riesgos y TODOs
- Riesgos: […]
- TODO: […]

MARCAS
<!-- AUTO:BEGIN --> … <!-- AUTO:END -->

REGLAS
- Todo SLI debe tener fórmula y fuente de medición.
- Presupuestos de latencia deben sumar al E2E objetivo (no exceder 100%).
- **Si el archivo ya existe en la ruta indicada, SOBRESCRIBIRLO (no crear copia duplicada).**

COMANDOS
- GENERAR / ACTUALIZAR / EXPORTAR plan de pruebas
