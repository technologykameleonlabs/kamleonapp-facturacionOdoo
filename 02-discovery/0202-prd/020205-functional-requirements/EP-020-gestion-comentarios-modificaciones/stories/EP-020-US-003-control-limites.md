# EP-020-US-003 — Control automático de límites de modificaciones

### Epic padre
EP-020 — Gestión de comentarios y modificaciones

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** controlar automáticamente los límites de modificaciones (3 corporativo, 2 bodas) y avisar cuando se alcanza o supera el límite, **para** cumplir con la política de rondas.

### Alcance
**Incluye:** Límites configurados (3 corporativo, 2 bodas); conteo de rondas de comentarios; aviso cuando se alcanza o supera el límite. **Excluye:** Registro de comentarios (EP-020-US-002); notificación al responsable (EP-020-US-004).

### Precondiciones
- Comentarios registrados (EP-020-US-002); proyecto con tipo (corporativo/boda) definido.

### Postcondiciones
- Si se alcanza o supera el límite: aviso visible al cliente y/o responsable; opcional bloqueo de nuevos comentarios según regla.

### Flujo principal
1. Sistema cuenta rondas de comentarios por proyecto (entrega más comentarios = 1 ronda).
2. Sistema compara con límite (3 corporativo, 2 bodas).
3. Si se alcanza o supera: sistema muestra aviso y puede bloquear nuevos comentarios según configuración.

### Criterios BDD
- *Dado* que el proyecto tiene límite 3 (corporativo) o 2 (bodas)  
- *Cuando* se alcanza o supera el número de rondas de comentarios  
- *Entonces* el sistema muestra aviso y puede bloquear nuevos comentarios

### Trazabilidad
- TO-BE-020.
