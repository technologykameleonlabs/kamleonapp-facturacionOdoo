---
docId: sitemap-architecture
projectCode: kameleon-app
version: 0.2.0
date: 2025-09-19
inputsHash: pending
schemas: [masterdata, projects, tasks, base, auth, analytics, progress, audit]
totalViews: 31
totalGroups: 7
maxDepth: 3
owner: product.design
reviewers: [engineering, qa, schema-leads]
status: draft
---

# Arquitectura de Información - Sitemap

## Aplicación Principal

├── G01 - Configuración de Datos Maestros
│   ├── G01-V01 - Gestión de Empleados
│   ├── G01-V02 - Catálogos de Proyectos (tabs)
│   │   ├── G01-V02-01 - Tipos de Proyecto
│   │   ├── G01-V02-02 - Etapas de Proyecto
│   │   └── G01-V02-03 - Plantillas de Proyecto
│   ├── G01-V03 - Catálogos de Tareas (tabs)
│   │   ├── G01-V03-01 - Tipos de Tarea
│   │   └── G01-V03-02 - Etapas/Workflow de Tarea
│   ├── G01-V04 - Gestión de Contactos
│   ├── G01-V05 - Gestión de Entidades (multi-tenant)
│   ├── G01-V06 - Seguridad, Roles y Permisos (roles globales, permisos, jerarquías)
│   ├── G01-V07 - Estados de Presencia (configuración de 9 estados, reglas de transición, gestión de inactividad)
│   ├── G01-V08 - Auditoría & Seguridad (logs de acceso, validación de permisos, reportes)
│   └── G01-V09 - Configuración del Sistema (vista consolidada de datos maestros)
├── [Widget Global] Estado de Presencia (disponible en header/sidebar: actualización manual, estados temporales, historial rápido)
├── G02 - Gestión de Proyectos
│   ├── G02-V01 - Proyectos — Lista / Dashboard (lista activa, métricas, accesos rápidos, cálculos de progreso)
│   ├── G02-V02 - Creación de Proyecto (pantalla única con secciones plegables)
│   ├── G02-V03 - Detalle de Proyecto (tabs: general, configuración, miembros, permisos, tareas, historial)
│   └── G02-V04 - Salud & Reportes de Proyectos (hub con modos: Salud por proyecto, Comparativa de portafolio, Reportes ejecutivos)
├── G03 - Gestión de Tareas
│   ├── G03-V01 - Home de Tareas / Tablero Kanban (mis tareas, filtros, notificaciones)
│   ├── G03-V02 - Crear Tarea (pantalla única con secciones: proyecto/tipo, datos básicos, asignación/dependencias)
│   ├── G03-V03 - Detalle de Tarea (info, historial, comentarios, adjuntos, dependencias, actualizar estado, reasignar)
│   ├── G03-V04 - Workflows y Aprobaciones de Tareas Críticas (asignación/cambio con aprobación)
│   └── G03-V05 - Configuración de Metadata de Asignaciones (para analítica/contabilidad)
├── G05 - Registro de Tiempo
│   ├── G05-V01 - Registro Diario (hub principal: propuesta automática, inicio/pausa, tipos dedicación, recordatorios, historial diario, ajustes retroactivos con validaciones, integración con estados de presencia automáticos)
│   └── G05-V02 - Configuración & Reportes (tabs: políticas y límites, reportes de calidad, metadatos analítica, configuración de detección de inactividad)
├── G06 - Portafolio & Presupuestos
│   ├── G06-V01 - Hub de Planificación (modos por rol: PM-Planificar[capacidad+asignaciones], CTO-Revisar[consolidado+correcciones], Ejecutivo-Aprobar[revisión estratégica+ingresos+aprobación final+activación automática seguimiento])
│   └── G06-V02 - Seguimiento & Ajustes (tabs: estado proyectos, comparativas rendimiento, ajustes estratégicos, reportes ejecutivos, planes mensuales activos, comparación diaria vs real[alertas automáticas+análisis causas+reportes variaciones])
├── G08 - Oficina Virtual y Dashboards
│   ├── G08-V01 - Oficina Virtual Unificada (centro de experiencia: vista inmersiva del equipo, navegación intuitiva, presencia compartida, integración Google Calendar)
│   ├── G08-V02 - Dashboard de Equipo (presencia por departamento, carga de trabajo, métricas agregadas, contexto proyectos/tareas en tiempo real)
│   ├── G08-V03 - Dashboard de Proyecto (presencia por proyecto, asignaciones activas, progreso en tiempo real, drill-down detallado)
│   └── G08-V04 - Análisis de Rendimiento (hub multidimensional avanzado: análisis por empleado/departamento/proyecto/tarea/cliente, gasto-ingreso-rentabilidad, comparaciones intra-grupo, productividad por período, costes directos/indirectos, rentabilidad por cliente-sector-país, tendencias temporales, comparativas inter-períodos, proyecciones basadas en histórico, alertas por desviaciones)
├── G09 - Herramientas Administrativas
│   ├── G09-V01 - Gestión de Canales Discord (creación automática, categorías, organización, sincronización con estructura organizacional)
│   ├── G09-V02 - Integraciones Externas (configuración APIs, sincronización servicios externos, utilidades administrativas)
│   ├── G09-V03 - Contabilidad Analítica (configuración tarifas empleados, apuntes manuales, aprobaciones stages, conversión automática horas→costes)
│   ├── G09-V04 - Sistema de Workflows de Aprobación (configuración workflows maestros, gestión etapas, asignación a objetos, dashboard monitoreo, historial completo)
│   └── G09-V05 - Sistema de Notificaciones (configuración tipos, templates HTML, gestión destinatarios, API genérica, dashboard envío)
├── [Componente Transversal] Bandeja de Aprobaciones (disponible en header/navigation: solicitudes pendientes, filtros por tipo/prioridad, procesamiento masivo)
├── [Componente Transversal] Centro de Notificaciones (disponible en header/sidebar: historial notificaciones, filtros por tipo/fecha, configuración preferencias)
└── [Backlog futuro] Auditoría y Seguridad avanzada (validación de accesos, logs, reportes de seguridad)

