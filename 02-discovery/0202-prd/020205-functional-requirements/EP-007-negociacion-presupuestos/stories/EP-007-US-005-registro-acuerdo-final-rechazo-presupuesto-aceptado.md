# EP-007-US-005 — Registro de acuerdo final o rechazo y marcado presupuesto Aceptado

### Epic padre
EP-007 — Negociación de presupuestos

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** registrar cuando hay acuerdo final (versión aceptada, acuerdos documentados) o rechazo definitivo, y marcar el presupuesto como "Aceptado" cuando el cliente acepta,  
**para** dejarlo listo para generación de contrato (EP-008) y tener trazabilidad completa.

### Alcance
**Incluye:**
- Registro de **acuerdo final** cuando el cliente acepta (por portal, email o registro manual):
  - Versión final aceptada identificada (ej. PRES-{ID}-v{N}).
  - Acuerdos alcanzados documentados (resumen o campos estructurados: precio final, servicios, condiciones especiales si aplica).
  - Cambio de estado del presupuesto a "Aceptado".
  - Fecha y, si aplica, usuario que registra el acuerdo.
- Registro de **rechazo definitivo**:
  - Por cliente: estado "Rechazado por cliente"; fecha y trazabilidad.
  - Por ONGAKU: estado "Rechazado por ONGAKU"; fecha y trazabilidad (opcional, si se cierra la negociación sin acuerdo).
- Presupuesto "Aceptado" queda disponible como entrada para EP-008 (generación de contrato).
- Historial de negociación completo (todas las versiones y respuestas) sigue visible para auditoría.

**Excluye:**
- Generación del contrato (EP-008).
- Registro de respuestas intermedias (EP-007-US-001) o de decisiones (EP-007-US-003).

### Precondiciones
- Negociación en curso: presupuesto en "En negociación" o respuesta del cliente de tipo "Aceptación" o "Rechazo".
- Para acuerdo: cliente ha aceptado explícitamente (portal, email o registro manual confirmado).
- Para rechazo: cliente ha rechazado o ONGAKU cierra la negociación sin acuerdo.

### Postcondiciones
- **Si acuerdo:** Presupuesto en estado "Aceptado"; versión aceptada y acuerdos documentados registrados; listo para EP-008.
- **Si rechazo:** Presupuesto en estado "Rechazado por cliente" o "Rechazado por ONGAKU"; fecha y trazabilidad registradas; flujo de negociación cerrado.
- Trazabilidad completa de la negociación disponible (versiones, respuestas, decisión final).

### Flujo principal
1. Se produce el cierre de la negociación: cliente acepta o rechaza, o ONGAKU registra rechazo/cierre.
2. **Si el cliente acepta:**
   - Sistema (o usuario) registra "Acuerdo final" con la versión aceptada (última versión vigente).
   - Usuario o sistema documenta acuerdos alcanzados (precio final, servicios, condiciones si aplica).
   - Sistema cambia el estado del presupuesto a "Aceptado".
   - Sistema registra fecha (y usuario si es registro manual).
   - Presupuesto queda disponible para EP-008 (generación de contrato).
3. **Si el cliente rechaza:**
   - Sistema registra "Rechazo definitivo por cliente" con fecha.
   - Sistema cambia el estado del presupuesto a "Rechazado por cliente".
   - Flujo de negociación se da por cerrado.
4. **Si ONGAKU cierra sin acuerdo:**
   - Sistema registra "Rechazo por ONGAKU" o "Negociación cerrada sin acuerdo" con fecha.
   - Estado "Rechazado por ONGAKU".
5. En todos los casos, el historial de versiones y respuestas permanece accesible para trazabilidad.

### Flujos alternos y excepciones

**Flujo alterno 1: Aceptación por teléfono**
- Si el cliente acepta por teléfono:
- Fátima/Paz/Javi registra manualmente el acuerdo final y documenta los acuerdos; sistema marca presupuesto como "Aceptado" igual que si fuera por portal/email.

**Excepción 1: Intentar marcar Aceptado sin acuerdo registrado**
- Si se intenta pasar a "Aceptado" sin haber registrado la aceptación del cliente o el acuerdo:
- Sistema exige completar versión aceptada y al menos un resumen de acuerdos (o confirmación explícita) antes de guardar.

**Excepción 2: Presupuesto ya en estado final**
- Si el presupuesto ya está "Aceptado" o "Rechazado por cliente/ONGAKU":
- Sistema no permite cambiar a otro estado final sin flujo de anulación/corrección si existe.

### Validaciones y reglas de negocio
- Solo puede haber un estado final por presupuesto: "Aceptado", "Rechazado por cliente" o "Rechazado por ONGAKU".
- Para "Aceptado" es obligatorio identificar la versión aceptada y documentar acuerdos (mínimo precio final o resumen).
- Una vez en estado final, el presupuesto no vuelve a "En negociación" salvo proceso excepcional de reapertura si se define.

### Criterios BDD
- **Escenario 1: Acuerdo final y presupuesto Aceptado**
  - *Dado* que el cliente ha aceptado la última versión del presupuesto (portal o registrado manualmente)
  - *Cuando* se registra el acuerdo final con versión aceptada y acuerdos documentados
  - *Entonces* el sistema marca el presupuesto como "Aceptado", guarda la versión aceptada y los acuerdos, y deja el presupuesto listo para EP-008

- **Escenario 2: Rechazo por cliente**
  - *Dado* que el cliente ha comunicado rechazo
  - *Cuando* se registra el rechazo definitivo
  - *Entonces* el sistema marca el presupuesto como "Rechazado por cliente", registra la fecha y cierra la negociación

- **Escenario 3: Rechazo por ONGAKU**
  - *Dado* que ONGAKU decide cerrar la negociación sin acuerdo
  - *Cuando* se registra "Rechazo por ONGAKU"
  - *Entonces* el sistema marca el presupuesto como "Rechazado por ONGAKU", registra la fecha y cierra la negociación

- **Escenario 4 (negativo): Aceptado sin documentar acuerdos**
  - *Dado* que se intenta marcar presupuesto como "Aceptado"
  - *Cuando* no se ha indicado la versión aceptada o no se ha documentado al menos el acuerdo (precio final o resumen)
  - *Entonces* el sistema no guarda el estado "Aceptado" y solicita completar versión aceptada y acuerdos

### Notificaciones
- **Equipo comercial / Administración:** Opcional: notificación cuando un presupuesto pasa a "Aceptado" (para disparar EP-008 o seguimiento).
- **Cliente:** Opcional: confirmación por email o portal de que el presupuesto ha sido aceptado y próximos pasos (contrato).

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-007-negociacion-presupuestos.md`
- Paso(s): Pasos 7–8 del flujo principal (cliente responde acepta/rechaza; sistema registra acuerdo final o rechazo y marca Aceptado cuando aplica).
