# EP-016-US-006 — Trazabilidad completa y confirmación por Paz

### Epic padre
EP-016 — Gestión del día de la boda

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** registrar la trazabilidad completa (material por profesional, ubicación, estado, timestamp) y **como** Paz **quiero** confirmar al finalizar el día el material capturado por cada profesional, **para** que el material quede listo para postproducción (EP-017).

### Alcance
**Incluye:** Trazabilidad en BD: material por profesional, ubicación, estado (capturado, en proceso, listo), timestamp; vista resumen para Paz; confirmación por Paz de material por profesional y de completitud; marcado de día completado. **Excluye:** Registro de material en tiempo real (EP-016-US-003); postproducción (EP-017).

### Precondiciones
- Material e incidencias registrados (EP-016-US-003 a US-005); Paz con acceso al dashboard.

### Postcondiciones
- Trazabilidad completa registrada; Paz ha confirmado material; día de boda marcado como completado; listo para EP-017.

### Flujo principal
1. Sistema mantiene trazabilidad de cada registro de material (profesional, ubicación, estado, timestamp).
2. Paz accede al resumen del día: material por profesional, incidencias.
3. Paz revisa y confirma material capturado por cada profesional y completitud.
4. Sistema marca día de boda como completado; datos disponibles para postproducción (EP-017).

### Criterios BDD
- *Dado* que el día ha finalizado y hay material registrado  
- *Cuando* Paz confirma el material por profesional  
- *Entonces* el día queda marcado como completado y listo para postproducción

### Trazabilidad
- TO-BE-016, pasos 8–9.
