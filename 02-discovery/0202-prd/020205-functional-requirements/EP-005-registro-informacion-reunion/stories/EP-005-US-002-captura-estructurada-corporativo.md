# EP-005-US-002 — Captura estructurada durante reunión — Corporativo

### Epic padre
EP-005 — Registro de información durante reunión

### Contexto/Descripción y valor
**Como** Fátima,  
**quiero** registrar durante la reunión corporativa las necesidades, servicios de interés, presupuesto estimado y notas clave en un formulario estructurado,  
**para** que la información quede lista para la generación automática de presupuesto corporativo sin depender de memoria posterior.

### Alcance
**Incluye:**
- Formulario estructurado específico para reuniones corporativas con secciones:
  - Necesidades del cliente (campo de texto libre o selección de opciones predefinidas)
  - Servicios de interés (selección múltiple de packs y servicios adicionales)
  - Presupuesto estimado mencionado por el cliente (campo numérico opcional)
  - Requerimientos especiales (campo de texto libre)
  - Referencias visuales mencionadas (campo de texto o URLs)
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
- Línea de negocio del lead es "Corporativo"
- Catálogo de servicios/packs corporativos disponible en el sistema
- Fátima tiene permisos para registrar información de reuniones corporativas

### Postcondiciones
- Información de la reunión corporativa capturada en formato estructurado
- Datos guardados en borrador (si no se completa) o en registro definitivo
- Información lista para validación y generación de presupuesto

### Flujo principal
1. Fátima tiene el formulario de registro abierto durante la reunión corporativa
2. Durante la conversación, Fátima registra información en tiempo real:
   - **Necesidades del cliente:** Escribe o selecciona las necesidades mencionadas
   - **Servicios de interés:** Selecciona packs/servicios de interés del catálogo disponible
   - **Presupuesto estimado:** Si el cliente menciona presupuesto, lo registra (opcional)
   - **Requerimientos especiales:** Toma notas de requerimientos específicos
   - **Referencias visuales:** Registra URLs o descripciones de referencias mencionadas
   - **Notas adicionales:** Captura cualquier información adicional relevante
3. Sistema guarda automáticamente los cambios cada X segundos
4. Fátima puede completar el formulario durante o al finalizar la reunión
5. Al finalizar, Fátima revisa la información capturada y completa campos faltantes si es necesario

### Flujos alternos y excepciones

**Flujo alterno 1: Servicio no estándar mencionado**
- Si el cliente menciona un servicio que no está en el catálogo:
- Fátima puede añadirlo como nota libre en "Requerimientos especiales"
- Sistema registra el servicio no estándar para posible incorporación futura al catálogo

**Flujo alterno 2: Cliente no menciona presupuesto**
- Si el cliente no menciona presupuesto estimado:
- Campo queda vacío (es opcional)
- No bloquea el registro de la reunión

**Excepción 1: Error al guardar información**
- Si falla el guardado automático:
- Sistema muestra advertencia pero permite continuar capturando
- Sistema intenta guardar nuevamente en segundo plano
- Si persiste el error, notifica a Fátima para guardar manualmente

**Excepción 2: Formulario cerrado accidentalmente**
- Si Fátima cierra el formulario sin completar:
- Sistema mantiene el borrador guardado
- Al reabrir, carga el borrador con la información capturada

### Validaciones y reglas de negocio
- Campo "Servicios de interés" debe permitir selección múltiple
- Campo "Presupuesto estimado" es opcional y acepta valores numéricos
- Todos los campos de texto tienen límites de caracteres razonables
- Guardado automático no debe interrumpir la captura

### Criterios BDD
- **Escenario 1: Captura exitosa de información corporativa**
  - *Dado* que Fátima tiene el formulario de registro abierto durante una reunión corporativa
  - *Cuando* registra necesidades, selecciona servicios de interés, presupuesto estimado y toma notas
  - *Entonces* el sistema guarda toda la información de forma estructurada y queda lista para generación de presupuesto

- **Escenario 2: Registro de servicio no estándar**
  - *Dado* que el cliente menciona un servicio que no está en el catálogo
  - *Cuando* Fátima lo registra en "Requerimientos especiales"
  - *Entonces* el sistema guarda la información como nota libre y no bloquea el registro

- **Escenario 3 (negativo): Error al guardar información**
  - *Dado* que Fátima está capturando información durante la reunión
  - *Cuando* falla el guardado automático
  - *Entonces* el sistema muestra advertencia, permite continuar capturando e intenta guardar nuevamente en segundo plano

### Notificaciones
- **Fátima:** Advertencia visual si falla el guardado automático
- No se generan notificaciones externas durante la captura

### Seguridad
- Validación de permisos antes de permitir captura
- Sanitización de datos de entrada para prevenir inyección
- Protección de datos sensibles del cliente

### Analítica/KPIs
- Tiempo promedio de captura durante reunión corporativa
- Número de servicios seleccionados por reunión
- Tasa de reuniones con presupuesto estimado registrado
- Frecuencia de uso de campos de notas libres

### Definition of Ready
- [ ] Catálogo de servicios/packs corporativos definido y disponible
- [ ] Estructura del formulario corporativo definida
- [ ] Sistema de guardado automático implementado
- [ ] Diseño de UI optimizado para uso rápido aprobado

### Definition of Done
- [ ] Formulario corporativo permite capturar todas las secciones requeridas
- [ ] Selección de servicios funciona correctamente (múltiple, catálogo)
- [ ] Guardado automático funciona sin interrumpir la captura
- [ ] Manejo de servicios no estándar implementado
- [ ] Manejo de errores de guardado implementado
- [ ] Pruebas de aceptación pasadas (todos los escenarios BDD)
- [ ] Diseño responsive verificado

### Riesgos y supuestos
- **Riesgo:** Captura interrumpe la conversación con el cliente
  - **Probabilidad:** Media
  - **Impacto:** Medio
  - **Mitigación:** Diseño de formulario optimizado para uso rápido, campos predefinidos, guardado automático

- **Riesgo:** Información incompleta por olvido durante reunión
  - **Probabilidad:** Media
  - **Impacto:** Alto
  - **Mitigación:** Formulario guiado con secciones claras, validación antes de completar (EP-005-US-004)

- **Supuesto:** Fátima puede usar dispositivo durante la reunión sin interrumpir la conversación
- **Supuesto:** Catálogo de servicios corporativos está actualizado

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-005-registro-informacion-reunion.md`
- Bloque funcional: Captura estructurada en tiempo real durante reunión
- Paso(s): Pasos 2-3 del flujo principal (registro de necesidades, servicios, presupuesto estimado y notas durante reunión corporativa)
