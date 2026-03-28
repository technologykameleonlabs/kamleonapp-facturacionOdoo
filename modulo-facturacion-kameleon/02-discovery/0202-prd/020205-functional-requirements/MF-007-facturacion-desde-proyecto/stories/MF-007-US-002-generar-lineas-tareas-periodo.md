# MF-007-US-002 — Generar líneas desde tareas realizadas en el periodo (no facturadas previamente)

**Epic**: MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

**Como** usuario con permiso de facturación, **quiero** que el sistema proponga líneas de factura a partir de las tareas del proyecto completadas en el periodo seleccionado y aún no facturadas, **para** no duplicar trabajo y acelerar la facturación mensual.

**Criterios de aceptación**:
- Se consultan tareas del proyecto con estado completado (o equivalente) cuya fecha de cierre cae dentro del periodo y **sin** `factura_id` / vínculo de facturación previo.
- Por cada tarea elegible: se crea línea con descripción (nombre tarea) e importe según precio fijo o horas × tarifa según configuración del proyecto/módulo.
- El usuario puede **excluir** líneas o **editar** en borrador (MF-003) antes de publicar.
- Al **publicar** la factura, las tareas incluidas quedan marcadas como facturadas (vínculo a factura/línea).

### Campos de datos

| Campo | Descripción | Tipo |
|-------|-------------|------|
| linea.origen_tipo | Valor `tarea` | Enumerado |
| linea.origen_id | Identificador de la tarea | Entero / UUID |
| tarea.estado | Completada / equivalente | Enumerado |
| tarea.fecha_cierre | Para filtrar por periodo | Fecha |
| tarea.factura_id | Asignación tras publicar (o tabla intermedia) | Relación (FK) / Null |

### Estimación de esfuerzo (con IA)

- Consulta y filtrado por periodo + generación de líneas: **0,5–0,75 días**.
- Marcado facturado al publicar + pruebas: **0,25–0,5 días**.
- Total estimado para esta US: **~0,75–1,25 días** de desarrollo efectivo.

**Prioridad**: Alta
