# EP-003-US-004 — Gestión de plantillas de correo y control de envío automático

### Epic padre
EP-003 — Respuesta automática inicial a leads

### Contexto/Descripción y valor
**Como** usuario de ONGAKU,  
**quiero** crear, leer, actualizar y eliminar plantillas de correo modelo (Anexo 1, Anexo 2, Anexo 3 y corporativo) y poder activar/desactivar el envío automático para casos especiales,  
**para** mantener las plantillas actualizadas con la información más reciente, personalizar los mensajes según necesidades del negocio, y tener control sobre el proceso automático cuando sea necesario para casos especiales

### Alcance
**Incluye:**
- Gestión completa de plantillas de correo (CRUD):
  - Crear nueva plantilla de correo (Anexo 1, Anexo 2, Anexo 3, Corporativo)
  - Leer/visualizar plantillas existentes
  - Actualizar plantillas existentes (editar contenido, variables, asunto)
  - Eliminar plantillas (con validación de uso)
- Editor de plantillas con:
  - Campo de asunto del correo
  - Campo de contenido del correo (HTML/texto)
  - Variables disponibles para personalización (`{{NOMBRE}}`, `{{FECHA_BODA}}`, `{{UBICACION}}`, `{{EMPRESA}}`, `{{LINK_DOSSIER}}`)
  - Preview de plantilla con datos de ejemplo
  - Validación de variables antes de guardar
- Control de envío automático:
  - Activar/desactivar envío automático globalmente
  - Activar/desactivar envío automático para leads específicos
  - Ver estado de envío automático (activo/inactivo)
  - Razón de desactivación (registro)
- Gestión de versiones de plantillas (opcional):
  - Historial de cambios en plantillas
  - Restaurar versión anterior de plantilla
- Validación de plantillas antes de activar:
  - Verificar que plantilla tiene variables correctas
  - Verificar que plantilla está completa (asunto y contenido)

**Excluye:**
- Envío manual de correos (se gestiona en otro módulo)
- Análisis de efectividad de plantillas
- A/B testing de plantillas
- Personalización avanzada con IA

### Precondiciones
- Usuario de ONGAKU tiene permisos para gestionar plantillas de correo
- Usuario de ONGAKU está autenticado en el sistema
- Sistema tiene capacidad para almacenar plantillas de correo
- Variables de personalización están definidas y documentadas

### Postcondiciones
- Plantilla de correo creada, actualizada o eliminada según acción realizada
- Plantilla queda disponible para uso en envíos automáticos (si está activa)
- Envío automático activado o desactivado según configuración
- Cambios registrados en sistema con timestamp y usuario responsable
- Si se elimina plantilla en uso, se marca como inactiva y se notifica al responsable

### Flujo principal

#### Crear nueva plantilla
1. Usuario de ONGAKU accede a gestión de plantillas de correo
2. Usuario selecciona "Crear nueva plantilla"
3. Usuario selecciona tipo de plantilla (Anexo 1, Anexo 2, Anexo 3, Corporativo)
4. Usuario completa formulario de plantilla:
   - Nombre de la plantilla
   - Asunto del correo (puede incluir variables)
   - Contenido del correo (puede incluir variables)
5. Sistema muestra variables disponibles para insertar (`{{NOMBRE}}`, `{{FECHA_BODA}}`, etc.)
6. Usuario puede insertar variables en asunto y contenido
7. Sistema muestra preview de plantilla con datos de ejemplo
8. Usuario revisa preview y ajusta si es necesario
9. Usuario guarda plantilla
10. Sistema valida plantilla (variables correctas, contenido completo)
11. Sistema guarda plantilla en base de datos con estado "Activa"
12. Sistema registra creación con timestamp y usuario responsable
13. Plantilla queda disponible para uso en envíos automáticos

#### Leer/visualizar plantillas
1. Usuario de ONGAKU accede a gestión de plantillas de correo
2. Sistema muestra lista de plantillas existentes con información:
   - Tipo de plantilla (Anexo 1, Anexo 2, Anexo 3, Corporativo)
   - Nombre de la plantilla
   - Estado (Activa, Inactiva)
   - Fecha de última modificación
   - Usuario que modificó por última vez
3. Usuario puede filtrar por tipo de plantilla o estado
4. Usuario selecciona plantilla para ver detalles
5. Sistema muestra detalles completos de la plantilla:
   - Asunto del correo
   - Contenido del correo
   - Variables utilizadas
   - Preview con datos de ejemplo
   - Historial de cambios (si está disponible)

#### Actualizar plantilla existente
1. Usuario de ONGAKU accede a gestión de plantillas de correo
2. Usuario selecciona plantilla existente para editar
3. Sistema muestra formulario de edición con datos actuales de la plantilla
4. Usuario modifica asunto y/o contenido del correo
5. Sistema muestra preview actualizado con datos de ejemplo
6. Usuario revisa cambios y guarda
7. Sistema valida plantilla actualizada (variables correctas, contenido completo)
8. Sistema guarda cambios en base de datos
9. Sistema registra actualización con timestamp y usuario responsable
10. Si plantilla está en uso, sistema notifica que cambios afectarán envíos futuros
11. Plantilla actualizada queda disponible para uso en envíos automáticos

#### Eliminar plantilla
1. Usuario de ONGAKU accede a gestión de plantillas de correo
2. Usuario selecciona plantilla para eliminar
3. Sistema verifica si plantilla está en uso (si se ha usado recientemente)
4. Si plantilla está en uso:
   - Sistema muestra advertencia: "Esta plantilla está en uso. ¿Desea desactivarla en lugar de eliminarla?"
   - Usuario puede elegir desactivar o eliminar de todas formas
5. Si usuario confirma eliminación:
   - Sistema marca plantilla como "Eliminada" (soft delete) o la elimina permanentemente
   - Sistema registra eliminación con timestamp y usuario responsable
   - Si plantilla estaba activa, sistema notifica al responsable

#### Control de envío automático
1. Usuario de ONGAKU accede a configuración de envío automático
2. Sistema muestra estado actual de envío automático (Activo/Inactivo)
3. Usuario puede activar/desactivar envío automático globalmente:
   - Si activa: Todos los leads cualificados recibirán respuesta automática
   - Si desactiva: Ningún lead recibirá respuesta automática (requiere envío manual)
4. Usuario puede activar/desactivar envío automático para lead específico:
   - Selecciona lead específico
   - Activa/desactiva envío automático para ese lead
   - Opcionalmente ingresa razón de desactivación
5. Sistema guarda configuración de envío automático
6. Sistema registra cambio con timestamp, usuario responsable, y razón (si aplica)
7. Sistema notifica al equipo del cambio en configuración de envío automático

### Flujos alternos y excepciones

**Flujo alterno 1: Preview de plantilla con datos reales**
- Usuario puede seleccionar lead real para preview en lugar de datos de ejemplo
- Sistema muestra preview de plantilla con datos del lead seleccionado
- Usuario puede ver cómo se vería el correo para ese lead específico

**Flujo alterno 2: Duplicar plantilla existente**
- Usuario puede duplicar plantilla existente como base para nueva plantilla
- Sistema crea copia de plantilla con nombre modificado (ejemplo: "Anexo 1 - Copia")
- Usuario puede modificar plantilla duplicada y guardarla como nueva

**Flujo alterno 3: Desactivar plantilla en lugar de eliminar**
- Si plantilla está en uso, usuario puede desactivarla en lugar de eliminarla
- Sistema marca plantilla como "Inactiva" pero la mantiene en base de datos
- Plantilla desactivada no se usa en envíos automáticos pero puede reactivarse después

**Excepción 1: Plantilla con variables incorrectas**
- Si usuario guarda plantilla con variables en formato incorrecto (ejemplo: `{NOMBRE}` en lugar de `{{NOMBRE}}`)
- Sistema muestra error: "Variables deben estar en formato {{VARIABLE}}. Variables incorrectas: {NOMBRE}"
- Usuario corrige variables y reintenta guardar

**Excepción 2: Plantilla sin contenido completo**
- Si usuario intenta guardar plantilla sin asunto o sin contenido
- Sistema muestra error: "Plantilla debe tener asunto y contenido completos"
- Usuario completa campos faltantes y reintenta guardar

**Excepción 3: Intentar eliminar única plantilla activa de un tipo**
- Si usuario intenta eliminar la única plantilla activa de un tipo (ejemplo: única Anexo 1 activa)
- Sistema muestra advertencia: "Esta es la única plantilla activa de este tipo. ¿Está seguro de eliminarla?"
- Si usuario confirma, sistema permite eliminación pero notifica al responsable

**Excepción 4: Error al guardar plantilla**
- Si falla el guardado de plantilla en base de datos
- Sistema muestra error: "Error al guardar plantilla. Por favor, intente nuevamente."
- Sistema intenta guardar nuevamente automáticamente
- Si falla nuevamente, sistema notifica al equipo técnico

**Excepción 5: Usuario sin permisos**
- Si usuario intenta gestionar plantillas pero no tiene permisos
- Sistema muestra error: "No tiene permisos para gestionar plantillas de correo"
- Usuario es redirigido a vista de solo lectura o acceso denegado

### Validaciones y reglas de negocio
- **Nombre de plantilla:** Obligatorio, único por tipo, mínimo 3 caracteres, máximo 100 caracteres
- **Tipo de plantilla:** Obligatorio, selección única de lista predefinida (Anexo 1, Anexo 2, Anexo 3, Corporativo)
- **Asunto del correo:** Obligatorio, mínimo 5 caracteres, máximo 200 caracteres, puede incluir variables
- **Contenido del correo:** Obligatorio, mínimo 50 caracteres, máximo 10000 caracteres, puede incluir variables
- **Variables:** Variables deben estar en formato `{{VARIABLE}}` (doble llave), variables válidas: `{{NOMBRE}}`, `{{FECHA_BODA}}`, `{{UBICACION}}`, `{{EMPRESA}}`, `{{LINK_DOSSIER}}`
- **Estado de plantilla:** Activa, Inactiva, Eliminada
- **Validación antes de activar:** Plantilla debe tener asunto y contenido completos, variables en formato correcto
- **Prevención de eliminación:** No permitir eliminar plantilla si es la única activa de su tipo (advertencia)
- **Control de envío automático:** Envío automático puede estar activo/inactivo globalmente o por lead específico
- **Registro de cambios:** Todos los cambios en plantillas y configuración de envío automático deben registrarse con timestamp y usuario responsable

### Criterios BDD
- **Escenario 1: Crear nueva plantilla exitosamente**
  - *Dado* que un usuario de ONGAKU con permisos accede a gestión de plantillas
  - *Cuando* crea una nueva plantilla tipo "Anexo 1" con asunto y contenido completos, incluyendo variables válidas
  - *Entonces* el sistema guarda la plantilla en base de datos con estado "Activa", registra la creación con timestamp y usuario responsable, y la plantilla queda disponible para uso en envíos automáticos

- **Escenario 2: Actualizar plantilla existente**
  - *Dado* que existe una plantilla "Anexo 1" activa en el sistema
  - *Cuando* un usuario de ONGAKU modifica el contenido de la plantilla y guarda los cambios
  - *Entonces* el sistema guarda los cambios en base de datos, registra la actualización con timestamp y usuario responsable, y notifica que cambios afectarán envíos futuros

- **Escenario 3: Error al crear plantilla con variables incorrectas**
  - *Dado* que un usuario de ONGAKU está creando una nueva plantilla
  - *Cuando* ingresa variables en formato incorrecto (ejemplo: `{NOMBRE}` en lugar de `{{NOMBRE}}`)
  - *Entonces* el sistema muestra error "Variables deben estar en formato {{VARIABLE}}. Variables incorrectas: {NOMBRE}" y no permite guardar la plantilla

- **Escenario 4: Error al crear plantilla sin contenido completo**
  - *Dado* que un usuario de ONGAKU está creando una nueva plantilla
  - *Cuando* intenta guardar la plantilla sin asunto o sin contenido
  - *Entonces* el sistema muestra error "Plantilla debe tener asunto y contenido completos" y no permite guardar la plantilla

- **Escenario 5: Desactivar envío automático globalmente**
  - *Dado* que el envío automático está activo globalmente
  - *Cuando* un usuario de ONGAKU desactiva el envío automático globalmente
  - *Entonces* el sistema guarda la configuración, registra el cambio con timestamp y usuario responsable, y ningún lead cualificado recibirá respuesta automática hasta que se reactive

- **Escenario 6: Desactivar envío automático para lead específico**
  - *Dado* que existe un lead cualificado y el envío automático está activo globalmente
  - *Cuando* un usuario de ONGAKU desactiva el envío automático para ese lead específico e ingresa razón "Caso especial"
  - *Entonces* el sistema guarda la configuración para ese lead, registra el cambio con razón, y ese lead específico no recibirá respuesta automática aunque el envío automático global esté activo

- **Escenario 7: Intentar eliminar única plantilla activa**
  - *Dado* que existe una única plantilla "Anexo 1" activa en el sistema
  - *Cuando* un usuario de ONGAKU intenta eliminar esa plantilla
  - *Entonces* el sistema muestra advertencia "Esta es la única plantilla activa de este tipo. ¿Está seguro de eliminarla?" y requiere confirmación antes de permitir eliminación

### Notificaciones
- **Usuario que gestiona plantilla:** Confirmación de creación/actualización/eliminación exitosa de plantilla
- **Equipo de ONGAKU:** Notificación cuando se desactiva envío automático globalmente
- **Responsable (Fátima/Paz):** Notificación cuando se elimina plantilla en uso o única plantilla activa de un tipo
- **Sistema:** Registro de todos los cambios en plantillas y configuración de envío automático para auditoría

### Seguridad
- **Permisos:** Solo usuarios con permisos específicos pueden gestionar plantillas de correo
- **Validación de entrada:** Sanitización de contenido de plantillas para prevenir inyección de código
- **Auditoría:** Todos los cambios en plantillas y configuración quedan registrados con usuario responsable y timestamp
- **Prevención de eliminación accidental:** Confirmación requerida antes de eliminar plantillas, especialmente si están en uso
- **Control de acceso:** Validación de permisos antes de permitir cualquier acción de gestión

### Analítica/KPIs
- **Métricas a instrumentar:**
  - Número de plantillas creadas por tipo
  - Frecuencia de actualización de plantillas
  - Número de veces que se desactiva envío automático (global y por lead)
  - Razones más comunes de desactivación de envío automático
  - Tasa de uso de cada plantilla (número de envíos por plantilla)
  - Tiempo promedio entre actualizaciones de plantillas
- **Objetivo:** Plantillas actualizadas y relevantes, control efectivo sobre envío automático

### Definition of Ready
- [ ] Sistema de gestión de plantillas implementado (CRUD)
- [ ] Editor de plantillas con preview implementado
- [ ] Variables de personalización definidas y documentadas
- [ ] Sistema de permisos implementado para gestión de plantillas
- [ ] Sistema de control de envío automático implementado
- [ ] Validación de plantillas implementada
- [ ] Sistema de registro de cambios implementado

### Definition of Done
- [ ] Gestión completa de plantillas funciona correctamente (crear, leer, actualizar, eliminar)
- [ ] Editor de plantillas funciona correctamente con preview y variables
- [ ] Validación de plantillas funciona correctamente (variables, contenido completo)
- [ ] Control de envío automático funciona correctamente (activar/desactivar global y por lead)
- [ ] Manejo de errores implementado (variables incorrectas, contenido incompleto, permisos)
- [ ] Prevención de eliminación accidental implementada (confirmaciones, advertencias)
- [ ] Registro de cambios funciona correctamente con auditoría completa
- [ ] Notificaciones funcionan correctamente (confirmaciones, advertencias, cambios importantes)
- [ ] Pruebas de aceptación pasadas (todos los escenarios BDD)
- [ ] Documentación técnica actualizada
- [ ] Desplegado en entorno de producción

### Riesgos y supuestos
- **Riesgo:** Eliminación accidental de plantilla puede causar interrupción en envíos automáticos
  - **Probabilidad:** Baja
  - **Impacto:** Alto
  - **Mitigación:** Confirmaciones antes de eliminar, advertencias si plantilla está en uso, soft delete en lugar de eliminación permanente, historial de cambios

- **Riesgo:** Plantilla con errores puede causar envíos incorrectos
  - **Probabilidad:** Media
  - **Impacto:** Alto
  - **Mitigación:** Validación exhaustiva antes de guardar, preview con datos de ejemplo, pruebas antes de activar, posibilidad de desactivar rápidamente

- **Riesgo:** Desactivación accidental de envío automático puede causar falta de respuestas
  - **Probabilidad:** Baja
  - **Impacto:** Alto
  - **Mitigación:** Confirmaciones antes de desactivar, notificaciones al equipo, fácil reactivación, monitoreo de estado de envío automático

- **Supuesto:** Usuarios de ONGAKU tienen conocimiento de las variables disponibles y formato correcto
- **Supuesto:** Plantillas se actualizan periódicamente según necesidades del negocio

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-003-respuesta-automatica-inicial.md`
- Bloque funcional: Envío automático de correos modelo personalizados
- Paso(s): Gestión de plantillas de correo modelo y control de envío automático (requisito transversal para todo el proceso)
