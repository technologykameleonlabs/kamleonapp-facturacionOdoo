# EP-013-US-001 — Acceso al formulario de recursos desde dashboard

### Epic padre
EP-013 — Gestión de recursos de producción

### Contexto/Descripción y valor
**Como** responsable del proyecto, **quiero** acceder al formulario de recursos desde el dashboard del proyecto con elementos predeterminados, **para** registrar recursos en menos de 3 minutos por recurso.

### Alcance
**Incluye:** Acceso al formulario desde dashboard; formulario con elementos predeterminados (iluminación, equipos, casting, localización, transporte, alojamiento, otros). **Excluye:** Registro efectivo (EP-013-US-002); cálculo e integración (EP-013-US-003, EP-013-US-004).

### Precondiciones
- Proyecto activado (EP-010); responsable asignado; usuario con rol de responsable.

### Postcondiciones
- Formulario visible y listo para introducir datos.

### Flujo principal
1. Responsable accede al dashboard del proyecto.
2. Responsable abre el formulario de recursos.
3. Sistema muestra formulario con tipos predeterminados y opción de recurso personalizado.
4. Responsable puede introducir datos (EP-013-US-002).

### Criterios BDD
- *Dado* que soy responsable del proyecto y el proyecto está activado  
- *Cuando* accedo al dashboard y abro el formulario de recursos  
- *Entonces* veo tipos predeterminados y opción de añadir recurso personalizado

### Trazabilidad
- TO-BE-013, paso 1.
