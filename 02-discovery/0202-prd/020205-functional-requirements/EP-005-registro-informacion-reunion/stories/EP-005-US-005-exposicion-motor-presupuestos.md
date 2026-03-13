# EP-005-US-005 — Exposición de la información de reunión al motor de presupuestos

### Epic padre
EP-005 — Registro de información durante reunión

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** exponer la información estructurada de la reunión al motor de generación automática de presupuestos,  
**para** que al finalizar la reunión el presupuesto pueda generarse inmediatamente sin pasos manuales intermedios.

### Alcance
**Incluye:**
- Detección automática cuando una reunión pasa a estado "Completada"
- Transformación de la información estructurada del registro de reunión al formato esperado por el motor de presupuestos (EP-006)
- Exposición de datos mediante API, evento o cola según arquitectura:
  - Lead asociado (ID, nombre, email, teléfono, línea de negocio)
  - Reunión asociada (ID, fecha, hora)
  - Información capturada (servicios de interés, presupuesto estimado, provincia, extras, notas, etc.)
- Registro de que la información ha sido expuesta al motor de presupuestos
- Notificación opcional al responsable (Fátima/Paz) de que la reunión está lista para presupuesto

**Excluye:**
- Generación real del presupuesto (EP-006)
- Envío del presupuesto al cliente (EP-006/EP-007)
- Validación de campos críticos (EP-005-US-004)

### Precondiciones
- Reunión está en estado "Completada" (EP-005-US-004)
- Registro de reunión tiene información estructurada validada
- Motor de presupuestos (EP-006) está disponible y espera datos en el formato definido
- Sistema tiene acceso a los datos del lead y de la reunión

### Postcondiciones
- Información estructurada de la reunión está disponible para el motor de presupuestos
- Sistema ha registrado que la información fue expuesta (trazabilidad)
- Motor de presupuestos puede generar presupuesto inmediatamente (EP-006)
- Opcionalmente, responsable ha sido notificado de que la reunión está lista para presupuesto

### Flujo principal
1. Sistema detecta que una reunión ha cambiado a estado "Completada" (trigger desde EP-005-US-004)
2. Sistema lee el registro de reunión asociado:
   - ID de reunión, ID de lead
   - Información capturada según línea de negocio (Corporativo o Bodas)
3. Sistema lee datos del lead asociado (nombre, email, teléfono, línea de negocio)
4. Sistema construye payload en el formato esperado por el motor de presupuestos:
   - Identificadores (lead_id, reunion_id)
   - Datos del lead
   - Servicios de interés, presupuesto estimado (Corporativo)
   - Servicios de interés, provincia, extras, número de profesionales (Bodas)
   - Notas y campos de texto libre
5. Sistema expone la información al motor de presupuestos:
   - Opción A: Llamada a API del motor de presupuestos
   - Opción B: Publicación de evento en cola/bus
   - Opción C: Escritura en tabla/compartida que el motor consume
6. Sistema registra que la información fue expuesta:
   - Timestamp, reunion_id, estado "Exponiendo" / "Exposición exitosa" / "Error"
7. Si está configurado, sistema notifica al responsable (Fátima/Paz) de que la reunión está lista para presupuesto
8. Proceso completado; motor de presupuestos puede proceder con generación (EP-006)

### Flujos alternos y excepciones

**Flujo alterno 1: Motor de presupuestos no disponible**
- Si el motor de presupuestos no está disponible en el momento de la exposición:
- Sistema reintenta N veces con backoff
- Si tras reintentos sigue fallando, marca estado "Exposición pendiente" y notifica al equipo
- Proceso de exposición se puede ejecutar manualmente o en siguiente ciclo

**Flujo alterno 2: Exposición asíncrona**
- Sistema publica evento o escribe en cola sin esperar confirmación inmediata del motor
- Motor de presupuestos consume cuando está listo
- Sistema registra "Exposición enviada" y el motor registra "Recibido" cuando procesa

**Excepción 1: Datos incompletos o formato incorrecto**
- Si la información estructurada no cumple el formato esperado por el motor:
- Sistema registra error con detalles (campos faltantes, formato incorrecto)
- Sistema notifica al equipo técnico y/o al responsable
- No se reintenta automáticamente hasta corregir datos o formato

**Excepción 2: Lead o reunión no encontrados**
- Si el lead o la reunión asociada no existen en el momento de la exposición:
- Sistema registra error y notifica al equipo
- Proceso se detiene; requiere investigación manual

**Excepción 3: Error de red o timeout**
- Si falla la comunicación con el motor de presupuestos (red, timeout):
- Sistema reintenta según política
- Si persiste el error, marca "Exposición fallida" y notifica al equipo

### Validaciones y reglas de negocio
- Solo se expone información de reuniones en estado "Completada"
- Payload debe cumplir el contrato definido entre EP-005 y EP-006 (formato, campos obligatorios)
- Cada reunión completada debe exponerse una única vez (idempotencia si el motor lo requiere)
- Registro de exposición debe permitir trazabilidad (qué se envió, cuándo, resultado)
- Reintentos deben tener límite y backoff para no saturar el motor

### Criterios BDD
- **Escenario 1: Exposición exitosa al motor de presupuestos**
  - *Dado* que una reunión ha sido marcada como "Completada" con información estructurada válida
  - *Cuando* el sistema ejecuta el proceso de exposición al motor de presupuestos
  - *Entonces* el sistema construye el payload correcto, lo envía al motor, registra "Exposición exitosa" y el motor puede generar el presupuesto

- **Escenario 2: Reintento ante fallo temporal**
  - *Dado* que una reunión ha sido marcada como "Completada" y el motor de presupuestos no está disponible en el primer intento
  - *Cuando* el sistema intenta exponer la información
  - *Entonces* el sistema reintenta según política; si el motor está disponible en un reintento, la exposición se completa y se registra como exitosa

- **Escenario 3 (negativo): Error por datos incompletos**
  - *Dado* que la información estructurada de la reunión no cumple el formato esperado por el motor
  - *Cuando* el sistema intenta exponer la información
  - *Entonces* el sistema registra error con detalles, no reintenta automáticamente y notifica al equipo

### Notificaciones
- **Responsable (Fátima/Paz):** Notificación opcional de que la reunión está lista para presupuesto (si está configurado)
- **Equipo técnico:** Notificación si exposición falla tras reintentos o por datos incorrectos
- **Sistema:** Registro de todas las exposiciones (éxito/fallo) para trazabilidad

### Seguridad
- Comunicación con motor de presupuestos debe ser segura (HTTPS, autenticación si aplica)
- No exponer datos sensibles innecesarios al motor; solo los requeridos para presupuesto
- Registro de auditoría de exposiciones para cumplimiento

### Analítica/KPIs
- Tasa de exposición exitosa al motor de presupuestos
- Tiempo promedio desde "Completada" hasta exposición exitosa
- Número de reintentos por exposición
- Tasa de errores por formato incorrecto o datos incompletos

### Definition of Ready
- [ ] Contrato de integración con motor de presupuestos (EP-006) definido (formato, API/evento/cola)
- [ ] Definición de payload (campos obligatorios, formato) documentada
- [ ] Motor de presupuestos (o mock) disponible para pruebas
- [ ] Política de reintentos y backoff definida

### Definition of Done
- [ ] Detección automática de reunión "Completada" funciona correctamente
- [ ] Construcción de payload según contrato funciona correctamente
- [ ] Exposición al motor de presupuestos funciona (API/evento/cola)
- [ ] Registro de exposición y trazabilidad funciona correctamente
- [ ] Reintentos ante fallo temporal implementados según política
- [ ] Manejo de errores implementado (datos incorrectos, motor no disponible)
- [ ] Notificación al responsable (si aplica) funciona correctamente
- [ ] Pruebas de aceptación pasadas (todos los escenarios BDD)
- [ ] Pruebas de integración con motor de presupuestos (o mock) pasadas

### Riesgos y supuestos
- **Riesgo:** Cambio de contrato entre EP-005 y EP-006 rompe la integración
  - **Probabilidad:** Media | **Impacto:** Alto
  - **Mitigación:** Contrato documentado, versionado de API/eventos, pruebas de integración
- **Supuesto:** El motor de presupuestos (EP-006) está diseñado para consumir la información en el formato expuesto
- **Supuesto:** Una reunión completada se expone una vez; el motor es responsable de no duplicar presupuestos

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-005-registro-informacion-reunion.md`
- Bloque funcional: Captura estructurada en tiempo real durante reunión
- Paso(s): Paso 6 del flujo principal (información queda disponible para generación automática de presupuesto — TO-BE-006)
