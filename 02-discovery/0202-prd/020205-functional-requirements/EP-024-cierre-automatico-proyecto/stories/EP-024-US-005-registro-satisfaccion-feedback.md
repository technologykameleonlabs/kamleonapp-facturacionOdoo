# EP-024-US-005 — Registro de satisfacción (feedback) en cierre

### Epic padre
EP-024 — Cierre automático de proyecto

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** registrar la satisfacción del cliente (feedback recibido EP-023 si aplica) en el cierre del proyecto, **para** reportes y mejora continua.

### Alcance
**Incluye:** Vinculación del feedback recibido (EP-023-US-005) al cierre del proyecto; inclusión en reporte final y archivo; datos para reportes de satisfacción. **Excluye:** Solicitud de feedback (EP-023); cierre efectivo (EP-024-US-002).

### Precondiciones
- Proyecto cerrado (EP-024-US-002); feedback recibido (EP-023-US-005) si aplica.

### Postcondiciones
- Satisfacción del cliente registrada en cierre; disponible para reporte final (EP-024-US-004) y reportes de mejora.

### Flujo principal
1. Sistema obtiene feedback recibido del proyecto (EP-023-US-005) si existe.
2. Sistema registra satisfacción del cliente en el cierre del proyecto (valoración, comentarios).
3. Datos incluidos en reporte final (EP-024-US-004) y en archivo (EP-024-US-003).

### Criterios BDD
- *Dado* que el proyecto está cerrado y hay feedback recibido  
- *Cuando* el sistema registra la satisfacción en el cierre  
- *Entonces* la satisfacción queda vinculada al cierre y al reporte final

### Trazabilidad
- TO-BE-024.
