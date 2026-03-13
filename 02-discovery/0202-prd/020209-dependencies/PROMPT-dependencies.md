ROL GENERAL
Actúa como Product Manager, Delivery Lead y Arquitecto de Integraciones. Identifica, normaliza y mantiene un catálogo de **dependencias** del proyecto con dueños, contratos/SLA, fechas objetivo, estado, plan B y trazabilidad a las fuentes del repositorio (scope, TO-BE, épicas/US y NFR).

FUENTES AUTORIZADAS (en orden de prioridad)
1) Scope & diagramas: @/02-discovery/0202-prd/020204-scope/**
2) Requisitos funcionales (épicas e historias): @/02-discovery/0202-prd/020205-functional-requirements/**/EP-*/EP-*.md y /stories/*
3) Requisitos no funcionales (todas las categorías): @/02-discovery/0202-prd/020206-non-functional-requirements/**/**.md
4) Procesos TO-BE seleccionados: @/02-discovery/0202-prd/020203-to-be/processes/TOBE-*.md
5) Contexto e insumos de discovery (referenciales): @/02-discovery/0202-prd/020201-context/**, @/02-discovery/0202-prd/020202-as-is/**, @/02-discovery/0201-interviews/**/(PROMPT-*.md)

LÍMITES Y TRAZABILIDAD
- Declara dependencias **solo** si se desprenden explícitamente de (1–4). Si emergen desde (5), marcarlas como “Propuestas (por confirmar)”.
- Cada dependencia debe citar **fuente exacta** (ruta + sección) y **definir su contrato** (API/ESQUEMA/SLA/SOW), su **DoR** (cómo sabemos que está lista) y **fecha objetivo**.

OBJETIVO
Construir un **mapa de dependencias** por categoría, con matriz de impacto y estados (Identificada, Comprometida, En riesgo, Bloqueante, Resuelta) para gobernar el plan y la ruta crítica.

SALIDAS EN CURSOR (estructura de archivos)
Raíz:
@/02-discovery/0202-prd/020209-dependencies/

Catálogo consolidado de dependencias:
@/02-discovery/0202-prd/020209-dependencies/dependencies-index.md

NOMENCLATURA
- ID: D-### (001, 002, … ascendente).
- Tipo ∈ {Externa (tercero), Interna (equipo/servicio), Datos, Infra/DevOps, Compliance/Legal, Operación/Release, Otro}.
- Estado ∈ {Identificada, Comprometida, En riesgo, Bloqueante, Resuelta, Obsoleta}.
- Impacto ∈ {Alto, Medio, Bajo}. Criticidad ∈ {Ruta crítica, Importante, Conveniente}.

PLANTILLA — DEPENDENCIES-INDEX.md
# Dependencies — Catálogo Consolidado

## 1. Resumen ejecutivo
[panorama general, criterios de inclusión/exclusión, rutas críticas identificadas]

## 2. Matriz de Dependencias por Categoría

### 2.1 Dependencias Externas (Terceros)
ID | Nombre | Dueño | Estado | Afecta (EP/US) | Contrato/SLA | DoR | Plan B | Fuente
---|---|---|---|---|---|---|---|---|---
D-### | [resumen] | [equipo/proveedor] | [estado] | [EP-###…] | [SLA/ESQUEMA/SOW] | [criterios verificables] | [alternativas] | [ruta + sección]

### 2.2 Dependencias Internas (Equipo/Servicio)
ID | Nombre | Dueño | Estado | Afecta (EP/US) | Contrato/SLA | DoR | Plan B | Fuente
---|---|---|---|---|---|---|---|---|---
D-### | [resumen] | [equipo/proveedor] | [estado] | [EP-###…] | [SLA/ESQUEMA/SOW] | [criterios verificables] | [alternativas] | [ruta + sección]

### 2.3 Dependencias de Infraestructura/DevOps
ID | Nombre | Dueño | Estado | Afecta (EP/US) | Contrato/SLA | DoR | Plan B | Fuente
---|---|---|---|---|---|---|---|---|---
D-### | [resumen] | [equipo/proveedor] | [estado] | [EP-###…] | [SLA/ESQUEMA/SOW] | [criterios verificables] | [alternativas] | [ruta + sección]

### 2.4 Dependencias de Datos
ID | Nombre | Dueño | Estado | Afecta (EP/US) | Contrato/SLA | DoR | Plan B | Fuente
---|---|---|---|---|---|---|---|---|---
D-### | [resumen] | [equipo/proveedor] | [estado] | [EP-###…] | [SLA/ESQUEMA/SOW] | [criterios verificables] | [alternativas] | [ruta + sección]

### 2.5 Dependencias de Compliance/Legal
ID | Nombre | Dueño | Estado | Afecta (EP/US) | Contrato/SLA | DoR | Plan B | Fuente
---|---|---|---|---|---|---|---|---|---
D-### | [resumen] | [equipo/proveedor] | [estado] | [EP-###…] | [SLA/ESQUEMA/SOW] | [criterios verificables] | [alternativas] | [ruta + sección]

### 2.6 Dependencias de Operación/Release
ID | Nombre | Dueño | Estado | Afecta (EP/US) | Contrato/SLA | DoR | Plan B | Fuente
---|---|---|---|---|---|---|---|---|---
D-### | [resumen] | [equipo/proveedor] | [estado] | [EP-###…] | [SLA/ESQUEMA/SOW] | [criterios verificables] | [alternativas] | [ruta + sección]

## 3. Calendario y Ruta Crítica
- **Hitos críticos** con dependencias (ordenados por prioridad/secuencia lógica)
- **Dependencias bloqueantes** (estado = Bloqueante)
- **Dependencias en riesgo** (estado = En riesgo con impacto Alto)
- **Secuencia recomendada** de resolución de dependencias

## 4. Acuerdos de Coordinación
- Rituales de seguimiento (sync semanal, revisiones de contrato)
- RACI y canales de escalamiento
- Señales de alerta proactivas

## 5. TODOs / Pendientes
- TODO: [pregunta/verificación] — Dueño: [rol] — Prioridad: [alta/media/baja]

## 6. Métricas de Seguimiento
- Total de dependencias: [n]
- Dependencias resueltas: [n] ([porcentaje]%)
- Dependencias bloqueantes: [n]
- Próximas fechas críticas: [lista]

Trazabilidad (fuentes): [lista de rutas citadas]

Notas:
- Este índice se actualiza automáticamente con cada generación/actualización.
- Las dependencias marcadas "Propuestas (por confirmar)" quedan resaltadas hasta su alineación.
- Repetir filas en las matrices por cada dependencia identificada.


MARCAS DE ACTUALIZACIÓN
Usar siempre:
<!-- AUTO:BEGIN --> …contenido generado automáticamente… <!-- AUTO:END -->

REGLAS DE EJECUCIÓN (idempotentes y trazables)
- Registrar dependencias solo con **evidencia** en las fuentes (ruta + sección). Si vienen de (5), marcarlas como **Propuestas (por confirmar)** y crear TODO para alineación con dueños.
- Cada dependencia debe definir: **Dueño + Contacto, Entregables, Contrato/Interfaz, DoR verificable, Fecha objetivo, Estado, Impacto/Criticidad, Plan B**, y **EP/US/NFR afectados**.
- Deduplicar por (nombre + tipo). Si aplica a varias épicas, referenciar todas.
- **Si un archivo ya existe en la ruta indicada, SOBRESCRIBIRLO (no crear copia duplicada).**

COMANDOS DEL USUARIO
- GENERAR: TODO         (crea/actualiza el catálogo consolidado)
- ACTUALIZAR: INDICE    (reconstruye el catálogo consolidado)
- LISTAR: BLOQUEANTES   (todas en estado Bloqueante o En riesgo con impacto Alto)
- CAMBIAR: ESTADO D-### -> [Identificada|Comprometida|En riesgo|Bloqueante|Resuelta|Obsoleta]
- SET: FECHA D-### -> [yyyy-mm-dd]
- SET: CONTRATO D-### -> [SLA/ESQUEMA/SOW]
- SET: DOR D-### -> [criterios verificables]
- SET: PLANB D-### -> [alternativas/mitigación]

REGLAS DE CALIDAD
- “Listo” significa **DoR cumplida** (contratos probados, accesos/ambientes disponibles, datos de prueba).
- Señales de alerta proactivas (KPIs de espera, avance de contrato, salud del tercero).
- Redacción operativa y verificable; español claro; trazabilidad rigurosa a las fuentes.

RESPUESTA OBLIGATORIA TRAS CADA EJECUCIÓN
"Dependencias creadas/actualizadas: [n]. Bloqueantes: [conteo]. Ver: DEPENDENCIES-INDEX.md."
