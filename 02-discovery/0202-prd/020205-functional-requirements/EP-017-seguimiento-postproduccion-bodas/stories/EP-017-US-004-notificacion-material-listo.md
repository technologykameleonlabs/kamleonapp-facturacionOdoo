# EP-017-US-004 — Notificación automática cuando material está listo

### Epic padre
EP-017 — Seguimiento de postproducción de bodas

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** notificar automáticamente a novios cuando teaser, película, fotografías o álbumes pasan a estado "Listo", **para** que sepan que el material está disponible (EP-019).

### Alcance
**Incluye:** Detección de cambio de estado a "Listo" (teaser, película, fotos, álbumes); notificación automática a novios (email y/o portal) con indicación de qué material está listo y enlace al portal; disparo hacia EP-019 (entrega para revisión) si aplica. **Excluye:** Actualización de estado (EP-017-US-001); comunicación mensual (EP-017-US-003).

### Precondiciones
- Equipo actualiza estado a "Listo" (EP-017-US-001); novios con canal de notificación.

### Postcondiciones
- Novios han recibido notificación de que material está listo; pueden acceder al portal para ver/descargar (EP-019).

### Flujo principal
1. Sistema detecta cambio de estado de un elemento a "Listo" (EP-017-US-001).
2. Sistema prepara notificación para novios (elemento listo, enlace al portal).
3. Sistema envía notificación por email y/o portal.
4. Material queda disponible para entrega/revisión (EP-019).

### Criterios BDD
- *Dado* que un elemento pasa a estado "Listo"  
- *Cuando* el sistema procesa el cambio  
- *Entonces* novios reciben notificación de que el material está listo

### Trazabilidad
- TO-BE-017, paso 5.
