# EP-022 — Generación automática de factura final

**Descripción:** Generación automática de factura del 50% restante al aceptar segunda entrega por el cliente, notificación de factura generada; el pago se gestiona fuera del sistema (sin pasarela de pago integrada).

**Proceso TO-BE origen:** TO-BE-022: Proceso de generación automática de factura final

**Bloque funcional:** Generación tras aceptación — Desde aceptación de segunda entrega hasta factura generada y notificada.

**Objetivo de negocio:** Generar automáticamente la factura final (50% restante) al aceptar segunda entrega y notificar al cliente; pago gestionado fuera del sistema.

**Alcance y exclusiones:**
- **Incluye:**
  - Detección de aceptación de segunda entrega (EP-021); primer pago (50%) ya recibido.
  - Generación automática de factura del 50% restante (número, monto, datos cliente, concepto).
  - Notificación automática al cliente de factura generada (acceso o adjunto según configuración).
  - Registro de factura y estado de pago (confirmación manual por administración si aplica).
- **Excluye:**
  - Incorporación de cambios y segunda entrega (EP-021).
  - Pasarela de pago integrada; pago se gestiona fuera del sistema.
  - Cierre automático de proyecto (EP-024) — requiere pago final recibido.

**KPIs (éxito):**
- 100% de facturas finales generadas automáticamente.
- Tiempo de generación < 2 minutos desde aceptación.
- Notificación automática de factura generada.

**Actores y permisos (RBAC):**
- **Sistema centralizado:** Generar factura automáticamente, notificar.
- **Cliente:** Recibir factura y realizar pago fuera del sistema.
- **Administración:** Gestionar recepción de pago fuera del sistema; confirmar pago si aplica.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-022-generacion-automatica-factura-final.md`

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-022-US-001 | Detección de aceptación segunda entrega y generación factura 50% | Como sistema centralizado, quiero detectar cuando el cliente acepta la segunda entrega (EP-021) y generar automáticamente la factura del 50% restante (número, monto, datos cliente, concepto), para tener factura lista en menos de 2 minutos | Definida | Alta |
| EP-022-US-002 | Notificación al cliente de factura generada | Como sistema centralizado, quiero notificar automáticamente al cliente cuando la factura final está generada (acceso o adjunto según configuración), para que sepa que debe realizar el pago | Definida | Alta |
| EP-022-US-003 | Registro de factura y estado de pago | Como sistema centralizado, quiero registrar la factura generada y el estado de pago (pendiente/recibido según confirmación de administración), para trazabilidad y EP-024 (cierre) | Definida | Alta |
| EP-022-US-004 | Administración confirma recepción de pago final | Como administración, quiero confirmar manualmente la recepción del pago final cuando el cliente ha pagado fuera del sistema, para que el proyecto pueda cerrarse (EP-024) | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`
