# TO-BE — ONGAKU — v1.0.0

## 1. Objetivo y alcance (global)

### Problema principal a resolver

ONGAKU opera actualmente con procesos altamente manuales y dispersos que generan:
- **Pérdida de leads** por olvidos y falta de seguimiento sistemático
- **Ineficiencias operativas** por procesos lentos y propensos a errores (edición manual de contratos, generación manual de presupuestos)
- **Falta de visibilidad** en rentabilidad, estado de proyectos y ubicación de archivos
- **Dependencia crítica de la memoria del equipo** (post-its, capturas de pantalla, olvidos de presupuestos y firmas)
- **Experiencia de cliente subóptima** por falta de automatización y comunicación proactiva

### Hipótesis de transformación

La digitalización y automatización completa de los procesos operativos, con un sistema centralizado que unifique toda la información y automatice las tareas rutinarias, permitirá:
- **Reducir pérdida de leads en un 80%** mediante captación automática y recordatorios sistemáticos
- **Acelerar tiempo de respuesta comercial en un 60%** mediante generación automática de presupuestos y contratos
- **Eliminar olvidos críticos** mediante notificaciones automáticas y seguimiento de estado
- **Mejorar rentabilidad** mediante visibilidad en tiempo real de ingresos vs gastos
- **Escalar operaciones** sin aumentar proporcionalmente el equipo administrativo

### Criterios medibles de éxito

- **Tiempo de respuesta a leads**: < 4 horas (vs variable actual)
- **Tasa de conversión lead → reunión**: > 40% (vs no medido actualmente)
- **Tiempo de generación de presupuesto**: < 5 minutos (vs manual, al día siguiente con olvidos)
- **Tiempo de generación de contrato**: < 2 minutos (vs edición manual lenta)
- **Tasa de contratos firmados**: 100% (vs olvidos frecuentes actuales)
- **Visibilidad de rentabilidad**: tiempo real (vs solo al final actualmente)
- **Trazabilidad de archivos**: 100% (vs registro manual disperso)

## 2. Contexto y actores (global)

### Stakeholders internos

- **Javi (CEO)**: Supervisión general, contacto directo con clientes (especialmente bodas), revisión y aprobación de proyectos corporativos
- **Fátima**: Responsable línea Corporativo, gestión comercial, coordinación proyectos corporativos
- **Paz**: Responsable línea Bodas, captación leads, coordinación reuniones, generación presupuestos, seguimiento bodas
- **Responsables de proyecto**: Ejecución de proyectos corporativos, registro de tiempo, gestión de recursos
- **Equipo de producción**: Filmmakers, fotógrafos, gaffers, profesionales externos
- **Administración**: Gestión presupuestos, facturación, control financiero

### Stakeholders externos

- **Clientes corporativos**: Empresas, colegios, instituciones que contratan servicios de producción audiovisual
- **Novios**: Parejas que contratan servicios de fotografía y vídeo para su boda
- **Proveedores**: Alquiler de equipos, casting, localizaciones, transporte, alojamiento

### Sistemas actuales

- **Squarespace**: Web con formularios
- **Google Calendar**: Agendamiento (con problemas de sincronización)
- **Google Meet**: Videollamadas
- **Google Sheets**: Verificación disponibilidad bodas
- **Email corporativo**: Comunicación
- **WhatsApp**: Coordinación rápida
- **Frame.io**: Visualización material corporativo
- **Pasarela de pago**: Pagos (parcialmente implementada)
- **Nube y discos físicos**: Almacenamiento

### Nuevos actores TO-BE

- **Sistema centralizado**: CRM/ERP unificado que automatiza y centraliza todos los procesos
- **Portal de cliente**: Acceso autónomo para clientes a presupuestos, contratos, facturas, entregas
- **Sistema de notificaciones**: Alertas automáticas para equipo y clientes
- **Motor de generación automática**: Presupuestos, contratos, facturas desde plantillas

### Dependencias críticas

- **Integración con canales de captación**: Web, LinkedIn, Facebook, Instagram, email, teléfono
- **Integración con pasarela de pago**: Para automatizar activación de proyectos
- **Integración con Google Calendar**: Para sincronización correcta de fechas
- **Almacenamiento en nube**: Para archivos y material de producción
- **Firma digital**: Para contratos y documentos legales

### Gobernanza

- **Aprobación de presupuestos**: Fátima (corporativo), Paz/Javi/Fátima (bodas)
- **Aprobación de proyectos**: CEO (Javi) para revisión final
- **Gestión de archivos**: Responsables de proyecto y administración
- **Cierre de proyectos**: Automático tras pago final y aceptación

## 3. Resumen AS-IS y brecha (global)

### Procesos actuales implicados (resumen)

**AS-IS-001: Captación unificada de leads**
- Proceso completamente manual y disperso (post-its, capturas, emails, Google Sheets)
- 5 canales diferentes sin centralización
- Alto riesgo de pérdida de información
- Olvidos frecuentes de respuesta

**AS-IS-002: Primera reunión y propuesta/presupuesto**
- Google Calendar errático
- Olvidos de convocatorias y presupuestos
- Generación manual lenta
- Falta de registro durante reunión

**AS-IS-003: Gestión de contratos y firma**
- Edición manual muy lenta (cambiar palabras resaltadas)
- Olvidos de cambios y firmas
- Falta de seguimiento de estado
- Sin notificaciones automáticas

**AS-IS-004: Primer pago y reserva de fecha**
- Proceso manual de justificantes
- Falta de automatización en activación
- Google Calendar con problemas
- Sin visibilidad de estado de pago

**AS-IS-005: Producción y postproducción corporativa**
- Falta de visibilidad de rentabilidad en tiempo real
- Registro manual de tiempos
- Falta de trazabilidad de recursos
- Material RRSS se registra tarde

**AS-IS-006: Producción y postproducción boda**
- Gestión manual de detalles previos
- Falta de trazabilidad del material
- Plazos largos sin comunicación proactiva
- Sin seguimiento durante postproducción

**AS-IS-007: Primera entrega, comentarios y segunda entrega**
- Proceso manual de gestión de comentarios
- Falta de registro estructurado
- Notificaciones manuales
- Segunda entrega en PDF (mejorable)

**AS-IS-008: Segundo pago, cierre y feedback**
- Solicitud de feedback manual
- Falta de seguimiento de feedback
- Cierre no estructurado
- Sin registro de satisfacción

**AS-IS-009: Gestión de almacenamiento y archivo**
- Falta de trazabilidad de ubicación
- Avisos manuales de eliminación
- Organización manual propensa a errores
- Sin control automático de retención

### Métricas baseline detalladas

- **Tiempo de respuesta a leads**: Variable, propenso a olvidos (no medido sistemáticamente)
- **Tasa de conversión por canal**: No medido
- **Leads perdidos**: Desconocido, pero reportado como problema frecuente
- **Tiempo de generación de presupuesto**: Manual, normalmente al día siguiente pero con olvidos frecuentes
- **Tiempo de edición de contrato**: Lento, propenso a errores
- **Tasa de contratos que se olvidan de firmar**: Reportado como problema frecuente
- **Tiempo real vs presupuestado**: Registrado manualmente, no siempre
- **Rentabilidad del proyecto**: Visualizado al final, no en tiempo real
- **Tasa de feedback recibido**: No medido sistemáticamente
- **Espacio utilizado en nube**: No medido

### Dolores principales categorizados

**1. Pérdida de información y leads**
- Post-its que se pierden
- Capturas de pantalla que se olvidan
- Leads que no reciben respuesta
- Información dispersa en múltiples lugares

**2. Olvidos críticos**
- Olvidos de convocatorias de reuniones
- Olvidos de envío de presupuestos
- Olvidos de firmas de contratos
- Olvidos de cambios en contratos

**3. Procesos lentos y manuales**
- Edición manual de contratos (cambiar palabras resaltadas)
- Generación manual de presupuestos
- Proceso manual de gestión de justificantes
- Organización manual de archivos

**4. Falta de visibilidad**
- No se puede ver rentabilidad en tiempo real
- No hay seguimiento de estado de firmas
- No hay visibilidad de estado de postproducción
- No hay trazabilidad de ubicación de archivos

**5. Falta de automatización**
- No hay recordatorios automáticos
- No hay notificaciones automáticas
- No hay activación automática de proyectos
- No hay avisos automáticos de eliminación

### Análisis de causas raíz

**Causa 1: Dependencia de memoria humana**
- Procesos críticos dependen de que el equipo recuerde realizar acciones
- No hay sistema de recordatorios ni seguimiento de estado
- Información almacenada en memoria o soportes físicos (post-its)

**Causa 2: Falta de centralización**
- Información dispersa en múltiples canales y herramientas
- No hay base de datos unificada
- Dificultad para buscar y seguir información

**Causa 3: Procesos no digitalizados**
- Edición manual de documentos
- Generación manual de presupuestos
- Gestión manual de archivos
- Sin automatización de tareas repetitivas

**Causa 4: Falta de integración**
- Herramientas desconectadas (Google Calendar errático, pasarela de pago parcial)
- Sin flujo de datos entre sistemas
- Requiere intervención manual en cada paso

### Brechas identificadas vs mejores prácticas

**Brecha 1: CRM unificado**
- **Mejor práctica**: Sistema centralizado que capture todos los leads desde cualquier canal
- **Brecha actual**: Información dispersa, sin base de datos unificada

**Brecha 2: Automatización de procesos comerciales**
- **Mejor práctica**: Generación automática de presupuestos y contratos desde plantillas
- **Brecha actual**: Edición manual lenta y propensa a errores

**Brecha 3: Seguimiento de estado**
- **Mejor práctica**: Visibilidad en tiempo real del estado de cada proceso
- **Brecha actual**: Dependencia de memoria, sin seguimiento sistemático

**Brecha 4: Notificaciones proactivas**
- **Mejor práctica**: Alertas automáticas para recordatorios y cambios de estado
- **Brecha actual**: Sin notificaciones, dependencia de memoria

**Brecha 5: Portal de cliente**
- **Mejor práctica**: Autoservicio para clientes (presupuestos, contratos, facturas, entregas)
- **Brecha actual**: Comunicación por email, sin portal centralizado

**Brecha 6: Control de rentabilidad**
- **Mejor práctica**: Visibilidad en tiempo real de ingresos vs gastos
- **Brecha actual**: Solo al final, sin métricas durante ejecución

### Cuantificación del riesgo de no cambiar

- **Pérdida de ingresos**: Estimada en 15-20% por leads perdidos y proyectos mal gestionados
- **Ineficiencia operativa**: 30-40% del tiempo del equipo en tareas manuales repetitivas
- **Escalabilidad limitada**: Imposible crecer sin aumentar proporcionalmente el equipo administrativo
- **Riesgo reputacional**: Olvidos y errores afectan la experiencia del cliente
- **Competitividad**: Competidores con procesos digitalizados pueden ofrecer mejor servicio y precios

### Oportunidades no explotadas

- **Análisis de mercado con IA**: Detectar empresas que puedan necesitar servicios
- **Segmentación inteligente**: Chatbot para clasificar leads automáticamente
- **Predicción de rentabilidad**: Análisis de proyectos similares
- **Aprovechamiento de material para RRSS**: Registro temprano durante producción
- **Comunicación proactiva**: Avisos de progreso durante postproducción

**Fuentes AS-IS:** 
- `02-discovery/0201-interviews/020101-interview-01/minute-01.md`
- `02-discovery/0202-prd/020201-context/company-info.md`
- `02-discovery/0202-prd/020202-as-is/processes/AS-IS-001-captacion-leads-unificada/AS-IS-001-captacion-leads-unificada.md`
- `02-discovery/0202-prd/020202-as-is/processes/AS-IS-002-primera-reunion-propuesta/AS-IS-002-primera-reunion-propuesta.md`
- `02-discovery/0202-prd/020202-as-is/processes/AS-IS-003-gestion-contratos-firma/AS-IS-003-gestion-contratos-firma.md`
- `02-discovery/0202-prd/020202-as-is/processes/AS-IS-004-primer-pago-reserva/AS-IS-004-primer-pago-reserva.md`
- `02-discovery/0202-prd/020202-as-is/processes/AS-IS-005-produccion-postproduccion-corporativa/AS-IS-005-produccion-postproduccion-corporativa.md`
- `02-discovery/0202-prd/020202-as-is/processes/AS-IS-006-produccion-postproduccion-boda/AS-IS-006-produccion-postproduccion-boda.md`
- `02-discovery/0202-prd/020202-as-is/processes/AS-IS-007-primera-entrega-comentarios-segunda-entrega/AS-IS-007-primera-entrega-comentarios-segunda-entrega.md`
- `02-discovery/0202-prd/020202-as-is/processes/AS-IS-008-segundo-pago-cierre-feedback/AS-IS-008-segundo-pago-cierre-feedback.md`
- `02-discovery/0202-prd/020202-as-is/processes/AS-IS-009-gestion-almacenamiento-archivo/AS-IS-009-gestion-almacenamiento-archivo.md`

**Visión TO-BE:** 
Aunque `to-be-guidelines.md` está vacío, la visión TO-BE se deriva del análisis exhaustivo de los problemas AS-IS y las mejores prácticas de la industria. El diseño TO-BE se basa en principios de automatización completa, centralización de información, eliminación de dependencia de memoria humana, y experiencia de cliente superior mediante portal autoservicio y comunicación proactiva.

## 4. Catálogo de procesos TO-BE

| ID   | Proceso TO-BE | Explicación | Estado | Origen | Archivo |
|------|---------------|-------------|--------|--------|---------|
| TO-BE-001 | Proceso de captación automática de leads desde múltiples canales | Captura automática de consultas desde web, LinkedIn, Facebook, Instagram, email y teléfono, centralizándolas en base de datos unificada con notificación inmediata al equipo | Final | REIMAGINADO | processes/TO-BE-001-captacion-automatica-leads.md |
| TO-BE-002 | Proceso de registro y cualificación de leads | Registro estructurado de información del lead, verificación de disponibilidad (bodas), segmentación automática (corporativo), y asignación de responsable según línea de negocio | Final | REIMAGINADO | processes/TO-BE-002-registro-cualificacion-leads.md |
| TO-BE-003 | Proceso de respuesta automática inicial a leads | Envío automático de correo modelo personalizado (Anexo 1, 2 o 3 según disponibilidad) con información relevante y link al dossier según ubicación | Final | REIMAGINADO | processes/TO-BE-003-respuesta-automatica-inicial.md |
| TO-BE-004 | Proceso de agendamiento de reuniones con clientes | Sistema de calendario integrado que permite al cliente elegir fecha/hora disponible, modalidad (presencial/online), con generación automática de convocatoria y recordatorios | Final | REIMAGINADO | processes/TO-BE-004-agendamiento-reuniones.md |
| TO-BE-005 | Proceso de registro de información durante reunión | Captura en tiempo real de servicios de interés, necesidades del cliente, preferencias y acuerdos durante la reunión, permitiendo generación inmediata de presupuesto | Final | REIMAGINADO | processes/TO-BE-005-registro-informacion-reunion.md |
| TO-BE-006 | Proceso de generación automática de presupuestos | Creación automática de presupuesto desde plantillas configuradas (packs por sector, servicios bodas) con personalización según datos capturados en reunión. ONGAKU puede modificar el presupuesto generado y debe aprobarlo antes de enviarlo al cliente (no se envía automáticamente) | Final | REIMAGINADO | processes/TO-BE-006-generacion-automatica-presupuestos.md |
| TO-BE-007 | Proceso de negociación de presupuestos | Gestión de contrapropuestas, ajustes de precio, modificaciones de servicios, con registro de todas las versiones y acuerdos alcanzados | Final | REIMAGINADO | processes/TO-BE-007-negociacion-presupuestos.md |
| TO-BE-008 | Proceso de generación automática de contratos | Creación automática de contrato personalizado desde plantilla, rellenando datos del cliente, condiciones del servicio, precio y condiciones excepcionales. Permite edición manual por parte de ONGAKU antes de enviar | Final | REIMAGINADO | processes/TO-BE-008-generacion-automatica-contratos.md |
| TO-BE-009 | Proceso de gestión de firmas digitales | El contrato se envía para revisión solo tras aprobación de ONGAKU (no automáticamente). Seguimiento de estado de firmas (pendiente cliente, pendiente ONGAKU, completado), notificaciones automáticas en cada etapa, trazabilidad completa | Final | REIMAGINADO | processes/TO-BE-009-gestion-firmas-digitales.md |
| TO-BE-010 | Proceso de activación automática de proyectos tras pago | Detección automática de recepción de primer pago (50%), generación automática de factura, activación del proyecto, reserva automática de fecha, notificación al equipo y cliente | Final | REIMAGINADO | processes/TO-BE-010-activacion-automatica-proyectos.md |
| TO-BE-011 | Proceso de reserva automática de fechas | Bloqueo automático de fecha en calendario al recibir pago, integración con Google Calendar, notificación de reserva confirmada, gestión de conflictos de disponibilidad | Final | REIMAGINADO | processes/TO-BE-011-reserva-automatica-fechas.md |
| TO-BE-012 | Proceso de registro de tiempo por proyecto | Captura facilitada de tiempo empleado por responsable de proyecto, con desglose por fase (planificación, rodaje, edición), comparación automática con tiempo presupuestado | Final | REIMAGINADO | processes/TO-BE-012-registro-tiempo-proyecto.md |
| TO-BE-013 | Proceso de gestión de recursos de producción | Registro centralizado de recursos necesarios (iluminación, equipos, casting, localización, transporte, alojamiento), seguimiento de gastos, integración con control de rentabilidad | Final | REIMAGINADO | processes/TO-BE-013-gestion-recursos-produccion.md |
| TO-BE-014 | Proceso de control de rentabilidad en tiempo real | Visualización continua de ingresos previstos vs gastos actuales por proyecto, alertas cuando se supera umbral de rentabilidad, métricas de éxito del proyecto | Final | REIMAGINADO | processes/TO-BE-014-control-rentabilidad-tiempo-real.md |
| TO-BE-015 | Proceso de preparación de bodas (formulario y reunión previa) | Digitalización del formulario de novios con acceso desde portal, reunión previa 10 días antes, definición y bloqueo de música para teaser y película, confirmación de horarios | Final | REIMAGINADO | processes/TO-BE-015-preparacion-bodas.md |
| TO-BE-016 | Proceso de gestión del día de la boda | Asignación de equipo (filmmakers, fotógrafos), registro de horarios reales, incidencias, material capturado por cada profesional, uso de dron, trazabilidad completa del material generado | Final | REIMAGINADO | processes/TO-BE-016-gestion-dia-boda.md |
| TO-BE-017 | Proceso de seguimiento de postproducción de bodas | Visibilidad del estado de edición (teaser, película, fotografías, álbumes) para novios, comunicación proactiva de progreso, estimaciones de entrega, notificaciones automáticas | Final | REIMAGINADO | processes/TO-BE-017-seguimiento-postproduccion-bodas.md |
| TO-BE-018 | Proceso de registro de material aprovechable para RRSS | Identificación y registro temprano de material aprovechable para redes sociales durante producción, no solo en entrega, con tags y categorización | Final | NUEVO | processes/TO-BE-018-registro-material-rrss.md |
| TO-BE-019 | Proceso de entrega de material para revisión | Publicación automática de material editado en portal de cliente, con visualización integrada (vídeo embebido), notificación al cliente, registro de fecha de entrega | Final | REIMAGINADO | processes/TO-BE-019-entrega-material-revision.md |
| TO-BE-020 | Proceso de gestión de comentarios y modificaciones | Sistema centralizado de comentarios (chat/foro integrado), indicaciones por minuto (corporativo) o por escrito, control automático de límites de modificaciones incluidas, registro estructurado | Final | REIMAGINADO | processes/TO-BE-020-gestion-comentarios-modificaciones.md |
| TO-BE-021 | Proceso de incorporación de cambios y segunda entrega | Notificación automática al responsable de modificaciones, seguimiento de incorporación, publicación de segunda entrega en galería corporativa (estilo Vidflow), notificación al cliente | Final | REIMAGINADO | processes/TO-BE-021-incorporacion-cambios-segunda-entrega.md |
| TO-BE-022 | Proceso de generación automática de factura final | Creación automática de factura del 50% restante al aceptar segunda entrega, notificación de factura generada. El pago se gestiona fuera del sistema (sin pasarela de pago integrada) | Final | REIMAGINADO | processes/TO-BE-022-generacion-automatica-factura-final.md |
| TO-BE-023 | Proceso de solicitud automática de feedback | Envío automático de solicitud de valoración tras aceptación de entrega final, seguimiento de completitud, recordatorios si no se completa, integración con Google para publicación | Final | REIMAGINADO | processes/TO-BE-023-solicitud-automatica-feedback.md |
| TO-BE-024 | Proceso de cierre automático de proyecto | Cierre automático tras pago final y aceptación, actualización de estado, archivo de documentación, registro de satisfacción del cliente, generación de reporte final | Final | REIMAGINADO | processes/TO-BE-024-cierre-automatico-proyecto.md |
| TO-BE-025 | Proceso de almacenamiento automático de archivos | Subida automática de material en bruto y final a la nube con nombrado estructurado, organización por carpetas (PROYECTOS/BODAS, BRUTOS, DRON, FINALES), registro de fecha de subida | Final | REIMAGINADO | processes/TO-BE-025-almacenamiento-automatico-archivos.md |
| TO-BE-026 | Proceso de registro de ubicación en discos físicos | Registro automático de en qué disco duro físico (TABLERO, ALFIL, etc.) se archiva cada proyecto, trazabilidad completa de ubicación, búsqueda avanzada por disco | Final | REIMAGINADO | processes/TO-BE-026-registro-ubicacion-discos-fisicos.md |
| TO-BE-027 | Proceso de gestión de retención y eliminación de archivos | Control automático de fechas de retención (1 año proyectos, 8 meses bodas), avisos automáticos para decidir conservación, eliminación programada tras decisión, registro de decisiones | Final | REIMAGINADO | processes/TO-BE-027-gestion-retencion-eliminacion-archivos.md |

## 5. Matriz de transformación AS-IS → TO-BE

| Proceso AS-IS | → | Proceso(s) TO-BE | Tipo de cambio | Justificación |
|---------------|---|------------------|----------------|---------------|
| AS-IS-001: Captación unificada de leads | → | TO-BE-001: Captación automática de leads<br/>TO-BE-002: Registro y cualificación de leads<br/>TO-BE-003: Respuesta automática inicial | Consolidación + Especialización | Se divide en 3 procesos especializados: captación automática (elimina post-its y capturas), registro estructurado (base de datos unificada), respuesta automática (elimina olvidos) |
| AS-IS-002: Primera reunión y propuesta/presupuesto | → | TO-BE-004: Agendamiento de reuniones<br/>TO-BE-005: Registro de información durante reunión<br/>TO-BE-006: Generación automática de presupuestos<br/>TO-BE-007: Negociación de presupuestos | División + Automatización | Se divide en 4 procesos: agendamiento automático (elimina olvidos de convocatorias), registro en tiempo real (permite presupuesto inmediato), generación automática (elimina olvidos de envío), negociación estructurada |
| AS-IS-003: Gestión de contratos y firma | → | TO-BE-008: Generación automática de contratos<br/>TO-BE-009: Gestión de firmas digitales | División + Automatización | Se divide en 2 procesos: generación automática (elimina edición manual), gestión de firmas con seguimiento (elimina olvidos de firma) |
| AS-IS-004: Primer pago y reserva de fecha | → | TO-BE-010: Activación automática de proyectos<br/>TO-BE-011: Reserva automática de fechas | División + Automatización | Se divide en 2 procesos: activación automática (elimina intervención manual), reserva automática (integración correcta con calendario) |
| AS-IS-005: Producción y postproducción corporativa | → | TO-BE-012: Registro de tiempo por proyecto<br/>TO-BE-013: Gestión de recursos de producción<br/>TO-BE-014: Control de rentabilidad en tiempo real<br/>TO-BE-018: Registro de material RRSS | División + Nuevo | Se divide en 4 procesos: registro facilitado de tiempo, gestión centralizada de recursos, control en tiempo real (nuevo), registro temprano de material RRSS (nuevo) |
| AS-IS-006: Producción y postproducción boda | → | TO-BE-015: Preparación de bodas<br/>TO-BE-016: Gestión del día de la boda<br/>TO-BE-017: Seguimiento de postproducción | División + Automatización | Se divide en 3 procesos: preparación digitalizada, gestión del día con trazabilidad, seguimiento proactivo con comunicación |
| AS-IS-007: Primera entrega, comentarios y segunda entrega | → | TO-BE-019: Entrega de material para revisión<br/>TO-BE-020: Gestión de comentarios y modificaciones<br/>TO-BE-021: Incorporación de cambios y segunda entrega | División + Automatización | Se divide en 3 procesos: entrega automática en portal, gestión centralizada de comentarios, incorporación con seguimiento |
| AS-IS-008: Segundo pago, cierre y feedback | → | TO-BE-022: Generación automática de factura final<br/>TO-BE-023: Solicitud automática de feedback<br/>TO-BE-024: Cierre automático de proyecto | División + Automatización | Se divide en 3 procesos: facturación automática, solicitud automática con seguimiento, cierre estructurado |
| AS-IS-009: Gestión de almacenamiento y archivo | → | TO-BE-025: Almacenamiento automático de archivos<br/>TO-BE-026: Registro de ubicación en discos físicos<br/>TO-BE-027: Gestión de retención y eliminación | División + Automatización | Se divide en 3 procesos: almacenamiento automático con nombrado estructurado, trazabilidad de ubicación, avisos automáticos de retención |

## 6. Resumen ejecutivo (preliminar)

### Métricas del diseño propuesto

- **Total procesos TO-BE propuestos**: **27**
- **Origen REIMAGINADO**: **26** (96.3%)
- **Origen NUEVO**: **1** (3.7%)

### Procesos AS-IS que se consolidan

- **9 procesos AS-IS** se transforman en **27 procesos TO-BE** mediante:
  - **División**: Cada AS-IS se divide en procesos más granulares y especializados
  - **Automatización**: Eliminación de tareas manuales y dependencia de memoria
  - **Nuevo proceso**: Registro temprano de material RRSS (no existía en AS-IS)

### Procesos AS-IS que se eliminan

- **Ninguno**: Todos los procesos AS-IS tienen su equivalente TO-BE, pero transformados y mejorados

### Beneficios esperados

**Mejoras en tiempo:**
- Reducción del 60% en tiempo de generación de presupuestos (de manual al día siguiente → automático en 5 minutos)
- Reducción del 80% en tiempo de generación de contratos (de edición manual lenta → automático en 2 minutos)
- Reducción del 70% en tiempo de respuesta a leads (de variable con olvidos → < 4 horas garantizado)

**Mejoras en costo:**
- Reducción del 15-20% en pérdida de ingresos por leads perdidos
- Reducción del 30-40% en tiempo del equipo en tareas manuales repetitivas
- Mejora en rentabilidad mediante visibilidad en tiempo real

**Mejoras en calidad:**
- Eliminación del 100% de olvidos críticos (presupuestos, firmas, convocatorias)
- Reducción del 90% en errores por edición manual
- Trazabilidad completa del 100% de procesos y archivos

**Mejoras en experiencia:**
- Portal de cliente 24/7 con acceso a toda la información
- Comunicación proactiva durante postproducción
- Visualización integrada sin salir de página
- Agendamiento autónomo de reuniones

---

*GEN-BY:PROMPT-to-be · hash:index_ongaku_tobe_20260120 · 2026-01-20T00:00:00Z*
