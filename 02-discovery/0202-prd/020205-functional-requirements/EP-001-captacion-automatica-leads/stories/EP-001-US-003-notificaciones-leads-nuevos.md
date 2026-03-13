# EP-001-US-003 — Notificaciones de leads nuevos

### Epic padre
EP-001 — Entrada estandarizada y registro automático de leads

### Contexto/Descripción y valor
**Como** usuario de ONGAKU,  
**quiero** recibir notificaciones de los nuevos leads que se creen en el sistema,  
**para** poder cualificarlos inmediatamente y no perder ninguna oportunidad comercial por falta de seguimiento

### Alcance
**Incluye:**
- Notificación automática cuando se crea un nuevo lead (desde formulario web o entrada manual)
- Múltiples canales de notificación: notificación en sistema (dashboard), email, push (opcional)
- Contenido de notificación: ID de lead, nombre, email, línea de negocio, vía de conocimiento, fecha de creación, enlace directo al lead
- Centro de notificaciones en dashboard con lista de notificaciones de leads nuevos
- Marcar notificación como leída
- Marcar todas las notificaciones como leídas
- Acceso directo al lead desde la notificación
- Indicador de notificaciones no leídas (badge con contador)
- Configuración de preferencias de notificación (canales, frecuencia)

**Excluye:**
- Asignación automática de responsable según línea de negocio
- Notificaciones de actualizaciones de leads existentes
- Notificaciones de otros eventos (presupuestos, contratos, etc.)
- Cualificación de leads (EP-002)
- Gestión de leads (EP-001-US-002)

### Precondiciones
- Lead ha sido creado en el sistema (desde formulario web - EP-001-US-001 o entrada manual - EP-001-US-002)
- Usuario de ONGAKU tiene sesión iniciada en el sistema o tiene email configurado
- Sistema de notificaciones está disponible y funcionando
- Usuario de ONGAKU tiene permisos para recibir notificaciones de leads

### Postcondiciones
- Notificación creada y enviada a usuarios de ONGAKU configurados para recibir notificaciones
- Notificación visible en centro de notificaciones del dashboard
- Email enviado (si está configurado) con información del lead
- Push notification enviada (si está configurado y disponible)
- Indicador de notificaciones no leídas actualizado
- Usuario puede acceder directamente al lead desde la notificación

### Flujo principal

#### Notificación automática al crear lead
1. Sistema detecta creación de nuevo lead (desde formulario web o entrada manual)
2. Sistema identifica usuarios de ONGAKU que deben recibir notificaciones (según configuración)
3. Sistema genera notificación con información del lead: ID, nombre, email, línea de negocio, vía de conocimiento, fecha de creación
4. Sistema crea entrada en centro de notificaciones para cada usuario configurado
5. Sistema envía email de notificación (si está configurado) con resumen del lead y enlace directo
6. Sistema envía push notification (si está configurado y disponible)
7. Sistema actualiza contador de notificaciones no leídas para cada usuario
8. Usuario de ONGAKU recibe notificación en dashboard, email y/o push

#### Visualizar notificaciones en dashboard
1. Usuario de ONGAKU accede al dashboard del sistema
2. Sistema muestra indicador de notificaciones (badge con número de notificaciones no leídas) en icono de campana
3. Usuario hace clic en icono de notificaciones
4. Sistema muestra centro de notificaciones con lista de notificaciones de leads nuevos (más recientes primero)
5. Sistema muestra para cada notificación: ID de lead, nombre, línea de negocio, fecha/hora, estado (leída/no leída)
6. Usuario puede ver todas sus notificaciones de leads nuevos

#### Acceder al lead desde notificación
1. Usuario de ONGAKU está viendo centro de notificaciones
2. Usuario hace clic en una notificación de lead nuevo
3. Sistema marca la notificación como leída
4. Sistema actualiza contador de notificaciones no leídas
5. Sistema redirige a vista de detalle del lead correspondiente
6. Usuario puede gestionar el lead desde la vista de detalle

#### Marcar notificaciones como leídas
1. Usuario de ONGAKU está viendo centro de notificaciones
2. Usuario hace clic en botón "Marcar todas como leídas"
3. Sistema marca todas las notificaciones de leads nuevos como leídas
4. Sistema actualiza contador de notificaciones no leídas a cero
5. Sistema muestra confirmación visual de que todas están marcadas como leídas

### Flujos alternos y excepciones

**Flujo alterno 1: Notificación por email con enlace**
- Si usuario tiene email configurado, recibe email con resumen del lead
- Email incluye botón/enlace "Ver lead en sistema" que redirige directamente al lead
- Al hacer clic, usuario accede al sistema (con autenticación si es necesario) y ve el lead

**Flujo alterno 2: Múltiples notificaciones acumuladas**
- Si hay varios leads nuevos sin leer, sistema muestra todas las notificaciones en lista
- Usuario puede ver resumen: "Tienes 5 leads nuevos sin revisar"
- Usuario puede acceder a cada uno individualmente o ver lista completa

**Flujo alterno 3: Configurar preferencias de notificación**
- Usuario puede acceder a configuración de notificaciones
- Usuario puede elegir canales: solo dashboard, dashboard + email, todos los canales
- Usuario puede elegir frecuencia: inmediata, resumen diario, resumen semanal
- Sistema guarda preferencias y aplica en próximas notificaciones

**Excepción 1: Error al enviar notificación**
- Si falla envío de email o push, sistema registra error en logs
- Sistema mantiene notificación en dashboard aunque falle email/push
- Sistema reintenta envío de email/push en segundo plano
- Usuario siempre puede ver notificación en dashboard

**Excepción 2: Usuario no tiene sesión iniciada**
- Si usuario no está en el sistema, solo recibe email (si está configurado)
- Al iniciar sesión, usuario ve todas las notificaciones pendientes en dashboard
- Contador de notificaciones no leídas se actualiza al iniciar sesión

**Excepción 3: Lead eliminado antes de ver notificación**
- Si lead se elimina antes de que usuario vea la notificación, sistema marca notificación como "Lead eliminado"
- Notificación permanece en historial pero enlace al lead muestra mensaje "Lead no encontrado"

**Excepción 4: Notificaciones deshabilitadas por usuario**
- Si usuario ha deshabilitado notificaciones en sus preferencias, sistema no envía notificaciones
- Sistema registra que notificación debería haberse enviado pero fue omitida por preferencias

### Validaciones y reglas de negocio
- **Notificación automática:** Se genera automáticamente para cada lead creado (sin excepciones)
- **Destinatarios:** Todos los usuarios de ONGAKU con permisos para gestionar leads reciben notificaciones (según configuración)
- **Contenido mínimo:** Notificación debe incluir: ID de lead, nombre, línea de negocio, fecha de creación, enlace directo
- **Timing:** Notificación se envía inmediatamente tras creación del lead (< 1 minuto)
- **Estado de notificación:** Notificaciones tienen estado "leída" o "no leída"
- **Retención:** Notificaciones se mantienen en historial por tiempo configurado (ejemplo: 30 días)
- **Unicidad:** No se crean notificaciones duplicadas para el mismo lead y usuario
- **Prioridad:** Notificaciones de leads nuevos tienen prioridad alta
- **Agregación:** Si hay múltiples leads nuevos en corto tiempo, sistema puede enviar resumen (según preferencias del usuario)

### Criterios BDD
- **Escenario 1: Recibir notificación al crear lead desde formulario web**
  - *Dado* que un cliente potencial ha enviado un formulario y el sistema ha creado un nuevo lead
  - *Cuando* el sistema genera la notificación automática
  - *Entonces* los usuarios de ONGAKU configurados reciben notificación en dashboard con información del lead (ID, nombre, línea de negocio) y contador de notificaciones no leídas se actualiza

- **Escenario 2: Acceder al lead desde notificación**
  - *Dado* que un usuario de ONGAKU tiene una notificación de lead nuevo no leída en su dashboard
  - *Cuando* hace clic en la notificación
  - *Entonces* el sistema marca la notificación como leída, actualiza el contador, y redirige a la vista de detalle del lead correspondiente

- **Escenario 3: Recibir email de notificación**
  - *Dado* que un nuevo lead ha sido creado y un usuario de ONGAKU tiene email configurado en sus preferencias
  - *Cuando* el sistema envía la notificación
  - *Entonces* el usuario recibe email con resumen del lead (nombre, línea de negocio, fecha) y enlace directo al lead en el sistema

- **Escenario 4: Marcar todas las notificaciones como leídas**
  - *Dado* que un usuario de ONGAKU tiene 5 notificaciones de leads nuevos no leídas
  - *Cuando* hace clic en "Marcar todas como leídas"
  - *Entonces* el sistema marca todas las notificaciones como leídas y el contador de notificaciones no leídas se actualiza a cero

- **Escenario 5: Notificación no enviada por preferencias del usuario**
  - *Dado* que un usuario de ONGAKU ha deshabilitado las notificaciones de leads nuevos en sus preferencias
  - *Cuando* se crea un nuevo lead en el sistema
  - *Entonces* el sistema no envía notificación al usuario pero registra en logs que debería haberse enviado

### Notificaciones
- **Usuario de ONGAKU (Dashboard):** Notificación visible en centro de notificaciones con información del lead y enlace directo
- **Usuario de ONGAKU (Email):** Email con resumen del lead y enlace directo (si está configurado)
- **Usuario de ONGAKU (Push):** Push notification en dispositivo móvil (si está configurado y disponible)
- **Sistema:** Registro en logs de todas las notificaciones enviadas (éxito o fallo)

### Seguridad
- **Autenticación:** Usuario debe estar autenticado para ver notificaciones en dashboard
- **Autorización:** Solo usuarios de ONGAKU con permisos para gestionar leads reciben notificaciones
- **Privacidad:** Información del lead en notificaciones se limita a datos necesarios (no se incluyen datos sensibles innecesarios)
- **Enlaces seguros:** Enlaces directos a leads requieren autenticación y validación de permisos
- **Rate limiting:** Límite de notificaciones por usuario para prevenir spam
- **Validación de destinatarios:** Sistema valida que destinatarios tengan permisos antes de enviar

### Analítica/KPIs
- **Métricas a instrumentar:**
  - Tiempo entre creación de lead y visualización de notificación por usuario
  - Tasa de apertura de notificaciones (notificaciones leídas vs no leídas)
  - Tiempo promedio desde notificación hasta acceso al lead
  - Canales de notificación más efectivos (dashboard vs email vs push)
  - Número de notificaciones no leídas acumuladas por usuario
  - Tasa de clics en enlaces de notificaciones
  - Frecuencia de uso de "marcar todas como leídas"
- **Objetivo:** 100% de notificaciones entregadas en < 1 minuto desde creación del lead, 80% de notificaciones leídas en < 5 minutos

### Definition of Ready
- [ ] Diseño de centro de notificaciones aprobado (UI/UX)
- [ ] Sistema de notificaciones implementado (dashboard, email, push)
- [ ] Configuración de preferencias de notificación definida
- [ ] Plantilla de email de notificación diseñada
- [ ] Permisos RBAC definidos para recepción de notificaciones
- [ ] Endpoints del backend disponibles para gestión de notificaciones
- [ ] Integración con servicio de email configurada
- [ ] Integración con servicio de push notifications configurada (si aplica)

### Definition of Done
- [ ] Notificaciones automáticas se generan correctamente al crear lead
- [ ] Centro de notificaciones en dashboard funciona correctamente
- [ ] Notificaciones se muestran con información correcta del lead
- [ ] Contador de notificaciones no leídas funciona correctamente
- [ ] Acceso directo al lead desde notificación funciona correctamente
- [ ] Marcar notificaciones como leídas funciona correctamente
- [ ] Email de notificación se envía correctamente (si está configurado)
- [ ] Push notification se envía correctamente (si está configurado)
- [ ] Configuración de preferencias de notificación funciona correctamente
- [ ] Manejo de errores implementado (fallos de envío, lead eliminado)
- [ ] Pruebas de aceptación pasadas (todos los escenarios BDD)
- [ ] Documentación técnica actualizada
- [ ] Desplegado en entorno de producción

### Riesgos y supuestos
- **Riesgo:** Sobrecarga de notificaciones si hay muchos leads nuevos
  - **Probabilidad:** Media
  - **Impacto:** Medio
  - **Mitigación:** Agregación de notificaciones, resumen diario según preferencias, configuración de frecuencia

- **Riesgo:** Notificaciones no vistas si usuario no accede al sistema frecuentemente
  - **Probabilidad:** Media
  - **Impacto:** Medio
  - **Mitigación:** Email como canal alternativo, push notifications, recordatorios si hay notificaciones pendientes

- **Riesgo:** Fallo en envío de notificaciones puede causar pérdida de leads
  - **Probabilidad:** Baja
  - **Impacto:** Alto
  - **Mitigación:** Notificaciones siempre disponibles en dashboard aunque falle email/push, logs de errores, alertas automáticas de fallos

- **Supuesto:** Usuarios de ONGAKU acceden al sistema regularmente o tienen email configurado
- **Supuesto:** Sistema de notificaciones (email, push) está disponible y funcionando

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-001-captacion-automatica-leads.md`
- Bloque funcional: Notificación inmediata al equipo responsable
- Paso(s): Paso 5 del flujo principal (notificación automática al responsable correspondiente)
