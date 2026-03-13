# Arquitectura de Información - Tabla de Nodos

## Tabla Principal de Nodos

| nodeId | label | path | schema | level | purpose | primaryActor | dataRefs (Database Schema) | visibilityRule | groupId | viewId |
|--------|-------|------|--------|-------|---------|--------------|--------------------------|----------------|---------|--------|
| G01-V01 | Gestión de Empleados | /admin/masterdata/employees | masterdata | 2 | list | Admin | masterdata.employees | role:ADMIN | G01 | V01 |
| G01-V02 | Gestión de Maestros de Proyectos | /admin/projects | projects | 1 | list | Admin | projects.*, tasks.* | role:ADMIN | G01 | V02 |
| G01-V02-01 | Tipos de Proyecto | /admin/projects/types | projects | 3 | list | Admin | projects.project_types | role:ADMIN | G01 | V02-01 |
| G01-V02-02 | Etapas de Proyecto | /admin/projects/stages | projects | 3 | list | Admin | projects.project_stages | role:ADMIN | G01 | V02-02 |
| G01-V02-03 | Plantillas de Proyecto | /admin/projects/templates | projects | 3 | list | Admin | projects.project_templates | role:ADMIN | G01 | V02-03 |
| G01-V02-04 | Tipos de Tarea | /admin/projects/tasks/types | tasks | 3 | list | Admin | tasks.task_types | role:ADMIN | G01 | V02-04 |
| G01-V02-05 | Etapas de Tarea | /admin/projects/tasks/stages | tasks | 3 | list | Admin | tasks.task_stages | role:ADMIN | G01 | V02-05 |
| G01-V03 | Gestión de Contactos | /admin/masterdata/contacts | masterdata | 2 | list | Admin | masterdata.contacts | role:ADMIN | G01 | V03 |
| G01-V04 | Gestión de Entidades | /admin/base/entities | base | 2 | list | Admin | base.entities | role:ADMIN | G01 | V04 |
| G01-V05 | Gestión de Roles y Permisos (roles globales, permisos, jerarquías) | /admin/auth/roles | auth | 2 | list | Admin | auth.roles, auth.permissions | role:ADMIN | G01 | V05 |
| G01-V06 | Gestión de KPIs y Métricas | /admin/kpis | analytics | 2 | list | Admin | analytics.kpis, analytics.metrics | role:ADMIN | G01 | V06 |
| G01-V07 | Auditoría y Seguridad (validación accesos, logs, reportes seguridad) | /admin/audit | audit | 2 | dashboard | Admin | audit.logs, audit.reports | role:ADMIN | G01 | V07 |
| G02-V01 | Dashboard de Proyectos | /projects | projects | 1 | dashboard | PM | projects.* | role:PM | G02 | V01 |
| G02-V02 | Creación de Proyecto | /projects/create | projects | 1 | create | PM | projects.* | role:PM | G02 | V02 |
| G02-V02-01 | Paso 1: Seleccionar Tipo/Plantilla | /projects/create?step=1 | projects | 2 | form | PM | projects.* | role:PM | G02 | V02-01 |
| G02-V02-02 | Paso 2: Configurar Parámetros Básicos | /projects/create?step=2 | projects | 2 | form | PM | projects.* | role:PM | G02 | V02-02 |
| G02-V02-03 | Paso 3: Revisar y Validar | /projects/create?step=3 | projects | 2 | form | PM | projects.* | role:PM | G02 | V02-03 |
| G02-V02-04 | Paso 4: Crear Proyecto | /projects/create?step=4 | projects | 2 | form | PM | projects.* | role:PM | G02 | V02-04 |
| G02-V03 | Detalles de Proyecto | /projects/:id | projects | 2 | detail | PM | projects.* | role:PM | G02 | V03 |
| G03-V01 | Home de Tareas | /tasks | tasks | 1 | dashboard | User | tasks.* | role:USER | G03 | V01 |
| G03-V02 | Creación de Tarea | /tasks/create | tasks | 1 | create | PM | tasks.* | role:PM | G03 | V02 |
| G03-V02-01 | Selección de Proyecto y Tipo | /tasks/create?step=1 | tasks | 2 | form | PM | tasks.* | role:PM | G03 | V02-01 |
| G03-V02-02 | Configuración Básica | /tasks/create?step=2 | tasks | 2 | form | PM | tasks.* | role:PM | G03 | V02-02 |
| G03-V02-03 | Asignación y Dependencias | /tasks/create?step=3 | tasks | 2 | form | PM | tasks.* | role:PM | G03 | V02-03 |
| G03-V02-04 | Revisión y Creación | /tasks/create?step=4 | tasks | 2 | form | PM | tasks.* | role:PM | G03 | V02-04 |
| G03-V03 | Detalle de Tarea | /tasks/:id | tasks | 2 | detail | User | tasks.* | role:USER | G03 | V03 |
| G03-V04 | Workflows Activos | /tasks/workflows | tasks | 1 | process | PM | tasks.* | role:PM | G03 | V04 |

## Metadatos Adicionales por Nodo

### Información General
- **Total de nodos:** 22
- **Grupos definidos:** 3
- **Profundidad máxima:** 3
- **Esquemas cubiertos:** masterdata, projects, tasks, base, auth, analytics, audit

### Detalles por Vista

#### G01-V01 - Gestión de Empleados
- **Propósito:** CRUD completo de empleados con gestión de tarifas horarias
- **Actor primario:** Administrador
- **Funcionalidades:** Listado paginado, creación, edición, eliminación con confirmaciones
- **Puntos de entrada:** /admin/masterdata/employees
- **Cross-links:** G01-V08 (dashboard), G01-V07 (roles)
- **Breadcrumb:** Admin > Datos Maestros > Empleados
- **Parámetros:** ?page=1&sort=name&filter=active
- **Estados vacíos:** "No hay empleados registrados"
- **Facetas:** status (active/inactive), role, department
- **Contenido relacionado:** Perfiles de empleado, historial de tarifas

#### G01-V02 - Gestión de Maestros de Proyectos
- **Propósito:** Vista principal que agrupa todos los maestros relacionados con proyectos y tareas
- **Actor primario:** Administrador
- **Funcionalidades:** Navegación unificada a tipos, etapas y plantillas de proyecto y tarea
- **Puntos de entrada:** /admin/projects
- **Cross-links:** G01-V02-01, G01-V02-02, G01-V02-03, G01-V02-04, G01-V02-05 (subvistas)
- **Breadcrumb:** Admin > Datos Maestros > Proyectos
- **Parámetros:** ?tab=types (por defecto)
- **Estados vacíos:** "No hay maestros de proyecto configurados"
- **Facetas:** category (types/stages/templates/tasks), status
- **Contenido relacionado:** Todas las configuraciones de proyecto y tarea

#### G01-V02-01 - Tipos de Proyecto
- **Propósito:** CRUD de tipos de proyecto con asignación de etapas por defecto
- **Actor primario:** Administrador
- **Funcionalidades:** Gestión de tipos, asignación de etapas, validaciones
- **Puntos de entrada:** /admin/projects/types
- **Cross-links:** G01-V02-02 (etapas), G01-V02-03 (plantillas)
- **Breadcrumb:** Admin > Proyectos > Tipos
- **Parámetros:** ?page=1&sort=name&filter=active
- **Estados vacíos:** "No hay tipos de proyecto configurados"
- **Facetas:** status (active/inactive), category
- **Contenido relacionado:** Estadísticas de uso por tipo

#### G01-V02-02 - Etapas de Proyecto
- **Propósito:** CRUD de etapas del ciclo de vida de proyectos
- **Actor primario:** Administrador
- **Funcionalidades:** Definición de etapas con orden y propiedades
- **Puntos de entrada:** /admin/projects/stages
- **Cross-links:** G01-V02-01 (tipos), G01-V02-03 (plantillas)
- **Breadcrumb:** Admin > Proyectos > Etapas
- **Parámetros:** ?page=1&sort=order&filter=active
- **Estados vacíos:** "No hay etapas de proyecto definidas"
- **Facetas:** status (active/inactive), type
- **Contenido relacionado:** Proyectos usando cada etapa

#### G01-V02-03 - Plantillas de Proyecto
- **Propósito:** CRUD de plantillas con configuración predefinida
- **Actor primario:** Administrador
- **Funcionalidades:** Creación de plantillas basadas en tipos y etapas
- **Puntos de entrada:** /admin/projects/templates
- **Cross-links:** G01-V02-01 (tipos), G01-V02-02 (etapas)
- **Breadcrumb:** Admin > Proyectos > Plantillas
- **Parámetros:** ?page=1&sort=name&filter=active
- **Estados vacíos:** "No hay plantillas de proyecto disponibles"
- **Facetas:** status (active/inactive), type
- **Contenido relacionado:** Estadísticas de reutilización

#### G01-V02-04 - Tipos de Tarea
- **Propósito:** CRUD de categorías de tareas
- **Actor primario:** Administrador
- **Funcionalidades:** Clasificación y configuración de tipos
- **Puntos de entrada:** /admin/projects/tasks/types
- **Cross-links:** G01-V02-05 (etapas)
- **Breadcrumb:** Admin > Proyectos > Tareas > Tipos
- **Parámetros:** ?page=1&sort=name&filter=active
- **Estados vacíos:** "No hay tipos de tarea definidos"
- **Facetas:** status (active/inactive), category
- **Contenido relacionado:** Estadísticas de uso

#### G01-V02-05 - Etapas de Tarea
- **Propósito:** CRUD de etapas del flujo de trabajo de tareas
- **Actor primario:** Administrador
- **Funcionalidades:** Definición del workflow de tareas
- **Puntos de entrada:** /admin/projects/tasks/stages
- **Cross-links:** G01-V02-04 (tipos)
- **Breadcrumb:** Admin > Proyectos > Tareas > Etapas
- **Parámetros:** ?page=1&sort=order&filter=active
- **Estados vacíos:** "No hay etapas de tarea definidas"
- **Facetas:** status (active/inactive), workflow
- **Contenido relacionado:** Tareas en cada etapa

#### G01-V03 - Gestión de Contactos
- **Propósito:** CRUD de contactos individuales y empresas
- **Actor primario:** Administrador
- **Funcionalidades:** Gestión completa con segmentación por tipo
- **Puntos de entrada:** /admin/masterdata/contacts
- **Cross-links:** G01-V04 (entidades)
- **Breadcrumb:** Admin > Datos Maestros > Contactos
- **Parámetros:** ?page=1&sort=name&filter=type
- **Estados vacíos:** "No hay contactos registrados"
- **Facetas:** type (individual/company), sector, country
- **Contenido relacionado:** Proyectos asociados

#### G01-V04 - Gestión de Entidades
- **Propósito:** CRUD de entidades para multi-tenancy
- **Actor primario:** Administrador
- **Funcionalidades:** Configuración de segmentación por organización
- **Puntos de entrada:** /admin/base/entities
- **Cross-links:** G01-V01 (empleados)
- **Breadcrumb:** Admin > Base > Entidades
- **Parámetros:** ?page=1&sort=name&filter=active
- **Estados vacíos:** "No hay entidades configuradas"
- **Facetas:** status (active/inactive), type
- **Contenido relacionado:** Empleados y proyectos por entidad

#### G01-V05 - Gestión de Roles y Permisos
- **Propósito:** CRUD de roles con asignación granular de permisos
- **Actor primario:** Administrador
- **Funcionalidades:** Gestión de control de acceso
- **Puntos de entrada:** /admin/auth/roles
- **Cross-links:** G01-V01 (empleados)
- **Breadcrumb:** Admin > Auth > Roles y Permisos
- **Parámetros:** ?page=1&sort=name&filter=active
- **Estados vacíos:** "No hay roles definidos"
- **Facetas:** status (active/inactive), level
- **Contenido relacionado:** Usuarios por rol, permisos asignados

#### G02-V01 - Dashboard de Proyectos (lista activa, métricas, pendientes, accesos rápidos, notificaciones)
- **Propósito:** Vista principal integrada del PM con navegación a todas las funcionalidades
- **Actor primario:** Project Manager
- **Funcionalidades:** Lista proyectos, métricas, estados pendientes, accesos rápidos, notificaciones
- **Puntos de entrada:** /projects
- **Cross-links:** G02-V02 (crear), G02-V03 (detalles), G01-V02 (configuración)
- **Breadcrumb:** Proyectos
- **Parámetros:** ?view=dashboard&filter=my_projects
- **Estados vacíos:** "Bienvenido, crea tu primer proyecto"
- **Facetas:** time_period (week/month/quarter), status (active/overdue/completed)
- **Contenido relacionado:** Próximas entregas, proyectos críticos, estadísticas personales, estados pendientes

#### G02-V02 - Creación de Proyecto
- **Propósito:** Flujo guiado de 4 pasos para crear proyectos desde plantillas o manual
- **Actor primario:** Project Manager
- **Funcionalidades:** Wizard de creación, validaciones en tiempo real, vista previa
- **Puntos de entrada:** /projects/create
- **Cross-links:** G01-V02 (plantillas), G01-V02-01 (tipos), G02-V01 (dashboard)
- **Breadcrumb:** Proyectos > Crear Proyecto
- **Parámetros:** ?step=1&template_id=123&mode=template
- **Estados vacíos:** "Selecciona un tipo de proyecto para comenzar"
- **Facetas:** creation_mode (template/manual), project_type, complexity
- **Contenido relacionado:** Plantillas recomendadas, proyectos similares creados

#### G02-V03 - Detalles de Proyecto (general, config, miembros, tareas, dashboard salud, reportes, historial, estados, acciones)
- **Propósito:** Vista completa de un proyecto con navegación por pestañas incluyendo gestión de miembros, tareas y seguimiento de progreso
- **Actor primario:** Project Manager
- **Funcionalidades:** Información general, configuración, gestión de miembros del proyecto con roles y permisos granulares, gestión de tareas del proyecto, dashboard de salud con indicadores visuales, generación de reportes automáticos, historial, estados, acciones
- **Puntos de entrada:** /projects/:id
- **Cross-links:** G02-V01 (dashboard), G01-V02 (configuración), G03-V01 (home tareas), G03-V02 (crear tarea)
- **Breadcrumb:** Proyectos > [Nombre Proyecto]
- **Parámetros:** ?tab=overview&section=general
- **Estados vacíos:** "Proyecto en configuración inicial"
- **Facetas:** information_type (general/config/tasks/health/reports/history/states/actions), status
- **Contenido relacionado:** Miembros del equipo, tareas del proyecto, tablero Kanban, dashboard de salud con semáforos, reportes automáticos, documentos, historial de estados

#### G03-V01 - Home de Tareas (kanban, mis tareas, actualización, comentarios, métricas, filtros, notificaciones)
- **Propósito:** Centro principal unificado de gestión de tareas con Kanban y trabajo diario
- **Actor primario:** Miembro del equipo
- **Funcionalidades:** Tablero Kanban, mis tareas activas, actualización rápida de estado, comentarios, adjuntos, métricas, filtros, notificaciones
- **Puntos de entrada:** /tasks
- **Cross-links:** G03-V02 (crear), G03-V03 (detalle), G03-V04 (workflows), G02-V01 (proyectos)
- **Breadcrumb:** Tareas
- **Parámetros:** ?view=kanban&filter=my_tasks&status=active
- **Estados vacíos:** "No tienes tareas asignadas, ¡bienvenido!"
- **Facetas:** view_mode (kanban/list), time_filter (today/week/month), priority, status, work_mode (active/overdue)
- **Contenido relacionado:** Estadísticas personales, tareas por proyecto, recordatorios, historial de actividad

#### G03-V02 - Creación de Tarea
- **Propósito:** Wizard de creación de tareas con selección de proyecto y configuración completa
- **Actor primario:** Project Manager
- **Funcionalidades:** Selección proyecto/tipo, configuración básica, asignación, dependencias, revisión
- **Puntos de entrada:** /tasks/create
- **Cross-links:** G03-V01 (dashboard), G02-V01 (proyectos), G01-V02-04 (tipos tarea)
- **Breadcrumb:** Tareas > Crear Tarea
- **Parámetros:** ?project_id=123&type_id=456&template=true
- **Estados vacíos:** "Selecciona un proyecto para comenzar"
- **Facetas:** project_selection, task_type, complexity_level
- **Contenido relacionado:** Proyectos disponibles, tipos de tarea, usuarios para asignación

#### G03-V03 - Detalle de Tarea (info, historial, workflows, comentarios, dependencias, acciones)
- **Propósito:** Vista completa de una tarea individual con toda su información y gestión
- **Actor primario:** Miembro del equipo
- **Funcionalidades:** Información completa, historial, workflows de aprobación, comentarios, adjuntos, dependencias, acciones
- **Puntos de entrada:** /tasks/:id
- **Cross-links:** G03-V01 (home), G03-V04 (workflows), G02-V03 (proyecto padre)
- **Breadcrumb:** Tareas > [Nombre Tarea]
- **Parámetros:** ?tab=overview&section=details
- **Estados vacíos:** "Tarea en configuración inicial"
- **Facetas:** information_type (general/history/workflows/comments/dependencies), status
- **Contenido relacionado:** Proyecto padre, tareas relacionadas, usuarios asignados

#### G03-V04 - Workflows Activos (aprobaciones, críticas, reasignaciones, acciones rápidas)
- **Propósito:** Centro de control para gestionar workflows de tareas críticos y aprobaciones
- **Actor primario:** Project Manager
- **Funcionalidades:** Aprobaciones pendientes, tareas críticas por asignar, reasignaciones pendientes, acciones rápidas
- **Puntos de entrada:** /tasks/workflows
- **Cross-links:** G03-V03 (detalle tarea), G03-V01 (home), G02-V01 (proyectos)
- **Breadcrumb:** Tareas > Workflows Activos
- **Parámetros:** ?filter=pending&sort=priority&type=approval
- **Estados vacíos:** "No hay workflows pendientes de acción"
- **Facetas:** workflow_type (approval/assignment/reassignment), priority (high/medium/low), time_urgency
- **Contenido relacionado:** Tareas críticas, usuarios pendientes, métricas de workflow

#### G01-V07 - Auditoría y Seguridad (validación accesos, logs, reportes seguridad)
- **Propósito:** Dashboard administrativo para validación de accesos, consulta de auditoría y reportes de seguridad
- **Actor primario:** Administrador
- **Funcionalidades:** Validación en tiempo real de accesos, consulta de logs detallados, reportes de actividad por usuario/rol/proyecto, detección de accesos inusuales, revisión de permisos efectivos, exportación de datos de auditoría, alertas de seguridad automáticas
- **Puntos de entrada:** /admin/audit
- **Cross-links:** G01-V05 (roles), G01-V01 (usuarios)
- **Breadcrumb:** Admin > Auditoría y Seguridad
- **Parámetros:** ?filter=user&period=last_30_days&anomalies=true
- **Estados vacíos:** "No hay registros de auditoría recientes"
- **Facetas:** activity_type (login/access/modification), user_role (admin/pm/user), severity (normal/warning/critical)
- **Contenido relacionado:** Logs de actividad, reportes de cumplimiento, métricas de seguridad, usuarios activos

#### G01-V06 - Gestión de KPIs y Métricas
- **Propósito:** Configuración y gestión de indicadores KPIs personalizados para proyectos
- **Actor primario:** Administrador
- **Funcionalidades:** Definición de KPIs personalizados, configuración de fórmulas, umbrales y objetivos, seguimiento histórico, alertas automáticas
- **Puntos de entrada:** /admin/kpis
- **Cross-links:** G01-V02 (maestros proyectos), G02-V03 (detalles proyecto)
- **Breadcrumb:** Admin > KPIs y Métricas
- **Parámetros:** ?page=1&sort=name&filter=active
- **Estados vacíos:** "No hay KPIs configurados"
- **Facetas:** type (standard/custom), category (progress/risk/cost/time), status (active/inactive)
- **Contenido relacionado:** Librería de KPIs estándar, fórmulas de cálculo, configuraciones por proyecto