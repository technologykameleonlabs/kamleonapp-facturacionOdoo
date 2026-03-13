# EP-003-US-002 — Personalización automática de correos con datos del lead y selección de dossier

### Epic padre
EP-003 — Respuesta automática inicial a leads

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** personalizar automáticamente el correo modelo seleccionado con datos del lead (nombre, fecha boda, ubicación) y seleccionar el link al dossier correcto según ubicación,  
**para** que el cliente reciba información relevante y personalizada que mejore su experiencia y aumente la probabilidad de respuesta positiva

### Alcance
**Incluye:**
- Lectura de datos del lead cualificado necesarios para personalización (nombre, fecha boda, ubicación, empresa, etc.)
- Reemplazo de variables en plantilla de correo con datos del lead:
  - `{{NOMBRE}}` → Nombre del cliente/novios
  - `{{FECHA_BODA}}` → Fecha de boda (si aplica)
  - `{{UBICACION}}` → Ubicación del evento/cliente
  - `{{EMPRESA}}` → Empresa (si es corporativo)
  - `{{LINK_DOSSIER}}` → Link al dossier según ubicación
- Selección automática del link al dossier correcto según ubicación del cliente
- Validación de datos antes de personalizar (datos críticos presentes)
- Manejo de datos faltantes (usar valores por defecto o genéricos)
- Generación del correo personalizado listo para envío

**Excluye:**
- Selección de plantilla (EP-003-US-001)
- Envío del correo (EP-003-US-003)
- Gestión de plantillas (EP-003-US-004)
- Gestión de dossiers (se asume que existen y están disponibles)

### Precondiciones
- Plantilla de correo modelo ya seleccionada (EP-003-US-001 completado)
- Lead cualificado tiene datos disponibles (nombre mínimo requerido)
- Sistema tiene acceso a información del lead cualificado
- Base de datos de dossiers por ubicación disponible
- Plantilla contiene variables que pueden ser reemplazadas

### Postcondiciones
- Correo personalizado generado con todos los datos del lead insertados
- Link al dossier correcto seleccionado e insertado en el correo
- Correo listo para envío (EP-003-US-003)
- Si faltan datos críticos, se usa plantilla genérica y se notifica al responsable

### Flujo principal
1. Sistema recibe plantilla de correo seleccionada (desde EP-003-US-001) e ID del lead cualificado
2. Sistema lee datos del lead cualificado: nombre, email, fecha boda (si aplica), ubicación, empresa (si aplica), línea de negocio
3. Sistema valida que datos críticos estén presentes (nombre mínimo requerido)
4. Sistema identifica variables en plantilla que necesitan reemplazo: `{{NOMBRE}}`, `{{FECHA_BODA}}`, `{{UBICACION}}`, `{{EMPRESA}}`, `{{LINK_DOSSIER}}`
5. Sistema reemplaza variables con datos del lead:
   - `{{NOMBRE}}` → Nombre del cliente/novios (si falta, usa "Estimado/a cliente")
   - `{{FECHA_BODA}}` → Fecha de boda formateada (si aplica y está disponible, si falta se omite o usa texto genérico)
   - `{{UBICACION}}` → Ubicación del evento/cliente (si falta, usa texto genérico o se omite)
   - `{{EMPRESA}}` → Empresa (si es corporativo y está disponible, si falta se omite)
6. Sistema consulta base de datos de dossiers por ubicación
7. Sistema selecciona link al dossier correcto según ubicación del cliente:
   - Si existe dossier específico para la ubicación → usa ese link
   - Si no existe dossier específico → usa dossier genérico
8. Sistema reemplaza variable `{{LINK_DOSSIER}}` con el link seleccionado
9. Sistema valida que el correo personalizado está completo (todas las variables críticas reemplazadas)
10. Sistema genera correo personalizado final listo para envío
11. Sistema pasa control a envío del correo (EP-003-US-003)

### Flujos alternos y excepciones

**Flujo alterno 1: Datos faltantes no críticos**
- Si faltan datos no críticos (fecha boda, ubicación, empresa) pero nombre está presente
- Sistema personaliza con datos disponibles y omite variables faltantes o usa texto genérico
- Sistema genera correo personalizado con datos disponibles
- Sistema registra datos faltantes para referencia

**Flujo alterno 2: Ubicación sin dossier específico**
- Si ubicación del cliente no tiene dossier específico disponible
- Sistema usa dossier genérico como respaldo
- Sistema registra uso de dossier genérico con razón "No existe dossier específico para ubicación"
- Sistema notifica al responsable para posible creación de dossier específico

**Flujo alterno 3: Múltiples ubicaciones posibles**
- Si cliente tiene múltiples ubicaciones posibles (ejemplo: boda en ciudad A pero vive en ciudad B)
- Sistema usa ubicación del evento (si está disponible) o ubicación principal del cliente
- Sistema registra selección de ubicación utilizada

**Excepción 1: Datos críticos faltantes**
- Si falta nombre del cliente (dato crítico mínimo)
- Sistema marca error y notifica al responsable
- Sistema registra error con detalles: ID de lead, datos faltantes, timestamp
- Sistema usa plantilla genérica sin personalización o detiene proceso hasta corrección

**Excepción 2: Plantilla con variables no reconocidas**
- Si plantilla contiene variables no reconocidas o con formato incorrecto
- Sistema reemplaza variables reconocidas y deja variables no reconocidas como están (o las elimina)
- Sistema registra advertencia con variables no reconocidas
- Sistema notifica al responsable para revisión de plantilla

**Excepción 3: Error al consultar dossiers**
- Si falla la consulta a base de datos de dossiers
- Sistema usa dossier genérico como respaldo
- Sistema registra error y notifica al responsable
- Proceso continúa con dossier genérico

**Excepción 4: Link de dossier inválido**
- Si el link del dossier seleccionado está roto o inválido
- Sistema valida link antes de insertar
- Si link es inválido, sistema usa dossier genérico y notifica al responsable
- Sistema registra error con detalles del link inválido

### Validaciones y reglas de negocio
- **Datos críticos:** Nombre del cliente es mínimo requerido para personalización básica
- **Reemplazo de variables:** Todas las variables en formato `{{VARIABLE}}` deben ser reemplazadas con datos del lead o valores por defecto
- **Formato de fecha:** Fecha de boda debe formatearse según estándar (ejemplo: "15 de junio de 2025")
- **Selección de dossier:** Prioridad: dossier específico por ubicación > dossier genérico
- **Validación de links:** Links de dossiers deben ser válidos y accesibles antes de insertar
- **Manejo de datos faltantes:** Si falta dato no crítico, usar texto genérico o omitir variable; si falta dato crítico, usar plantilla genérica o detener proceso
- **Personalización completa:** Correo personalizado debe tener todas las variables críticas reemplazadas antes de envío
- **Registro de personalización:** Todas las personalizaciones deben registrarse con datos utilizados y variables reemplazadas

### Criterios BDD
- **Escenario 1: Personalización exitosa con todos los datos disponibles**
  - *Dado* que un lead cualificado tiene todos los datos disponibles (nombre, fecha boda, ubicación) y se ha seleccionado plantilla Anexo 1
  - *Cuando* el sistema personaliza el correo con datos del lead
  - *Entonces* el sistema reemplaza todas las variables (`{{NOMBRE}}`, `{{FECHA_BODA}}`, `{{UBICACION}}`, `{{LINK_DOSSIER}}`) con datos del lead y genera correo personalizado completo

- **Escenario 2: Personalización con datos faltantes no críticos**
  - *Dado* que un lead cualificado tiene nombre pero falta fecha de boda y ubicación
  - *Cuando* el sistema personaliza el correo con datos disponibles
  - *Entonces* el sistema reemplaza `{{NOMBRE}}` con el nombre del cliente, omite o usa texto genérico para variables faltantes, y genera correo personalizado con datos disponibles

- **Escenario 3: Selección correcta de dossier según ubicación**
  - *Dado* que un lead cualificado tiene ubicación "Madrid" y existe dossier específico para Madrid
  - *Cuando* el sistema selecciona el link al dossier
  - *Entonces* el sistema selecciona el dossier específico de Madrid y reemplaza `{{LINK_DOSSIER}}` con ese link

- **Escenario 4: Uso de dossier genérico cuando no hay específico**
  - *Dado* que un lead cualificado tiene ubicación "Ciudad pequeña" y no existe dossier específico para esa ubicación
  - *Cuando* el sistema selecciona el link al dossier
  - *Entonces* el sistema selecciona el dossier genérico y reemplaza `{{LINK_DOSSIER}}` con ese link, y registra uso de dossier genérico

- **Escenario 5: Error cuando falta dato crítico (nombre)**
  - *Dado* que un lead cualificado no tiene nombre registrado
  - *Cuando* el sistema intenta personalizar el correo
  - *Entonces* el sistema marca error, notifica al responsable, y usa plantilla genérica sin personalización o detiene proceso

- **Escenario 6: Manejo de variables no reconocidas en plantilla**
  - *Dado* que una plantilla contiene variable `{{VARIABLE_DESCONOCIDA}}` que no está definida
  - *Cuando* el sistema personaliza el correo
  - *Entonces* el sistema reemplaza variables reconocidas, elimina o deja como está la variable no reconocida, y registra advertencia para revisión

### Notificaciones
- **Responsable (Fátima/Paz):** Notificación automática si faltan datos críticos para personalización
- **Responsable (Fátima/Paz):** Notificación automática si se usa dossier genérico por falta de específico
- **Responsable (Fátima/Paz):** Notificación automática si hay variables no reconocidas en plantilla
- **Sistema:** Registro de todas las personalizaciones realizadas con datos utilizados

### Seguridad
- **Sanitización de datos:** Todos los datos del lead deben ser sanitizados antes de insertar en correo (prevenir XSS)
- **Validación de links:** Links de dossiers deben ser validados antes de insertar (prevenir links maliciosos)
- **Escape de caracteres especiales:** Caracteres especiales en datos del lead deben ser escapados correctamente para HTML/email
- **Privacidad:** No incluir información sensible innecesaria en correo personalizado

### Analítica/KPIs
- **Métricas a instrumentar:**
  - Tasa de personalización exitosa (con todos los datos disponibles)
  - Tasa de uso de valores por defecto o genéricos (datos faltantes)
  - Tasa de uso de dossier genérico vs específico
  - Tiempo promedio de personalización (< 30 segundos objetivo)
  - Número de errores en personalización (datos críticos faltantes, variables no reconocidas)
  - Distribución de datos faltantes por tipo
- **Objetivo:** 95% de personalizaciones exitosas con datos completos

### Definition of Ready
- [ ] Variables de plantilla definidas y documentadas (`{{NOMBRE}}`, `{{FECHA_BODA}}`, etc.)
- [ ] Base de datos de dossiers por ubicación disponible
- [ ] Dossier genérico disponible como respaldo
- [ ] Formato de fecha definido (ejemplo: "15 de junio de 2025")
- [ ] Textos genéricos definidos para datos faltantes
- [ ] Sistema de validación de links implementado
- [ ] Sistema de sanitización de datos implementado

### Definition of Done
- [ ] Personalización automática funciona correctamente con todos los datos disponibles
- [ ] Reemplazo de variables funciona correctamente según formato definido
- [ ] Selección de dossier según ubicación funciona correctamente
- [ ] Manejo de datos faltantes funciona correctamente (valores por defecto o genéricos)
- [ ] Validación de datos críticos funciona correctamente
- [ ] Manejo de errores implementado (datos críticos faltantes, variables no reconocidas, links inválidos)
- [ ] Sanitización de datos implementada correctamente
- [ ] Registro de personalizaciones funciona correctamente
- [ ] Notificaciones al responsable funcionan correctamente en caso de errores
- [ ] Pruebas de aceptación pasadas (todos los escenarios BDD)
- [ ] Documentación técnica actualizada
- [ ] Desplegado en entorno de producción

### Riesgos y supuestos
- **Riesgo:** Personalización incorrecta puede causar confusión o mala experiencia al cliente
  - **Probabilidad:** Baja
  - **Impacto:** Alto
  - **Mitigación:** Validación exhaustiva de datos, pruebas de todos los escenarios, sanitización de datos, revisión de correos personalizados

- **Riesgo:** Datos faltantes pueden reducir efectividad del correo personalizado
  - **Probabilidad:** Media
  - **Impacto:** Medio
  - **Mitigación:** Validación de datos en etapas anteriores (EP-001, EP-002), uso de valores genéricos cuando sea apropiado, notificación al responsable para completar datos

- **Riesgo:** Link de dossier inválido puede causar frustración al cliente
  - **Probabilidad:** Baja
  - **Impacto:** Medio
  - **Mitigación:** Validación de links antes de insertar, uso de dossier genérico como respaldo, monitoreo de links

- **Supuesto:** Datos del lead están disponibles y correctamente formateados
- **Supuesto:** Base de datos de dossiers está actualizada y accesible
- **Supuesto:** Plantillas contienen variables en formato correcto

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-003-respuesta-automatica-inicial.md`
- Bloque funcional: Envío automático de correos modelo personalizados
- Paso(s): Pasos 2-3 del flujo principal (personalización del correo con datos del lead y selección del link al dossier según ubicación)
