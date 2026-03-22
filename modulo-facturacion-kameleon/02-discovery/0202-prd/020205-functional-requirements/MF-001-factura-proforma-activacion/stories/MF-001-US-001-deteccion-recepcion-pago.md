# MF-001-US-001 — Activación del proyecto (manual o por evento: contrato firmado)

**Epic**: MF-001 — Activación de proyecto y prefactura por importe total

**Como** usuario o sistema, **quiero** activar el proyecto (cambio de estado a `Activo`) de forma manual (acción `Activar proyecto`) o automáticamente cuando se detecte contrato firmado u otra regla configurable, **para** que el proyecto quede disponible para producción.

**Criterios de aceptación**:
- La activación cambia `proyecto.estado` a `Activo` y registra `proyecto.fecha_activacion` (fecha/hora).
- El disparador puede ser manual (usuario con permiso) o por evento/regla (contrato firmado u otra regla configurable).
- Idempotencia: si el proyecto ya está en `Activo`, no se duplica la activación ni se genera un nuevo registro equivalente (el sistema mantiene consistencia).
- Se valida que el proyecto está en un estado habilitado para activación (p.ej. pendiente/contrato firmado) y se rechaza si no cumple.
- La activación **no depende de cobro online** (pasarela). En el alcance de la versión actual, el flujo de activación debe enlazar con la **prefactura por importe total** (MF-001-US-002) como paso requerido del proceso de puesta en marcha del proyecto.

### Campos de datos

| Campo                          | Descripción                                                | Tipo |
|--------------------------------|------------------------------------------------------------|------|
| proyecto.id                    | Identificador del proyecto                                | Entero/UUID |
| proyecto.estado                | Estado del proyecto (`Pendiente` -> `Activo`)          | Enumerado |
| proyecto.fecha_activacion     | Fecha/hora de activación                                  | Fecha/hora |
| proyecto.activated_by         | Usuario o sistema que dispara la activación              | Relación / Texto corto |
| proyecto.disparador_activacion| Tipo de disparador (manual, contrato_firmado, regla)    | Enumerado |

### Estimación de esfuerzo (con IA)

- Validaciones de transición de estados + idempotencia: **0,35 días**.
- Lógica de activación (disparadores) + API/servicio: **0,55 días**.
- Ajustes UI en ficha de proyecto (acción `Activar proyecto`) y manejo de errores: **0,30 días**.
- Total estimado para esta US: **~1,2 días** de desarrollo efectivo.

**Prioridad**: Alta
