# EP-019-US-005 — Cliente accede a material en portal

### Epic padre
EP-019 — Entrega de material para revisión

### Contexto/Descripción y valor
**Como** cliente, **quiero** acceder al portal para ver el material entregado y poder hacer comentarios (EP-020), **para** revisar y solicitar modificaciones si aplica.

### Alcance
**Incluye:** Acceso al portal del proyecto; visualización del material entregado (EP-019-US-002); enlace al sistema de comentarios (EP-020). **Excluye:** Comentarios en sí (EP-020).

### Precondiciones
- Material publicado en portal (EP-019-US-001); cliente con acceso al portal.

### Postcondiciones
- Cliente puede ver material y hacer comentarios (EP-020).

### Flujo principal
1. Cliente accede al portal (por notificación EP-019-US-003 o directamente).
2. Cliente abre el proyecto y la sección de material entregado.
3. Cliente ve material (visualización integrada EP-019-US-002).
4. Cliente puede añadir comentarios (EP-020).

### Criterios BDD
- *Dado* que soy cliente y el material está publicado  
- *Cuando* accedo al portal  
- *Entonces* veo el material y puedo hacer comentarios

### Trazabilidad
- TO-BE-019.
