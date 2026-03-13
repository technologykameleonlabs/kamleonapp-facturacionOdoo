# EP-015-US-001 — Notificación a novios 10 días antes para completar formulario

### Epic padre
EP-015 — Preparación de bodas

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** notificar automáticamente a novios 10 días antes de la boda para completar el formulario digital (enlace al portal, recordatorio de reunión previa), **para** que novios tengan tiempo de preparar y completar los datos.

### Alcance
**Incluye:** Cálculo de fecha 10 días antes de boda; envío de notificación a novios con enlace al formulario y recordatorio de reunión previa. **Excluye:** Formulario en sí (EP-015-US-002); programación reunión (EP-015-US-003).

### Precondiciones
- Fecha de boda reservada (EP-011); novios con acceso al portal (email/contacto).

### Postcondiciones
- Novios han recibido notificación con enlace al formulario y recordatorio de reunión previa.

### Flujo principal
1. Sistema calcula fecha 10 días antes de la boda.
2. Sistema envía notificación a novios (email y/o portal) con enlace al formulario digital y recordatorio de reunión previa.
3. Novios pueden acceder al formulario (EP-015-US-002).

### Criterios BDD
- *Dado* que la boda está a 10 días  
- *Cuando* el sistema envía la notificación  
- *Entonces* novios reciben enlace al formulario y recordatorio de reunión previa

### Trazabilidad
- TO-BE-015, paso 1.
