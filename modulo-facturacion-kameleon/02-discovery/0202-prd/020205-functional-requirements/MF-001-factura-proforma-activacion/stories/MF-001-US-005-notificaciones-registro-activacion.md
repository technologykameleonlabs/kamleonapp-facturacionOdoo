# MF-001-US-005 — Registro de activación (timestamp y trazabilidad)

**Epic**: MF-001 — Activación de proyecto y prefactura por importe total

**Como** sistema, **quiero** guardar un registro de activación con `proyecto_id`, timestamp, disparador (usuario/evento), referencia al documento/registro de **prefactura** (US-002) si existe y referencia de fecha reservada si aplica, **para** auditoría, trazabilidad y para evitar ejecuciones duplicadas del flujo de activación.

**Criterios de aceptación**:
- Se crea/actualiza un registro de activación persistente por proyecto y evento de activación.
- El registro incluye:
  - `proyecto_id`
  - `timestamp`
  - `disparador_activacion` (acción manual / contrato_firmado / regla)
  - referencia a **prefactura/cupo** si se generó (US-002)
  - referencia/fecha reservada si se reservó (US-004)
- Idempotencia: ante reintentos, el sistema no debe generar registros duplicados equivalentes.

### Campos de datos

| Campo                             | Descripción                               | Tipo |
|-----------------------------------|-------------------------------------------|------|
| activacion.registro_id           | Identificador del registro               | Entero/UUID |
| activacion.proyecto_id           | Proyecto asociado                         | Relación (FK) |
| activacion.timestamp             | Fecha/hora del momento de activación     | Fecha/hora |
| activacion.disparador_activacion | Origen de la activación                   | Enumerado |
| activacion.activated_by         | Usuario/sistema que disparó               | Relación / Texto corto |
| activacion.prefactura_id / documento_id | Referencia a prefactura o cupo (si existe) | Relación (FK) |
| activacion.calendario_evento_id | Evento calendario asociado (si aplica)    | Texto / Relación |

### Estimación de esfuerzo (con IA)

- Modelo/migración del registro de activación: **0,15 días**.
- Persistencia, idempotencia y API/servicio: **0,1 días**.
- Integración con el flujo de activación (pasar IDs/timestamps): **0,05 días**.
- Total estimado para esta US: **~0,3 días** de desarrollo efectivo.

**Prioridad**: Alta

