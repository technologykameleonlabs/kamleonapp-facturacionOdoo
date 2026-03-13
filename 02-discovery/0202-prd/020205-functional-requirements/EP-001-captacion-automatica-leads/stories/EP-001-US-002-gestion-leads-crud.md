# EP-001-US-002 — Gestión de leads (CRUD)

### Epic padre
EP-001 — Entrada estandarizada y registro automático de leads

### Contexto/Descripción y valor
**Como** usuario de ONGAKU,  
**quiero** crear, leer, actualizar y eliminar leads en el sistema,  
**para** gestionar correctamente la información de clientes potenciales y garantizar que todos los datos queden capturados sin depender de post-its o procesos manuales dispersos

### Alcance
**Incluye:**
- Crear nuevos leads manualmente (entrada desde teléfono u otros canales no automatizados)
- Leer/visualizar lista de leads con filtros y búsqueda
- Leer/visualizar detalle completo de un lead específico
- Actualizar información de leads existentes (corregir datos, completar información faltante)
- Eliminar leads (con confirmación y registro de auditoría)
- Formulario estructurado para entrada manual desde teléfono (mismos campos que formulario web)
- Filtros por línea de negocio (Bodas/Corporativo), estado, canal de origen, fecha
- Búsqueda por nombre, email, teléfono
- Vista de lista con información resumida
- Vista de detalle con todos los campos del lead
- Historial de cambios (auditoría)

**Excluye:**
- Registro automático desde formulario web (EP-001-US-001)
- Notificaciones de nuevos leads (EP-001-US-003)
- Cualificación de leads (EP-002)
- Asignación de responsables
- Análisis avanzado o reportes

### Precondiciones
- Usuario de ONGAKU tiene sesión iniciada en el sistema
- Usuario de ONGAKU tiene permisos para gestionar leads (lectura/escritura según RBAC)
- Lead existe en el sistema (para operaciones de lectura, actualización y eliminación)
- Sistema está disponible y base de datos accesible

### Postcondiciones
- **Crear:** Nuevo lead registrado en base de datos con estado "Nuevo", ID generado, timestamp de creación
- **Leer:** Información del lead mostrada correctamente en lista o detalle
- **Actualizar:** Cambios guardados en base de datos, historial de cambios registrado, timestamp de última modificación actualizado
- **Eliminar:** Lead marcado como eliminado (soft delete) o eliminado físicamente con registro de auditoría, timestamp de eliminación

### Flujo principal

#### Crear lead manualmente
1. Usuario de ONGAKU accede a la sección de gestión de leads
2. Usuario hace clic en botón "Crear nuevo lead"
3. Sistema muestra formulario estructurado con campos: nombre, email, teléfono, mensaje/consulta, vía por la que se enteró de ONGAKU (dropdown), línea de negocio (Bodas/Corporativo - radio buttons o select)
4. Usuario completa los campos del formulario (mismos campos que formulario web público)
5. Sistema valida campos en tiempo real (email válido, teléfono con formato correcto, campos obligatorios)
6. Usuario envía formulario
7. Sistema valida todos los campos antes de guardar
8. Sistema registra el lead en base de datos unificada con todos los datos capturados
9. Sistema genera ID de lead automáticamente (formato: LEAD-YYYYMMDD-XXX)
10. Sistema muestra mensaje de confirmación: "Lead creado correctamente"
11. Sistema redirige a vista de detalle del lead creado

#### Leer lista de leads
1. Usuario de ONGAKU accede a la sección de gestión de leads
2. Sistema muestra lista de leads con información resumida: ID, nombre, email, línea de negocio, estado, fecha de creación, canal de origen
3. Usuario puede aplicar filtros: línea de negocio, estado, canal de origen, rango de fechas
4. Usuario puede buscar por nombre, email o teléfono
5. Sistema muestra resultados filtrados/buscados
6. Usuario hace clic en un lead de la lista
7. Sistema muestra vista de detalle del lead seleccionado

#### Leer detalle de lead
1. Usuario de ONGAKU accede a vista de detalle de un lead (desde lista o desde notificación)
2. Sistema muestra todos los campos del lead: ID, nombre, email, teléfono, mensaje/consulta, vía de conocimiento, línea de negocio, estado, canal de origen, fecha de creación, fecha de última modificación
3. Sistema muestra historial de cambios si existe
4. Usuario puede ver información completa del lead

#### Actualizar lead
1. Usuario de ONGAKU accede a vista de detalle de un lead
2. Usuario hace clic en botón "Editar"
3. Sistema muestra formulario con campos editables pre-rellenados con datos actuales
4. Usuario modifica los campos que desea actualizar
5. Sistema valida campos en tiempo real
6. Usuario guarda cambios
7. Sistema valida todos los campos antes de actualizar
8. Sistema actualiza el lead en base de datos
9. Sistema registra cambio en historial de auditoría (campo modificado, valor anterior, valor nuevo, usuario, timestamp)
10. Sistema actualiza timestamp de última modificación
11. Sistema muestra mensaje de confirmación: "Lead actualizado correctamente"
12. Sistema muestra vista de detalle actualizada

#### Eliminar lead
1. Usuario de ONGAKU accede a vista de detalle de un lead
2. Usuario hace clic en botón "Eliminar"
3. Sistema muestra diálogo de confirmación: "¿Estás seguro de que quieres eliminar este lead? Esta acción no se puede deshacer."
4. Usuario confirma eliminación
5. Sistema registra eliminación en auditoría (ID de lead, usuario que elimina, timestamp, motivo si se solicita)
6. Sistema elimina el lead (soft delete: marca como eliminado, o eliminación física según política)
7. Sistema muestra mensaje de confirmación: "Lead eliminado correctamente"
8. Sistema redirige a lista de leads

### Flujos alternos y excepciones

**Flujo alterno 1: Crear lead con campos incompletos**
- Si usuario intenta crear lead con campos obligatorios vacíos, sistema muestra mensaje de error indicando campos faltantes
- Usuario completa campos faltantes y reintenta guardar

**Flujo alterno 2: Actualizar lead con email duplicado**
- Si usuario intenta actualizar email a uno que ya existe en otro lead, sistema muestra mensaje de error: "Este email ya está registrado en otro lead"
- Usuario corrige email o cancela actualización

**Flujo alterno 3: Búsqueda sin resultados**
- Si búsqueda no encuentra resultados, sistema muestra mensaje: "No se encontraron leads que coincidan con tu búsqueda"
- Usuario puede limpiar filtros y buscar nuevamente

**Flujo alterno 4: Cancelar edición**
- Si usuario está editando y hace clic en "Cancelar", sistema muestra diálogo de confirmación si hay cambios sin guardar
- Si confirma cancelación, sistema descarta cambios y vuelve a vista de detalle sin modificar

**Excepción 1: Error de conexión al guardar**
- Si hay error de conexión al crear/actualizar lead, sistema muestra mensaje: "Error de conexión. Por favor, intenta nuevamente."
- Usuario puede reintentar guardar
- Sistema mantiene datos en caché local si es posible

**Excepción 2: Lead no encontrado**
- Si usuario intenta acceder a un lead que no existe o fue eliminado, sistema muestra mensaje: "Lead no encontrado"
- Sistema redirige a lista de leads

**Excepción 3: Sin permisos para eliminar**
- Si usuario no tiene permisos para eliminar leads, botón "Eliminar" está deshabilitado o no visible
- Sistema muestra mensaje si intenta eliminar: "No tienes permisos para eliminar leads"

**Excepción 4: Validación de email inválido**
- Si usuario ingresa email con formato inválido, sistema muestra mensaje de error: "Por favor, ingresa un email válido"
- Usuario corrige email y continúa

### Validaciones y reglas de negocio
- **Nombre:** Obligatorio, mínimo 2 caracteres, máximo 100 caracteres, solo letras, espacios y caracteres especiales comunes (ñ, acentos)
- **Email:** Obligatorio, formato válido de email (regex estándar), máximo 255 caracteres, único en el sistema (no puede haber dos leads con mismo email activos)
- **Teléfono:** Obligatorio, formato válido (puede incluir código de país), mínimo 9 dígitos, máximo 20 caracteres
- **Mensaje/Consulta:** Obligatorio, mínimo 10 caracteres, máximo 2000 caracteres
- **Vía por la que se enteró de ONGAKU:** Obligatorio, selección única de lista predefinida (LinkedIn, Facebook, Instagram, Web, Recomendación, Teléfono, Otro)
- **Línea de negocio:** Obligatorio, selección única entre "Bodas" o "Corporativo"
- **Estado:** Se asigna automáticamente "Nuevo" al crear, puede cambiarse manualmente a otros estados (Información incompleta, Cualificado, etc.)
- **Validación en tiempo real:** Campos se validan mientras usuario escribe (email, teléfono)
- **Unicidad de email:** No se pueden crear dos leads activos con el mismo email
- **Auditoría:** Todos los cambios se registran en historial (campo modificado, valor anterior, valor nuevo, usuario, timestamp)
- **Soft delete:** Los leads eliminados se marcan como eliminados pero se mantienen en base de datos para auditoría (o eliminación física según política)

### Criterios BDD
- **Escenario 1: Crear lead manualmente exitosamente**
  - *Dado* que un usuario de ONGAKU está en la sección de gestión de leads
  - *Cuando* hace clic en "Crear nuevo lead", completa todos los campos correctamente (nombre, email, teléfono, mensaje, vía de conocimiento "Teléfono", línea de negocio "Bodas") y envía el formulario
  - *Entonces* el sistema registra el lead en la base de datos con todos los datos capturados, genera ID de lead, y muestra mensaje de confirmación "Lead creado correctamente"

- **Escenario 2: Actualizar información de lead existente**
  - *Dado* que un usuario de ONGAKU está viendo el detalle de un lead existente
  - *Cuando* hace clic en "Editar", modifica el teléfono a un nuevo número válido y guarda los cambios
  - *Entonces* el sistema actualiza el teléfono en la base de datos, registra el cambio en el historial de auditoría, y muestra mensaje de confirmación "Lead actualizado correctamente"

- **Escenario 3: Intentar crear lead con email duplicado**
  - *Dado* que existe un lead con email "cliente@ejemplo.com" en el sistema
  - *Cuando* un usuario de ONGAKU intenta crear un nuevo lead con el mismo email "cliente@ejemplo.com"
  - *Entonces* el sistema muestra mensaje de error "Este email ya está registrado en otro lead" y no permite crear el lead

- **Escenario 4: Buscar lead por nombre**
  - *Dado* que existen varios leads en el sistema
  - *Cuando* un usuario de ONGAKU busca por nombre "María" en el campo de búsqueda
  - *Entonces* el sistema muestra solo los leads cuyo nombre contiene "María" en la lista de resultados

- **Escenario 5: Eliminar lead con confirmación**
  - *Dado* que un usuario de ONGAKU está viendo el detalle de un lead
  - *Cuando* hace clic en "Eliminar" y confirma la eliminación en el diálogo
  - *Entonces* el sistema marca el lead como eliminado (soft delete), registra la eliminación en auditoría, y muestra mensaje de confirmación "Lead eliminado correctamente"

### Notificaciones
- **Usuario de ONGAKU:** Mensajes de confirmación tras crear, actualizar o eliminar lead exitosamente
- **Sistema:** Registro de auditoría para todas las operaciones (crear, actualizar, eliminar)
- **No hay notificaciones a otros usuarios en esta US** (las notificaciones de nuevos leads se gestionan en EP-001-US-003)

### Seguridad
- **Autenticación:** Usuario debe estar autenticado para acceder a gestión de leads
- **Autorización:** Permisos RBAC para determinar qué usuarios pueden crear, leer, actualizar o eliminar leads
- **Validación de entrada:** Sanitización de todos los campos para prevenir inyección SQL/XSS
- **Auditoría:** Registro completo de todas las operaciones (quién, qué, cuándo, valores anteriores y nuevos)
- **Protección contra eliminación accidental:** Diálogo de confirmación obligatorio antes de eliminar
- **Validación en backend:** Validación adicional de todos los campos en servidor antes de guardar
- **Rate limiting:** Límite de operaciones por usuario para prevenir abuso

### Analítica/KPIs
- **Métricas a instrumentar:**
  - Número de leads creados manualmente vs automáticamente
  - Tiempo promedio de creación manual de lead
  - Frecuencia de actualizaciones de leads
  - Tasa de eliminación de leads
  - Campos más frecuentemente actualizados
  - Búsquedas más comunes (términos buscados)
  - Filtros más utilizados
  - Leads con información incompleta
- **Objetivo:** Reducir tiempo de gestión manual de leads en 50% respecto a proceso AS-IS

### Definition of Ready
- [ ] Diseño de interfaz de gestión de leads aprobado (UI/UX)
- [ ] Permisos RBAC definidos para gestión de leads
- [ ] Política de eliminación definida (soft delete vs eliminación física)
- [ ] Campos del formulario manual definidos y validados con stakeholders
- [ ] Base de datos unificada disponible con estructura de leads
- [ ] Endpoints del backend disponibles para operaciones CRUD
- [ ] Especificaciones de validación definidas
- [ ] Sistema de auditoría implementado
- [ ] Formato de ID de lead definido

### Definition of Done
- [ ] Interfaz de gestión de leads implementada (lista y detalle)
- [ ] Operación Crear lead manual funciona correctamente
- [ ] Operación Leer leads (lista y detalle) funciona correctamente
- [ ] Operación Actualizar lead funciona correctamente
- [ ] Operación Eliminar lead funciona correctamente (con confirmación)
- [ ] Filtros y búsqueda funcionan correctamente
- [ ] Validaciones de campos implementadas (frontend y backend)
- [ ] Historial de auditoría se registra correctamente para todas las operaciones
- [ ] Permisos RBAC implementados y funcionando
- [ ] Mensajes de confirmación y error se muestran correctamente
- [ ] Manejo de errores implementado (conexión, permisos, validaciones)
- [ ] Pruebas de aceptación pasadas (todos los escenarios BDD)
- [ ] Documentación técnica actualizada
- [ ] Desplegado en entorno de producción

### Riesgos y supuestos
- **Riesgo:** Usuario puede crear leads duplicados si no verifica antes de crear
  - **Probabilidad:** Media
  - **Impacto:** Medio
  - **Mitigación:** Validación de unicidad de email, sugerencias de leads similares al crear

- **Riesgo:** Eliminación accidental de leads importantes
  - **Probabilidad:** Baja
  - **Impacto:** Alto
  - **Mitigación:** Diálogo de confirmación obligatorio, soft delete para recuperación, registro de auditoría completo

- **Riesgo:** Información desactualizada si múltiples usuarios editan simultáneamente
  - **Probabilidad:** Media
  - **Impacto:** Medio
  - **Mitigación:** Control de concurrencia (optimistic locking), notificaciones de cambios simultáneos

- **Supuesto:** Usuario de ONGAKU tiene conocimiento de los datos del lead para entrada manual
- **Supuesto:** Usuario de ONGAKU tiene permisos adecuados según su rol en la organización

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-001-captacion-automatica-leads.md`
- Bloque funcional: Gestión de leads capturados
- Paso(s): Paso 2 del flujo principal (entrada manual estructurada para teléfono) y gestión posterior de leads registrados
