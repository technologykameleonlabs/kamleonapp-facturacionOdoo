# MF-007-US-003 — Generar líneas desde horas registradas facturables en el periodo (no facturadas)

**Epic**: MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

**Como** usuario con permiso de facturación, **quiero** que el sistema agrupe las horas facturables del proyecto en el periodo y genere líneas de factura, **para** facturar el tiempo imputable sin duplicar registros ya facturados.

**Criterios de aceptación**:
- Se consultan registros de tiempo del proyecto en el periodo marcados como **facturables** y **no vinculados** a una factura previa.
- Las líneas se generan por **agrupación** acordada (p. ej. por recurso, por tipo de actividad o una sola línea resumen) con descripción, horas, tarifa e importe.
- El usuario puede ajustar o eliminar líneas en borrador (MF-003).
- Al publicar, los registros de tiempo incluidos quedan vinculados a la factura (o tabla de asignación).

### Campos de datos

| Campo | Descripción | Tipo |
|-------|-------------|------|
| linea.origen_tipo | Valor `horas` o agrupación | Enumerado |
| registro_tiempo.facturable | Filtro de inclusión | Booleano |
| registro_tiempo.factura_id | Asignación tras publicar | Relación (FK) / Null |
| registro_tiempo.fecha | Dentro del periodo | Fecha |

### Estimación de esfuerzo (con IA)

- Agregación horas + reglas de tarifa: **0,5–1 día**.
- Vínculo factura–registros al publicar: **0,25–0,5 días**.
- Total estimado para esta US: **~0,75–1,5 días** de desarrollo efectivo.

**Prioridad**: Alta
