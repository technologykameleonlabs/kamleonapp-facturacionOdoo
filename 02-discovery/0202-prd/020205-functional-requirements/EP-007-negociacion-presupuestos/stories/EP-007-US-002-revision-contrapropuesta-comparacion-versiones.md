# EP-007-US-002 — Revisión de contrapropuesta y comparación de versiones

### Epic padre
EP-007 — Negociación de presupuestos

### Contexto/Descripción y valor
**Como** Fátima/Paz/Javi,  
**quiero** revisar la contrapropuesta del cliente y ver una comparación automática entre la versión actual del presupuesto y lo que solicita el cliente,  
**para** decidir si acepto, rechazo o propongo alternativa.

### Alcance
**Incluye:**
- Acceso al listado o detalle de presupuestos con respuesta del cliente pendiente de revisión.
- Vista de la versión actual del presupuesto (líneas, precios, totales).
- Vista de la respuesta del cliente (tipo, cambios solicitados, precio propuesto si aplica).
- Comparación automática entre versión actual y solicitud del cliente (diferencias de precio, líneas añadidas/quitadas, totales).
- Filtros por línea de negocio y permisos (Fátima Corporativo, Paz/Javi/Fátima Bodas).
- Navegación para tomar decisión: aceptar, rechazar o proponer contrapropuesta (EP-007-US-003).

**Excluye:**
- Registrar la decisión y nueva versión (EP-007-US-003).
- Envío de respuesta al cliente (EP-007-US-004).

### Precondiciones
- Existe una respuesta del cliente registrada (EP-007-US-001) de tipo contrapropuesta o modificación.
- Presupuesto en estado "En negociación".
- Fátima/Paz/Javi tiene permisos para revisar negociaciones según línea de negocio.
- Usuario está autenticado.

### Postcondiciones
- Usuario ha visto la contrapropuesta y la comparación con la versión actual.
- Usuario puede pasar a tomar decisión (aceptar, rechazar, contrapropuesta alternativa) en EP-007-US-003.

### Flujo principal
1. Fátima/Paz/Javi accede al dashboard o listado de presupuestos "En negociación" con respuesta pendiente de revisión.
2. Sistema muestra los presupuestos filtrados según permisos y línea de negocio.
3. Usuario selecciona un presupuesto y abre la vista de revisión de contrapropuesta.
4. Sistema muestra la versión actual del presupuesto (líneas, precios, total).
5. Sistema muestra la respuesta del cliente (tipo, cambios solicitados, precio propuesto).
6. Sistema muestra la comparación automática (diferencias: precio anterior vs propuesto, líneas añadidas/eliminadas, impacto en total).
7. Usuario revisa y decide pasar a EP-007-US-003 para aceptar, rechazar o proponer contrapropuesta alternativa.

### Flujos alternos y excepciones

**Flujo alterno 1: Múltiples respuestas**
- Si hay varias respuestas en la misma negociación:
- Sistema muestra historial de respuestas y comparación con la versión vigente en cada momento.

**Excepción 1: Sin permisos para esta línea**
- Si el usuario no tiene permiso para revisar ese presupuesto:
- Sistema no muestra el presupuesto en su listado o muestra mensaje de solo lectura.

**Excepción 2: Datos de comparación incompletos**
- Si la respuesta del cliente no tiene datos suficientes para comparar (ej. solo texto libre):
- Sistema muestra lo disponible y permite ver descripción sin comparación numérica automática.

### Validaciones y reglas de negocio
- Solo se muestran presupuestos en "En negociación" con al menos una respuesta pendiente de decisión.
- La comparación se calcula entre la última versión archivada del presupuesto y la solicitud del cliente (precio, líneas).
- Permisos RBAC: Fátima Corporativo; Paz/Javi/Fátima Bodas; Javi puede intervenir en negociaciones complejas.

### Criterios BDD
- **Escenario 1: Revisión con comparación de precio**
  - *Dado* que hay una contrapropuesta de precio registrada para un presupuesto
  - *Cuando* Fátima abre la vista de revisión de esa negociación
  - *Entonces* el sistema muestra la versión actual del presupuesto, el precio propuesto por el cliente y la comparación (diferencia de total)

- **Escenario 2: Revisión con modificación de servicios**
  - *Dado* que hay una respuesta tipo "Modificación de servicios" con líneas a añadir/quitar
  - *Cuando* Paz abre la vista de revisión
  - *Entonces* el sistema muestra la versión actual, los cambios solicitados y una comparación de líneas y totales

- **Escenario 3 (negativo): Sin permisos**
  - *Dado* que Javi intenta acceder a una negociación de Corporativo sin permiso
  - *Entonces* el sistema no muestra esa negociación en su listado o muestra solo lectura según política

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-007-negociacion-presupuestos.md`
- Paso(s): Paso 3 del flujo principal (Fátima/Paz/Javi revisa contrapropuesta y ve comparación).
