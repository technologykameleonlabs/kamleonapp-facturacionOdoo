# EP-003 — Respuesta automática inicial a leads

**Descripción:** Sistema automatizado que envía correos modelo personalizados (Anexo 1, 2 o 3 según disponibilidad) con información relevante y link al dossier según ubicación, garantizando que todos los leads cualificados reciban respuesta automática en menos de 5 minutos desde su cualificación, eliminando completamente los olvidos de respuesta y mejorando la experiencia del cliente.

**Proceso TO-BE origen:** TO-BE-003: Respuesta automática inicial a leads

**Bloque funcional:** Envío automático de correos modelo personalizados - Flujo completo desde detección de lead cualificado hasta envío automático de correo personalizado con registro y notificación

**Objetivo de negocio:** Eliminar completamente los olvidos de respuesta a leads cualificados, garantizando que el 100% de los leads cualificados reciban respuesta automática personalizada en menos de 5 minutos desde su cualificación, mejorando la experiencia del cliente y reduciendo la pérdida de oportunidades comerciales por falta de respuesta oportuna.

**Alcance y exclusiones:**  
- **Incluye:** Selección automática del correo modelo correcto según disponibilidad (Anexo 1 disponible, Anexo 2 no disponible, Anexo 3 recordatorio) y línea de negocio; personalización automática de correos con datos del lead (nombre, fecha boda, ubicación); selección automática del link al dossier según ubicación; envío automático de correos; registro de envíos con trazabilidad completa; gestión de plantillas de correo (CRUD); control de envío automático (activar/desactivar); notificaciones al equipo de envíos realizados
- **Excluye:** Tracking de apertura de correos; análisis de respuestas del cliente; integración con sistemas externos de email marketing; A/B testing de plantillas; personalización avanzada con IA; cualificación de leads (EP-002); agendamiento de reuniones (EP-004); gestión de dossiers (se asume que existen y están disponibles)

**KPIs (éxito):**  
- 100% de leads cualificados reciben respuesta automática en < 5 minutos desde cualificación - Fecha objetivo: v1.0.0
- Correo modelo correcto según disponibilidad (100% de precisión en selección) - Fecha objetivo: v1.0.0
- Personalización correcta con datos del lead (0% de errores en personalización) - Fecha objetivo: v1.0.0
- Link al dossier correcto según ubicación (100% de precisión) - Fecha objetivo: v1.0.0
- 0% de olvidos de respuesta a leads cualificados - Fecha objetivo: v1.0.0

**Actores y permisos (RBAC):**  
- **Sistema centralizado:** Selección automática de plantilla, personalización, envío automático, registro de envíos (sin permisos, proceso automático)
- **Usuario de ONGAKU:** Visualización de historial de envíos, gestión de plantillas de correo (lectura/escritura en plantillas según permisos), control de envío automático (activar/desactivar según permisos)
- **Cliente potencial:** Recepción de correo modelo personalizado (sin permisos, receptor pasivo)

**Trazabilidad (fuentes):**  
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-003-respuesta-automatica-inicial.md` - Bloque: Pasos 1-7 (detección de lead cualificado hasta notificación al responsable)

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-003-US-001 | Selección automática de correo modelo según disponibilidad y línea de negocio | Como sistema centralizado, quiero seleccionar automáticamente el correo modelo correcto (Anexo 1 disponible, Anexo 2 no disponible, Anexo 3 recordatorio) según disponibilidad verificada y línea de negocio del lead cualificado, para garantizar que se envíe el mensaje apropiado en cada situación | Pendiente | Alta |
| EP-003-US-002 | Personalización automática de correos con datos del lead y selección de dossier | Como sistema centralizado, quiero personalizar automáticamente el correo modelo seleccionado con datos del lead (nombre, fecha boda, ubicación) y seleccionar el link al dossier correcto según ubicación, para que el cliente reciba información relevante y personalizada | Pendiente | Alta |
| EP-003-US-003 | Envío automático de correos y registro de envíos | Como sistema centralizado, quiero enviar automáticamente el correo personalizado al lead cualificado y registrar el envío con timestamp, tipo de correo y destinatario, para garantizar trazabilidad completa y notificar al equipo del envío realizado | Pendiente | Alta |
| EP-003-US-004 | Gestión de plantillas de correo y control de envío automático | Como usuario de ONGAKU, quiero crear, leer, actualizar y eliminar plantillas de correo modelo (Anexo 1, 2, 3 y corporativo) y poder activar/desactivar el envío automático para casos especiales, para mantener las plantillas actualizadas y tener control sobre el proceso automático cuando sea necesario | Pendiente | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Correo modelo:** Plantilla de correo electrónico predefinida con variables que se personalizan con datos del lead (Anexo 1: Disponible, Anexo 2: No disponible, Anexo 3: Recordatorio, Corporativo: Plantilla específica)
- **Personalización:** Reemplazo de variables en plantilla con datos del lead (nombre, fecha boda, ubicación, empresa, etc.)
- **Dossier:** Documento informativo específico por ubicación que se envía al cliente potencial (link según ubicación)
- **Envío automático:** Proceso que se ejecuta automáticamente cuando un lead es marcado como cualificado, sin intervención manual
- **Registro de envío:** Trazabilidad de cada correo enviado con timestamp, tipo de correo, destinatario y estado de entrega
- **Estado de envío:** Enviado, Error, Pendiente, Cancelado

### Reglas de numeración/ID específicas
- Formato de ID de envío: `ENV-{ID_LEAD}-{TIMESTAMP}`
- Formato de ID de plantilla: `TPL-{TIPO}-{VERSION}` (ejemplo: TPL-ANEXO1-v1.0)
- Formato de variables en plantilla: `{{NOMBRE}}`, `{{FECHA_BODA}}`, `{{UBICACION}}`, `{{LINK_DOSSIER}}`

### Mockups o enlaces a UI
- [Pendiente de diseño] Vista de historial de envíos con filtros por lead, fecha, tipo de correo
- [Pendiente de diseño] Editor de plantillas de correo con preview y variables disponibles
- [Pendiente de diseño] Configuración de envío automático (activar/desactivar) con opciones de casos especiales
- [Pendiente de diseño] Vista de detalle de envío con información completa del correo enviado
