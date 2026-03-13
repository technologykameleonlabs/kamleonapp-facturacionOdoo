# EP-012-US-002 — Registro de tiempo por fase con horas y notas

### Epic padre
EP-012 — Registro de tiempo por proyecto

### Contexto/Descripción y valor
**Como** responsable del proyecto,  
**quiero** registrar el tiempo empleado seleccionando fase (planificación, rodaje, edición), ingresando horas y minutos y añadiendo notas opcionales,  
**para** tener desglose por fase y contexto.

### Alcance
**Incluye:** Selección de fase; entrada de horas y minutos; notas opcionales; guardado del registro con timestamp y vinculación al proyecto.  
**Excluye:** Cálculo de totales (EP-012-US-003); comparación con presupuesto (EP-012-US-004).

### Precondiciones
- Formulario de registro abierto (EP-012-US-001); proyecto activado.

### Postcondiciones
- Registro guardado; tiempo total por fase y proyecto se actualiza (EP-012-US-003).

### Flujo principal
1. Responsable selecciona fase (planificación, rodaje, edición).
2. Responsable ingresa tiempo empleado (horas, minutos); sistema valida formato.
3. Responsable añade notas opcionales.
4. Responsable guarda registro; sistema guarda con timestamp y proyecto_id.

### Validaciones
- Tiempo en formato válido; valores mínimos/máximos razonables.

### Criterios BDD
- *Dado* que tengo el formulario abierto  
- *Cuando* selecciono fase, ingreso horas y minutos y guardo  
- *Entonces* el registro se guarda vinculado al proyecto y a la fase

### Trazabilidad
- TO-BE-012, pasos 2–5.
