# EP-012-US-001 — Acceso al formulario de registro de tiempo desde dashboard

### Epic padre
EP-012 — Registro de tiempo por proyecto

### Contexto/Descripción y valor
**Como** responsable del proyecto,  
**quiero** acceder al formulario de registro de tiempo desde el dashboard del proyecto con campos predefinidos,  
**para** registrar el tiempo empleado en menos de 2 minutos por sesión.

### Alcance
**Incluye:** Acceso al formulario desde dashboard del proyecto; formulario rápido con campos predefinidos (fase, tiempo, notas).  
**Excluye:** Registro efectivo de tiempo (EP-012-US-002); cálculo y comparación (EP-012-US-003, EP-012-US-004).

### Precondiciones
- Proyecto activado (EP-010); responsable asignado al proyecto; usuario con rol de responsable.

### Postcondiciones
- Formulario de registro visible y listo para introducir datos.

### Flujo principal
1. Responsable accede al dashboard del proyecto.
2. Responsable abre el formulario de registro de tiempo (botón o enlace).
3. Sistema muestra formulario con campos predefinidos (fase, horas, minutos, notas opcionales).
4. Responsable puede introducir datos (EP-012-US-002).

### Criterios BDD
- *Dado* que soy responsable del proyecto y el proyecto está activado  
- *Cuando* accedo al dashboard del proyecto y abro el formulario de registro de tiempo  
- *Entonces* veo un formulario rápido con campos para fase, tiempo y notas

### Trazabilidad
- TO-BE-012, paso 1.
