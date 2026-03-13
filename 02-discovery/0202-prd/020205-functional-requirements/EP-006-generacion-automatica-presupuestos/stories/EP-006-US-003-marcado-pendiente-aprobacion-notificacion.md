# EP-006-US-003 — Marcado Pendiente de aprobación y notificación

### Epic padre
EP-006 — Generación automática de presupuestos

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** marcar el presupuesto como "Pendiente de aprobación" y notificar a Fátima/Paz con enlace al presupuesto y resumen,  
**para** que revisen y aprueben antes de enviar al cliente.

### Alcance
**Incluye:**
- Cambio de estado del presupuesto a "Pendiente de aprobación" tras personalización (EP-006-US-002).
- Notificación a Fátima/Paz (según línea de negocio o responsable asignado):
  - Enlace directo al presupuesto.
  - Resumen: cliente, servicios, precio total.
- Registro de timestamp de marcado y notificación.
- Bloqueo de envío al cliente hasta que el presupuesto esté "Aprobado".

**Excluye:**
- Revisión y modificación por Fátima/Paz (EP-006-US-004).
- Aprobación (EP-006-US-005).
- Envío al cliente (EP-006-US-006).

### Precondiciones
- Presupuesto personalizado y guardado (EP-006-US-002).
- Sistema de notificaciones operativo.
- Fátima/Paz tienen acceso al sistema y pueden recibir notificaciones.

### Postcondiciones
- Presupuesto en estado "Pendiente de aprobación".
- Fátima/Paz han recibido notificación con enlace y resumen.
- Presupuesto no puede enviarse al cliente hasta aprobación.

### Flujo principal
1. Sistema recibe confirmación de presupuesto personalizado (EP-006-US-002).
2. Sistema cambia estado del presupuesto a "Pendiente de aprobación".
3. Sistema construye resumen para la notificación (cliente, servicios, precio total).
4. Sistema envía notificación a Fátima/Paz (o responsable según línea de negocio):
   - Asunto: "Presupuesto listo para aprobación - [Cliente]"
   - Cuerpo: resumen y enlace directo al presupuesto.
5. Sistema registra timestamp de marcado y de envío de notificación.
6. Presupuesto queda visible en listado "Pendientes de aprobación" para Fátima/Paz.

### Flujos alternos y excepciones

**Excepción 1: Error al enviar notificación**
- Si falla el envío de la notificación:
- Sistema mantiene estado "Pendiente de aprobación" y reintenta notificación según política.
- Si persiste el error, registra y notifica al equipo técnico; presupuesto sigue visible en el listado.

### Validaciones y reglas de negocio
- Solo presupuestos personalizados y guardados pueden pasar a "Pendiente de aprobación".
- No se puede enviar presupuesto al cliente si el estado no es "Aprobado".
- Notificación debe incluir enlace válido al presupuesto.

### Criterios BDD
- **Escenario 1: Marcado y notificación exitosos**
  - *Dado* que un presupuesto ha sido personalizado correctamente
  - *Cuando* el sistema marca como Pendiente de aprobación y envía notificación
  - *Entonces* el presupuesto queda en estado "Pendiente de aprobación", Fátima/Paz reciben notificación con enlace y resumen, y el presupuesto no puede enviarse al cliente

- **Escenario 2 (negativo): Envío al cliente sin aprobar**
  - *Dado* que un presupuesto está en estado "Pendiente de aprobación"
  - *Cuando* se intenta enviar el presupuesto al cliente
  - *Entonces* el sistema no permite el envío y muestra mensaje indicando que debe aprobarse antes

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-006-generacion-automatica-presupuestos.md`
- Paso(s): Pasos 4–5 del flujo principal (marcado Pendiente de aprobación, notificación a Fátima/Paz).
