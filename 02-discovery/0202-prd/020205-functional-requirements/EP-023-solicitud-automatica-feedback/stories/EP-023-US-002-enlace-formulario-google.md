# EP-023-US-002 — Enlace a formulario o portal de valoración e integración Google

### Epic padre
EP-023 — Solicitud automática de feedback

### Contexto/Descripción y valor
**Como** cliente, **quiero** recibir un enlace al formulario o portal de valoración (e integración con Google si aplica), **para** poder completar el feedback y publicar valoración.

### Alcance
**Incluye:** Enlace a formulario de feedback en portal o a valoración Google; cliente completa valoración y comentarios. **Excluye:** Solicitud automática (EP-023-US-001); registro (EP-023-US-005).

### Precondiciones
- Cliente ha recibido solicitud de feedback (EP-023-US-001); enlace a formulario o Google disponible.

### Postcondiciones
- Cliente puede completar feedback; sistema registra (EP-023-US-005) cuando se completa.

### Flujo principal
1. Cliente accede al enlace de la solicitud (EP-023-US-001).
2. Cliente completa formulario de valoración (estrellas, comentarios) en portal o en Google.
3. Sistema recibe completitud y registra feedback (EP-023-US-005).

### Criterios BDD
- *Dado* que he recibido la solicitud de feedback  
- *Cuando* accedo al enlace y completo la valoración  
- *Entonces* el feedback queda enviado y registrado

### Trazabilidad
- TO-BE-023.
