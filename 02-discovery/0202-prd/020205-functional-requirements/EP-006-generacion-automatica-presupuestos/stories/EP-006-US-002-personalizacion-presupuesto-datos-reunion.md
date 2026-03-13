# EP-006-US-002 — Personalización del presupuesto con datos de reunión

### Epic padre
EP-006 — Generación automática de presupuestos

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** personalizar el presupuesto generado con los datos capturados en reunión (cliente, servicios, extras, precios actualizados) y calcular totales automáticamente,  
**para** que el presupuesto refleje exactamente lo acordado con el cliente.

### Alcance
**Incluye:**
- Lectura de datos del lead (nombre, email, teléfono) y de la reunión (servicios, extras, provincia, notas).
- Inserción de datos del cliente en el presupuesto (nombre, contacto).
- Inserción de líneas de servicio según datos de reunión (descripción, precio unitario, cantidad).
- Aplicación de precios actualizados del sistema.
- Cálculo automático de subtotales y total.
- Manejo de extras (transporte, tiempo extra, etc.) con precios configurados.
- Guardado del presupuesto personalizado.

**Excluye:**
- Generación desde plantilla (EP-006-US-001).
- Marcado Pendiente de aprobación y notificación (EP-006-US-003).
- Modificación manual por Fátima/Paz (EP-006-US-004).

### Precondiciones
- Borrador de presupuesto generado desde plantilla (EP-006-US-001).
- Información de reunión disponible (lead, servicios, extras, provincia).
- Precios actualizados en el sistema para todos los conceptos usados.

### Postcondiciones
- Presupuesto personalizado con datos del cliente y líneas de servicio correctas.
- Totales calculados automáticamente.
- Presupuesto listo para marcar como Pendiente de aprobación (EP-006-US-003).

### Flujo principal
1. Sistema recibe el borrador de presupuesto generado (EP-006-US-001).
2. Sistema lee datos del lead (nombre, email, teléfono) y de la reunión (servicios, extras, provincia, notas).
3. Sistema reemplaza variables en el presupuesto (nombre cliente, etc.).
4. Sistema construye líneas de servicio según datos de reunión:
   - Corporativo: líneas según pack/servicios seleccionados con precios actualizados.
   - Bodas: líneas según servicios (fotografía, vídeo, dron), provincia (desplazamiento si aplica), extras (transporte, tiempo extra).
5. Sistema aplica precios actualizados del sistema a cada línea.
6. Sistema calcula subtotales por línea y total del presupuesto.
7. Sistema guarda el presupuesto personalizado.
8. Sistema pasa control a EP-006-US-003 (marcado Pendiente de aprobación y notificación).

### Flujos alternos y excepciones

**Excepción 1: Precio faltante para un concepto**
- Si un servicio o extra no tiene precio configurado:
- Sistema inserta la línea con precio en blanco o 0 y marca presupuesto como "Precios incompletos".
- Sistema notifica a Fátima/Paz para completar precios antes de aprobar.

**Excepción 2: Error en cálculo**
- Si hay error en el cálculo de totales (ej. overflow, dato inválido):
- Sistema registra error y notifica al equipo técnico.
- Presupuesto queda en estado "Error de cálculo" hasta corrección.

### Validaciones y reglas de negocio
- Todas las líneas deben tener descripción y precio (o marcarse como pendiente de precio).
- Total debe ser coherente con la suma de líneas.
- Datos del cliente deben insertarse correctamente (nombre, contacto).

### Criterios BDD
- **Escenario 1: Personalización exitosa**
  - *Dado* que existe un borrador de presupuesto generado desde plantilla y datos de reunión completos
  - *Cuando* el sistema personaliza el presupuesto
  - *Entonces* el presupuesto contiene datos del cliente, líneas de servicio con precios actualizados y total calculado correctamente

- **Escenario 2 (negativo): Precio faltante**
  - *Dado* que un extra seleccionado en la reunión no tiene precio configurado en el sistema
  - *Cuando* el sistema personaliza el presupuesto
  - *Entonces* el sistema inserta la línea con precio en blanco o 0, marca "Precios incompletos" y notifica a Fátima/Paz

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-006-generacion-automatica-presupuestos.md`
- Paso(s): Paso 3 del flujo principal (personalización con datos capturados en reunión).
