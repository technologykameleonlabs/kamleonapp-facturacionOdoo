# EP-003-US-003 — Envío automático de correos y registro de envíos

### Epic padre
EP-003 — Respuesta automática inicial a leads

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** enviar automáticamente el correo personalizado al lead cualificado y registrar el envío con timestamp, tipo de correo y destinatario,  
**para** garantizar trazabilidad completa de todas las comunicaciones, notificar al equipo del envío realizado, y asegurar que todos los leads cualificados reciban respuesta automática en menos de 5 minutos

### Alcance
**Incluye:**
- Envío automático del correo personalizado al email del lead cualificado
- Validación de email antes de envío (formato válido, no vacío)
- Registro de envío en sistema con información completa:
  - ID del lead
  - Email destinatario
  - Tipo de correo enviado (Anexo 1, Anexo 2, Anexo 3, Corporativo)
  - Timestamp de envío
  - Estado de envío (Enviado, Error, Pendiente)
  - Contenido del correo enviado (opcional, para referencia)
- Notificación al responsable (Fátima/Paz) del envío realizado
- Manejo de errores en envío (reintentos automáticos, notificación de fallos)
- Prevención de envíos duplicados (no reenviar si ya se envió recientemente)
- Historial de envíos por lead (trazabilidad completa)

**Excluye:**
- Selección de plantilla (EP-003-US-001)
- Personalización del correo (EP-003-US-002)
- Gestión de plantillas (EP-003-US-004)
- Tracking de apertura de correos
- Análisis de respuestas del cliente

### Precondiciones
- Correo personalizado generado y listo para envío (EP-003-US-002 completado)
- Email del lead cualificado está disponible y es válido
- Sistema de envío de emails está configurado y disponible
- Envío automático está activado (no desactivado manualmente)
- No se ha enviado correo recientemente al mismo lead (prevención de duplicados)

### Postcondiciones
- Correo enviado automáticamente al email del lead cualificado
- Envío registrado en sistema con información completa y timestamp
- Responsable (Fátima/Paz) notificado del envío realizado
- Lead queda disponible para seguimiento y agendamiento (EP-004)
- Si hay error en envío, se registra error y se notifica al responsable

### Flujo principal
1. Sistema recibe correo personalizado listo para envío (desde EP-003-US-002) e ID del lead cualificado
2. Sistema valida que email del lead es válido y no está vacío
3. Sistema verifica que envío automático está activado (no desactivado manualmente)
4. Sistema verifica que no se ha enviado correo recientemente al mismo lead (configurable, ejemplo: no reenviar en menos de 24 horas)
5. Sistema prepara envío del correo:
   - Email destinatario: email del lead
   - Asunto: asunto de la plantilla personalizado
   - Contenido: correo personalizado generado
   - Remitente: email configurado de ONGAKU
6. Sistema envía correo automáticamente mediante sistema de envío de emails
7. Sistema registra envío en base de datos con información completa:
   - ID del lead
   - Email destinatario
   - Tipo de correo enviado (Anexo 1, Anexo 2, Anexo 3, Corporativo)
   - Timestamp de envío
   - Estado: "Enviado"
   - Contenido del correo (opcional, para referencia)
8. Sistema notifica al responsable (Fátima/Paz) del envío realizado:
   - Resumen del correo enviado
   - Tipo de correo
   - Datos del lead
   - Enlace al lead para seguimiento
9. Sistema actualiza estado del lead (opcional: marcar como "Respuesta enviada")
10. Proceso completado, lead disponible para agendamiento (EP-004)

### Flujos alternos y excepciones

**Flujo alterno 1: Envío automático desactivado manualmente**
- Si envío automático está desactivado para este lead específico o globalmente
- Sistema no envía correo automáticamente
- Sistema registra razón: "Envío automático desactivado"
- Sistema notifica al responsable que correo no se envió por desactivación manual
- Proceso se detiene, requiere intervención manual

**Flujo alterno 2: Correo ya enviado recientemente**
- Si se ha enviado correo al mismo lead en las últimas 24 horas (configurable)
- Sistema no reenvía correo automáticamente
- Sistema registra razón: "Correo ya enviado recientemente"
- Sistema notifica al responsable si se intenta reenvío
- Proceso se detiene, requiere intervención manual si se necesita reenvío

**Excepción 1: Email inválido o faltante**
- Si el email del lead no es válido o está vacío
- Sistema marca error y no envía correo
- Sistema registra error con detalles: ID de lead, problema detectado, timestamp
- Sistema notifica al responsable para corrección del email
- Proceso se detiene hasta que se corrija el email

**Excepción 2: Error en envío de correo (fallo temporal)**
- Si el sistema de envío de emails falla al enviar (error de conexión, servidor no disponible)
- Sistema intenta reenvío automático 3 veces con intervalo de 5 minutos entre intentos
- Si después de 3 intentos sigue fallando, sistema marca error permanente
- Sistema registra error con detalles: ID de lead, número de intentos, error específico, timestamp
- Sistema notifica al responsable del error permanente
- Correo queda en estado "Pendiente" para envío manual posterior

**Excepción 3: Error en envío de correo (fallo permanente)**
- Si el sistema de envío de emails rechaza el correo (email inválido, bloqueado, etc.)
- Sistema marca error permanente inmediatamente (no reintenta)
- Sistema registra error con detalles: ID de lead, razón del rechazo, timestamp
- Sistema notifica al responsable del error permanente
- Correo queda en estado "Error" y requiere intervención manual

**Excepción 4: Error al registrar envío**
- Si el envío del correo es exitoso pero falla el registro en base de datos
- Sistema notifica al responsable del problema
- Sistema intenta registro nuevamente en segundo plano
- Correo queda enviado pero sin registro completo (requiere corrección manual)

**Excepción 5: Timeout del sistema de envío**
- Si el sistema de envío de emails no responde en tiempo razonable (timeout)
- Sistema marca error y reintenta envío automático (hasta 3 intentos)
- Si después de 3 intentos sigue sin respuesta, sistema marca error permanente
- Sistema registra error y notifica al responsable

### Validaciones y reglas de negocio
- **Email válido:** Email del lead debe ser válido (formato correcto) y no estar vacío antes de envío
- **Envío automático activado:** Envío automático debe estar activado (no desactivado manualmente)
- **Prevención de duplicados:** No reenviar correo si se ha enviado recientemente (configurable, ejemplo: 24 horas)
- **Reintentos automáticos:** En caso de fallo temporal, reintentar envío automático hasta 3 veces con intervalo de 5 minutos
- **Registro obligatorio:** Todos los envíos (exitosos o fallidos) deben registrarse en sistema con información completa
- **Notificación al responsable:** Todos los envíos exitosos y errores deben notificarse al responsable
- **Estado de envío:** Estados posibles: "Enviado", "Error", "Pendiente", "Cancelado"
- **Trazabilidad completa:** Historial de todos los envíos por lead debe estar disponible para consulta

### Criterios BDD
- **Escenario 1: Envío exitoso de correo personalizado**
  - *Dado* que un correo personalizado está listo para envío y el email del lead es válido
  - *Cuando* el sistema envía el correo automáticamente
  - *Entonces* el sistema envía el correo al email del lead, registra el envío con timestamp y tipo de correo, y notifica al responsable del envío realizado

- **Escenario 2: Error cuando email es inválido**
  - *Dado* que un correo personalizado está listo para envío pero el email del lead es inválido o está vacío
  - *Cuando* el sistema intenta enviar el correo
  - *Entonces* el sistema marca error, no envía el correo, registra el error con detalles, y notifica al responsable para corrección

- **Escenario 3: Reintento automático en caso de fallo temporal**
  - *Dado* que un correo personalizado está listo para envío y el sistema de envío de emails falla temporalmente
  - *Cuando* el sistema intenta enviar el correo
  - *Entonces* el sistema reintenta el envío automáticamente hasta 3 veces con intervalo de 5 minutos, y si después de 3 intentos sigue fallando, marca error permanente y notifica al responsable

- **Escenario 4: Prevención de envíos duplicados**
  - *Dado* que se ha enviado un correo a un lead en las últimas 24 horas
  - *Cuando* el sistema intenta enviar otro correo automáticamente al mismo lead
  - *Entonces* el sistema no reenvía el correo, registra razón "Correo ya enviado recientemente", y notifica al responsable si se intenta reenvío

- **Escenario 5: Envío automático desactivado**
  - *Dado* que el envío automático está desactivado manualmente para un lead o globalmente
  - *Cuando* el sistema intenta enviar el correo automáticamente
  - *Entonces* el sistema no envía el correo, registra razón "Envío automático desactivado", y notifica al responsable

- **Escenario 6: Registro completo de envío exitoso**
  - *Dado* que un correo se ha enviado exitosamente
  - *Cuando* el sistema registra el envío
  - *Entonces* el sistema registra información completa: ID del lead, email destinatario, tipo de correo, timestamp, estado "Enviado", y el registro queda disponible para consulta en historial

### Notificaciones
- **Responsable (Fátima/Paz):** Notificación automática de cada envío exitoso con resumen del correo, tipo de correo, datos del lead, y enlace al lead para seguimiento
- **Responsable (Fátima/Paz):** Notificación automática de errores en envío (email inválido, fallo permanente, etc.) con detalles del error
- **Responsable (Fátima/Paz):** Notificación automática si envío automático está desactivado y se intenta envío
- **Sistema:** Registro de todos los envíos (exitosos y fallidos) para trazabilidad y análisis

### Seguridad
- **Validación de email:** Email debe ser válido antes de envío (prevenir envíos a direcciones inválidas)
- **Rate limiting:** Límite de envíos por lead para prevenir spam (configurable)
- **Sanitización:** Contenido del correo debe estar sanitizado antes de envío (prevenir inyección de código)
- **Privacidad:** Información del lead solo se usa para envío del correo, no se comparte con terceros
- **Registro de auditoría:** Todos los envíos quedan registrados para auditoría y cumplimiento

### Analítica/KPIs
- **Métricas a instrumentar:**
  - Número de correos enviados exitosamente por tipo (Anexo 1, Anexo 2, Anexo 3, Corporativo)
  - Tiempo promedio de envío desde cualificación hasta envío (< 5 minutos objetivo)
  - Tasa de errores en envío (email inválido, fallos temporales, fallos permanentes)
  - Número de reintentos automáticos realizados
  - Tasa de envíos duplicados prevenidos
  - Distribución de estados de envío (Enviado, Error, Pendiente)
  - Tiempo promedio de resolución de errores
- **Objetivo:** 100% de leads cualificados reciben respuesta automática en < 5 minutos desde cualificación

### Definition of Ready
- [ ] Sistema de envío de emails configurado y disponible (SMTP, API de email, etc.)
- [ ] Email remitente configurado (email de ONGAKU)
- [ ] Configuración de reintentos definida (número de intentos, intervalo)
- [ ] Configuración de prevención de duplicados definida (tiempo mínimo entre envíos)
- [ ] Sistema de registro de envíos implementado
- [ ] Sistema de notificaciones al responsable implementado
- [ ] Validación de emails implementada

### Definition of Done
- [ ] Envío automático de correos funciona correctamente
- [ ] Validación de emails funciona correctamente antes de envío
- [ ] Registro de envíos funciona correctamente con información completa
- [ ] Notificaciones al responsable funcionan correctamente (éxitos y errores)
- [ ] Reintentos automáticos funcionan correctamente en caso de fallos temporales
- [ ] Prevención de envíos duplicados funciona correctamente
- [ ] Manejo de errores implementado (email inválido, fallos temporales, fallos permanentes)
- [ ] Historial de envíos funciona correctamente y está disponible para consulta
- [ ] Pruebas de aceptación pasadas (todos los escenarios BDD)
- [ ] Documentación técnica actualizada
- [ ] Desplegado en entorno de producción

### Riesgos y supuestos
- **Riesgo:** Correo no llega al cliente (spam, bloqueado, etc.)
  - **Probabilidad:** Media
  - **Impacto:** Alto
  - **Mitigación:** Configuración correcta de SPF/DKIM, monitoreo de tasa de entrega, validación de emails antes de envío

- **Riesgo:** Envíos duplicados pueden causar confusión al cliente
  - **Probabilidad:** Baja
  - **Impacto:** Medio
  - **Mitigación:** Prevención de envíos duplicados, control de envíos recientes, registro de historial

- **Riesgo:** Fallo en sistema de envío puede detener el proceso
  - **Probabilidad:** Media
  - **Impacto:** Alto
  - **Mitigación:** Reintentos automáticos, notificación inmediata al responsable, sistema de respaldo, monitoreo de sistema de envío

- **Riesgo:** Error en registro puede causar pérdida de trazabilidad
  - **Probabilidad:** Baja
  - **Impacto:** Medio
  - **Mitigación:** Registro robusto con reintentos, notificación de errores de registro, sistema de respaldo

- **Supuesto:** Sistema de envío de emails está disponible y funcionando correctamente
- **Supuesto:** Email del lead es válido y accesible
- **Supuesto:** Envío automático está activado por defecto

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-003-respuesta-automatica-inicial.md`
- Bloque funcional: Envío automático de correos modelo personalizados
- Paso(s): Pasos 4-7 del flujo principal (envío automático del correo, registro del envío, notificación al responsable)
