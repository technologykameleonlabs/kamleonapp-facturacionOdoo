# EP-006-US-004 — Revisión y modificación del presupuesto por ONGAKU

### Epic padre
EP-006 — Generación automática de presupuestos

### Contexto/Descripción y valor
**Como** Fátima/Paz,  
**quiero** revisar el presupuesto generado y poder modificar precios, servicios o notas, con recálculo automático de totales,  
**para** ajustar el presupuesto antes de aprobar.

### Alcance
**Incluye:**
- Vista de detalle del presupuesto (líneas, precios, totales, datos del cliente).
- Editor de presupuesto:
  - Modificar precio unitario de líneas.
  - Añadir o eliminar líneas (servicios, extras).
  - Modificar descripción o notas.
- Recálculo automático de subtotales y total al modificar.
- Guardado de cambios (borrador modificado).
- Validación básica (totales coherentes, precios numéricos válidos).

**Excluye:**
- Aprobación del presupuesto (EP-006-US-005).
- Envío al cliente (EP-006-US-006).
- Gestión de plantillas (EP-006-US-006).

### Precondiciones
- Presupuesto en estado "Pendiente de aprobación" (EP-006-US-003).
- Fátima/Paz tiene permisos para editar presupuestos según línea de negocio.
- Usuario está autenticado en el sistema.

### Postcondiciones
- Presupuesto modificado (si aplica) y guardado.
- Totales recalculados correctamente.
- Presupuesto sigue en "Pendiente de aprobación" hasta que se apruebe (EP-006-US-005).

### Flujo principal
1. Fátima/Paz accede al listado de presupuestos pendientes de aprobación.
2. Fátima/Paz selecciona un presupuesto y abre la vista de detalle.
3. Sistema muestra presupuesto con líneas, precios, totales y datos del cliente.
4. Fátima/Paz revisa el presupuesto.
5. Si requiere cambios:
   - Fátima/Paz edita precios, añade/elimina líneas o modifica notas en el editor.
   - Sistema recalcula subtotales y total automáticamente al cambiar valores.
   - Fátima/Paz guarda los cambios.
6. Sistema guarda el presupuesto modificado y mantiene estado "Pendiente de aprobación".
7. Fátima/Paz puede aprobar el presupuesto (EP-006-US-005) cuando esté correcto.

### Flujos alternos y excepciones

**Flujo alterno 1: No requiere modificación**
- Si Fátima/Paz considera que el presupuesto está correcto:
- No modifica nada y pasa directamente a aprobar (EP-006-US-005).

**Excepción 1: Error en recálculo**
- Si al modificar un precio se produce error en el cálculo:
- Sistema muestra mensaje de error y no guarda hasta corregir (ej. precio inválido).
- Sistema valida que precios sean numéricos y totales coherentes.

**Excepción 2: Sin permisos para editar**
- Si el usuario no tiene permisos para editar ese presupuesto:
- Sistema muestra mensaje de permisos y solo permite vista de solo lectura.

### Validaciones y reglas de negocio
- Precios deben ser numéricos y no negativos.
- Total debe ser coherente con la suma de líneas.
- Cambios se guardan como borrador modificado; estado sigue "Pendiente de aprobación" hasta aprobación.

### Criterios BDD
- **Escenario 1: Modificación exitosa con recálculo**
  - *Dado* que Fátima tiene un presupuesto pendiente de aprobación abierto
  - *Cuando* modifica el precio de una línea y guarda
  - *Entonces* el sistema recalcula subtotales y total automáticamente, guarda los cambios y mantiene el estado "Pendiente de aprobación"

- **Escenario 2 (negativo): Precio inválido**
  - *Dado* que Paz está editando un presupuesto
  - *Cuando* introduce un precio no numérico o negativo
  - *Entonces* el sistema muestra error de validación y no guarda hasta corregir

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-006-generacion-automatica-presupuestos.md`
- Paso(s): Pasos 6–7 del flujo principal (revisión y modificación por Fátima/Paz).
