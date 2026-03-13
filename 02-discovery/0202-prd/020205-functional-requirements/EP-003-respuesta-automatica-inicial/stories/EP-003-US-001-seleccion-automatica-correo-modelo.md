# EP-003-US-001 — Selección automática de correo modelo según disponibilidad y línea de negocio

### Epic padre
EP-003 — Respuesta automática inicial a leads

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** seleccionar automáticamente el correo modelo correcto (Anexo 1 disponible, Anexo 2 no disponible, Anexo 3 recordatorio) según disponibilidad verificada y línea de negocio del lead cualificado,  
**para** garantizar que se envíe el mensaje apropiado en cada situación y que todos los leads cualificados reciban la respuesta correcta según su estado

### Alcance
**Incluye:**
- Detección automática cuando un lead es marcado como "Cualificado" (trigger desde EP-002)
- Evaluación de disponibilidad verificada para bodas (ya verificada en EP-001 o EP-002)
- Identificación de línea de negocio del lead (Bodas o Corporativo)
- Selección automática de plantilla según reglas:
  - Bodas con fecha disponible → Anexo 1 (Disponible)
  - Bodas con fecha no disponible → Anexo 2 (No disponible)
  - Lead sin respuesta después de X días → Anexo 3 (Recordatorio)
  - Corporativo → Plantilla específica de corporativo
- Validación de que existe plantilla disponible para el tipo seleccionado
- Registro de selección realizada para trazabilidad

**Excluye:**
- Personalización del correo con datos del lead (EP-003-US-002)
- Envío del correo (EP-003-US-003)
- Gestión de plantillas (EP-003-US-004)
- Verificación de disponibilidad (ya realizada en EP-001 o EP-002)

### Precondiciones
- Lead está marcado como "Cualificado" (EP-002 completado)
- Disponibilidad verificada para bodas (si aplica) registrada en el lead
- Línea de negocio del lead está definida (Bodas o Corporativo)
- Plantillas de correo modelo están configuradas en el sistema (Anexo 1, Anexo 2, Anexo 3, Corporativo)
- Sistema tiene acceso a información del lead cualificado

### Postcondiciones
- Plantilla de correo modelo seleccionada automáticamente según reglas
- Selección registrada en sistema con timestamp y tipo de plantilla seleccionada
- Lead queda listo para personalización del correo (EP-003-US-002)
- Si no hay plantilla disponible, se marca error y se notifica al responsable

### Flujo principal
1. Sistema detecta automáticamente que un lead ha sido marcado como "Cualificado" (trigger desde EP-002)
2. Sistema lee información del lead cualificado: línea de negocio, disponibilidad verificada (si es Bodas), fecha de cualificación
3. Sistema evalúa línea de negocio del lead
4. Si línea de negocio es "Bodas":
   - Sistema verifica disponibilidad en fecha solicitada (ya verificada previamente)
   - Si fecha está disponible → Sistema selecciona plantilla "Anexo 1 (Disponible)"
   - Si fecha no está disponible → Sistema selecciona plantilla "Anexo 2 (No disponible)"
5. Si línea de negocio es "Corporativo":
   - Sistema selecciona plantilla "Corporativo"
6. Sistema valida que la plantilla seleccionada existe y está activa en el sistema
7. Sistema registra selección realizada: ID de lead, tipo de plantilla seleccionada, timestamp, razón de selección
8. Sistema pasa control a personalización del correo (EP-003-US-002)

### Flujos alternos y excepciones

**Flujo alterno 1: Lead sin respuesta después de X días (Anexo 3)**
- Si lead cualificado no ha respondido después de X días (configurable, ejemplo: 7 días) y no se ha enviado Anexo 3
- Sistema selecciona plantilla "Anexo 3 (Recordatorio)" independientemente de disponibilidad inicial
- Sistema registra selección de Anexo 3 con razón "Recordatorio por falta de respuesta"

**Flujo alterno 2: Lead corporativo sin plantilla específica**
- Si línea de negocio es "Corporativo" pero no existe plantilla específica de corporativo
- Sistema usa plantilla genérica de corporativo o notifica error
- Sistema registra uso de plantilla genérica o error

**Excepción 1: Plantilla seleccionada no existe**
- Si la plantilla seleccionada no existe en el sistema o está desactivada
- Sistema marca error y notifica al responsable (Fátima/Paz)
- Sistema registra error con detalles: ID de lead, plantilla esperada, timestamp
- Proceso se detiene hasta que se resuelva el problema

**Excepción 2: Lead sin línea de negocio definida**
- Si el lead cualificado no tiene línea de negocio definida
- Sistema marca error y notifica al responsable
- Sistema registra error con detalles: ID de lead, problema detectado, timestamp
- Proceso se detiene hasta que se corrija la información del lead

**Excepción 3: Lead de Bodas sin disponibilidad verificada**
- Si línea de negocio es "Bodas" pero no hay disponibilidad verificada registrada
- Sistema selecciona plantilla "Anexo 2 (No disponible)" por defecto
- Sistema registra selección con razón "Disponibilidad no verificada, usando plantilla por defecto"
- Sistema notifica al responsable para verificación manual

### Validaciones y reglas de negocio
- **Trigger automático:** Proceso se inicia automáticamente cuando lead cambia a estado "Cualificado"
- **Línea de negocio:** Debe estar definida (Bodas o Corporativo), no puede estar vacía
- **Disponibilidad para bodas:** Si línea de negocio es "Bodas", debe existir registro de disponibilidad verificada (disponible/no disponible)
- **Selección de plantilla según disponibilidad:**
  - Bodas + Disponible → Anexo 1
  - Bodas + No disponible → Anexo 2
  - Bodas + Sin respuesta X días → Anexo 3
  - Corporativo → Plantilla Corporativo
- **Validación de plantilla:** Plantilla seleccionada debe existir y estar activa en el sistema
- **Registro de selección:** Todas las selecciones deben registrarse con timestamp, tipo de plantilla y razón
- **Prevención de duplicados:** No seleccionar plantilla si ya se envió correo recientemente (configurable, ejemplo: no reenviar en menos de 24 horas)

### Criterios BDD
- **Escenario 1: Selección correcta de Anexo 1 para bodas disponible**
  - *Dado* que un lead de línea de negocio "Bodas" ha sido marcado como cualificado con disponibilidad verificada "Disponible"
  - *Cuando* el sistema detecta el cambio de estado a "Cualificado"
  - *Entonces* el sistema selecciona automáticamente la plantilla "Anexo 1 (Disponible)" y registra la selección con timestamp

- **Escenario 2: Selección correcta de Anexo 2 para bodas no disponible**
  - *Dado* que un lead de línea de negocio "Bodas" ha sido marcado como cualificado con disponibilidad verificada "No disponible"
  - *Cuando* el sistema detecta el cambio de estado a "Cualificado"
  - *Entonces* el sistema selecciona automáticamente la plantilla "Anexo 2 (No disponible)" y registra la selección con timestamp

- **Escenario 3: Selección correcta de plantilla corporativo**
  - *Dado* que un lead de línea de negocio "Corporativo" ha sido marcado como cualificado
  - *Cuando* el sistema detecta el cambio de estado a "Cualificado"
  - *Entonces* el sistema selecciona automáticamente la plantilla "Corporativo" y registra la selección con timestamp

- **Escenario 4: Selección de Anexo 3 por falta de respuesta**
  - *Dado* que un lead cualificado no ha respondido después de 7 días y no se ha enviado Anexo 3
  - *Cuando* el sistema ejecuta el proceso de selección de plantilla
  - *Entonces* el sistema selecciona automáticamente la plantilla "Anexo 3 (Recordatorio)" independientemente de disponibilidad inicial

- **Escenario 5: Error cuando plantilla no existe**
  - *Dado* que un lead cualificado requiere una plantilla específica
  - *Cuando* el sistema intenta seleccionar la plantilla pero esta no existe o está desactivada
  - *Entonces* el sistema marca error, notifica al responsable, y detiene el proceso hasta que se resuelva

- **Escenario 6: Error cuando lead no tiene línea de negocio**
  - *Dado* que un lead ha sido marcado como cualificado pero no tiene línea de negocio definida
  - *Cuando* el sistema intenta seleccionar la plantilla
  - *Entonces* el sistema marca error, notifica al responsable, y detiene el proceso hasta que se corrija la información

### Notificaciones
- **Responsable (Fátima/Paz):** Notificación automática si plantilla seleccionada no existe o está desactivada
- **Responsable (Fátima/Paz):** Notificación automática si lead no tiene línea de negocio definida
- **Sistema:** Registro de todas las selecciones realizadas para trazabilidad y análisis

### Seguridad
- **Validación de datos:** Verificación de que lead existe y está cualificado antes de procesar
- **Prevención de procesamiento duplicado:** Control de que no se procese el mismo lead múltiples veces
- **Registro de auditoría:** Todas las selecciones y errores quedan registrados para auditoría
- **Acceso a información:** Sistema solo accede a información necesaria del lead para selección

### Analítica/KPIs
- **Métricas a instrumentar:**
  - Número de selecciones automáticas realizadas por tipo de plantilla (Anexo 1, Anexo 2, Anexo 3, Corporativo)
  - Tiempo promedio de selección automática (< 30 segundos objetivo)
  - Tasa de errores en selección (plantilla no existe, datos faltantes)
  - Distribución de selecciones por línea de negocio
  - Número de Anexo 3 enviados (recordatorios)
- **Objetivo:** 100% de selecciones correctas según disponibilidad y línea de negocio

### Definition of Ready
- [ ] Plantillas de correo modelo configuradas en sistema (Anexo 1, Anexo 2, Anexo 3, Corporativo)
- [ ] Trigger automático implementado para detectar cambio de estado a "Cualificado"
- [ ] Reglas de selección definidas y validadas con stakeholders
- [ ] Configuración de tiempo para Anexo 3 definida (ejemplo: 7 días)
- [ ] Sistema de registro de selecciones implementado
- [ ] Sistema de notificaciones disponible para errores

### Definition of Done
- [ ] Selección automática de plantilla funciona correctamente según reglas definidas
- [ ] Detección automática de lead cualificado funciona correctamente
- [ ] Validación de plantillas existe y funciona correctamente
- [ ] Registro de selecciones funciona correctamente con trazabilidad completa
- [ ] Manejo de errores implementado (plantilla no existe, datos faltantes)
- [ ] Notificaciones al responsable funcionan correctamente en caso de errores
- [ ] Prevención de procesamiento duplicado implementada
- [ ] Pruebas de aceptación pasadas (todos los escenarios BDD)
- [ ] Documentación técnica actualizada
- [ ] Desplegado en entorno de producción

### Riesgos y supuestos
- **Riesgo:** Selección incorrecta de plantilla puede causar confusión al cliente
  - **Probabilidad:** Baja
  - **Impacto:** Alto
  - **Mitigación:** Validación exhaustiva de reglas, pruebas de todos los escenarios, registro de selecciones para auditoría

- **Riesgo:** Plantilla no existe o está desactivada puede detener el proceso
  - **Probabilidad:** Media
  - **Impacto:** Medio
  - **Mitigación:** Validación de existencia de plantillas antes de selección, notificación inmediata al responsable, plantillas genéricas de respaldo

- **Riesgo:** Procesamiento duplicado puede causar envíos múltiples
  - **Probabilidad:** Baja
  - **Impacto:** Medio
  - **Mitigación:** Control de procesamiento duplicado, registro de selecciones previas, validación de envíos recientes

- **Supuesto:** Lead cualificado tiene toda la información necesaria (línea de negocio, disponibilidad si aplica)
- **Supuesto:** Plantillas de correo están configuradas y activas en el sistema

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-003-respuesta-automatica-inicial.md`
- Bloque funcional: Envío automático de correos modelo personalizados
- Paso(s): Paso 1 del flujo principal (selección del correo modelo correcto según disponibilidad)
