# EP-016-US-003 — Registro de material capturado por profesional

### Epic padre
EP-016 — Gestión del día de la boda

### Contexto/Descripción y valor
**Como** profesional del equipo, **quiero** registrar en tiempo real el material que capturo (vídeo, fotos) durante el día de boda, **para** que quede trazabilidad por profesional y el material esté listo para postproducción.

### Alcance
**Incluye:** Registro rápido por profesional: tipo de material (vídeo, foto), cantidad o descripción, timestamp; vinculación a profesional y proyecto; estado (capturado, en proceso). **Excluye:** Uso de dron y horarios (EP-016-US-004); incidencias (EP-016-US-005); confirmación final (EP-016-US-006).

### Precondiciones
- Equipo asignado (EP-016-US-001); profesional con acceso al sistema (móvil o web).

### Postcondiciones
- Material registrado con trazabilidad (profesional, proyecto, timestamp); disponible para EP-016-US-006 y EP-017.

### Flujo principal
1. Profesional accede al formulario de registro de material (desde móvil o portal).
2. Profesional indica tipo de material (vídeo, foto), cantidad o descripción breve.
3. Sistema registra con timestamp, profesional_id, proyecto_id y estado "Capturado".
4. Trazabilidad queda registrada para postproducción.

### Criterios BDD
- *Dado* que soy profesional asignado al día de boda  
- *Cuando* registro material capturado  
- *Entonces* queda registrado con mi usuario, timestamp y proyecto

### Trazabilidad
- TO-BE-016, pasos 5 y 8.
