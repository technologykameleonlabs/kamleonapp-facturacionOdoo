# EP-015-US-005 — Bloqueo automático de música y registro de detalles confirmados

### Epic padre
EP-015 — Preparación de bodas

### Contexto/Descripción y valor
**Como** sistema centralizado, **quiero** bloquear automáticamente la música definida en la reunión previa (sin cambios posteriores) y registrar todos los detalles confirmados (formulario, música, horarios, logística), **para** que estén disponibles para el día de la boda (EP-016).

### Alcance
**Incluye:** Bloqueo de música (teaser, película) tras registro por Paz; no se puede modificar después; registro de formulario, música, horarios y detalles logísticos confirmados; datos disponibles para EP-016. **Excluye:** Reunión previa (EP-015-US-004); día de boda (EP-016).

### Precondiciones
- Música definida y registrada por Paz (EP-015-US-004); formulario y detalles confirmados.

### Postcondiciones
- Música bloqueada; todos los detalles confirmados registrados; preparación completada; listo para EP-016.

### Flujo principal
1. Sistema recibe confirmación de música registrada por Paz (EP-015-US-004).
2. Sistema bloquea música para teaser y película (estado "Bloqueada"; no editable).
3. Sistema registra todos los detalles confirmados: formulario, música, horarios, logística.
4. Sistema marca preparación como completada; datos disponibles para día de boda (EP-016).

### Criterios BDD
- *Dado* que Paz ha registrado la música definida  
- *Cuando* el sistema ejecuta el bloqueo  
- *Entonces* la música queda bloqueada y no se puede modificar; detalles quedan registrados

### Trazabilidad
- TO-BE-015, pasos 9–10.
