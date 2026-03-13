# EP-001 — Captación automática de leads

**Descripción:** Sistema centralizado con un único formulario web unificado que permite a clientes potenciales enviar consultas desde cualquier canal (LinkedIn, Facebook, Instagram, web, etc.) mediante CTAs que redirigen al formulario. El sistema registra automáticamente todas las consultas en una base de datos unificada, eliminando la pérdida de información por procesos manuales dispersos.

**Proceso TO-BE origen:** TO-BE-001: Captación automática de leads desde múltiples canales

**Bloque funcional:** Entrada estandarizada y registro automático - Flujo completo desde CTA en cualquier canal hasta registro en base de datos unificada con notificación inmediata al equipo responsable

**Objetivo de negocio:** Eliminar completamente la pérdida de leads por procesos manuales dispersos (post-its, capturas de pantalla, emails), estandarizando la entrada mediante un único formulario web accesible desde todos los canales mediante CTAs, garantizando que el 100% de las consultas queden registradas automáticamente y sean notificadas al equipo en menos de 5 minutos, permitiendo escalar el negocio sin aumentar proporcionalmente el equipo comercial.

**Alcance y exclusiones:**  
- **Incluye:** Formulario web unificado accesible desde todos los canales mediante CTAs/links; registro automático en base de datos unificada; selección de vía por la que se enteró de ONGAKU en formulario; selección de línea de negocio (Bodas/Corporativo) en formulario; notificaciones de leads nuevos al personal de ONGAKU; gestión de leads (CRUD)
- **Excluye:** Tracking mediante parámetros UTM; detección automática de línea de negocio; asignación automática de responsable; integraciones con APIs de redes sociales para captura directa; parsing automático de emails; cualificación de leads (EP-002); respuesta automática inicial (EP-003); análisis avanzado de calidad de leads; integración con sistemas externos de marketing automation

**KPIs (éxito):**  
- 100% de leads capturados automáticamente (sin post-its ni capturas de pantalla) - Fecha objetivo: v1.0.0
- Tiempo de captura < 1 minuto desde recepción hasta registro - Fecha objetivo: v1.0.0
- Notificación al equipo < 5 minutos desde captura - Fecha objetivo: v1.0.0
- 0% de pérdida de información por canales manuales - Fecha objetivo: v1.0.0

**Actores y permisos (RBAC):**  
- **Sistema centralizado:** Registro automático, notificaciones (sin permisos, proceso automático)
- **Cliente potencial:** Acceso al formulario web unificado mediante CTA/link desde cualquier canal (solo escritura - envío de formulario)
- **Usuario de ONGAKU:** Visualización y gestión de leads (lectura/escritura en leads según permisos asignados), recepción de notificaciones de leads nuevos

**Trazabilidad (fuentes):**  
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-001-captacion-automatica-leads.md` - Bloque: Pasos 1-6 (captura desde múltiples canales hasta notificación)

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-001-US-001 | Cliente potencial inserta lead mediante formulario | Como cliente potencial, quiero insertar mi consulta mediante un formulario web unificado accesible desde cualquier canal mediante CTA/link, seleccionando la vía por la que me enteré de ONGAKU y si es para Bodas o Corporativo, para que mi consulta quede registrada automáticamente en el sistema | Pendiente | Alta |
| EP-001-US-002 | Gestión de leads (CRUD) | Como usuario de ONGAKU, quiero crear, leer, actualizar y eliminar leads en el sistema, para gestionar correctamente la información de clientes potenciales y garantizar que todos los datos queden capturados | Pendiente | Alta |
| EP-001-US-003 | Notificaciones de leads nuevos | Como usuario de ONGAKU, quiero recibir notificaciones de los nuevos leads que se creen en el sistema, para poder cualificarlos inmediatamente | Pendiente | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Lead:** Cliente potencial que ha enviado una consulta mediante el formulario web unificado
- **Vía de conocimiento:** Opción seleccionada por cliente potencial en formulario sobre cómo se enteró de ONGAKU o llegó al link (ejemplo: LinkedIn, Facebook, Instagram, Web, Recomendación, Otro)
- **CTA (Call To Action):** Botón o enlace en anuncios/perfiles que redirige al formulario unificado (ejemplo: "Solicita info")
- **Línea de negocio:** Corporativo, Bodas (seleccionado por cliente potencial en formulario)
- **Estado del lead:** Nuevo, Información incompleta

### Reglas de numeración/ID específicas
- Formato de ID de lead: `LEAD-YYYYMMDD-XXX` (año-mes-día-número secuencial)
- Formato de ID de notificación: `NOTIF-LEAD-{ID_LEAD}-{TIMESTAMP}`

### Mockups o enlaces a UI
- [Pendiente de diseño] Formulario web unificado accesible desde todos los canales
- [Pendiente de diseño] Dashboard de leads para usuarios de ONGAKU
- [Pendiente de diseño] Formulario manual estructurado para entrada telefónica (incluido en CRUD - EP-001-US-002)
- [Pendiente de diseño] Vista de detalle de lead con todos los datos capturados y canal de origen
