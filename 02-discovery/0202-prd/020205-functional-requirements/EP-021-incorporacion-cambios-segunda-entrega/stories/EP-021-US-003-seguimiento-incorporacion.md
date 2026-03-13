# EP-021-US-003 — Seguimiento de incorporación de cambios

### Epic padre
EP-021 — Incorporación de cambios y segunda entrega

### Contexto/Descripción y valor
**Como** responsable o sistema, **quiero** ver el estado de incorporación de cambios (en curso, listo), **para** coordinar y saber cuándo publicar segunda entrega.

### Alcance
**Incluye:** Estado de incorporación (en curso, listo); vista para responsable; disparo para publicación cuando listo. **Excluye:** Incorporación efectiva (EP-021-US-002); publicación (EP-021-US-004).

### Precondiciones
- Comentarios registrados (EP-020); responsable asignado.

### Postcondiciones
- Estado visible; cuando "listo" se puede publicar segunda entrega (EP-021-US-004).

### Flujo principal
1. Responsable actualiza estado de incorporación (en curso, listo) tras trabajar en cambios (EP-021-US-002).
2. Sistema muestra estado en dashboard; cuando "listo" habilita publicación segunda entrega (EP-021-US-004).

### Criterios BDD
- *Dado* que hay incorporación en curso  
- *Cuando* el responsable marca como listo  
- *Entonces* el estado queda "listo" y se puede publicar segunda entrega

### Trazabilidad
- TO-BE-021.
