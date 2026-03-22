# MF-001-US-002 — Prefactura por importe total al activar (cupo consumible en facturas mensuales)

**Epic**: MF-001 — Activación de proyecto y prefactura por importe total

**Como** usuario, **quiero** que, al activar el proyecto, quede registrada una **prefactura** por el **importe total acordado** del proyecto, **para** disponer de un saldo explícito que las **facturas mensuales** irán consumiendo hasta cero (MF-007 + MF-008).

**Criterios de aceptación**:
- El **importe de la prefactura** debe coincidir con el **total acordado** del proyecto (`presupuesto_total` / `total_acordado` u origen equivalente definido en el modelo de proyecto). Si el total no está definido, el flujo de activación debe solicitarlo o bloquear la finalización según política documentada.
- La prefactura se crea en el **contexto de activación** (mismo asistente, paso posterior inmediato o transacción ligada), no como flujo opcional desconectado en esta versión.
- **Una sola prefactura/cupo** por proyecto en esta versión (no duplicar cupos salvo rectificación explícita fuera de alcance inicial).
- El sistema genera el documento o registro de prefactura asociado al proyecto con:
  - cliente de facturación del proyecto
  - importe = total acordado
  - concepto descriptivo (ej. `Proyecto [nombre] – Prefactura / cupo total`)
  - moneda coherente con el proyecto
- **Decisión fiscal** (véase MF-001 épica y MF-003-US-011):
  - Si el documento es **proforma / no fiscal**: no exigir numeración fiscal; guardar tipo documental `prefactura_proforma` (o equivalente).
  - Si el documento es **factura fiscal**: asignar **número por serie** configurada al publicar, según MF-003.
- El registro queda disponible para **aplicación / descuento** en facturas de periodo (MF-008); el **saldo pendiente** = importe total − importe ya aplicado en facturas publicadas.
- Idempotencia: reintentos del flujo de activación no deben crear una segunda prefactura/cupo para el mismo proyecto.

### Campos de datos

| Campo                     | Descripción                                         | Tipo |
|---------------------------|-----------------------------------------------------|------|
| proyecto.total_acordado   | Importe total del contrato (fuente del cupo)       | Numérico (decimal) |
| prefactura.proyecto_id    | Proyecto al que se asocia el cupo                  | Relación (FK) |
| prefactura.importe_total  | Importe total del cupo (= total acordado al crear) | Numérico (decimal) |
| prefactura.importe_aplicado | Suma aplicada en facturas (actualizado vía MF-008) | Numérico (decimal) |
| prefactura.saldo_pendiente | importe_total − importe_aplicado (derivado o guardado) | Numérico (decimal) |
| prefactura.documento_id   | Referencia al documento contable/PDF si aplica      | Relación (FK) |
| prefactura.tipo_documental | proforma \| factura_fiscal (según decisión)       | Enumerado |

### Estimación de esfuerzo (con IA)

- Modelado prefactura/cupo + validación total = proyecto: **0,25 días**.
- Lógica/API generación documento y vínculo activación: **0,4 días**.
- Integración serie/tipo documental (MF-003) + saldo inicial MF-008: **0,35 días**.
- Total estimado para esta US: **~1 días** de desarrollo efectivo.

**Prioridad**: Alta
