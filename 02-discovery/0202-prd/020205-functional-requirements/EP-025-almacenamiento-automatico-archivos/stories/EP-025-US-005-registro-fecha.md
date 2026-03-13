# EP-025-US-005 — Registro de fecha de subida

### Epic padre
EP-025 — Almacenamiento automático de archivos

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** registrar automáticamente la fecha de subida (timestamp) de cada archivo o proyecto archivado, **para** EP-027 (retención) y trazabilidad.

### Alcance
**Incluye:** Timestamp de subida por archivo o proyecto; vinculación a proyecto; datos para EP-027. **Excluye:** Subida (EP-025-US-002); notificación (EP-025-US-006).

### Precondiciones
- Archivos subidos y organizados (EP-025-US-002, EP-025-US-004).

### Postcondiciones
- Fecha de subida registrada; EP-027 puede calcular retención.

### Flujo principal
1. Sistema registra timestamp cuando archivos quedan archivados (EP-025-US-004).
2. Fecha vinculada a proyecto/boda; disponible para EP-027.

### Criterios BDD
- *Dado* que los archivos están archivados  
- *Cuando* el sistema registra la fecha de subida  
- *Entonces* la fecha queda registrada para retención (EP-027)

### Trazabilidad
- TO-BE-025.
