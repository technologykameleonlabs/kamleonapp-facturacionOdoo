# MF-001 — Activación de proyecto y prefactura por importe total

**Contexto**: La facturación del proyecto es **mensual** (MF-007); las facturas de periodo **consumen** el saldo de la prefactura hasta llegar a cero (mecánica descrita en MF-008 como anticipo / aplicación a facturas).

**Descripción**: El proyecto se **activa** por contrato firmado, por acción manual del usuario o por otro criterio de negocio definido. **En el alcance de la versión actual**, junto con la activación se registra una **prefactura** por el **importe total acordado** del proyecto (misma magnitud que el total del contrato/presupuesto). Ese importe constituye un **cupo** que las facturas mensuales posteriores van **rebajando** hasta **saldo 0**. No se exige pasarela de pago integrada en la activación.

**Proceso TO-BE**: TO-BE-MF-01 — Activación de proyecto y prefactura total

**Objetivo de negocio**: Activar el proyecto con un **techo de facturación** explícito (prefactura = total) y permitir **facturas mensuales** que consuman ese saldo de forma trazable (MF-007 + MF-008).

**Glosario**:
- **Prefactura (cupo del proyecto)**: documento o registro que fija el **importe total** consumible mediante facturas posteriores del mismo proyecto; el **saldo pendiente** disminuye al aplicar importes en facturas de periodo publicadas (MF-008).

### Decisión fiscal (pendiente de cierre con negocio/legal)

La implementación depende de si la prefactura se emite como:

| Opción | Implicación breve |
|--------|-------------------|
| **A — Proforma / sin numeración fiscal** | Documento informativo o borrador contable; la numeración fiscal aplica a las **facturas mensuales**; evitar doble conteo en “total facturado” mostrado al cliente (definir qué sumas se muestran). |
| **B — Factura fiscal** | Serie propia o tipo “prefactura”; numeración oficial desde publicación; alinear impuestos y contabilidad con Odoo/localización. |

**Hasta decidir A o B**, los criterios de aceptación de US-002 y MF-003-US-011 contemplan **ambas ramas** (numeración obligatoria solo si el documento es fiscal).

**Alcance**:

- **Incluye**: Activación del proyecto (cambio de estado a "Activo", registro de fecha de activación); disparador por contrato firmado, por acción manual o por regla configurable. **Prefactura por importe total** del proyecto al activar (una por proyecto en esta versión); reserva de fecha en calendario; notificaciones a equipo y cliente; registro de activación y vínculo a documento de prefactura.
- **Excluye**: Pasarela de pago integrada. Detalle completo del consumo en facturas mensuales (líneas desde tareas/horas/hitos) puede ampliarse en MF-007; la **regla de saldo** y aplicación contra prefactura se cubre en MF-008.

---

## Historias de usuario (índice)


| ID            | Título                                                                                   | Estado   | Prioridad |
| ------------- | ---------------------------------------------------------------------------------------- | -------- | --------- |
| MF-001-US-001 | Activación del proyecto (manual o por evento: contrato firmado)                          | Definida | Alta      |
| MF-001-US-002 | Prefactura por importe total al activar (cupo consumible en facturas mensuales)        | Definida | Alta      |
| MF-001-US-003 | Registro de fecha de activación y notificaciones a equipo y cliente                      | Definida | Alta      |
| MF-001-US-004 | Reserva automática de fecha en calendario (si aplica)                                    | Definida | Media     |
| MF-001-US-005 | Registro de activación (timestamp, referencia prefactura) para trazabilidad              | Definida | Alta      |


> Detalle en carpeta `/stories`

