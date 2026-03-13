# EP-002 — Registro y cualificación de leads

**Descripción:** Proceso específico de cualificación de leads que sugiere segmentación automática para corporativo y permite marcar leads como cualificados con validación de campos críticos. Se enfoca en las funcionalidades específicas de cualificación que no están cubiertas por el CRUD básico de gestión de leads. La verificación de disponibilidad para bodas se realiza en tiempo real durante la captación del lead (EP-001).

**Proceso TO-BE origen:** TO-BE-002: Registro y cualificación de leads

**Bloque funcional:** Cualificación específica - Segmentación automática sugerida y marcado como cualificado con validaciones

**Objetivo de negocio:** Estructurar completamente la información de cada lead capturado, automatizar la verificación de disponibilidad para bodas y la segmentación para corporativo, garantizando que el 100% de los leads queden cualificados en menos de 4 horas desde su captura, con toda la información necesaria registrada para acelerar el proceso comercial y reducir errores.

**Alcance y exclusiones:**  
- **Incluye:** Segmentación automática sugerida para corporativo según sector/presupuesto/palabras clave; asignación de pack/servicio; marcar lead como cualificado con validación de campos críticos
- **Excluye:** Verificación de disponibilidad para bodas (ya cubierta en EP-001-US-001 durante captación); revisar información del lead (ya cubierto en EP-001-US-002 CRUD); completar información faltante del lead (ya cubierto en EP-001-US-002 CRUD - actualizar); captación de leads (EP-001); respuesta automática inicial (EP-003); agendamiento de reuniones (EP-004); gestión de calendario de fechas (EP-011); análisis avanzado de calidad de leads; scoring automático de leads

**KPIs (éxito):**  
- 100% de leads cualificados en < 4 horas desde captura - Fecha objetivo: v1.0.0
- Información completa registrada (0% de campos críticos faltantes) - Fecha objetivo: v1.0.0
- Tiempo promedio de cualificación < 15 minutos por lead - Fecha objetivo: v1.0.0

**Actores y permisos (RBAC):**  
- **Usuario de ONGAKU:** Visualización y cualificación de leads según línea de negocio asignada (lectura/escritura en leads de su línea de negocio)
- **Sistema centralizado:** Sugerencia de segmentación automática (sin permisos, proceso automático)
- **Usuario de ONGAKU con permisos especiales:** Cualificación de todos los leads y casos especiales (lectura/escritura en todos los leads)

**Trazabilidad (fuentes):**  
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-002-registro-cualificacion-leads.md` - Bloque: Pasos 1-7 (recepción de notificación hasta lead cualificado)

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-002-US-001 | Segmentación automática sugerida y asignación de pack para corporativo | Como usuario de ONGAKU, quiero que el sistema sugiera automáticamente la segmentación (pack o servicio) según sector, presupuesto y palabras clave del lead, y poder asignar el pack de interés, para acelerar la cualificación sin tener que decidir manualmente entre todos los packs posibles | Pendiente | Alta |
| EP-002-US-002 | Marcar lead como cualificado con validación | Como usuario de ONGAKU, quiero marcar un lead como cualificado una vez asignado pack (corporativo) o confirmada fecha disponible (bodas), con validación automática de que todos los campos críticos estén completos, para que quede disponible para respuesta inicial y agendamiento solo cuando esté completamente cualificado | Pendiente | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Lead cualificado:** Lead con información completa, disponibilidad verificada (bodas) o pack asignado (corporativo), y estado "Cualificado"
- **Campos críticos:** Campos obligatorios que deben completarse antes de cualificar (nombre, email, teléfono, fecha boda para bodas, empresa/sector para corporativo)
- **Segmentación:** Asignación de pack o servicio según características del lead (3 packs para colegios, 4 packs para empresas en corporativo)
- **Disponibilidad:** Estado de disponibilidad en fecha solicitada para bodas (verificada durante captación en EP-001)
- **Pack de interés:** Servicio o paquete específico asignado al lead corporativo según su sector y necesidades

### Reglas de numeración/ID específicas
- Formato de ID de lead cualificado: `LEAD-YYYYMMDD-XXX` (mismo que lead capturado)
- Formato de estado: `Nuevo` → `En cualificación` → `Cualificado`
- Formato de segmentación: `CORP-PACK-{NÚMERO}` o `CORP-SERVICIO-{NOMBRE}`

### Mockups o enlaces a UI
- [Pendiente de diseño] Vista de segmentación sugerida con opciones de packs/servicios y posibilidad de asignar
- [Pendiente de diseño] Botón de marcar como cualificado con validación de campos críticos y mensajes de error si faltan campos
