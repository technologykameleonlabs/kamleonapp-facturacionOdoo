# EP-008-US-002 — Personalización con datos del presupuesto aceptado

### Epic padre
EP-008 — Generación automática de contratos

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** personalizar el contrato generado con los datos del presupuesto aceptado (cliente, servicios, precio acordado, condiciones excepcionales),  
**para** que el documento refleje exactamente lo acordado.

### Alcance
**Incluye:**
- Lectura de los datos del presupuesto aceptado (lead/cliente, reunión, versión aceptada, acuerdos documentados).
- Reemplazo de variables en la plantilla: datos del cliente/novios, servicios contratados, precio acordado, fecha del evento si aplica.
- Inclusión de condiciones excepcionales (apartado 4 en bodas o secciones equivalentes) si están documentadas en el acuerdo.
- Generación del documento personalizado (PDF o editable) con todos los campos rellenados.

**Excluye:**
- Generación desde plantilla (EP-008-US-001).
- Marcado Pendiente de revisión y notificación (EP-008-US-003).
- Edición manual por Fátima/Paz (EP-008-US-004).

### Precondiciones
- Contrato borrador generado desde plantilla (EP-008-US-001).
- Presupuesto aceptado con datos completos: cliente, servicios, precio final, acuerdos documentados (EP-007-US-005).
- Variables de la plantilla definidas y mapeadas a fuentes de datos.

### Postcondiciones
- Contrato personalizado con datos del cliente, servicios, precio y condiciones excepcionales si aplica.
- Documento listo para marcar como Pendiente de revisión (EP-008-US-003).

### Flujo principal
1. Sistema recibe el contrato borrador generado (EP-008-US-001).
2. Sistema lee los datos del presupuesto aceptado: lead_id, datos cliente/novios, servicios, precio acordado, acuerdos/condiciones excepcionales.
3. Sistema reemplaza en la plantilla las variables por los valores correspondientes (nombre cliente, servicios, importe, fechas, etc.).
4. Si hay condiciones excepcionales documentadas (apartado 4 bodas u otras), sistema las inserta en la sección correspondiente.
5. Sistema genera la versión personalizada del contrato (documento final en borrador).
6. Sistema guarda el contrato personalizado y pasa control a EP-008-US-003 (marcado Pendiente de revisión y notificación).

### Flujos alternos y excepciones

**Excepción 1: Datos faltantes para variables obligatorias**
- Si faltan datos críticos (ej. nombre cliente, precio):
- Sistema marca contrato como "Datos incompletos", deja las variables sin rellenar o con placeholder y notifica a Fátima/Paz para completar o editar manualmente (EP-008-US-004).

**Excepción 2: Condiciones excepcionales en texto libre**
- Si las condiciones excepcionales están solo en texto libre y no estructuradas:
- Sistema las incluye en el apartado correspondiente tal cual, o las deja para que Fátima/Paz las edite manualmente.

### Validaciones y reglas de negocio
- Todas las variables obligatorias de la plantilla deben tener valor o quedar marcadas como pendientes (no enviar sin revisión si faltan datos críticos).
- El precio y servicios deben coincidir con la versión aceptada del presupuesto.

### Criterios BDD
- **Escenario 1: Personalización completa Bodas**
  - *Dado* que el contrato borrador es de bodas y el presupuesto aceptado tiene datos de novios, servicios y precio
  - *Cuando* el sistema ejecuta la personalización
  - *Entonces* el contrato queda con nombres, servicios, precio y condiciones excepcionales (si las hay) rellenados correctamente

- **Escenario 2: Personalización completa Corporativo**
  - *Dado* que el contrato borrador es corporativo y el presupuesto aceptado tiene datos de cliente, pack/servicios y precio
  - *Cuando* el sistema ejecuta la personalización
  - *Entonces* el contrato queda con datos de cliente, servicios y precio acordado rellenados

- **Escenario 3 (negativo): Datos faltantes**
  - *Dado* que el presupuesto aceptado no tiene precio final documentado
  - *Cuando* el sistema intenta personalizar
  - *Entonces* el sistema marca "Datos incompletos" o deja el campo pendiente y notifica a Fátima/Paz

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-008-generacion-automatica-contratos.md`
- Paso(s): Paso 3 del flujo principal (personalización con datos del presupuesto aceptado).
