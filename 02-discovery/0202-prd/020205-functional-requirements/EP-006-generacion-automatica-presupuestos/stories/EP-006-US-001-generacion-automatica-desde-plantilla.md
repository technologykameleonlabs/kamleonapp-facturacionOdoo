# EP-006-US-001 — Generación automática desde plantilla según reunión

### Epic padre
EP-006 — Generación automática de presupuestos

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** generar automáticamente un presupuesto desde la plantilla correspondiente (Corporativo: pack; Bodas: servicios, provincia, extras) cuando una reunión pasa a Completada,  
**para** tener el presupuesto listo en menos de 5 minutos sin pasos manuales.

### Alcance
**Incluye:**
- Detección automática cuando una reunión pasa a estado "Completada" (trigger desde EP-005).
- Lectura de la información de reunión expuesta por EP-005-US-005 (línea de negocio, servicios, pack, provincia, extras).
- Selección de la plantilla de presupuesto según línea de negocio:
  - Corporativo: plantilla según pack seleccionado (3 packs colegios, 4 packs empresas) o servicios personalizados.
  - Bodas: plantilla según servicios seleccionados (fotografía, vídeo, dron), provincia y extras.
- Generación del borrador de presupuesto desde la plantilla seleccionada.
- Uso de precios actualizados en el sistema.

**Excluye:**
- Personalización con datos del cliente y cálculo de totales (EP-006-US-002).
- Marcado Pendiente de aprobación y notificación (EP-006-US-003).
- Revisión, modificación y aprobación (EP-006-US-004, EP-006-US-005).

### Precondiciones
- Reunión está en estado "Completada" (EP-005-US-004).
- Información de reunión está expuesta al motor de presupuestos (EP-005-US-005).
- Plantillas de presupuesto están configuradas para la línea de negocio y servicios correspondientes.
- Base de datos de precios está actualizada.

### Postcondiciones
- Borrador de presupuesto generado desde la plantilla correcta.
- Presupuesto vinculado al lead y a la reunión.
- Presupuesto listo para personalización (EP-006-US-002).

### Flujo principal
1. Sistema detecta que una reunión ha cambiado a estado "Completada" (trigger).
2. Sistema lee la información de reunión disponible (lead_id, reunion_id, línea de negocio, servicios, pack/provincia/extras).
3. Sistema identifica la plantilla de presupuesto correspondiente:
   - Corporativo: según pack seleccionado o servicios personalizados.
   - Bodas: según servicios (fotografía, vídeo, dron), provincia y extras.
4. Sistema carga la plantilla y los precios actualizados.
5. Sistema genera el borrador de presupuesto aplicando la plantilla y precios.
6. Sistema guarda el presupuesto con estado "Borrador" o "En generación".
7. Sistema pasa control a personalización (EP-006-US-002).

### Flujos alternos y excepciones

**Excepción 1: Plantilla no encontrada**
- Si no existe plantilla para el pack/servicios/provincia indicados:
- Sistema marca presupuesto como "Datos incompletos" o "Plantilla no encontrada".
- Sistema notifica a Fátima/Paz para generación manual o configuración de plantilla.

**Excepción 2: Datos faltantes para seleccionar plantilla**
- Si la información de reunión no permite seleccionar una plantilla (ej. sin servicios de interés):
- Sistema marca error y notifica a Fátima/Paz para completar datos o generar manualmente.

**Excepción 3: Precios no disponibles**
- Si algún precio no está configurado en el sistema:
- Sistema genera presupuesto con precio en blanco o placeholder y notifica para completar.

### Validaciones y reglas de negocio
- Solo se genera presupuesto para reuniones en estado "Completada".
- Plantilla debe existir y estar activa para la combinación pack/servicios/provincia.
- Precios deben estar actualizados en el sistema; si faltan, se marca y notifica.

### Criterios BDD
- **Escenario 1: Generación exitosa Corporativo**
  - *Dado* que una reunión corporativa está Completada con pack seleccionado
  - *Cuando* el sistema ejecuta la generación automática
  - *Entonces* el sistema selecciona la plantilla del pack, genera el borrador de presupuesto y lo vincula al lead y reunión

- **Escenario 2: Generación exitosa Bodas**
  - *Dado* que una reunión de bodas está Completada con servicios, provincia y extras
  - *Cuando* el sistema ejecuta la generación automática
  - *Entonces* el sistema selecciona la plantilla según servicios/provincia/extras, genera el borrador y lo vincula al lead y reunión

- **Escenario 3 (negativo): Plantilla no encontrada**
  - *Dado* que la reunión tiene servicios para los que no existe plantilla configurada
  - *Cuando* el sistema intenta generar el presupuesto
  - *Entonces* el sistema marca error "Plantilla no encontrada", no genera presupuesto y notifica a Fátima/Paz

### Notificaciones
- **Fátima/Paz:** Notificación si plantilla no encontrada o datos faltantes (no en happy path).

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-006-generacion-automatica-presupuestos.md`
- Paso(s): Pasos 1–2 del flujo principal (detección reunión Completada, generación desde plantilla).
