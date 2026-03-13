# EP-011-US-001 — Obtención de fecha del proyecto desde contrato

### Epic padre
EP-011 — Reserva automática de fechas

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** obtener automáticamente la fecha del evento/proyecto desde el contrato firmado,  
**para** poder validar disponibilidad y reservar sin intervención manual.

### Alcance
**Incluye:**
- Lectura de la fecha del evento/proyecto desde datos del contrato firmado (bodas: fecha de boda; corporativo: fecha acordada).
- Extracción automática sin intervención del usuario.
- Pasar la fecha al flujo de validación de disponibilidad (EP-011-US-002).

**Excluye:**
- Validación de disponibilidad (EP-011-US-002).
- Reserva en calendario (EP-011-US-003).
- Edición manual del contrato (EP-008).

### Precondiciones
- Proyecto activado (EP-010) o disparo manual de reserva.
- Contrato firmado con fecha del evento definida.
- Datos del contrato accesibles en el sistema.

### Postcondiciones
- Fecha del evento obtenida y disponible para el flujo.
- Si fecha no definida: sistema notifica y requiere definir fecha antes de continuar.

### Flujo principal
1. Sistema recibe trigger de proyecto activado o de reserva manual.
2. Sistema obtiene el contrato asociado al proyecto.
3. Sistema extrae la fecha del evento desde el contrato (campo definido según línea de negocio).
4. Si fecha definida: sistema pasa la fecha al flujo de validación (EP-011-US-002).
5. Si fecha no definida: sistema notifica a equipo/administración y finaliza (requiere definir fecha).

### Flujos alternos y excepciones

**Excepción 1: Fecha no definida en contrato**
- Sistema notifica que la fecha no está definida y requiere que se defina antes de reservar (edición de contrato o datos del proyecto).

**Excepción 2: Múltiples fechas (corporativo)**
- Si el contrato contempla varias fechas: sistema obtiene la fecha principal o la primera; regla de negocio según convención del proyecto.

### Validaciones y reglas de negocio
- La fecha del evento debe estar definida en el contrato o en datos del proyecto vinculados al contrato.
- Formato de fecha coherente con el sistema (fecha única del evento).

### Criterios BDD
- **Escenario 1: Fecha definida en contrato**
  - *Dado* que el contrato del proyecto tiene fecha del evento definida
  - *Cuando* el sistema obtiene la fecha del proyecto desde el contrato
  - *Entonces* el sistema extrae la fecha correctamente y la pasa al flujo de validación de disponibilidad

- **Escenario 2: Fecha no definida**
  - *Dado* que el contrato no tiene fecha del evento definida
  - *Cuando* el sistema intenta obtener la fecha
  - *Entonces* el sistema notifica que la fecha no está definida y no continúa con la reserva

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-011-reserva-automatica-fechas.md`
- Paso(s): Paso 1 del flujo principal (obtención de fecha desde contrato).
