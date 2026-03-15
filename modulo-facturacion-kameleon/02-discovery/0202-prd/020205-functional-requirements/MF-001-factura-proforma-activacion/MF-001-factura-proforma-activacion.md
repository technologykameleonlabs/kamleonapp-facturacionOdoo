# MF-001 — Activación de proyecto (sin pago inicial obligatorio)

**Contexto**: La facturación de proyectos es **mensual** por tareas/horas/hitos/fee (MF-007).

**Descripción**: El proyecto se **activa** por contrato firmado, por acción manual del usuario o por otro criterio de negocio definido. Opcionalmente se puede registrar un anticipo o pago inicial acordado (cualquier importe) y generar una factura por ese monto; reserva de fecha en calendario y notificaciones al equipo y al cliente.

**Proceso TO-BE**: TO-BE-MF-01 — Activación de proyecto (y opcional factura de anticipo)

**Objetivo de negocio**: Activar el proyecto para poder facturar mensualmente (MF-007) sin depender de un pago previo; opcionalmente documentar un anticipo con factura y notificar.

**Alcance**:
- **Incluye**: Activación del proyecto (cambio de estado a "Activo", registro de fecha de activación); disparador por contrato firmado, por acción manual o por regla configurable. Opcional: registro de un anticipo/pago inicial (importe acordado) y generación de factura por ese importe; reserva de fecha en calendario; notificaciones a equipo y cliente; registro de activación.
- **Excluye**: Pasarela de pago integrada. La facturación principal del proyecto es mensual (MF-007).

---

## Historias de usuario (índice)

| ID | Título | Estado | Prioridad |
|----|--------|--------|-----------|
| MF-001-US-001 | Activación del proyecto (manual o por evento: contrato firmado) | Definida | Alta |
| MF-001-US-002 | Opcional: registro de anticipo/pago inicial y generación de factura por monto acordado | Definida | Media |
| MF-001-US-003 | Registro de fecha de activación y notificaciones a equipo y cliente | Definida | Alta |
| MF-001-US-004 | Reserva automática de fecha en calendario (si aplica) | Definida | Media |
| MF-001-US-005 | Registro de activación (timestamp, referencia factura si hay anticipo) para trazabilidad | Definida | Alta |

> Detalle en carpeta `/stories`
