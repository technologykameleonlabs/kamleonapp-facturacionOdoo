# EP-002-US-002 — Marcar lead como cualificado con validación

### Epic padre
EP-002 — Registro y cualificación de leads

### Contexto/Descripción y valor
**Como** usuario de ONGAKU,  
**quiero** marcar un lead como cualificado una vez asignado pack (corporativo) o confirmada fecha disponible (bodas), con validación automática de que todos los campos críticos estén completos,  
**para** que quede disponible para respuesta inicial y agendamiento solo cuando esté completamente cualificado con toda la información necesaria

### Alcance
**Incluye:**
- Botón/acción para marcar lead como cualificado
- Validación automática de campos críticos antes de permitir cualificación:
  - Para Corporativo: nombre, email, teléfono, pack asignado, empresa/sector
  - Para Bodas: nombre, email, teléfono, fecha de boda (si fue seleccionada durante captación)
- Mensajes de error específicos indicando qué campos faltan
- Cambio de estado del lead: "Nuevo" → "Cualificado"
- Bloqueo de cualificación si faltan campos críticos
- Visualización de estado "Cualificado" en el lead
- Disponibilidad del lead para siguiente etapa (respuesta inicial, agendamiento)

**Excluye:**
- Asignación de pack (EP-002-US-001)
- Verificación de disponibilidad (EP-001-US-001)
- Completar información faltante del lead (EP-001-US-002 CRUD)
- Respuesta automática inicial (EP-003)
- Agendamiento de reuniones (EP-004)

### Precondiciones
- Lead existe en el sistema con estado "Nuevo" o "En cualificación"
- Usuario de ONGAKU tiene sesión iniciada en el sistema
- Usuario de ONGAKU tiene permisos para cualificar leads
- Para Corporativo: pack debe estar asignado (EP-002-US-001)
- Para Bodas: fecha de boda debe estar verificada/confirmada (si fue seleccionada durante captación en EP-001-US-001)

### Postcondiciones
- Lead marcado como "Cualificado" en el sistema
- Estado del lead actualizado de "Nuevo"/"En cualificación" a "Cualificado"
- Lead disponible para respuesta automática inicial (EP-003)
- Lead disponible para agendamiento de reuniones (EP-004)
- Timestamp de cualificación registrado
- Usuario que cualificó registrado en auditoría

### Flujo principal

#### Cualificación exitosa (Corporativo)
1. Usuario de ONGAKU accede al detalle de un lead corporativo
2. Usuario ha asignado pack de interés (EP-002-US-001)
3. Usuario hace clic en botón "Marcar como cualificado" o "Cualificar lead"
4. Sistema valida automáticamente campos críticos:
   - Nombre: presente y válido
   - Email: presente y válido
   - Teléfono: presente y válido
   - Pack asignado: presente (verificado en EP-002-US-001)
   - Empresa/Sector: presente (puede estar en mensaje o campos específicos)
5. Si todos los campos críticos están completos, sistema permite cualificación
6. Sistema cambia estado del lead de "Nuevo"/"En cualificación" a "Cualificado"
7. Sistema registra timestamp de cualificación y usuario que cualificó
8. Sistema muestra mensaje de confirmación: "Lead cualificado correctamente. Disponible para respuesta inicial y agendamiento"
9. Lead queda disponible para siguiente etapa (EP-003, EP-004)

#### Cualificación exitosa (Bodas)
1. Usuario de ONGAKU accede al detalle de un lead de Bodas
2. Fecha de boda está verificada/confirmada (si fue seleccionada durante captación en EP-001-US-001)
3. Usuario hace clic en botón "Marcar como cualificado" o "Cualificar lead"
4. Sistema valida automáticamente campos críticos:
   - Nombre: presente y válido
   - Email: presente y válido
   - Teléfono: presente y válido
   - Fecha de boda: presente si fue seleccionada durante captación (opcional pero si existe debe estar verificada)
5. Si todos los campos críticos están completos, sistema permite cualificación
6. Sistema cambia estado del lead de "Nuevo"/"En cualificación" a "Cualificado"
7. Sistema registra timestamp de cualificación y usuario que cualificó
8. Sistema muestra mensaje de confirmación: "Lead cualificado correctamente. Disponible para respuesta inicial y agendamiento"
9. Lead queda disponible para siguiente etapa (EP-003, EP-004)

### Flujos alternos y excepciones

**Flujo alterno 1: Campos críticos faltantes (Corporativo)**
- Si usuario intenta marcar como cualificado pero faltan campos críticos, sistema muestra mensaje de error: "No se puede cualificar el lead. Faltan los siguientes campos críticos: [lista de campos faltantes]"
- Sistema muestra lista específica de campos faltantes con indicación de cuáles completar
- Usuario completa campos faltantes mediante formulario de edición (EP-001-US-002)
- Usuario reintenta marcar como cualificado

**Flujo alterno 2: Campos críticos faltantes (Bodas)**
- Si usuario intenta marcar como cualificado pero faltan campos críticos, sistema muestra mensaje de error: "No se puede cualificar el lead. Faltan los siguientes campos críticos: [lista de campos faltantes]"
- Sistema muestra lista específica de campos faltantes
- Usuario completa campos faltantes mediante formulario de edición (EP-001-US-002)
- Usuario reintenta marcar como cualificado

**Flujo alterno 3: Pack no asignado (Corporativo)**
- Si usuario intenta marcar como cualificado pero no hay pack asignado, sistema muestra mensaje de error: "No se puede cualificar el lead. Debe asignar un pack de interés primero"
- Sistema redirige a sección de segmentación (EP-002-US-001) o muestra botón "Asignar pack"
- Usuario asigna pack y luego marca como cualificado

**Flujo alterno 4: Fecha de boda no verificada (Bodas)**
- Si lead de Bodas tiene fecha seleccionada pero no está verificada, sistema muestra mensaje informativo: "Fecha de boda seleccionada. ¿Confirmar disponibilidad antes de cualificar?"
- Usuario puede confirmar disponibilidad o continuar sin verificación (si fecha es opcional)
- Sistema permite cualificación si fecha es opcional o si se confirma disponibilidad

**Excepción 1: Error al cambiar estado**
- Si falla el cambio de estado en base de datos, sistema muestra mensaje de error: "Error al cualificar el lead. Por favor, intenta nuevamente"
- Sistema mantiene estado anterior del lead
- Usuario puede reintentar cualificación

**Excepción 2: Lead ya cualificado**
- Si usuario intenta marcar como cualificado un lead que ya está cualificado, sistema muestra mensaje informativo: "Este lead ya está cualificado"
- Sistema muestra información de cuándo y quién lo cualificó

**Excepción 3: Sin permisos para cualificar**
- Si usuario no tiene permisos para cualificar leads, botón "Marcar como cualificado" está deshabilitado o no visible
- Sistema muestra mensaje si intenta cualificar: "No tienes permisos para cualificar leads"

### Validaciones y reglas de negocio
- **Campos críticos obligatorios (Corporativo):** nombre, email, teléfono, pack asignado, empresa/sector
- **Campos críticos obligatorios (Bodas):** nombre, email, teléfono (fecha de boda es opcional pero si existe debe estar verificada)
- **Validación de pack:** Para Corporativo, pack debe estar asignado antes de cualificar
- **Validación de fecha:** Para Bodas, si fecha de boda existe, debe estar verificada/confirmada
- **Estado previo:** Lead debe estar en estado "Nuevo" o "En cualificación" para poder cualificar
- **Unicidad:** No se puede cualificar un lead que ya está cualificado (solo informar)
- **Validación de formato:** Email y teléfono deben tener formato válido
- **Timestamp:** Se registra fecha y hora exacta de cualificación
- **Auditoría:** Se registra usuario que cualificó, timestamp, estado anterior y nuevo estado

### Criterios BDD
- **Escenario 1: Cualificación exitosa de lead corporativo**
  - *Dado* que un usuario de ONGAKU está viendo un lead corporativo con todos los campos críticos completos y pack asignado
  - *Cuando* hace clic en "Marcar como cualificado"
  - *Entonces* el sistema valida todos los campos, cambia el estado a "Cualificado", registra timestamp y usuario, y muestra mensaje de confirmación "Lead cualificado correctamente"

- **Escenario 2: Cualificación exitosa de lead de Bodas**
  - *Dado* que un usuario de ONGAKU está viendo un lead de Bodas con todos los campos críticos completos y fecha verificada (si existe)
  - *Cuando* hace clic en "Marcar como cualificado"
  - *Entonces* el sistema valida todos los campos, cambia el estado a "Cualificado", registra timestamp y usuario, y muestra mensaje de confirmación "Lead cualificado correctamente"

- **Escenario 3: Intento de cualificar con campos faltantes**
  - *Dado* que un usuario de ONGAKU está viendo un lead corporativo pero falta el campo "empresa/sector"
  - *Cuando* intenta hacer clic en "Marcar como cualificado"
  - *Entonces* el sistema muestra mensaje de error "No se puede cualificar el lead. Faltan los siguientes campos críticos: empresa/sector" y no permite cualificar hasta completar los campos

- **Escenario 4: Intento de cualificar sin pack asignado (Corporativo)**
  - *Dado* que un usuario de ONGAKU está viendo un lead corporativo con todos los campos completos pero sin pack asignado
  - *Cuando* intenta hacer clic en "Marcar como cualificado"
  - *Entonces* el sistema muestra mensaje de error "No se puede cualificar el lead. Debe asignar un pack de interés primero" y redirige o muestra opción para asignar pack

- **Escenario 5: Lead ya cualificado**
  - *Dado* que un usuario de ONGAKU está viendo un lead que ya está en estado "Cualificado"
  - *Cuando* intenta hacer clic en "Marcar como cualificado" nuevamente
  - *Entonces* el sistema muestra mensaje informativo "Este lead ya está cualificado" con información de cuándo y quién lo cualificó

### Notificaciones
- **Usuario de ONGAKU:** Mensaje de confirmación tras cualificar exitosamente: "Lead cualificado correctamente. Disponible para respuesta inicial y agendamiento"
- **Usuario de ONGAKU:** Mensajes de error específicos si faltan campos críticos o requisitos
- **Sistema:** Registro en auditoría de cualificación (usuario, timestamp, estado anterior, estado nuevo)
- **No hay notificaciones a otros usuarios en esta US** (las notificaciones de lead cualificado se gestionan en EP-003)

### Seguridad
- **Autenticación:** Usuario debe estar autenticado para cualificar leads
- **Autorización:** Solo usuarios de ONGAKU con permisos para cualificar leads pueden cambiar estado a "Cualificado"
- **Validación de datos:** Todos los campos críticos deben validarse antes de permitir cualificación
- **Auditoría:** Registro completo de cualificación (usuario, timestamp, campos validados, estado anterior y nuevo)
- **Prevención de cambios no autorizados:** No se puede cualificar sin cumplir todos los requisitos

### Analítica/KPIs
- **Métricas a instrumentar:**
  - Tiempo promedio desde captación hasta cualificación
  - Tasa de leads cualificados vs no cualificados
  - Campos críticos más frecuentemente faltantes
  - Tiempo promedio de cualificación por línea de negocio (Bodas vs Corporativo)
  - Número de intentos fallidos de cualificación por campos faltantes
- **Objetivo:** 100% de leads cualificados en < 4 horas desde captura, 0% de cualificaciones con campos críticos faltantes

### Definition of Ready
- [ ] Campos críticos definidos para cada línea de negocio (Corporativo y Bodas)
- [ ] Reglas de validación definidas (qué campos son obligatorios, formatos válidos)
- [ ] Diseño de interfaz de cualificación aprobado (UI/UX)
- [ ] Permisos RBAC definidos para cualificar leads
- [ ] Endpoints del backend disponibles para validación y cambio de estado
- [ ] Sistema de auditoría implementado
- [ ] Estados del lead definidos ("Nuevo", "En cualificación", "Cualificado")

### Definition of Done
- [ ] Botón/acción de marcar como cualificado implementado
- [ ] Validación automática de campos críticos funciona correctamente
- [ ] Mensajes de error específicos se muestran correctamente cuando faltan campos
- [ ] Cambio de estado funciona correctamente ("Nuevo"/"En cualificación" → "Cualificado")
- [ ] Validación de pack asignado funciona para Corporativo
- [ ] Validación de fecha verificada funciona para Bodas
- [ ] Timestamp y usuario de cualificación se registran correctamente
- [ ] Auditoría de cualificaciones funciona correctamente
- [ ] Manejo de errores implementado (campos faltantes, pack no asignado, errores de base de datos)
- [ ] Prevención de cualificación duplicada implementada
- [ ] Pruebas de aceptación pasadas (todos los escenarios BDD)
- [ ] Documentación técnica actualizada
- [ ] Desplegado en entorno de producción

### Riesgos y supuestos
- **Riesgo:** Cualificación con información incompleta puede afectar siguiente etapa
  - **Probabilidad:** Baja
  - **Impacto:** Alto
  - **Mitigación:** Validación estricta de campos críticos antes de permitir cualificación, mensajes de error específicos

- **Riesgo:** Usuario puede intentar cualificar sin cumplir requisitos
  - **Probabilidad:** Media
  - **Impacto:** Medio
  - **Mitigación:** Validación automática obligatoria, bloqueo de cualificación si faltan requisitos

- **Riesgo:** Error en cambio de estado puede dejar lead en estado inconsistente
  - **Probabilidad:** Baja
  - **Impacto:** Alto
  - **Mitigación:** Transacciones atómicas en base de datos, rollback en caso de error, registro de auditoría completo

- **Supuesto:** Campos críticos están correctamente definidos y son suficientes para cualificación
- **Supuesto:** Usuario de ONGAKU tiene conocimiento de qué información es crítica para cada línea de negocio

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-002-registro-cualificacion-leads.md`
- Bloque funcional: Marcado como cualificado con validaciones
- Paso(s): Paso 7 del flujo principal (marcar lead como "Cualificado" y listo para respuesta inicial)
