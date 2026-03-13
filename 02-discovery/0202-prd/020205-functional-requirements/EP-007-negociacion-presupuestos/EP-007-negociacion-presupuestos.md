# EP-007 — Negociación de presupuestos

**Descripción:** Sistema de registro estructurado de contrapropuestas, ajustes de precio y modificaciones de servicios, con registro de todas las versiones del presupuesto y acuerdos alcanzados, garantizando trazabilidad completa de la negociación hasta acuerdo final o rechazo.

**Proceso TO-BE origen:** TO-BE-007: Proceso de negociación de presupuestos

**Bloque funcional:** Gestión de contrapropuestas — Flujo completo desde respuesta del cliente al presupuesto hasta acuerdo final (presupuesto aceptado) o rechazo, con trazabilidad de versiones y acuerdos.

**Objetivo de negocio:** Eliminar la pérdida de información de negociación y los malentendidos sobre acuerdos, registrando el 100% de las versiones del presupuesto y documentando los acuerdos alcanzados, con tiempo de respuesta a contrapropuestas < 24 horas.

**Alcance y exclusiones:**
- **Incluye:**
  - Registro de respuesta del cliente (contrapropuesta de precio, modificación de servicios, ajustes o extras).
  - Revisión de contrapropuesta por Fátima/Paz/Javi (dashboard, comparación entre versiones).
  - Decisión: aceptar, rechazar o proponer contrapropuesta alternativa.
  - Registro de nueva versión del presupuesto (versión anterior archivada, comparación automática).
  - Envío de respuesta al cliente (nueva versión o decisión).
  - Registro de acuerdo final (versión aceptada, acuerdos documentados) o rechazo definitivo.
  - Marcado de presupuesto como "Aceptado" cuando hay acuerdo (listo para EP-008).
- **Excluye:**
  - Generación de presupuestos (EP-006).
  - Generación de contratos (EP-008).
  - Envío inicial del presupuesto al cliente (EP-006).

**KPIs (éxito):**
- 100% de versiones de presupuesto registradas.
- Trazabilidad completa de negociación.
- Acuerdos alcanzados documentados.
- Tiempo de respuesta a contrapropuestas < 24 horas.

**Actores y permisos (RBAC):**
- **Fátima/Paz/Javi:** Revisar contrapropuestas, decidir (aceptar/rechazar/contrapropuesta), registrar nueva versión, enviar respuesta al cliente (según línea de negocio y permisos).
- **Cliente:** Enviar contrapropuesta o aceptar/rechazar (portal o email).
- **Sistema centralizado:** Registrar respuestas, versiones y acuerdos (proceso automático de registro).

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-007-negociacion-presupuestos.md`
- Bloque funcional: Gestión de contrapropuestas con trazabilidad completa.
- Pasos: 1–8 del flujo principal (respuesta del cliente hasta acuerdo final o rechazo).

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-007-US-001 | Registro de respuesta del cliente (contrapropuesta) | Como sistema centralizado, quiero registrar la respuesta del cliente al presupuesto (contrapropuesta de precio, modificación de servicios, ajustes o extras) con tipo, cambios solicitados y fecha, para tener trazabilidad de la negociación | Definida | Alta |
| EP-007-US-002 | Revisión de contrapropuesta y comparación de versiones | Como Fátima/Paz/Javi, quiero revisar la contrapropuesta del cliente y ver una comparación automática entre la versión actual del presupuesto y lo que solicita el cliente, para decidir si acepto, rechazo o propongo alternativa | Definida | Alta |
| EP-007-US-003 | Decisión y registro de nueva versión del presupuesto | Como Fátima/Paz/Javi, quiero decidir aceptar la contrapropuesta, rechazarla y mantener la versión original, o proponer una contrapropuesta alternativa, y que el sistema registre la nueva versión del presupuesto (archivando la anterior) con comparación automática, para mantener trazabilidad de todas las versiones | Definida | Alta |
| EP-007-US-004 | Envío de respuesta al cliente | Como Fátima/Paz/Javi, quiero enviar al cliente la respuesta (nueva versión del presupuesto o decisión de rechazo/mantenimiento) con explicación si aplica, para que el cliente pueda aceptar, rechazar o hacer una nueva contrapropuesta | Definida | Alta |
| EP-007-US-005 | Registro de acuerdo final o rechazo y marcado presupuesto Aceptado | Como sistema centralizado, quiero registrar cuando hay acuerdo final (versión aceptada, acuerdos documentados) o rechazo definitivo, y marcar el presupuesto como "Aceptado" cuando el cliente acepta, para dejarlo listo para generación de contrato (EP-008) y tener trazabilidad completa | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Contrapropuesta:** Respuesta del cliente al presupuesto (cambio de precio, servicios o extras).
- **Versión de presupuesto:** Cada iteración del presupuesto durante la negociación (v1, v2, …).
- **Estado de negociación:** En negociación, Aceptado, Rechazado por cliente, Rechazado por ONGAKU.

### Reglas de numeración/ID específicas
- Formato de versión de presupuesto: `PRES-{ID_REUNION}-v{N}`
