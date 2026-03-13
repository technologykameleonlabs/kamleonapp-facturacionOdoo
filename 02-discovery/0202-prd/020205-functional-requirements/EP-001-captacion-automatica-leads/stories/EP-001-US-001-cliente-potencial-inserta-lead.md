# EP-001-US-001 — Cliente potencial inserta lead mediante formulario

### Epic padre
EP-001 — Entrada estandarizada y registro automático de leads

### Contexto/Descripción y valor
**Como** cliente potencial,  
**quiero** insertar mi consulta mediante un formulario web unificado accesible desde cualquier canal mediante CTA/link, seleccionando la vía por la que me enteré de ONGAKU y si es para Bodas o Corporativo,  
**para** que mi consulta quede registrada automáticamente en el sistema sin intervención manual y garantizar que toda mi información quede capturada correctamente

### Alcance
**Incluye:**
- Formulario web único accesible mediante URL pública
- Acceso desde cualquier canal mediante CTA/link (ejemplo: "Solicita info")
- Campos del formulario: nombre, email, teléfono, mensaje/consulta, vía por la que se enteró de ONGAKU (selección), línea de negocio (Bodas/Corporativo - selección única y mutuamente excluyente), fecha de boda (opcional, solo si selecciona Bodas - calendario con solo fechas disponibles)
- Registro automático en base de datos unificada tras envío exitoso
- Validación de campos en tiempo real
- Diseño responsive (móvil, tablet, desktop)
- Mensaje de confirmación tras envío exitoso
- Generación automática de ID de lead

**Excluye:**
- Tracking mediante parámetros UTM
- Detección automática de línea de negocio
- Asignación automática de responsable
- Notificaciones al equipo (EP-001-US-003)
- Gestión de leads (EP-001-US-002)
- Verificación de disponibilidad posterior a la captura (ya se hace en tiempo real en el formulario)

### Precondiciones
- Cliente potencial tiene acceso a internet
- Cliente potencial accede al formulario mediante CTA/link desde cualquier canal
- Formulario está disponible públicamente (sin autenticación requerida)
- Base de datos unificada disponible para registro automático

### Postcondiciones
- Lead registrado automáticamente en base de datos unificada con estado "Nuevo"
- ID de lead generado automáticamente
- Cliente potencial ve mensaje de confirmación
- Vía de conocimiento y línea de negocio registradas según selección del cliente
- Fecha de boda registrada si línea de negocio es "Bodas" y el cliente potencial la seleccionó (opcional, puede estar vacía)
- Disponibilidad verificada en tiempo real durante captación si se muestra el campo de fecha (solo fechas disponibles mostradas en calendario)
- Lead disponible para notificación al equipo (EP-001-US-003)

### Flujo principal
1. Cliente potencial hace clic en CTA/link desde cualquier canal (LinkedIn, Facebook, Instagram, web)
2. Sistema redirige al formulario web unificado
3. Cliente potencial ve formulario con campos: nombre, email, teléfono, mensaje/consulta, vía por la que se enteró de ONGAKU (dropdown/select), línea de negocio (Bodas/Corporativo - radio buttons, selección única y mutuamente excluyente)
4. Cliente potencial completa los campos del formulario
5. Cliente potencial selecciona vía por la que se enteró de ONGAKU (ejemplo: LinkedIn, Facebook, Instagram, Web, Recomendación, Otro)
6. Cliente potencial selecciona línea de negocio (Bodas o Corporativo)
7. Si cliente potencial selecciona "Bodas", sistema muestra campo de fecha de boda con calendario (opcional)
8. Sistema consulta automáticamente calendario de fechas reservadas y muestra solo fechas disponibles en el calendario
9. Cliente potencial puede seleccionar fecha de boda de entre las fechas disponibles mostradas, o puede continuar sin seleccionar fecha (campo opcional)
10. Sistema valida campos en tiempo real (email válido, teléfono con formato correcto, campos obligatorios, fecha válida y disponible si se selecciona)
11. Cliente potencial envía formulario
12. Sistema valida todos los campos antes de enviar (fecha de boda es opcional incluso si es Bodas)
13. Sistema registra automáticamente el lead en base de datos unificada con todos los datos capturados (incluyendo fecha de boda si aplica)
14. Sistema genera ID de lead automáticamente (formato: LEAD-YYYYMMDD-XXX)
15. Sistema muestra mensaje de confirmación: "Gracias por tu consulta. Te contactaremos pronto."
16. Lead queda disponible para notificación al equipo (EP-001-US-003)

### Flujos alternos y excepciones

**Flujo alterno 1: Campos incompletos**
- Si cliente potencial intenta enviar formulario con campos obligatorios vacíos, sistema muestra mensaje de error indicando campos faltantes
- Cliente potencial completa campos faltantes y reintenta envío

**Flujo alterno 2: Email inválido**
- Si cliente potencial ingresa email con formato inválido, sistema muestra mensaje de error: "Por favor, ingresa un email válido"
- Cliente potencial corrige email y continúa

**Flujo alterno 3: Teléfono con formato incorrecto**
- Si cliente potencial ingresa teléfono con formato incorrecto, sistema muestra mensaje de error: "Por favor, ingresa un teléfono válido (ejemplo: +34 600 000 000)"
- Cliente potencial corrige teléfono y continúa

**Flujo alterno 4: No selecciona vía de conocimiento**
- Si cliente potencial no selecciona vía por la que se enteró de ONGAKU, sistema muestra mensaje de error: "Por favor, selecciona cómo te enteraste de ONGAKU"
- Cliente potencial selecciona opción y continúa

**Flujo alterno 5: No selecciona línea de negocio**
- Si cliente potencial no selecciona línea de negocio (Bodas/Corporativo), sistema muestra mensaje de error: "Por favor, selecciona si es para Bodas o Corporativo"
- Cliente potencial selecciona opción y continúa

**Flujo alterno 6: Selecciona Bodas pero no selecciona fecha**
- Si cliente potencial selecciona "Bodas" pero no selecciona fecha de boda, puede continuar con el formulario sin fecha
- El campo de fecha de boda es opcional, el cliente potencial puede enviar el formulario sin seleccionar fecha
- Si hay fechas disponibles, el calendario las muestra, pero el cliente potencial puede omitir la selección

**Flujo alterno 7: Selecciona Bodas pero no hay fechas disponibles**
- Si cliente potencial selecciona "Bodas" y el calendario no muestra fechas disponibles en el rango consultado, sistema muestra mensaje informativo: "No hay fechas disponibles en este momento. Puedes continuar sin fecha y te contactaremos"
- Cliente potencial puede continuar con el formulario sin fecha

**Excepción 1: Error de conexión**
- Si hay error de conexión al enviar formulario, sistema muestra mensaje: "Error de conexión. Por favor, intenta nuevamente."
- Cliente potencial puede reintentar envío
- Si falla registro automático, sistema mantiene datos en caché local para reintento

**Excepción 2: Timeout del servidor**
- Si el servidor no responde en tiempo razonable, sistema muestra mensaje: "El servidor está tardando en responder. Por favor, intenta más tarde."
- Cliente potencial puede reintentar envío

**Excepción 3: Error en registro automático**
- Si falla el registro automático en base de datos, sistema muestra mensaje de error al cliente potencial y notifica al equipo técnico
- Sistema intenta registro automático nuevamente en segundo plano

### Validaciones y reglas de negocio
- **Nombre:** Obligatorio, mínimo 2 caracteres, máximo 100 caracteres, solo letras, espacios y caracteres especiales comunes (ñ, acentos)
- **Email:** Obligatorio, formato válido de email (regex estándar), máximo 255 caracteres
- **Teléfono:** Obligatorio, formato válido (puede incluir código de país), mínimo 9 dígitos, máximo 20 caracteres
- **Mensaje/Consulta:** Obligatorio, mínimo 10 caracteres, máximo 2000 caracteres
- **Vía por la que se enteró de ONGAKU:** Obligatorio, selección única de lista predefinida (LinkedIn, Facebook, Instagram, Web, Recomendación, Otro)
- **Línea de negocio:** Obligatorio, selección única y mutuamente excluyente entre "Bodas" o "Corporativo" (radio buttons, no se pueden seleccionar ambos)
- **Fecha de boda:** Opcional, solo visible si línea de negocio es "Bodas". Si se muestra, solo se pueden seleccionar fechas disponibles según calendario de fechas reservadas. El cliente potencial puede enviar el formulario sin seleccionar fecha
- **Consulta de disponibilidad:** Sistema consulta automáticamente calendario de fechas reservadas cuando se selecciona "Bodas" y muestra solo fechas disponibles en el calendario
- **Validación en tiempo real:** Campos se validan mientras cliente potencial escribe (email, teléfono)
- **Prevención de spam:** Validación de campos, posible captcha si se detecta comportamiento sospechoso
- **Registro automático:** Tras validación exitosa, lead se registra automáticamente en base de datos con timestamp, estado "Nuevo" y ID generado

### Criterios BDD
- **Escenario 1: Inserción exitosa de lead con registro automático**
  - *Dado* que un cliente potencial accede al formulario mediante CTA desde cualquier canal
  - *Cuando* completa todos los campos correctamente (nombre, email, teléfono, mensaje), selecciona vía de conocimiento "LinkedIn" y línea de negocio "Bodas", y envía el formulario
  - *Entonces* el sistema registra automáticamente el lead en la base de datos con todos los datos capturados, genera ID de lead, y muestra mensaje de confirmación "Gracias por tu consulta. Te contactaremos pronto."

- **Escenario 2: Validación de email inválido**
  - *Dado* que un cliente potencial está completando el formulario
  - *Cuando* ingresa un email con formato inválido (ejemplo: "email@sin-dominio")
  - *Entonces* el sistema muestra mensaje de error "Por favor, ingresa un email válido" y no permite enviar el formulario

- **Escenario 3: Campos obligatorios faltantes**
  - *Dado* que un cliente potencial intenta enviar el formulario
  - *Cuando* no completa todos los campos obligatorios (nombre, email, teléfono, mensaje, vía de conocimiento, línea de negocio)
  - *Entonces* el sistema muestra mensaje de error indicando los campos faltantes y no permite enviar el formulario

- **Escenario 4: No selecciona línea de negocio**
  - *Dado* que un cliente potencial está completando el formulario
  - *Cuando* completa todos los campos excepto línea de negocio y intenta enviar
  - *Entonces* el sistema muestra mensaje de error "Por favor, selecciona si es para Bodas o Corporativo" y no permite enviar el formulario

- **Escenario 5: Selecciona Bodas y ve solo fechas disponibles (opcional)**
  - *Dado* que un cliente potencial está completando el formulario y selecciona línea de negocio "Bodas"
  - *Cuando* el sistema consulta el calendario de fechas reservadas y muestra el campo de fecha de boda
  - *Entonces* el calendario muestra solo las fechas disponibles (no reservadas ni bloqueadas) y el cliente potencial puede seleccionar una de ellas o continuar sin fecha

- **Escenario 6: Selecciona Bodas y envía sin fecha**
  - *Dado* que un cliente potencial está completando el formulario y selecciona línea de negocio "Bodas"
  - *Cuando* completa todos los campos obligatorios pero no selecciona fecha de boda y envía el formulario
  - *Entonces* el sistema registra el lead correctamente sin fecha de boda, ya que el campo es opcional

- **Escenario 5: Error en registro automático**
  - *Dado* que un cliente potencial envía el formulario con todos los campos correctos
  - *Cuando* el sistema intenta registrar automáticamente el lead pero falla la conexión a la base de datos
  - *Entonces* el sistema muestra mensaje de error al cliente potencial, notifica al equipo técnico, e intenta registro automático nuevamente en segundo plano

### Notificaciones
- **Cliente potencial:** Mensaje de confirmación visual tras envío exitoso: "Gracias por tu consulta. Te contactaremos pronto."
- **Equipo técnico:** Notificación automática si falla registro en base de datos
- **No hay notificaciones al equipo comercial en esta US** (se gestionan en EP-001-US-003)

### Seguridad
- **Validación de entrada:** Sanitización de todos los campos para prevenir inyección SQL/XSS
- **HTTPS obligatorio:** Formulario solo accesible mediante HTTPS
- **Rate limiting:** Límite de envíos por IP para prevenir spam (ejemplo: máximo 5 envíos por hora por IP)
- **Prevención de bots:** Validación de campos y posible captcha si se detecta comportamiento sospechoso
- **Privacidad:** Información sobre tratamiento de datos personales según RGPD (link a política de privacidad)
- **Validación en backend:** Validación adicional de todos los campos en servidor antes de registro

### Analítica/KPIs
- **Métricas a instrumentar:**
  - Número de accesos al formulario por canal (mediante CTA/link)
  - Tasa de abandono del formulario (inicio vs envío)
  - Tiempo promedio de completado del formulario
  - Campos con mayor tasa de error
  - Dispositivo utilizado (móvil, tablet, desktop)
  - Distribución de vías de conocimiento seleccionadas
  - Distribución de líneas de negocio seleccionadas (Bodas vs Corporativo)
  - Tasa de registro exitoso vs fallos
- **Objetivo:** Tasa de conversión (acceso → envío → registro exitoso) > 60%

### Definition of Ready
- [ ] Diseño del formulario aprobado (UI/UX)
- [ ] Campos del formulario definidos y validados con stakeholders
- [ ] Opciones de vía de conocimiento definidas (LinkedIn, Facebook, Instagram, Web, Recomendación, Otro)
- [ ] Política de privacidad disponible
- [ ] Base de datos unificada disponible para registro automático
- [ ] Endpoint del backend disponible para recepción y registro de datos
- [ ] Especificaciones de validación definidas
- [ ] Formato de ID de lead definido

### Definition of Done
- [ ] Formulario web implementado y accesible públicamente
- [ ] Todos los campos funcionan correctamente con validación en tiempo real
- [ ] Campo de vía de conocimiento implementado con opciones predefinidas
- [ ] Campo de línea de negocio implementado (Bodas/Corporativo)
- [ ] Registro automático en base de datos funciona correctamente tras envío exitoso
- [ ] ID de lead se genera automáticamente con formato correcto
- [ ] Mensaje de confirmación se muestra tras envío exitoso
- [ ] Formulario es responsive (móvil, tablet, desktop)
- [ ] Validaciones de seguridad implementadas (sanitización, rate limiting)
- [ ] Manejo de errores implementado (conexión, timeout, registro fallido)
- [ ] Pruebas de aceptación pasadas (todos los escenarios BDD)
- [ ] Documentación técnica actualizada
- [ ] Desplegado en entorno de producción

### Riesgos y supuestos
- **Riesgo:** Cliente potencial puede abandonar formulario si es muy largo o complejo
  - **Probabilidad:** Media
  - **Impacto:** Medio
  - **Mitigación:** Formulario simple con solo campos esenciales, validación en tiempo real, diseño intuitivo

- **Riesgo:** Spam o envíos fraudulentos
  - **Probabilidad:** Media
  - **Impacto:** Bajo
  - **Mitigación:** Rate limiting, validación de campos, posible captcha, validación en backend

- **Riesgo:** Fallo en registro automático puede causar pérdida de leads
  - **Probabilidad:** Baja
  - **Impacto:** Alto
  - **Mitigación:** Manejo de errores robusto, reintento automático, notificación al equipo técnico, caché local para reintento

- **Supuesto:** Cliente potencial tiene acceso a internet y puede acceder al formulario desde cualquier dispositivo
- **Supuesto:** Cliente potencial puede seleccionar correctamente la vía por la que se enteró de ONGAKU y la línea de negocio

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-001-captacion-automatica-leads.md`
- Bloque funcional: Entrada estandarizada mediante formulario único
- Paso(s): Pasos 1-3 del flujo principal (cliente potencial envía consulta desde canal, sistema captura información, sistema registra en base de datos)
