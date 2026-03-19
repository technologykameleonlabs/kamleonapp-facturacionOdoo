# MF-003-US-007 — Reglas de bloqueo: campos inamovibles tras publicar; cierre de periodo (opcional)

**Epic**: MF-003 — Facturación núcleo

**Como** usuario con permisos de facturación, **quiero** que tras publicar una factura se apliquen reglas de bloqueo para evitar modificaciones que rompan coherencia fiscal, **para** asegurar integridad del documento oficial.

**Criterios de aceptación**: Tras publicar, el backend bloquea modificaciones de campos fiscales y de contenido; la UI refleja la inamovilidad y, opcionalmente, se valida el cierre de periodo antes de publicar.

### Campos de datos

| Campo                           | Descripción                                                | Tipo |
|---------------------------------|------------------------------------------------------------|------|
| factura.estado_documento        | Estado que determina el bloqueo                             | Enumerado |
| factura.lock_campos_fiscales   | Flag/estrategia de bloqueo post-publicación               | Booleano |
| factura.fecha                   | Fecha de la factura (para validación de periodo)         | Fecha |
| periodo.estado                  | Estado del periodo (abierto/cerrado)                     | Enumerado |
| periodo.fecha_desde             | Inicio del periodo (si existe)                              | Fecha |
| periodo.fecha_hasta             | Fin del periodo (si existe)                                 | Fecha |
| bloqueo.periodo_cerrado        | Flag calculado para indicar si se puede publicar          | Booleano |

### Estimación de esfuerzo (con IA)

- Reglas backend de validación de bloqueo en edición/API: **0,25 días**.
- Bloqueo en UI (solo lectura/disabled): **0,15 días**.
- Validación de cierre de periodo (si está habilitado): **0,1 días**.
- Total estimado para esta US: **~0,5 días** de desarrollo efectivo.

**Prioridad**: Media

