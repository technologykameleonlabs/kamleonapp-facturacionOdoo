# EP-020-US-005 — Responsable gestiona y responde comentarios

### Epic padre
EP-020 — Gestión de comentarios y modificaciones

### Contexto/Descripción y valor
**Como** responsable del proyecto, **quiero** ver los comentarios del cliente en el sistema y poder responder o gestionarlos, **para** coordinar la incorporación de cambios (EP-021).

### Alcance
**Incluye:** Vista de comentarios del cliente en dashboard/portal; respuesta o gestión de comentarios; coordinación con equipo para EP-021. **Excluye:** Registro de comentarios (EP-020-US-002); incorporación de cambios (EP-021).

### Precondiciones
- Comentarios registrados (EP-020-US-002); usuario es responsable del proyecto.

### Postcondiciones
- Responsable ha visto y gestionado comentarios; listo para incorporar cambios (EP-021).

### Flujo principal
1. Responsable accede al dashboard o al proyecto (por notificación EP-020-US-004 o directamente).
2. Responsable ve lista de comentarios del cliente (timestamp, material/minuto, contenido).
3. Responsable puede responder o marcar como gestionado; coordina incorporación (EP-021).

### Criterios BDD
- *Dado* que soy responsable del proyecto y hay comentarios  
- *Cuando* accedo al sistema  
- *Entonces* veo los comentarios del cliente y puedo responder o gestionarlos

### Trazabilidad
- TO-BE-020.
