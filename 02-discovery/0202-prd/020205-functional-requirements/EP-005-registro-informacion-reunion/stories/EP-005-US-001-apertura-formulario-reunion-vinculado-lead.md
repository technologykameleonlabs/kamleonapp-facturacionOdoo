# EP-005-US-001 — Apertura de formulario de reunión vinculado al lead

### Epic padre
EP-005 — Registro de información durante reunión

### Contexto/Descripción y valor
**Como** Fátima/Paz,  
**quiero** poder abrir un formulario de registro de reunión ya vinculado al lead y a la reunión agendada,  
**para** empezar a registrar la información desde el inicio sin tener que buscar datos manualmente.

### Alcance
**Incluye:**
- Acceso al formulario de registro desde la vista de reunión agendada (o desde listado de reuniones del día).
- Formulario pre-cargado con datos del lead (nombre, email, teléfono, línea de negocio) y de la reunión (fecha, hora, modalidad).
- Selección automática del tipo de formulario (Corporativo o Bodas) según línea de negocio del lead.
- Uso en tablet, laptop o móvil durante la reunión.

**Excluye:**
- Captura de campos específicos Corporativo/Bodas (EP-005-US-002, EP-005-US-003).
- Validación y cierre de reunión (EP-005-US-004).
- Exposición al motor de presupuestos (EP-005-US-005).

### Precondiciones
- Reunión está agendada (EP-004) y asociada a un lead.
- Usuario (Fátima o Paz) está autenticado y tiene permisos para esa línea de negocio.
- Lead tiene línea de negocio definida (Corporativo o Bodas).

### Postcondiciones
- Formulario de registro de reunión abierto y listo para captura.
- Datos del lead y de la reunión visibles y no editables (o editables solo si se define así).
- Usuario puede empezar a rellenar los campos específicos de la reunión.

### Flujo principal
1. Fátima/Paz accede al sistema y navega a "Reuniones" o "Reuniones de hoy".
2. Sistema muestra listado de reuniones agendadas (filtrable por fecha, estado).
3. Usuario selecciona la reunión que va a celebrar o está celebrando.
4. Usuario pulsa "Abrir formulario de registro" o equivalente.
5. Sistema carga el lead asociado a la reunión y la línea de negocio.
6. Sistema abre el formulario de registro correspondiente (Corporativo o Bodas) con datos del lead y de la reunión ya rellenados en cabecera.
7. Formulario queda listo para captura en tiempo real durante la reunión.

### Flujos alternos y excepciones

**Excepción 1: Reunión sin lead asociado**
- Si la reunión no tiene lead asociado, sistema muestra error y no abre formulario; notifica para corrección.

**Excepción 2: Lead sin línea de negocio**
- Si el lead no tiene línea de negocio definida, sistema solicita seleccionar Corporativo o Bodas antes de abrir el formulario.

**Excepción 3: Usuario sin permisos para esa reunión**
- Sistema no muestra el botón de apertura o muestra mensaje de acceso denegado.

### Validaciones y reglas de negocio
- Solo se puede abrir formulario de registro para reuniones en estado "Agendada".
- Un mismo registro de reunión puede editarse hasta que se marque como "Completada" (o equivalente).

### Criterios BDD
- **Escenario 1: Apertura correcta del formulario Corporativo**
  - *Dado* que existe una reunión agendada asociada a un lead corporativo
  - *Cuando* Fátima abre el formulario de registro para esa reunión
  - *Entonces* el sistema muestra el formulario Corporativo con datos del lead y de la reunión en cabecera.

- **Escenario 2: Apertura correcta del formulario Bodas**
  - *Dado* que existe una reunión agendada asociada a un lead de bodas
  - *Cuando* Paz abre el formulario de registro para esa reunión
  - *Entonces* el sistema muestra el formulario Bodas con datos del lead y de la reunión en cabecera.

- **Escenario 3 (negativo): Reunión sin lead asociado**
  - *Dado* que una reunión agendada no tiene lead asociado
  - *Cuando* el usuario intenta abrir el formulario de registro
  - *Entonces* el sistema muestra un mensaje de error y no abre el formulario.

### Notificaciones
- Ninguna en esta US (solo interacción en pantalla).

### Seguridad
- Control de acceso por rol (Fátima/Paz) y por línea de negocio.
- No exponer datos de otros leads.

### Analítica/KPIs
- Tiempo desde inicio de reunión hasta apertura del formulario (objetivo: mínimo uso de tiempo).

### Definition of Ready
- [ ] Vista de reuniones agendadas disponible.
- [ ] Asociación reunión–lead y línea de negocio definida en datos.

### Definition of Done
- [ ] Formulario se abre correctamente vinculado al lead y a la reunión.
- [ ] Tipo de formulario (Corporativo/Bodas) se selecciona según línea de negocio.
- [ ] Escenarios BDD pasados.

### Riesgos y supuestos
- **Supuesto:** Las reuniones siempre tienen un lead asociado en el flujo normal.

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-005-registro-informacion-reunion.md`
- Bloque funcional: Captura estructurada en tiempo real.
- Paso(s): 1 (acceso al formulario de registro vinculado al lead).
