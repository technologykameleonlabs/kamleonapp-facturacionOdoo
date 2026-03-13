# EP-021-US-006 — Cliente acepta segunda entrega en portal

### Epic padre
EP-021 — Incorporación de cambios y segunda entrega

### Contexto/Descripción y valor
**Como** cliente, **quiero** ver la segunda entrega en el portal y aceptarla explícitamente, **para** que el proyecto quede listo para factura final (EP-022) y feedback (EP-023).

### Alcance
**Incluye:** Cliente accede al portal; ve segunda entrega en galería Vidflow; acción explícita de aceptación; registro de aceptación; disparo para EP-022 y EP-023. **Excluye:** Factura final (EP-022); feedback (EP-023).

### Precondiciones
- Segunda entrega publicada (EP-021-US-004); cliente con acceso al portal.

### Postcondiciones
- Segunda entrega aceptada por cliente; proyecto listo para EP-022 (factura final) y EP-023 (feedback).

### Flujo principal
1. Cliente accede al portal (por notificación EP-021-US-005 o directamente).
2. Cliente ve segunda entrega en galería Vidflow.
3. Cliente ejecuta acción de aceptación (botón o equivalente).
4. Sistema registra aceptación; dispara EP-022 (generación factura final) y EP-023 (solicitud feedback).

### Criterios BDD
- *Dado* que la segunda entrega está publicada  
- *Cuando* el cliente acepta en el portal  
- *Entonces* queda registrada la aceptación y se disparan EP-022 y EP-023

### Trazabilidad
- TO-BE-021.
