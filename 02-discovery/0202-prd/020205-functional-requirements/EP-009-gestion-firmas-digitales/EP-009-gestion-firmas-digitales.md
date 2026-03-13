# EP-009 — Gestión de firmas digitales

**Descripción:** Seguimiento del estado de firmas del contrato (pendiente cliente, pendiente ONGAKU, completado), con notificaciones automáticas en cada etapa y trazabilidad completa de quién firmó cuándo, hasta contrato firmado por ambas partes y listo para activación de proyecto (EP-010).

**Proceso TO-BE origen:** TO-BE-009: Proceso de gestión de firmas digitales

**Bloque funcional:** Seguimiento de estado de firmas — Desde contrato enviado al cliente hasta contrato firmado por ambas partes.

**Objetivo de negocio:** Eliminar olvidos de firma, dar visibilidad del estado de firmas y garantizar trazabilidad completa con notificaciones automáticas en cada etapa.

**Alcance y exclusiones:**
- **Incluye:**
  - Estado "Enviado para revisión" cuando el contrato se envía al cliente (tras EP-008).
  - Disponibilidad del contrato para el cliente en portal o por enlace (revisar y firmar).
  - Firma digital del cliente con registro (quién, cuándo, IP, dispositivo).
  - Notificación automática a ONGAKU cuando el cliente firma.
  - Firma digital de ONGAKU con registro y estado "Firmado por ambas partes".
  - Notificación automática a cliente y ONGAKU cuando el contrato está completamente firmado.
  - Seguimiento de estado (pendiente cliente, pendiente ONGAKU, completado) y recordatorios si no se firma en tiempo razonable.
- **Excluye:**
  - Generación y envío del contrato al cliente (EP-008).
  - Activación automática de proyectos (EP-010).

**KPIs (éxito):**
- 100% de firmas con seguimiento de estado.
- Notificaciones automáticas en cada etapa.
- Trazabilidad completa de quién firmó cuándo.
- 0% de olvidos de firma (recordatorios y visibilidad).

**Actores y permisos (RBAC):**
- **Sistema centralizado:** Marcar estados, registrar firmas, enviar notificaciones y recordatorios.
- **Cliente:** Recibe contrato, revisa y firma digitalmente en portal o enlace.
- **Fátima/Paz (ONGAKU):** Firma el contrato tras la firma del cliente; visibilidad del estado de firmas.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-009-gestion-firmas-digitales.md`
- Bloque funcional: Seguimiento de estado de firmas con notificaciones y trazabilidad.
- Pasos: 3–10 del flujo principal (envío para revisión hasta contrato firmado por ambas partes).

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-009-US-001 | Estado Enviado para revisión y disponibilidad para el cliente | Como sistema centralizado, quiero marcar el contrato como "Enviado para revisión" y ponerlo a disposición del cliente (portal o enlace) cuando Fátima/Paz lo envía, para que el cliente pueda revisar y firmar | Definida | Alta |
| EP-009-US-002 | Firma digital del cliente con registro y trazabilidad | Como cliente, quiero firmar el contrato digitalmente en portal o enlace, para dar mi consentimiento de forma válida; el sistema registra quién, cuándo, IP y dispositivo | Definida | Alta |
| EP-009-US-003 | Notificación automática a ONGAKU cuando el cliente firma | Como sistema centralizado, quiero notificar automáticamente a ONGAKU cuando el cliente firma el contrato, para que ONGAKU proceda a firmar y no se olvide | Definida | Alta |
| EP-009-US-004 | Firma digital de ONGAKU y estado Firmado por ambas partes | Como Fátima/Paz (ONGAKU), quiero firmar el contrato digitalmente una vez el cliente ha firmado, para completar el acuerdo; el sistema registra la firma y marca "Firmado por ambas partes" | Definida | Alta |
| EP-009-US-005 | Notificación de contrato completamente firmado | Como sistema centralizado, quiero notificar automáticamente a cliente y ONGAKU cuando el contrato está firmado por ambas partes, para que ambas partes tengan constancia y el contrato quede listo para EP-010 | Definida | Alta |
| EP-009-US-006 | Seguimiento de estado de firmas y recordatorios | Como Fátima/Paz, quiero ver en todo momento el estado de las firmas (pendiente cliente, pendiente ONGAKU, completado) y que el sistema envíe recordatorios automáticos si no se firma en tiempo razonable, para evitar olvidos y tener trazabilidad | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Estado de firma del contrato:** Enviado para revisión, Firmado por cliente, Firmado por ambas partes; opcional: Rechazado, Expirado.
- **Registro de firma:** Firmante (cliente / usuario ONGAKU), fecha y hora, IP, dispositivo (opcional).
- **Recordatorios:** Configurables (ej. días sin firma cliente / ONGAKU).

### Reglas de numeración/ID específicas
- El contrato ya tiene identificador desde EP-008; las firmas pueden vincularse por contrato_id y secuencia (cliente = 1, ONGAKU = 2).
