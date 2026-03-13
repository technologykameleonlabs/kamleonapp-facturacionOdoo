# EP-015-US-003 — Programación automática reunión previa y notificación

### Epic padre
EP-015 — Preparación de bodas

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** programar automáticamente la reunión previa 10 días antes de la boda y notificar a Paz y a novios con convocatoria, **para** que la reunión quede agendada sin coordinación manual.

### Alcance
**Incluye:** Programación de reunión previa 10 días antes de boda; generación de convocatoria; notificación a Paz y novios. **Excluye:** Formulario (EP-015-US-002); reunión en sí (EP-015-US-004). Puede integrar con EP-004 (agendamiento) si aplica.

### Precondiciones
- Fecha de boda reservada (EP-011); formulario guardado o en curso (EP-015-US-002); Paz y novios con datos de contacto.

### Postcondiciones
- Reunión previa agendada; Paz y novios han recibido convocatoria.

### Flujo principal
1. Sistema programa reunión previa 10 días antes de la boda (fecha/hora según regla o configuración).
2. Sistema genera convocatoria (o integra con calendario EP-004).
3. Sistema notifica a Paz y a novios con convocatoria.
4. Reunión previa queda agendada para EP-015-US-004.

### Criterios BDD
- *Dado* que la boda está reservada  
- *Cuando* el sistema programa la reunión previa  
- *Entonces* la reunión queda agendada 10 días antes y Paz y novios reciben convocatoria

### Trazabilidad
- TO-BE-015, paso 5.
