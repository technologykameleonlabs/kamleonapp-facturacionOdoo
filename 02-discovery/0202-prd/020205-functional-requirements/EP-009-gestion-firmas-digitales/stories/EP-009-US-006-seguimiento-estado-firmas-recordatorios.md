# EP-009-US-006 — Seguimiento de estado de firmas y recordatorios

### Epic padre
EP-009 — Gestión de firmas digitales

### Contexto/Descripción y valor
**Como** Fátima/Paz,  
**quiero** ver en todo momento el estado de las firmas (pendiente cliente, pendiente ONGAKU, completado) y que el sistema envíe recordatorios automáticos si no se firma en tiempo razonable,  
**para** evitar olvidos y tener trazabilidad.

### Alcance
**Incluye:**
- Visibilidad del estado de firma del contrato: Enviado para revisión (pendiente cliente), Firmado por cliente (pendiente ONGAKU), Firmado por ambas partes (completado).
- Listado o vista donde Fátima/Paz pueda ver contratos pendientes de firma (por cliente o por ONGAKU) y fechas relevantes.
- Recordatorios automáticos configurables: por ejemplo, si el cliente no firma en X días, enviar recordatorio al cliente; si ONGAKU no firma en Y días tras firma del cliente, enviar recordatorio a ONGAKU.
- Registro de envío de recordatorios (opcional) para trazabilidad.
- Consulta de trazabilidad: quién firmó, cuándo, IP, dispositivo (según EP-009-US-002 y EP-009-US-004).

**Excluye:**
- Envío inicial del contrato al cliente (EP-008, EP-009-US-001).
- Acciones de firma en sí (EP-009-US-002, EP-009-US-004).
- Notificaciones puntuales al firmar (EP-009-US-003, EP-009-US-005).
- Activación de proyecto (EP-010).

### Precondiciones
- Contratos en estados de firma gestionados por EP-009 (Enviado para revisión, Firmado por cliente, Firmado por ambas partes).
- Reglas de recordatorios configuradas (días sin firma cliente / días sin firma ONGAKU) o valores por defecto.
- Usuario Fátima/Paz con permisos para ver estado de firmas y, si aplica, configuración de recordatorios.

### Postcondiciones
- Fátima/Paz puede ver en todo momento qué contratos están pendientes de firma (cliente o ONGAKU) y cuáles están completados.
- Si no se firma en el plazo configurado, se envían recordatorios automáticos (cliente y/o ONGAKU según corresponda).
- Trazabilidad de firmas consultable (quién, cuándo, IP, dispositivo).

### Flujo principal
1. Fátima/Paz accede al listado o dashboard de contratos / estado de firmas.
2. Sistema muestra para cada contrato: estado de firma (pendiente cliente, pendiente ONGAKU, completado), fechas (envío, firma cliente, firma ONGAKU si aplica).
3. Fátima/Paz puede filtrar por estado (ej. solo pendientes de firma ONGAKU) y ver detalle de trazabilidad (registros de firma).
4. Sistema, en background, evalúa periódicamente contratos "Enviado para revisión" sin firma del cliente durante X días: envía recordatorio al cliente (email o portal).
5. Sistema evalúa contratos "Firmado por cliente" sin firma de ONGAKU durante Y días: envía recordatorio a ONGAKU (email o sistema).
6. Sistema registra el envío de recordatorios (opcional) para no duplicar en exceso y para auditoría.

### Flujos alternos y excepciones

**Excepción 1: Recordatorio ya enviado**
- Si ya se envió recordatorio recientemente (ej. hace menos de Z días): no reenviar hasta cumplir intervalo configurado.

**Excepción 2: Contrato expirado o cancelado**
- Si el contrato pasa a estado Expirado o Rechazado: no enviar más recordatorios de firma.

**Excepción 3: Sin configuración de plazos**
- Si no hay plazos configurados: usar valores por defecto razonables (ej. 7 días cliente, 3 días ONGAKU) o no enviar recordatorios hasta que se configuren.

### Validaciones y reglas de negocio
- Los recordatorios solo se envían para estados "Enviado para revisión" (recordatorio al cliente) y "Firmado por cliente" (recordatorio a ONGAKU).
- Los plazos (X días, Y días) y la frecuencia de recordatorios deben ser configurables.
- La visibilidad del estado y la trazabilidad deben respetar permisos RBAC (solo usuarios autorizados ven datos de firmas).

### Criterios BDD
- **Escenario 1: Visualización de estado**
  - *Dado* que existen contratos en distintos estados de firma
  - *Cuando* Fátima accede al listado de estado de firmas
  - *Entonces* ve para cada contrato el estado (pendiente cliente, pendiente ONGAKU, completado) y las fechas relevantes

- **Escenario 2: Recordatorio al cliente**
  - *Dado* un contrato "Enviado para revisión" hace más de X días sin firma del cliente
  - *Cuando* se ejecuta el job de recordatorios
  - *Entonces* el sistema envía un recordatorio al cliente (email o portal) para que firme el contrato

- **Escenario 3: Recordatorio a ONGAKU**
  - *Dado* un contrato "Firmado por cliente" hace más de Y días sin firma de ONGAKU
  - *Cuando* se ejecuta el job de recordatorios
  - *Entonces* el sistema envía un recordatorio a Fátima/Paz para que firmen el contrato

- **Escenario 4: Trazabilidad**
  - *Dado* un contrato con al menos una firma registrada
  - *Cuando* Fátima consulta el detalle de firmas del contrato
  - *Entonces* puede ver quién firmó, cuándo y, si se registró, IP y dispositivo

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-009-gestion-firmas-digitales.md`
- Paso(s): Seguimiento de estado en todo el flujo; recordatorios (puntos de decisión 4.5); trazabilidad completa (pasos 6 y 9).
