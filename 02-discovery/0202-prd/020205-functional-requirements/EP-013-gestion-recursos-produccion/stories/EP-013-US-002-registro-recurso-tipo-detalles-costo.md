# EP-013-US-002 — Registro de recurso (tipo, detalles, costo)

### Epic padre
EP-013 — Gestión de recursos de producción

### Contexto/Descripción y valor
**Como** responsable del proyecto, **quiero** registrar un recurso seleccionando tipo (iluminación, equipos, casting, localización, transporte, alojamiento, otros o personalizado), ingresando detalles y costo/gasto y añadiendo notas opcionales, **para** tener trazabilidad de gastos.

### Alcance
**Incluye:** Selección de tipo predeterminado o personalizado; detalles del recurso; costo/gasto; notas opcionales; guardado con timestamp y proyecto_id. **Excluye:** Cálculo de totales (EP-013-US-003); integración rentabilidad (EP-013-US-004).

### Precondiciones
- Formulario de recursos abierto (EP-013-US-001); proyecto activado.

### Postcondiciones
- Registro guardado; totales se actualizan (EP-013-US-003).

### Flujo principal
1. Responsable selecciona tipo de recurso (predeterminado o añade personalizado).
2. Responsable ingresa detalles del recurso y costo/gasto; sistema valida formato.
3. Responsable añade notas opcionales.
4. Responsable guarda registro; sistema guarda con timestamp y proyecto_id.

### Validaciones
- Costo en formato válido; campos obligatorios: tipo, costo.

### Criterios BDD
- *Dado* que tengo el formulario abierto  
- *Cuando* selecciono tipo, ingreso detalles y costo y guardo  
- *Entonces* el registro se guarda vinculado al proyecto y al tipo de recurso

### Trazabilidad
- TO-BE-013, pasos 2–5.
