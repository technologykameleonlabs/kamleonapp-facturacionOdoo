# MF-007-US-008 — Prerellenar cliente/contacto de facturación desde proyecto

**Epic**: MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

**Como** usuario con permiso de facturación, **quiero** que al crear la factura de periodo desde un proyecto el **cliente de facturación** se rellene automáticamente desde el proyecto, **para** reducir errores y tiempo de captura.

**Criterios de aceptación**:
- Al iniciar factura de periodo desde proyecto, `factura.cliente_id` se prerrellena con el cliente/contacto configurado en el proyecto (mismo criterio que maestros **MF-011**).
- El usuario puede cambiar el cliente en borrador **solo si** la política de negocio lo permite; si no, el campo queda bloqueado o validado contra proyecto.
- Validación: cliente con datos mínimos para facturar antes de permitir publicar (coherente con MF-003/MF-011).

### Campos de datos

| Campo | Descripción | Tipo |
|-------|-------------|------|
| proyecto.cliente_id | Origen del prerrelleno | Relación (FK) |
| factura.cliente_id | Cliente en la factura | Relación (FK) |

### Estimación de esfuerzo (con IA)

- Copia cliente al crear borrador + UI: **0,15–0,35 días**.
- Validaciones mínimas: **0,1–0,2 días**.
- Total estimado para esta US: **~0,25–0,55 días** de desarrollo efectivo.

**Prioridad**: Alta
