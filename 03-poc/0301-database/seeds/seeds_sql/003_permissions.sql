-- =====================================================
-- SEEDS: Permisos del Sistema
-- =====================================================
-- Poblar base.mst_permissions con todos los permisos
-- =====================================================

INSERT INTO base.mst_permissions (
    id,
    name,
    description
) VALUES
-- Gestión de Roles y Permisos
(gen_random_uuid(), 'gestionar_roles_globales', 'Permite crear, editar y eliminar roles globales del sistema'),
(gen_random_uuid(), 'asignar_roles_proyectos', 'Permite asignar roles específicos a usuarios dentro de proyectos'),
(gen_random_uuid(), 'gestionar_permisos_granulares', 'Permite gestionar permisos detallados por usuario en proyectos específicos'),
(gen_random_uuid(), 'validar_accesos_auditoria', 'Permite validar accesos y consultar logs de auditoría completa'),

-- Gestión de Empleados y Contactos
(gen_random_uuid(), 'gestionar_empleados', 'Permite crear, editar y eliminar empleados del sistema'),
(gen_random_uuid(), 'gestionar_contactos', 'Permite gestionar contactos de individuos y empresas'),
(gen_random_uuid(), 'gestionar_entidades', 'Permite gestionar entidades/empresas para multi-tenancy'),

-- Gestión de Proyectos
(gen_random_uuid(), 'gestionar_tipos_proyecto', 'Permite gestionar tipos de proyecto y sus etapas asociadas'),
(gen_random_uuid(), 'gestionar_etapas_proyecto', 'Permite configurar etapas estándar del ciclo de vida de proyectos'),
(gen_random_uuid(), 'gestionar_plantillas_proyecto', 'Permite crear y gestionar plantillas de proyecto reutilizables'),
(gen_random_uuid(), 'crear_proyecto', 'Permite crear nuevos proyectos desde plantillas o manualmente'),
(gen_random_uuid(), 'configurar_proyecto', 'Permite modificar parámetros básicos de proyectos'),
(gen_random_uuid(), 'gestionar_proyectos', 'Permite visualizar y gestionar lista de proyectos creados'),

-- Gestión de Tareas
(gen_random_uuid(), 'gestionar_tipos_tarea', 'Permite gestionar tipos de tarea para categorizar el trabajo'),
(gen_random_uuid(), 'gestionar_etapas_tarea', 'Permite configurar etapas del flujo de trabajo de tareas'),
(gen_random_uuid(), 'gestionar_tipos_tarea_proyecto', 'Permite gestionar tipos de tarea específicos por proyecto'),
(gen_random_uuid(), 'crear_tareas', 'Permite crear tareas individuales en proyectos'),
(gen_random_uuid(), 'asignar_tareas', 'Permite asignar tareas a usuarios específicos'),
(gen_random_uuid(), 'gestionar_dependencias', 'Permite gestionar dependencias entre tareas'),
(gen_random_uuid(), 'actualizar_estado_tareas', 'Permite actualizar estado de tareas asignadas'),
(gen_random_uuid(), 'reasignar_tareas', 'Permite cambiar asignación de tareas a otros usuarios'),
(gen_random_uuid(), 'gestionar_tiempo_estimado', 'Permite configurar tiempo estimado para tareas'),
(gen_random_uuid(), 'visualizar_tablero_kanban', 'Permite ver tablero Kanban con estado de tareas'),
(gen_random_uuid(), 'gestionar_comentarios_tareas', 'Permite agregar comentarios a tareas'),
(gen_random_uuid(), 'gestionar_adjuntos_tareas', 'Permite gestionar archivos adjuntos a tareas'),

-- Dashboard y Salud de Proyectos
(gen_random_uuid(), 'calcular_progreso_automatico', 'Permite calcular progreso automático de proyectos'),
(gen_random_uuid(), 'evaluar_riesgos_tiempo_real', 'Permite evaluar riesgos en tiempo real'),
(gen_random_uuid(), 'visualizar_dashboard_salud', 'Permite ver dashboard de salud completo de proyectos'),
(gen_random_uuid(), 'configurar_indicadores_personalizados', 'Permite configurar indicadores KPIs personalizados'),
(gen_random_uuid(), 'monitorear_metricas_tiempo_real', 'Permite monitorear métricas en tiempo real'),
(gen_random_uuid(), 'gestionar_alertas_notificaciones', 'Permite gestionar alertas y notificaciones de proyectos'),
(gen_random_uuid(), 'comparar_salud_proyectos', 'Permite comparar salud entre diferentes proyectos'),
(gen_random_uuid(), 'generar_reportes_salud_ejecutivos', 'Permite generar reportes ejecutivos de salud de proyectos'),

-- Estados de Presencia
(gen_random_uuid(), 'actualizar_estado_presencia', 'Permite actualizar estado de presencia manualmente'),
(gen_random_uuid(), 'ver_estados_automaticos', 'Permite que el sistema actualice estados automáticamente'),
(gen_random_uuid(), 'transiciones_estado_validacion', 'Permite gestionar transiciones y validaciones de estado'),
(gen_random_uuid(), 'recibir_notificaciones_cambio', 'Permite recibir notificaciones de cambios de estado de equipo'),
(gen_random_uuid(), 'gestionar_estados_temporales', 'Permite establecer estados temporales con duración definida'),
(gen_random_uuid(), 'visualizar_dashboard_equipo', 'Permite ver dashboard de presencia por equipo'),
(gen_random_uuid(), 'visualizar_dashboard_proyecto', 'Permite ver dashboard de presencia por proyecto'),
(gen_random_uuid(), 'visualizar_carga_trabajo_equipo', 'Permite ver indicadores de carga de trabajo por departamento'),
(gen_random_uuid(), 'ver_metricas_agregadas_presencia', 'Permite ver métricas consolidadas de presencia organizacional'),
(gen_random_uuid(), 'ver_dashboard_historico_presencia', 'Permite ver historial de presencia del equipo'),
(gen_random_uuid(), 'ver_contexto_tareas_tiempo_real', 'Permite ver qué tareas trabaja cada miembro en tiempo real'),

-- Oficina Virtual
(gen_random_uuid(), 'visualizar_oficina_virtual', 'Permite acceder a la oficina virtual unificada'),
(gen_random_uuid(), 'ver_vista_global_empresa', 'Permite ver estado completo de la organización'),
(gen_random_uuid(), 'navegar_desde_oficina_virtual', 'Permite navegar directamente a proyectos y tareas desde oficina'),
(gen_random_uuid(), 'experiencia_trabajo_compartido', 'Permite elementos de trabajo compartido en oficina virtual'),

-- Registro de Tiempo
(gen_random_uuid(), 'registrar_tiempo_diario', 'Permite registrar tiempo diario con propuesta automática'),
(gen_random_uuid(), 'cambiar_tarea_asignada', 'Permite cambiar tarea propuesta por el sistema'),
(gen_random_uuid(), 'seleccionar_tipo_dedicacion', 'Permite seleccionar tipo de dedicación (producción, formación, etc.)'),
(gen_random_uuid(), 'gestionar_pausas', 'Permite registrar y gestionar pausas en jornada laboral'),
(gen_random_uuid(), 'revision_ajustes_registro_diario', 'Permite revisar y ajustar registro diario de tiempo'),
(gen_random_uuid(), 'integracion_contabilidad_analitica', 'Permite integrar registro de tiempo con contabilidad analítica'),
(gen_random_uuid(), 'configurar_metadatos_analiticos', 'Permite configurar metadatos para análisis avanzado'),
(gen_random_uuid(), 'control_limites_pausas', 'Permite establecer límites de duración y frecuencia de pausas'),
(gen_random_uuid(), 'validacion_automatica_ajustes', 'Permite validar automáticamente ajustes retroactivos'),
(gen_random_uuid(), 'manejo_excepciones_pausas', 'Permite manejar excepciones comunes en pausas'),
(gen_random_uuid(), 'reportes_calidad_registros', 'Permite visualizar reportes de calidad sobre registros y pausas'),

-- Planificación y Presupuestos
(gen_random_uuid(), 'visualizar_capacidad_recursos', 'Permite visualizar capacidad disponible de recursos humanos'),
(gen_random_uuid(), 'planificar_asignaciones_proyecto', 'Permite definir asignaciones de empleados considerando costes'),
(gen_random_uuid(), 'calcular_costes_margenes_automatico', 'Permite calcular costes y márgenes automáticamente'),
(gen_random_uuid(), 'definir_objetivos_rentabilidad', 'Permite establecer objetivos de rentabilidad mensuales'),
(gen_random_uuid(), 'validar_restricciones_disponibilidad', 'Permite validar restricciones de capacidad y disponibilidad'),
(gen_random_uuid(), 'integracion_contabilidad_analitica_pm', 'Permite integrar presupuestos con contabilidad analítica'),
(gen_random_uuid(), 'soporte_multi_moneda_presupuestos', 'Permite definir presupuestos en múltiples monedas'),
(gen_random_uuid(), 'clasificar_costes_directo_indirecto', 'Permite clasificar costes como directo o indirecto'),
(gen_random_uuid(), 'almacenamiento_datos_raw_analitica', 'Permite almacenar datos de presupuesto en formato raw'),

-- Revisión CTO
(gen_random_uuid(), 'enviar_revision_cto', 'Permite enviar presupuestos automáticamente a revisión CTO'),
(gen_random_uuid(), 'revisar_planificaciones_pm', 'Permite revisar planificaciones presupuestarias de Project Managers'),
(gen_random_uuid(), 'identificar_problemas_capacidad', 'Permite identificar problemas de sobrecarga o subutilización'),
(gen_random_uuid(), 'corregir_asignaciones_problematicas', 'Permite corregir asignaciones problemáticas con herramientas intuitivas'),
(gen_random_uuid(), 'validar_viabilidad_tecnica', 'Permite validar viabilidad técnica de planificaciones'),

-- Aprobación Ejecutiva
(gen_random_uuid(), 'escalada_automatica_aprobacion_ejecutiva', 'Permite escalar presupuestos validados a aprobación ejecutiva'),
(gen_random_uuid(), 'revisar_planificaciones_estrategicamente', 'Permite revisar planificaciones desde perspectiva estratégica'),
(gen_random_uuid(), 'incorporar_presupuestacion_ingresos', 'Permite incorporar estimaciones de ingresos a planificaciones'),
(gen_random_uuid(), 'aprobar_planificacion_final_ejecutiva', 'Permite dar aprobación final a planificaciones completas'),

-- Seguimiento Presupuestario
(gen_random_uuid(), 'activacion_automatica_seguimiento', 'Permite activar automáticamente módulo de seguimiento'),
(gen_random_uuid(), 'seguimiento_presupuestario_vs_real', 'Permite hacer seguimiento de presupuesto vs ejecución real'),

-- Análisis y Reportes
(gen_random_uuid(), 'consultar_gasto_ingreso_rentabilidad_empleado', 'Permite consultar gasto, ingreso y rentabilidad por empleado'),
(gen_random_uuid(), 'analizar_departamento', 'Permite analizar métricas por departamento'),
(gen_random_uuid(), 'consultar_proyecto_tarea_cliente', 'Permite consultar análisis por proyecto, tarea y cliente'),
(gen_random_uuid(), 'analizar_sector_pais_cliente', 'Permite analizar por sector económico y país de cliente'),
(gen_random_uuid(), 'analisis_temporal_comparativo', 'Permite análisis temporal comparativo de métricas'),
(gen_random_uuid(), 'configurar_modelo_datos_analiticos', 'Permite configurar modelo de datos multi-dimensional'),
(gen_random_uuid(), 'definir_reglas_clasificacion_automatica', 'Permite definir reglas automáticas para clasificar costes'),
(gen_random_uuid(), 'configurar_soporte_multi_moneda', 'Permite configurar conversión automática multi-moneda'),
(gen_random_uuid(), 'configurar_dimensiones_analiticas', 'Permite configurar dimensiones disponibles para análisis'),
(gen_random_uuid(), 'gestionar_acceso_reportes', 'Permite gestionar qué reportes están disponibles por rol'),
(gen_random_uuid(), 'consultar_reporte_especifico', 'Permite consultar reportes específicos con filtros básicos'),
(gen_random_uuid(), 'visualizar_datos_consolidados_tiempo_real', 'Permite visualizar datos consolidados en tiempo real'),
(gen_random_uuid(), 'exportar_reportes_multiples_formatos', 'Permite exportar reportes en PDF o Excel'),
(gen_random_uuid(), 'programar_envio_automatico_reportes', 'Permite programar envío automático de reportes por email'),

-- Gamificación
(gen_random_uuid(), 'desbloquear_logros', 'Permite desbloquear logros por actividades realizadas'),
(gen_random_uuid(), 'acumular_puntos_niveles', 'Permite acumular puntos y subir de nivel en sistema gamificado'),
(gen_random_uuid(), 'recibir_recompensas_consistencia', 'Permite recibir recompensas por hábitos consistentes'),
(gen_random_uuid(), 'ver_elementos_gamificados_sutiles', 'Permite ver elementos gamificados discretos en oficina virtual')

ON CONFLICT (name) DO NOTHING;
