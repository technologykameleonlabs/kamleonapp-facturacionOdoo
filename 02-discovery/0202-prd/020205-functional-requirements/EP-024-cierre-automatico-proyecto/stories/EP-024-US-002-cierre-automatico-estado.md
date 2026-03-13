# EP-024-US-002 — Cierre automático y actualización de estado a Cerrado

### Epic padre
EP-024 — Cierre automático de proyecto

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** cerrar automáticamente el proyecto y actualizar el estado a "Cerrado" cuando se cumplen las condiciones, **para** que el proyecto quede cerrado sin intervención manual.

### Alcance
**Incluye:** Cambio de estado del proyecto a "Cerrado"; timestamp de cierre; registro de cierre. **Excluye:** Archivo documentación (EP-024-US-003); reporte final (EP-024-US-004).

### Precondiciones
- Condiciones de cierre cumplidas (EP-024-US-001); sistema ha disparado cierre.

### Postcondiciones
- Proyecto en estado "Cerrado"; sistema dispara archivo (EP-024-US-003) y reporte (EP-024-US-004).

### Flujo principal
1. Sistema recibe disparo de cierre (EP-024-US-001).
2. Sistema actualiza estado del proyecto a "Cerrado" y registra timestamp de cierre.
3. Sistema dispara archivo de documentación (EP-024-US-003) y generación de reporte final (EP-024-US-004).

### Criterios BDD
- *Dado* que las condiciones de cierre se cumplen  
- *Cuando* el sistema ejecuta el cierre  
- *Entonces* el estado del proyecto pasa a "Cerrado"

### Trazabilidad
- TO-BE-024.
