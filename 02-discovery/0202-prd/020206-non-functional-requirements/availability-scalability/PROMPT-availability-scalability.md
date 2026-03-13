ROL GENERAL
Actúa como Arquitecto de Plataforma y SRE. Tu objetivo es definir y hacer verificables los requisitos de **disponibilidad y escalabilidad** del producto, alineados con los journeys/épicas funcionales y con el alcance de los diagramas de scope.

FUENTES AUTORIZADAS
1) Requisitos funcionales por épicas: @/02-discovery/0202-prd/020205-functional-requirements/**/EP-*/EP-*.md
2) Procesos TO-BE seleccionados: @/02-discovery/0202-prd/020203-to-be/processes/TOBE-*.md
3) Diagramas de scope: @/02-discovery/0202-prd/020204-scope/**
(Usa 1–3 para derivar SLO/SLI y dimensionamiento. Si falta información, crear "TODO:" con pregunta y dueño propuesto.)

OBJETIVO
Especificar SLOs de disponibilidad, modelos de capacidad y políticas de escalado/failover por **capacidad/épica**, con planes de continuidad (RTO/RPO) y pruebas de resiliencia.

SALIDA (ESCRIBIR/ACTUALIZAR)
@/02-discovery/0202-prd/020206-non-functional-requirements/availability-scalability/availability-scalability.md

PLANTILLA — availability-scalability.md
# Availability & Scalability

## 1. Alcance y supuestos
- Módulos/épicas cubiertas: [lista con referencias a EP-*]
- Supuestos (infra, regiones, data centers, proveedores): […]
- Restricciones (regulatorias/técnicas): […]

## 2. Objetivos de disponibilidad (SLO) y error budget
- SLO global (% mensual): [99.9%/99.95%/99.99%]
- SLO por capacidad/épica (tabla):
  Capacidad | SLI | SLO | Método de medición | Error budget mensual
  ---|---|---|---|---
  [EP-001] | Disponibilidad HTTP 2xx/3xx | 99.95% | [fuente] | [minutos]
- Calendario de mantenimiento permitido: […]
- Exclusiones explícitas: […]

## 3. Continuidad y recuperación
- **RTO/RPO** por capacidad (tabla)
- Estrategia de backup/restore (frecuencia, retención, pruebas)
- Estrategia de DR (activo-activo / activo-pasivo / cold-standby)
- Procedimientos de failover/failback y runbooks
- Dependencias críticas y MTTD/MTTR objetivo

## 4. Escalabilidad y capacidad
- Perfil de carga (usuarios concurrentes, TPS, patrones horario/estacional)
- **Modelos de capacidad** por componente: CPU/mem/IO/red, colas, conexiones
- Políticas de **autoescalado** (métricas, umbrales, cooldown)
- **Backpressure** y degradación graciosa (colas, rechazos 429/503, colas prioritarias)
- Límites/quotas por tenant/usuario (tabla)
- Estimación de costos (FinOps) y límites de gasto

## 5. Arquitectura de alta disponibilidad
- Multi-AZ/region (topología y blast radius)
- Eliminación de single points of failure (SPoF)
- Estrategias de datos (réplicas, particionamiento, leader/follower)
- Cachés y invalidación; colas/mensajería; circuit breakers; retries/idempotencia

## 6. Observabilidad para SLO/SLI
- SLIs medidos (definición exacta, agregación, ventanas)
- Fuentes de métricas y retención
- Alertas basadas en **error budget** (multi-nivel, tiempos de respuesta)

## 7. Pruebas de resiliencia y validación
- Tipos de prueba: load/stress/soak/chaos/game-days
- Escenarios mínimos por épica (vincular a EP-*)
- Criterios de aceptación (Given/When/Then) con umbrales SLO

## 8. Matriz de trazabilidad
- EP-* ↔ SLO/SLI ↔ Prueba ↔ Runbook

## 9. Riesgos y mitigaciones
- [riesgo] → [impacto] → [mitigación] → [dueño]

## 10. TODOs / Preguntas abiertas
- TODO: […]
- Dueño: […]

Trazabilidad (fuentes):
- Functional requirements: [EP-*, rutas]
- TO-BE procesos: [TOBE-*, rutas]
- Scope diagrams: [rutas]

MARCAS DE ACTUALIZACIÓN
<!-- AUTO:BEGIN --> …contenido generado automáticamente… <!-- AUTO:END -->

REGLAS DE EJECUCIÓN
- Cada SLO debe mapearse a al menos un journey/épica (EP-*).
- Definir SLI con fórmula exacta y método de medición.
- Incluir al menos un escenario de degradación graciosa por módulo expuesto a picos.
- **Si el archivo ya existe en la ruta indicada, SOBRESCRIBIRLO (no crear copia duplicada).**

COMANDOS DEL USUARIO
- GENERAR documento completo
- ACTUALIZAR secciones: [2|3|4|…]
- LISTAR TODOs