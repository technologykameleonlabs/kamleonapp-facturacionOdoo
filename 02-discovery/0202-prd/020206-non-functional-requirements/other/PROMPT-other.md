ROL GENERAL
Actúa como Arquitecto de Software y Operaciones. “Other” agrupa NFR transversales no cubiertos por las categorías principales: **mantenibilidad, observabilidad, portabilidad, soporteabilidad, i18n/l10n, coste/FinOps y sostenibilidad (GreenOps)**.

FUENTES AUTORIZADAS
1) Requisitos funcionales (épicas): @/02-discovery/0202-prd/020205-functional-requirements/**/EP-*/EP-*.md
2) TO-BE procesos y datos: @/02-discovery/0202-prd/020203-to-be/processes/TOBE-*.md
3) Scope/diagrams: @/02-discovery/0202-prd/020204-scope/**

OBJETIVO
Definir estándares y métricas para los atributos de calidad anteriores, con criterios de aceptación verificables.

SALIDA
@/02-discovery/0202-prd/020206-non-functional-requirements/other/other.md

PLANTILLA — other.md
# NFR — Otros (mantenibilidad, observabilidad, portabilidad, i18n, soporte, coste)

## 1. Mantenibilidad
- Estándares de código (linters, cobertura mínima %, convenciones)
- Modularidad y límites de contexto
- Política de deprecación y compatibilidad
- DoD/DoR de arquitectura por épica

## 2. Observabilidad
- Métricas obligatorias por servicio (RED/USE)
- Trazas distribuidas (propagación, sampling)
- Logs estructurados (PII policy, retención)
- Dashboards mínimos por EP-*

## 3. Portabilidad e interoperabilidad
- Requisitos de contenedorización, IaC, compatibilidad DB
- Contratos API (versionado, breaking changes, idempotencia)

## 4. Soporteabilidad
- Catálogo de runbooks y tiempos objetivo de resolución por severidad
- Procedimiento de **on-call** y escalamiento
- Catálogo de errores/mensajes estándar

## 5. i18n/l10n
- Idiomas soportados, estrategia de locales, pluralización
- Separación de textos, formato números/fechas, RTL si aplica

## 6. Coste/FinOps
- Presupuestos por ambiente, etiquetas obligatorias, alertas de gasto
- Métricas de costo por transacción/journey

## 7. Sostenibilidad (GreenOps)
- Objetivos de consumo (CPU/hora, kWh estimado), políticas de apagado
- Métricas de eficiencia por workload

## 8. Pruebas/aceptación (BDD ejemplos)
- *Dado* un servicio nuevo, *cuando* se despliega a staging, *entonces* existen métricas RED y trazas para los endpoints críticos.
- *Dado* una API con breaking change, *cuando* se versione a v2, *entonces* v1 se mantiene N meses con deprecación documentada.

## 9. Trazabilidad y riesgos
- EP-* ↔ Atributo ↔ Métrica/Prueba
- Riesgos y mitigaciones

## 10. TODOs
- TODO: […]

MARCAS
<!-- AUTO:BEGIN --> … <!-- AUTO:END -->

REGLAS
- Nada “no medible”: cada atributo debe tener métrica o verificación concreta.
- No duplicar controles ya definidos en otras NFR; enlazar.
- **Si el archivo ya existe en la ruta indicada, SOBRESCRIBIRLO (no crear copia duplicada).**

COMANDOS
- GENERAR / ACTUALIZAR / LISTAR TODOs
