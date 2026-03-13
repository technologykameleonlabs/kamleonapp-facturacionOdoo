# EP-004-US-004 — Generación automática de convocatorias según modalidad

### Epic padre
EP-004 — Agendamiento de reuniones

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** generar automáticamente la convocatoria según la modalidad elegida (presencial con dirección o online con enlace Google Meet),  
**para** que el cliente y el equipo tengan todos los detalles necesarios de la reunión sin intervención manual.

### Alcance
**Incluye:**
- Generación de un objeto “convocatoria” a partir de:
  - Datos del lead (nombre, email, teléfono).
  - Datos de la reunión (fecha, hora, duración, modalidad).
  - Configuración de ubicación física (dirección de oficina).
  - Configuración de integración con Google Meet (para modalidad online).
- Plantillas de texto para la convocatoria (asunto, cuerpo del email/invitación).
- Para modalidad presencial:
  - Incluir dirección completa de la oficina.
  - Incluir indicaciones básicas si se requiere.
- Para modalidad online:
  - Generar enlace Google Meet correctamente (sin comportamientos erráticos).
  - Incluir el enlace en la convocatoria.

**Excluye:**
- Envío de la convocatoria al cliente y al equipo (EP-004-US-005).
- Programación de recordatorios (EP-004-US-006).

### Precondiciones
- Slot de reunión ha sido validado y bloqueado correctamente (EP-004-US-003).
- Modalidad de reunión está definida (presencial u online).
- Configuración de la oficina (dirección) está disponible.
- Integración con Google Meet está configurada (para modalidad online).

### Postcondiciones
- Convocatoria generada correctamente con todos los datos necesarios.
- En caso de modalidad online, enlace Google Meet creado y asociado a la reunión.
- Convocatoria lista para ser enviada y sincronizada con Google Calendar (EP-004-US-005).

### Flujo principal
1. Sistema recibe datos de la reunión confirmada:
   - Lead asociado.
   - Fecha y hora bloqueadas.
   - Modalidad de reunión.
2. Sistema prepara plantilla base de convocatoria:
   - Asunto estándar (ej. “Confirmación reunión ONGAKU — [fecha y hora]”).
   - Cuerpo estándar con saludo, contexto y datos de contacto.
3. Si modalidad es **presencial**:
   - Sistema inserta dirección de la oficina (dirección completa).
   - Sistema puede incluir mapa o instrucciones básicas (opcional).
4. Si modalidad es **online**:
   - Sistema solicita a la integración con Google Meet la creación de un enlace de reunión.
   - Sistema valida que el enlace se ha generado correctamente.
   - Sistema inserta enlace en el cuerpo de la convocatoria.
5. Sistema inserta datos de la reunión:
   - Fecha y hora.
   - Duración estimada.
6. Sistema construye objeto de convocatoria con:
   - Asunto.
   - Cuerpo.
   - Fecha/hora.
   - Modalidad (y enlace o dirección).
7. Sistema deja la convocatoria lista para envío y sincronización (EP-004-US-005).

### Flujos alternos y excepciones

**Flujo alterno 1: Personalización adicional del texto**
- Sistema permite configurar textos adicionales según tipo de cliente (bodas/corporativo) sin cambiar la estructura básica.

**Excepción 1: Error al generar enlace Google Meet**
- Si la integración con Google Meet falla al generar el enlace:
  - Sistema registra el error.
  - Sistema genera convocatoria sin enlace y marca estado “Pendiente de enlace”.
  - Sistema notifica a Fátima/Paz para que añadan el enlace manualmente.

**Excepción 2: Falta de configuración de dirección de oficina**
- Si la modalidad es presencial pero no hay dirección configurada:
  - Sistema impide generar la convocatoria y registra error.
  - Sistema notifica al responsable de configuración.

### Validaciones y reglas de negocio
- Modalidad debe ser una de las permitidas: “Presencial” u “Online”.
- En modalidad online, la generación de enlace Meet debe completarse antes de marcar la convocatoria como completa (salvo excepciones).
- Asunto y cuerpo no pueden quedar vacíos.
- Deben incluirse siempre fecha y hora en el texto de la convocatoria.

### Criterios BDD
- **Escenario 1: Generación de convocatoria presencial correcta**
  - *Dado* que una reunión ha sido confirmada con modalidad “Presencial” y hay dirección configurada
  - *Cuando* el sistema genera la convocatoria
  - *Entonces* la convocatoria incluye fecha, hora y dirección de la oficina en el cuerpo del mensaje.

- **Escenario 2: Generación de convocatoria online con enlace Meet**
  - *Dado* que una reunión ha sido confirmada con modalidad “Online” y la integración con Google Meet está disponible
  - *Cuando* el sistema genera la convocatoria
  - *Entonces* la convocatoria incluye un enlace Google Meet válido en el cuerpo del mensaje.

- **Escenario 3 (negativo): Error al generar enlace Meet**
  - *Dado* que una reunión ha sido confirmada con modalidad “Online”
  - *Cuando* la integración con Google Meet falla al crear el enlace
  - *Entonces* el sistema registra el error, marca la convocatoria como “Pendiente de enlace” y notifica a Fátima/Paz para acción manual.

### Notificaciones
- **Fátima/Paz:** Notificación cuando no se pueda generar el enlace Meet y la convocatoria quede pendiente de enlace.

### Seguridad
- Control de credenciales para la integración con Google Meet.
- No exponer tokens sensibles en la convocatoria.

### Analítica/KPIs
- Número de convocatorias generadas por modalidad (presencial/online).
- Tasa de errores en generación de enlace Meet.
- Tiempo medio de generación de convocatorias.

### Definition of Ready
- [ ] Integración con Google Meet configurada.
- [ ] Plantillas base de convocatoria definidas (asunto y cuerpo).
- [ ] Dirección de oficina configurada y validada.

### Definition of Done
- [ ] Convocatorias se generan correctamente para ambas modalidades.
- [ ] Enlace Meet se genera y se inserta correctamente en modalidad online.
- [ ] Manejo de errores implementado (falta de dirección, fallo Meet).
- [ ] Escenarios BDD pasados.

### Riesgos y supuestos
- **Riesgo:** Enlace Meet incorrecto o roto → Mitigación: validación de enlace y pruebas periódicas.
- **Supuesto:** Configuraciones de oficina y Meet se mantienen al día por el equipo interno.

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-004-agendamiento-reuniones.md`
- Bloque funcional: Generación automática de convocatorias.
- Paso(s): 4–5 del flujo principal (generación de convocatoria según modalidad).

