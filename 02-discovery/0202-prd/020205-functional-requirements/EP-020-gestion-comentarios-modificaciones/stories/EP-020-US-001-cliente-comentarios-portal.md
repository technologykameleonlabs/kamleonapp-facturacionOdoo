# EP-020-US-001 — Cliente hace comentarios en portal (por minuto o por escrito)

### Epic padre
EP-020 — Gestión de comentarios y modificaciones

### Contexto/Descripción y valor
**Como** cliente, **quiero** hacer comentarios en el portal sobre el material entregado (indicaciones por minuto en vídeo — corporativo — o por escrito), **para** que queden registrados centralizadamente.

### Alcance
**Incluye:** Comentarios en portal; indicaciones por minuto (corporativo) o por escrito; vinculación al material/minuto. **Excluye:** Registro centralizado (EP-020-US-002); control límites (EP-020-US-003).

### Precondiciones
- Material entregado en portal (EP-019); cliente con acceso al portal.

### Postcondiciones
- Comentarios enviados; sistema registra (EP-020-US-002) y notifica al responsable (EP-020-US-004).

### Flujo principal
1. Cliente accede al material entregado en portal (EP-019).
2. Cliente añade comentario (por minuto en vídeo o por escrito).
3. Sistema registra comentario centralizadamente (EP-020-US-002) y notifica al responsable (EP-020-US-004).

### Criterios BDD
- *Dado* que el material está entregado en el portal  
- *Cuando* hago un comentario (por minuto o por escrito)  
- *Entonces* el comentario queda registrado y el responsable recibe notificación

### Trazabilidad
- TO-BE-020.
