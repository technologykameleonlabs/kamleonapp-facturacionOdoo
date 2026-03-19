# MF-003-US-004 — Publicar factura: asignar número definitivo (serie), pasar a Publicada, bloquear edición

**Epic**: MF-003 — Facturación núcleo

**Como** usuario con permiso de publicar, **quiero** confirmar/publicar la factura en borrador para que reciba el número definitivo según la serie configurada y pase a estado `Publicada`, **para** que el documento sea el oficial y quede bloqueado frente a ediciones fiscales.

**Criterios de aceptación**: Al publicar se asigna número definitivo por serie, se cambia estado a `Publicada` y se bloquean edición de campos fiscales/importes/líneas desde UI y backend.

### Campos de datos

| Campo                               | Descripción                                               | Tipo |
|-------------------------------------|-----------------------------------------------------------|------|
| factura.id                           | Identificador de factura                                   | Entero/UUID |
| factura.estado_documento           | Debe pasar de `Borrador` a `Publicada`                  | Enumerado |
| factura.numero                      | Número fiscal definitivo asignado                       | Texto |
| factura.serie_id                    | Serie documental usada para el número                    | Relación (FK) |
| serie_documental.nombre           | Nombre de la serie                                       | Texto |
| serie_documental.prefijo          | Prefijo de la serie                                     | Texto |
| serie_documental.siguiente_numero | Secuencia reservada/consumida                           | Entero |
| factura.lock_campos                | Flag/estado de bloqueo de campos fiscales                | Booleano |

### Estimación de esfuerzo (con IA)

- Servicio de publicación + transición de estados: **0,25 días**.
- Integración con numeración por series (reserva atómica): **0,25 días**.
- Bloqueo a nivel API (validaciones de no modificación): **0,2 días**.
- Actualización de UI (botón publicar + bloqueo visual): **0,1 días**.
- Total estimado para esta US: **~0,75 días** de desarrollo efectivo.

**Prioridad**: Alta
