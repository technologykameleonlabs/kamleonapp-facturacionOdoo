# EP-010 — Activación automática de proyectos

**Descripción:** Detección automática de recepción del primer pago (50%) tras contrato firmado, generación automática de factura proforma, activación del proyecto (estado Activo), reserva automática de fecha en calendario integrado y notificaciones al equipo y al cliente.

**Proceso TO-BE origen:** TO-BE-010: Proceso de activación automática de proyectos tras pago

**Bloque funcional:** Activación tras detección de pago — Desde detección de pago recibido hasta proyecto activado y fecha reservada.

**Objetivo de negocio:** Activar automáticamente todos los proyectos al recibir el primer pago, eliminar intervención manual, generar factura de forma automática y reservar la fecha con notificaciones a equipo y cliente.

**Alcance y exclusiones:**
- **Incluye:**
  - Detección de recepción de pago: cliente sube justificante en portal o administración confirma recepción manualmente.
  - Validación de que el monto corresponde al 50% del presupuesto.
  - Generación automática de factura proforma (número, monto 50%, datos cliente, concepto).
  - Activación automática del proyecto (estado "Activo", fecha de activación registrada).
  - Reserva automática de fecha (bloqueo en calendario, integración Google Calendar — TO-BE-011 se ejecuta en este proceso).
  - Notificaciones automáticas al equipo de proyecto (proyecto activado, fecha reservada) y al cliente (pago recibido, factura generada, proyecto activado).
  - Registro de activación con timestamp y datos del pago.
- **Excluye:**
  - Gestión de firmas digitales (EP-009).
  - Pasarela de pago integrada (el pago se gestiona fuera del sistema).
  - EP-011 como epic separado de ejecución posterior (la reserva de fecha se ejecuta dentro de este proceso).
  - Registro de tiempo por proyecto (EP-012) y gestión de recursos (EP-013) — requieren proyecto ya activado.

**KPIs (éxito):**
- 100% de proyectos activados automáticamente al recibir pago.
- Tiempo de activación < 5 minutos desde recepción de pago.
- Factura generada automáticamente en todos los casos.
- Fecha reservada automáticamente.
- Notificaciones enviadas a equipo y cliente.

**Actores y permisos (RBAC):**
- **Sistema centralizado:** Detectar pago, validar monto, generar factura, activar proyecto, reservar fecha, notificar.
- **Cliente:** Subir justificante de pago en portal.
- **Administración:** Confirmar recepción de pago manualmente si es necesario.
- **Equipo de proyecto:** Recibe notificación de activación (solo lectura del estado).

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-010-activacion-automatica-proyectos.md`
- Bloque funcional: Activación tras detección de pago con generación de factura y reserva de fecha.
- Pasos: 1–8 del flujo principal (detección de pago hasta proyecto activado y notificaciones).

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-010-US-001 | Detección de recepción de pago (justificante o confirmación manual) | Como cliente o administración, quiero registrar la recepción del primer pago (cliente subiendo justificante en portal o administración confirmando manualmente), para que el sistema pueda validar y activar el proyecto automáticamente | Definida | Alta |
| EP-010-US-002 | Validación de monto 50% y generación automática de factura proforma | Como sistema centralizado, quiero validar que el monto recibido corresponde al 50% del presupuesto y generar automáticamente la factura proforma (número, monto, datos cliente, concepto), para garantizar coherencia y tener factura lista sin intervención manual | Definida | Alta |
| EP-010-US-003 | Activación automática del proyecto | Como sistema centralizado, quiero activar automáticamente el proyecto (estado "Activo", fecha de activación registrada) cuando el pago es válido y la factura generada, para que el proyecto quede disponible para gestión de recursos y tiempo (EP-012, EP-013) | Definida | Alta |
| EP-010-US-004 | Reserva automática de fecha en calendario | Como sistema centralizado, quiero reservar automáticamente la fecha del proyecto en el calendario integrado (bloqueo, integración Google Calendar) tras la activación, para que la fecha quede bloqueada y confirmada sin pasos manuales (TO-BE-011) | Definida | Alta |
| EP-010-US-005 | Notificaciones a equipo y cliente y registro de activación | Como sistema centralizado, quiero notificar automáticamente al equipo de proyecto (proyecto activado, fecha reservada) y al cliente (pago recibido, factura generada, proyecto activado), y registrar la activación con timestamp y datos del pago, para que todas las partes tengan visibilidad y trazabilidad | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Estado del proyecto:** Borrador/Contrato firmado, Activo (tras pago recibido y validado).
- **Factura proforma:** Número automático, monto 50%, datos cliente, concepto (nombre proyecto/boda y fecha).
- **Registro de activación:** Timestamp, datos del pago, factura generada, fecha reservada.
- **Método de detección de pago:** Justificante subido por cliente en portal; confirmación manual por administración.

### Reglas de numeración/ID específicas
- El proyecto tiene identificador desde contrato/presupuesto; la activación se vincula por proyecto_id.
- Factura: formato según convención del proyecto (ej. FACT-{año}-{secuencial}).
