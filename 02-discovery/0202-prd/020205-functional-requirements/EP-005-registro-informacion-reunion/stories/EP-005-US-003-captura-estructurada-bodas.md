# EP-005-US-003 — Captura estructurada durante reunión — Bodas

### Epic padre
EP-005 — Registro de información durante reunión

### Contexto/Descripción y valor
**Como** Paz,  
**quiero** registrar durante la reunión de bodas los servicios de interés, provincia, extras, características especiales y número de profesionales recomendados en un formulario estructurado,  
**para** que la información quede lista para la generación automática de presupuesto de bodas sin depender de memoria posterior.

### Alcance
**Incluye:**
- Formulario estructurado específico para reuniones de bodas con secciones:
  - Servicios de interés (fotografía 1/2 fotógrafos, vídeo, dron — selección múltiple)
  - Provincia/ubicación de la boda (dropdown o búsqueda)
  - Extras (transporte, tiempo extra, etc. — selección múltiple u opciones predefinidas)
  - Características especiales de la boda (campo de texto libre)
  - Preferencias y acuerdos (campo de texto libre)
  - Número de profesionales recomendados (campo numérico o selección)
  - Notas adicionales (campo de texto libre)
- Selección rápida mediante checkboxes, dropdowns y campos predefinidos
- Guardado automático mientras se completa
- Diseño optimizado para uso rápido sin interrumpir la conversación

**Excluye:**
- Validación de campos críticos (EP-005-US-004)
- Marcado de reunión como completada (EP-005-US-004)
- Generación de presupuesto (EP-006)

### Precondiciones
- Formulario de reunión abierto y vinculado al lead (EP-005-US-001)
- Línea de negocio del lead es "Bodas"
- Catálogo de servicios/extras de bodas disponible en el sistema
- Paz tiene permisos para registrar información de reuniones de bodas

### Postcondiciones
- Información de la reunión de bodas capturada en formato estructurado
- Datos guardados en borrador (si no se completa) o en registro definitivo
- Información lista para validación y generación de presupuesto

### Flujo principal
1. Paz tiene el formulario de registro abierto durante la reunión de bodas
2. Durante la conversación, Paz registra información en tiempo real:
   - **Servicios de interés:** Selecciona fotografía (1 o 2 fotógrafos), vídeo, dron según lo discutido
   - **Provincia:** Selecciona provincia/ubicación de la boda
   - **Extras:** Selecciona transporte, tiempo extra u otros extras del catálogo
   - **Características especiales:** Toma notas de características especiales de la boda
   - **Preferencias y acuerdos:** Registra preferencias y acuerdos alcanzados
   - **Número de profesionales recomendados:** Registra el número recomendado
   - **Notas adicionales:** Captura cualquier información adicional relevante
3. Sistema guarda automáticamente los cambios cada X segundos
4. Paz puede completar el formulario durante o al finalizar la reunión
5. Al finalizar, Paz revisa la información capturada y completa campos faltantes si es necesario

### Flujos alternos y excepciones

**Flujo alterno 1: Servicio no estándar mencionado**
- Si la pareja menciona un servicio que no está en el catálogo:
- Paz puede añadirlo como nota libre en "Características especiales" o "Notas adicionales"
- Sistema registra el servicio no estándar para posible incorporación futura

**Flujo alterno 2: Provincia no encontrada**
- Si la ubicación de la boda no está en la lista de provincias:
- Paz puede seleccionar "Otra" y escribir la ubicación en texto libre
- Sistema registra la ubicación para posible incorporación futura al catálogo

**Excepción 1: Error al guardar información**
- Si falla el guardado automático:
- Sistema muestra advertencia pero permite continuar capturando
- Sistema intenta guardar nuevamente en segundo plano
- Si persiste el error, notifica a Paz para guardar manualmente

**Excepción 2: Formulario cerrado accidentalmente**
- Si Paz cierra el formulario sin completar:
- Sistema mantiene el borrador guardado
- Al reabrir, carga el borrador con la información capturada

### Validaciones y reglas de negocio
- Campo "Servicios de interés" debe permitir selección múltiple (fotografía, vídeo, dron)
- Campo "Provincia" es obligatorio para generación de presupuesto (validado en EP-005-US-004)
- Campo "Número de profesionales recomendados" acepta valores numéricos
- Todos los campos de texto tienen límites de caracteres razonables
- Guardado automático no debe interrumpir la captura

### Criterios BDD
- **Escenario 1: Captura exitosa de información de bodas**
  - *Dado* que Paz tiene el formulario de registro abierto durante una reunión de bodas
  - *Cuando* registra servicios de interés, provincia, extras, características especiales y número de profesionales recomendados
  - *Entonces* el sistema guarda toda la información de forma estructurada y queda lista para generación de presupuesto

- **Escenario 2: Registro de provincia "Otra"**
  - *Dado* que la ubicación de la boda no está en la lista de provincias
  - *Cuando* Paz selecciona "Otra" y escribe la ubicación en texto libre
  - *Entonces* el sistema guarda la ubicación como texto libre y no bloquea el registro

- **Escenario 3 (negativo): Error al guardar información**
  - *Dado* que Paz está capturando información durante la reunión
  - *Cuando* falla el guardado automático
  - *Entonces* el sistema muestra advertencia, permite continuar capturando e intenta guardar nuevamente en segundo plano

### Notificaciones
- **Paz:** Advertencia visual si falla el guardado automático
- No se generan notificaciones externas durante la captura

### Seguridad
- Validación de permisos antes de permitir captura
- Sanitización de datos de entrada para prevenir inyección
- Protección de datos sensibles del cliente

### Analítica/KPIs
- Tiempo promedio de captura durante reunión de bodas
- Número de servicios seleccionados por reunión
- Distribución de provincias/ubicaciones
- Frecuencia de uso de extras (transporte, tiempo extra)

### Definition of Ready
- [ ] Catálogo de servicios/extras de bodas definido y disponible
- [ ] Lista de provincias/ubicaciones definida
- [ ] Estructura del formulario de bodas definida
- [ ] Sistema de guardado automático implementado
- [ ] Diseño de UI optimizado para uso rápido aprobado

### Definition of Done
- [ ] Formulario de bodas permite capturar todas las secciones requeridas
- [ ] Selección de servicios (fotografía, vídeo, dron) funciona correctamente
- [ ] Selección de provincia y extras funciona correctamente
- [ ] Guardado automático funciona sin interrumpir la captura
- [ ] Manejo de ubicaciones no estándar implementado
- [ ] Manejo de errores de guardado implementado
- [ ] Pruebas de aceptación pasadas (todos los escenarios BDD)
- [ ] Diseño responsive verificado

### Riesgos y supuestos
- **Riesgo:** Captura interrumpe la conversación con la pareja
  - **Probabilidad:** Media | **Impacto:** Medio
  - **Mitigación:** Diseño de formulario optimizado para uso rápido, campos predefinidos, guardado automático
- **Supuesto:** Paz puede usar dispositivo durante la reunión sin interrumpir la conversación
- **Supuesto:** Catálogo de servicios de bodas está actualizado

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-005-registro-informacion-reunion.md`
- Bloque funcional: Captura estructurada en tiempo real durante reunión
- Paso(s): Pasos 2-3b del flujo principal (registro de servicios, provincia, extras y características durante reunión de bodas)
