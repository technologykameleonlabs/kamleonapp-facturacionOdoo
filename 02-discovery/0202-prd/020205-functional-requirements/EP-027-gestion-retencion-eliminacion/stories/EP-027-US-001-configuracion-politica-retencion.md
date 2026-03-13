# EP-027-US-001 — Configuración de política de retención

### Epic padre
EP-027 — Gestión de retención y eliminación

### Contexto/Descripción y valor
**Como** administración, **quiero** configurar la política de retención por tipo de archivo o proyecto (plazo en años/meses), **para** que el sistema calcule automáticamente las fechas de eliminación.

### Alcance
**Incluye:** Definición de plazo de retención por tipo (bruto, final, documentos) o por tipo de proyecto (boda, corporativo); unidad años/meses. **Excluye:** Cálculo de fechas (EP-027-US-002); avisos (EP-027-US-003).

### Precondiciones
- Usuario es administración; tipos de archivo/proyecto definidos en sistema.

### Postcondiciones
- Política de retención configurada; sistema puede calcular fechas (EP-027-US-002).

### Flujo principal
1. Administración accede a configuración de retención.
2. Administración define plazo (años/meses) por tipo de archivo o proyecto.
3. Sistema guarda política; se aplica al calcular fechas (EP-027-US-002).

### Criterios BDD
- *Dado* que soy administración  
- *Cuando* configuro el plazo de retención por tipo  
- *Entonces* la política queda guardada y el sistema la usa para calcular fechas

### Trazabilidad
- TO-BE-027.
