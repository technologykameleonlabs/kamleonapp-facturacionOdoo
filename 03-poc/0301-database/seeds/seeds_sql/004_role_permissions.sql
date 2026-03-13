-- =====================================================
-- SEEDS: Asignación de Permisos a Roles
-- =====================================================
-- Asignar permisos a roles de manera lógica
-- =====================================================

-- Primero obtenemos los IDs de los roles y permisos
INSERT INTO base.rel_role_permissions (
    role_id,
    permission_id
)
SELECT
    r.id as role_id,
    p.id as permission_id
FROM base.mst_roles r
CROSS JOIN base.mst_permissions p
WHERE
    -- ADMINISTRADOR: TODOS los permisos
    (r.name = 'Administrador')

    -- DIRECTOR: Permisos ejecutivos y estratégicos
    OR (r.name = 'Director' AND p.name IN (
        'gestionar_empleados',
        'gestionar_entidades',
        'definir_objetivos_rentabilidad',
        'revisar_planificaciones_estrategicamente',
        'incorporar_presupuestacion_ingresos',
        'aprobar_planificacion_final_ejecutiva',
        'analizar_departamento',
        'analisis_temporal_comparativo',
        'visualizar_datos_consolidados_tiempo_real',
        'exportar_reportes_multiples_formatos',
        'programar_envio_automatico_reportes',
        'ver_vista_global_empresa',
        'gestionar_acceso_reportes',
        'comparar_salud_proyectos',
        'generar_reportes_salud_ejecutivos'
    ))

    -- CTO: Permisos técnicos y tecnológicos
    OR (r.name = 'CTO' AND p.name IN (
        'gestionar_tipos_proyecto',
        'gestionar_etapas_proyecto',
        'gestionar_plantillas_proyecto',
        'gestionar_tipos_tarea',
        'gestionar_etapas_tarea',
        'gestionar_tipos_tarea_proyecto',
        'revisar_planificaciones_pm',
        'identificar_problemas_capacidad',
        'corregir_asignaciones_problematicas',
        'validar_viabilidad_tecnica',
        'escalada_automatica_aprobacion_ejecutiva',
        'configurar_modelo_datos_analiticos',
        'definir_reglas_clasificacion_automatica',
        'configurar_soporte_multi_moneda',
        'configurar_dimensiones_analiticas',
        'configurar_metadatos_analiticos',
        'integracion_contabilidad_analitica',
        'calcular_progreso_automatico',
        'evaluar_riesgos_tiempo_real',
        'configurar_indicadores_personalizados'
    ))

    -- PROJECT MANAGER: Permisos de gestión de proyectos y equipos
    OR (r.name = 'Project Manager' AND p.name IN (
        'crear_proyecto',
        'configurar_proyecto',
        'gestionar_proyectos',
        'crear_tareas',
        'asignar_tareas',
        'gestionar_dependencias',
        'actualizar_estado_tareas',
        'reasignar_tareas',
        'gestionar_tiempo_estimado',
        'visualizar_tablero_kanban',
        'gestionar_comentarios_tareas',
        'gestionar_adjuntos_tareas',
        'planificar_asignaciones_proyecto',
        'calcular_costes_margenes_automatico',
        'validar_restricciones_disponibilidad',
        'integracion_contabilidad_analitica_pm',
        'soporte_multi_moneda_presupuestos',
        'clasificar_costes_directo_indirecto',
        'almacenamiento_datos_raw_analitica',
        'enviar_revision_cto',
        'visualizar_capacidad_recursos',
        'visualizar_dashboard_salud',
        'monitorear_metricas_tiempo_real',
        'gestionar_alertas_notificaciones',
        'activacion_automatica_seguimiento',
        'seguimiento_presupuestario_vs_real'
    ))

    -- MIEMBRO DEL EQUIPO: Permisos básicos de trabajo diario
    OR (r.name = 'Miembro del equipo' AND p.name IN (
        'registrar_tiempo_diario',
        'cambiar_tarea_asignada',
        'seleccionar_tipo_dedicacion',
        'gestionar_pausas',
        'revision_ajustes_registro_diario',
        'control_limites_pausas',
        'validacion_automatica_ajustes',
        'manejo_excepciones_pausas',
        'reportes_calidad_registros',
        'actualizar_estado_presencia',
        'ver_estados_automaticos',
        'transiciones_estado_validacion',
        'recibir_notificaciones_cambio',
        'gestionar_estados_temporales',
        'visualizar_dashboard_equipo',
        'visualizar_dashboard_proyecto',
        'visualizar_carga_trabajo_equipo',
        'ver_metricas_agregadas_presencia',
        'ver_dashboard_historico_presencia',
        'ver_contexto_tareas_tiempo_real',
        'visualizar_oficina_virtual',
        'navegar_desde_oficina_virtual',
        'experiencia_trabajo_compartido',
        'consultar_gasto_ingreso_rentabilidad_empleado',
        'consultar_proyecto_tarea_cliente',
        'consultar_reporte_especifico',
        'desbloquear_logros',
        'acumular_puntos_niveles',
        'recibir_recompensas_consistencia',
        'ver_elementos_gamificados_sutiles'
    ))

-- Sin ON CONFLICT porque no hay restricción única en (role_id, permission_id)
