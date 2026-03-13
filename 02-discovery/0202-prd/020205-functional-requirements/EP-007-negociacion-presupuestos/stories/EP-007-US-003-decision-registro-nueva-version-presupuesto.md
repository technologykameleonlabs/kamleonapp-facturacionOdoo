# EP-007-US-003 — Decisión y registro de nueva versión del presupuesto

### Epic padre
EP-007 — Negociación de presupuestos

### Contexto/Descripción y valor
**Como** Fátima/Paz/Javi,  
**quiero** decidir aceptar la contrapropuesta, rechazarla y mantener la versión original, o proponer una contrapropuesta alternativa, y que el sistema registre la nueva versión del presupuesto (archivando la anterior) con comparación automática,  
**para** mantener trazabilidad de todas las versiones.

### Alcance
**Incluye:**
- Tomar decisión sobre la contrapropuesta: Aceptar, Rechazar (mantener original), Contrapropuesta alternativa.
- Si Aceptar: sistema registra que se acepta la contrapropuesta del cliente; nueva versión = incorporar cambios del cliente; versión anterior archivada.
- Si Rechazar: sistema registra rechazo y mantiene versión original vigente; no se crea nueva versión de presupuesto.
- Si Contrapropuesta alternativa: usuario introduce cambios (precios, líneas); sistema genera nueva versión del presupuesto; versión anterior archivada; comparación automática entre versiones.
- Registro de justificación u observaciones opcionales en la decisión.
- Versionado: formato PRES-{ID_REUNION}-v{N}; historial de versiones visible.

**Excluye:**
- Envío de la respuesta al cliente (EP-007-US-004).
- Registro de acuerdo final o rechazo definitivo (EP-007-US-005).

### Precondiciones
- Contrapropuesta del cliente revisada (EP-007-US-002).
- Presupuesto en estado "En negociación".
- Usuario tiene permisos para decidir en esta negociación (Fátima/Paz/Javi según línea).
- Si es "Contrapropuesta alternativa", los datos introducidos son coherentes (precios, líneas).

### Postcondiciones
- Decisión registrada (Aceptar / Rechazar / Contrapropuesta alternativa).
- Si hay nueva versión: versión anterior archivada, nueva versión creada con número incremental; comparación registrada.
- Si Rechazar: versión original se mantiene vigente; decisión registrada.
- Listo para envío al cliente (EP-007-US-004) o, si cliente ya había aceptado, para acuerdo final (EP-007-US-005).

### Flujo principal
1. Desde la vista de revisión (EP-007-US-002), Fátima/Paz/Javi elige una decisión: Aceptar, Rechazar o Contrapropuesta alternativa.
2. **Si Aceptar:**
   - Sistema crea nueva versión del presupuesto incorporando los cambios solicitados por el cliente.
   - Sistema archiva la versión anterior.
   - Sistema registra la decisión "Aceptada contrapropuesta" con fecha y usuario.
   - Sistema genera comparación automática (versión anterior vs nueva).
3. **Si Rechazar:**
   - Sistema registra la decisión "Rechazada contrapropuesta, se mantiene versión original".
   - No se crea nueva versión; la vigente sigue siendo la última.
4. **Si Contrapropuesta alternativa:**
   - Usuario introduce o ajusta precios/líneas en el editor (similar a EP-006-US-004).
   - Sistema recalcula totales y genera nueva versión del presupuesto.
   - Sistema archiva la versión anterior.
   - Sistema registra la decisión "Contrapropuesta alternativa" y genera comparación entre versiones.
5. Sistema guarda justificación u observaciones si el usuario las ha introducido.
6. Flujo continúa a EP-007-US-004 (envío de respuesta al cliente) o a EP-007-US-005 si aplica acuerdo/rechazo definitivo.

### Flujos alternos y excepciones

**Flujo alterno 1: Aceptar y cliente ya había aceptado**
- Si la respuesta del cliente era "Aceptación" y ONGAKU confirma:
- No se crea nueva versión de contenido; se registra acuerdo y se pasa a EP-007-US-005.

**Excepción 1: Datos inválidos en contrapropuesta alternativa**
- Si al introducir precios o líneas hay error de validación (precio negativo, total incoherente):
- Sistema no guarda la nueva versión y muestra errores hasta corregir.

**Excepción 2: Error al archivar versión anterior**
- Si falla el archivado:
- Sistema no crea la nueva versión y notifica error; se puede reintentar.

### Validaciones y reglas de negocio
- Solo una versión "vigente" por presupuesto; las anteriores quedan archivadas.
- Numeración de versión: incremental (v1, v2, v3…) según formato del epic.
- Decisión debe ser una de: Aceptar, Rechazar, Contrapropuesta alternativa.
- Si Contrapropuesta alternativa, precios y totales deben ser coherentes (reglas de EP-006-US-004).

### Criterios BDD
- **Escenario 1: Aceptar contrapropuesta**
  - *Dado* que hay una contrapropuesta del cliente revisada
  - *Cuando* Fátima elige "Aceptar contrapropuesta"
  - *Entonces* el sistema crea una nueva versión con los cambios del cliente, archiva la anterior, registra la decisión y la comparación

- **Escenario 2: Rechazar y mantener original**
  - *Dado* que hay una contrapropuesta revisada
  - *Cuando* Paz elige "Rechazar y mantener versión original"
  - *Entonces* el sistema registra la decisión, no crea nueva versión y mantiene la vigente

- **Escenario 3: Contrapropuesta alternativa**
  - *Dado* que hay una contrapropuesta revisada
  - *Cuando* Javi elige "Contrapropuesta alternativa", introduce nuevos precios y guarda
  - *Entonces* el sistema crea una nueva versión del presupuesto, archiva la anterior, registra la decisión y la comparación entre versiones

- **Escenario 4 (negativo): Precio inválido en alternativa**
  - *Dado* que el usuario está introduciendo una contrapropuesta alternativa
  - *Cuando* introduce un precio negativo o no numérico
  - *Entonces* el sistema no guarda y muestra error de validación

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-007-negociacion-presupuestos.md`
- Paso(s): Pasos 4–5 del flujo principal (decisión, registro de nueva versión y comparación).
