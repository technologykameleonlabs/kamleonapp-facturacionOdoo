# EP-014-US-002 — Visualización rentabilidad en dashboard estilo Holded

### Epic padre
EP-014 — Control de rentabilidad en tiempo real

### Contexto/Descripción y valor
**Como** CEO o responsable del proyecto, **quiero** ver la rentabilidad en un dashboard con gráfico de ingresos vs gastos (estilo Holded), **para** tener visibilidad clara de la situación del proyecto.

### Alcance
**Incluye:** Gráfico de ingresos vs gastos; dashboard por proyecto; acceso según rol (CEO todos los proyectos, responsable su proyecto). **Excluye:** Cálculo (EP-014-US-001); alertas (EP-014-US-004, EP-014-US-005).

### Precondiciones
- Rentabilidad calculada (EP-014-US-001); usuario con rol CEO o responsable del proyecto.

### Postcondiciones
- Usuario ve gráfico ingresos vs gastos en dashboard.

### Flujo principal
1. Usuario accede al dashboard de rentabilidad (o al proyecto).
2. Sistema obtiene rentabilidad actual (EP-014-US-001).
3. Sistema muestra gráfico de ingresos vs gastos (estilo Holded).
4. CEO ve todos los proyectos; responsable ve solo su proyecto.

### Criterios BDD
- *Dado* que soy CEO o responsable y hay datos de rentabilidad  
- *Cuando* accedo al dashboard  
- *Entonces* veo gráfico de ingresos vs gastos

### Trazabilidad
- TO-BE-014, paso 5.
