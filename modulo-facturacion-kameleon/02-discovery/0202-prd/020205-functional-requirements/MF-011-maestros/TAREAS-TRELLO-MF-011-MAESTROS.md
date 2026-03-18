# Tareas — MF-011 Maestros

Tareas separadas por **Backend** y **Frontend**. Cada bloque incluye descripción detallada y criterios de aceptación explícitos.

**Épica**: MF-011 — Maestros  
**Historias de usuario**: US-001 (Términos de pago), US-002 (Impuestos), US-003 (Cliente facturación), US-004 (Config. empresa), US-005 (Productos, opcional), US-006 (Precios por cliente, opcional).
---

# BACKEND
---

## [BACK] MF-011 — Modelo y migración: Términos de pago

**Historia de usuario**: MF-011-US-001

**Descripción**  
Implementar en backend la entidad **Término de pago** con persistencia (tabla/modelo) y migración de base de datos. La entidad es necesaria para asignar un término a cada factura y calcular fechas de vencimiento. No implementar aún la lógica de cálculo de vencimientos (irá en módulo de facturación); solo el CRUD del maestro.

**Detalle técnico**  
- Campos obligatorios: `nombre` (string), `tipo` (enum: contado, 30_dias, 60_dias, 90_dias, personalizado), `dias_vencimiento` (entero, nullable si tipo es personalizado y se usa regla), `activo` (boolean, default true).  
- Campos opcionales: `regla_vencimiento` (JSON o texto estructurado para fechas fijas, % a 30/60 días, etc.), `orden_visualizacion` (entero), `codigo` (string, único, para integraciones).  
- Índices recomendados: por `activo`, por `tipo`.  
- Soft delete o no: si se usa en facturas existentes, no borrar físicamente; usar campo `activo = false` y validar en API que no se elimine si hay facturas usando el término.

**Criterios de aceptación**  
- [ ] Existe migración que crea la tabla de términos de pago con los campos indicados.  
- [ ] El modelo expone nombre, tipo, dias_vencimiento, regla_vencimiento, activo, orden_visualizacion (y los opcionales definidos).  
- [ ] No se permite eliminar (o se desactiva) un término que esté referenciado por al menos una factura; la API devuelve error claro si se intenta.  
- [ ] Validaciones: nombre no vacío; tipo pertenece al enumerado; dias_vencimiento >= 0 si se informa; activo por defecto true.

---

## [BACK] MF-011 — API CRUD: Términos de pago

**Historia de usuario**: MF-011-US-001

**Descripción**  
Exponer endpoints REST (o GraphQL, según stack del proyecto) para **listar**, **obtener por ID**, **crear**, **actualizar** y **desactivar** términos de pago. Incluir filtros en listado (por activo, por tipo) y ordenación (por orden_visualizacion y nombre). Paginación en listado si el equipo lo usa por estándar.

**Detalle técnico**  
- Listado: `GET /api/terminos-pago` (o ruta equivalente). Query params: `activo` (boolean opcional), `tipo` (opcional). Orden: orden_visualizacion ASC, nombre ASC.  
- Detalle: `GET /api/terminos-pago/:id`.  
- Crear: `POST /api/terminos-pago` con body JSON (nombre, tipo, dias_vencimiento, etc.).  
- Actualizar: `PUT` o `PATCH /api/terminos-pago/:id`.  
- Desactivar: `PATCH /api/terminos-pago/:id` con `{ "activo": false }` o endpoint específico; no borrado físico si hay facturas que lo usan.

**Criterios de aceptación**  
- [ ] Listado devuelve solo términos con activo=true por defecto; existe opción (query param) para incluir inactivos.  
- [ ] Crear y actualizar validan nombre, tipo, dias_vencimiento y devuelven 400 con mensajes claros si falla.  
- [ ] Al desactivar, si el término está en uso en alguna factura, la API responde 409 (o 400) con mensaje: "No se puede desactivar: está en uso en facturas".  
- [ ] Respuestas siguen el estándar de la API del proyecto (formato JSON, códigos HTTP correctos).

---

## [BACK] MF-011 — Modelo y migración: Impuestos

**Historia de usuario**: MF-011-US-002

**Descripción**  
Implementar la entidad **Impuesto** con persistencia y migración. Se usará en líneas de factura para calcular base e importe de impuesto; el tipo "incluido en precio" / "no incluido" determina cómo se calcula. No implementar aún la lógica de facturación; solo el CRUD del maestro.

**Detalle técnico**  
- Campos: `nombre` (string), `porcentaje` (decimal, ej. 21.00), `tipo_calculo` (enum: incluido_en_precio | no_incluido), `activo` (boolean, default true).  
- Opcionales: `codigo_externo` (string, para integración contable), `es_retencion` (boolean, default false).  
- Validación: porcentaje >= 0 y <= 100 (o el rango que permita la normativa).  
- No eliminar físicamente si el impuesto está en uso en líneas de factura; desactivar con `activo = false`.

**Criterios de aceptación**  
- [ ] Migración crea tabla de impuestos con los campos indicados.  
- [ ] El modelo valida porcentaje en rango permitido (ej. 0–100).  
- [ ] No se permite eliminar (o se desactiva) un impuesto usado en facturas; la API debe poder comprobar uso antes de desactivar.  
- [ ] tipo_calculo solo acepta valores incluido_en_precio o no_incluido.

---

## [BACK] MF-011 — API CRUD: Impuestos

**Historia de usuario**: MF-011-US-002

**Descripción**  
Endpoints para **listar**, **obtener por ID**, **crear**, **actualizar** y **desactivar** impuestos. Filtros por activo y opcionalmente por nombre; ordenación por nombre.

**Detalle técnico**  
- Listado: `GET /api/impuestos`. Query params: `activo` (boolean opcional), `nombre` (búsqueda parcial opcional).  
- Detalle: `GET /api/impuestos/:id`.  
- Crear: `POST /api/impuestos` (nombre, porcentaje, tipo_calculo, opcionales).  
- Actualizar: `PUT` o `PATCH /api/impuestos/:id`.  
- Desactivar: poner `activo = false`; si está en uso en facturas, devolver error 409/400 con mensaje claro.

**Criterios de aceptación**  
- [ ] Listado por defecto solo activos; opción para incluir inactivos.  
- [ ] Crear/actualizar rechazan porcentaje fuera de rango o tipo_calculo inválido con mensaje explícito.  
- [ ] No se puede desactivar un impuesto que esté en uso en líneas de factura; respuesta 409 (o 400) con mensaje entendible.  
- [ ] Respuestas en el formato estándar de la API del proyecto.

---

## [BACK] MF-011 — Cliente/contacto de facturación (modelo y API)

**Historia de usuario**: MF-011-US-003

**Descripción**  
Definir o extender la entidad **Cliente de facturación** (o reutilizar "cliente" / "contacto" de Kameleon) con los campos mínimos necesarios para facturación: nombre (razón social), NIF/CIF, dirección fiscal, email, término de pago por defecto. Exponer API para listar, obtener, crear y actualizar. Si ya existe entidad cliente en el sistema, extender con los campos que falten y con la relación a término de pago por defecto; si no, crear entidad nueva y documentar la decisión.

**Detalle técnico**  
- Campos mínimos: nombre, nif (opcional según normativa), direccion (texto o estructura), email, termino_pago_id (FK a términos de pago, opcional).  
- Regla de negocio: NIF único si la normativa lo exige (validar en API).  
- Relación con proyecto: si en Kameleon el proyecto tiene "cliente", vincular este maestro a ese concepto (campo cliente_id en proyecto o equivalente) para poder prerellenar facturas desde el proyecto (MF-007).

**Criterios de aceptación**  
- [ ] Existe entidad (nueva o extendida) con nombre, NIF, dirección, email, término de pago por defecto.  
- [ ] API permite listar clientes con filtro por nombre/NIF y obtener por ID; crear y actualizar con validación de campos obligatorios.  
- [ ] Si se exige NIF único, la API rechaza crear/actualizar con NIF duplicado y devuelve mensaje claro.  
- [ ] Se puede asignar termino_pago_id a un cliente; el valor debe existir en el maestro de términos de pago.

---

## [BACK] MF-011 — Configuración empresa (modelo y API)

**Historia de usuario**: MF-011-US-004

**Descripción**  
Implementar entidad de **Configuración de empresa** (o extensión de empresa existente) con los datos que se usarán en el pie o cabecera del PDF de facturas: nombre legal, NIF, dirección, logo (URL o ruta de archivo). Una empresa por defecto si no hay multi-empresa. API de lectura y actualización (típicamente un solo registro o por empresa_id si hay multi-empresa).

**Detalle técnico**  
- Campos: nombre_legal, nif, direccion, logo_url (string, URL o path).  
- Si el sistema es multi-empresa, asociar configuración a empresa_id.  
- Endpoints: GET para obtener la configuración (por empresa o la por defecto); PUT/PATCH para actualizar. No suele hacerse "listado" de empresas en este contexto; solo edición de la configuración activa.

**Criterios de aceptación**  
- [ ] Existe modelo y migración para datos de empresa (nombre legal, NIF, dirección, logo).  
- [ ] API permite obtener la configuración de empresa actual (o por empresa_id) y actualizarla.  
- [ ] Validaciones: nombre_legal y al menos uno de NIF/dirección recomendados; logo_url opcional, formato URL o path válido si se valida.  
- [ ] Los datos devueltos serán consumidos por el generador de PDF (MF-006); asegurar que el contrato de la API sea estable.

---

## [BACK] MF-011 — Productos/tarifas (modelo y API) — OPCIONAL

**Historia de usuario**: MF-011-US-005

**Descripción**  
Implementar entidad **Producto** (o servicio) para catálogo: nombre, unidad de medida, precio unitario por defecto, impuesto por defecto (FK a impuestos). API CRUD. Opcional en alcance mínimo; si se prioriza después, esta tarea puede dejarse para una siguiente iteración.

**Detalle técnico**  
- Campos: nombre, unidad_medida (string o enum: hora, unidad, servicio, etc.), precio_unitario (decimal), impuesto_id (FK, opcional). activo (boolean).  
- No eliminar producto en uso en líneas de factura; desactivar.  
- Listado con filtros por activo y nombre; orden por nombre.

**Criterios de aceptación**  
- [ ] Migración y modelo de producto con los campos indicados.  
- [ ] API CRUD completa; al crear/editar línea de factura (en MF-003) se podrá opcionalmente elegir producto y rellenar cantidad y precio.  
- [ ] Desactivar producto en uso debe devolver error con mensaje claro.  
- [ ] precio_unitario >= 0; impuesto_id debe existir en maestro de impuestos si se informa.

---

# FRONTEND
---

## [FRONT] MF-011 — Pantallas CRUD: Términos de pago

**Historia de usuario**: MF-011-US-001

**Descripción**  
Implementar en la aplicación las pantallas para gestionar el maestro **Términos de pago**: listado con filtros (activo, tipo) y ordenación, formulario de alta, formulario de edición, y acción de desactivar (sin borrado físico). El listado debe mostrar al menos: nombre, tipo, días de vencimiento, activo. Las pantallas deben estar integradas en el menú o sección de Facturación → Maestros (o equivalente).

**Detalle técnico**  
- Listado: tabla o cards con columnas nombre, tipo, dias_vencimiento, activo; filtros por "Activo" (Sí/Todos/No) y por tipo; botón "Nuevo término de pago".  
- Formulario crear/editar: campos nombre (requerido), tipo (select: Contado, 30 días, 60 días, 90 días, Personalizado), días de vencimiento (número, requerido si tipo no es personalizado), regla de vencimiento (opcional, según definición), activo (checkbox), orden de visualización (opcional).  
- Acción desactivar: desde listado o detalle, botón "Desactivar"; confirmación "¿Desactivar este término? No se usará en nuevas facturas." Si el backend devuelve error por estar en uso, mostrar el mensaje al usuario.  
- Validación en cliente: nombre no vacío; días >= 0; no permitir enviar si hay errores de validación.

**Criterios de aceptación**  
- [ ] El usuario puede abrir el listado de términos de pago desde el menú de Facturación/Maestros.  
- [ ] El usuario puede crear un nuevo término rellenando nombre, tipo y días (y opcionales) y guardar; tras guardar se muestra en el listado.  
- [ ] El usuario puede editar un término existente y guardar; los cambios se reflejan en el listado.  
- [ ] El usuario puede desactivar un término; si está en uso en facturas, se muestra el mensaje de error devuelto por la API sin borrar el registro.  
- [ ] Los filtros por activo y tipo funcionan y el listado se actualiza correctamente.  
- [ ] Mensajes de validación (nombre obligatorio, días inválidos, etc.) se muestran en el formulario antes de enviar.

---

## [FRONT] MF-011 — Pantallas CRUD: Impuestos

**Historia de usuario**: MF-011-US-002

**Descripción**  
Pantallas para el maestro **Impuestos**: listado con filtros (activo, nombre), formulario de alta y edición, y desactivar. Columnas en listado: nombre, porcentaje, tipo de cálculo (incluido / no incluido), activo. Integración en menú Facturación → Maestros.

**Detalle técnico**  
- Listado: tabla con nombre, porcentaje, tipo_calculo (traducido: "Incluido en precio" / "No incluido"), activo; filtro por activo y búsqueda por nombre; botón "Nuevo impuesto".  
- Formulario: nombre (requerido), porcentaje (numérico, 0–100, requerido), tipo_calculo (select: Incluido en precio | No incluido), activo (checkbox), opcionales codigo_externo, es_retencion.  
- Desactivar con confirmación; si la API devuelve error por uso en facturas, mostrar mensaje.  
- Validación: porcentaje entre 0 y 100; nombre no vacío.

**Criterios de aceptación**  
- [ ] El usuario accede al listado de impuestos desde Facturación/Maestros.  
- [ ] El usuario puede crear un impuesto con nombre, porcentaje y tipo de cálculo; se guarda y aparece en el listado.  
- [ ] El usuario puede editar un impuesto existente; los cambios se guardan correctamente.  
- [ ] El usuario puede desactivar un impuesto; si está en uso, se muestra el mensaje de error de la API.  
- [ ] Si se introduce un porcentaje fuera de 0–100 o un nombre vacío, el formulario muestra error y no envía hasta corregir.  
- [ ] Filtros y búsqueda por nombre funcionan en el listado.

---

## [FRONT] MF-011 — Pantallas: Cliente/contacto de facturación

**Historia de usuario**: MF-011-US-003

**Descripción**  
Pantallas para gestionar **Clientes de facturación**: listado (con búsqueda por nombre/NIF), formulario de alta y edición con campos nombre, NIF, dirección, email y término de pago por defecto (selector que carga términos de pago desde la API). Si el sistema reutiliza la entidad "cliente" de Kameleon, las pantallas pueden ser una extensión o pestaña adicional de la ficha de cliente existente; documentar en la tarea la decisión (nueva sección Facturación vs integración en cliente existente).

**Detalle técnico**  
- Listado: nombre, NIF, email, término de pago (nombre), opcional dirección; búsqueda por nombre o NIF.  
- Formulario: nombre (requerido), NIF (opcional o requerido según normativa), dirección (texto o campos), email, término de pago por defecto (dropdown desde GET /api/terminos-pago).  
- Validación: email formato válido si se informa; NIF único si la API lo exige (mostrar error si devuelve conflicto).

**Criterios de aceptación**  
- [ ] El usuario puede listar clientes de facturación y buscar por nombre o NIF.  
- [ ] El usuario puede crear un cliente con nombre y al menos los campos mínimos definidos; el selector de término de pago muestra solo términos activos.  
- [ ] El usuario puede editar un cliente y cambiar término de pago por defecto; los cambios se persisten.  
- [ ] Si se exige NIF único y se repite, se muestra el mensaje de error devuelto por la API.  
- [ ] Las pantallas están accesibles desde el menú o sección de Facturación/Maestros (o Clientes según estructura del producto).

---

## [FRONT] MF-011 — Pantalla: Configuración empresa

**Historia de usuario**: MF-011-US-004

**Descripción**  
Una pantalla (o sección en Ajustes/Facturación) para editar la **Configuración de empresa** usada en los PDF: nombre legal, NIF, dirección, logo (subida de archivo o URL). Solo lectura + edición; no hay listado (una sola configuración por empresa o global). Botón Guardar que llama a la API de actualización.

**Detalle técnico**  
- Campos en formulario: nombre legal, NIF, dirección (área de texto o campos separados), logo: input URL o subida de archivo según lo que soporte el backend.  
- Al cargar la pantalla, GET de la configuración actual y rellenar el formulario.  
- Al guardar, PUT/PATCH con los valores del formulario; mostrar mensaje de éxito o error.  
- Validación: nombre legal no vacío; NIF y dirección recomendados; logo opcional.

**Criterios de aceptación**  
- [ ] El usuario accede a la configuración de empresa desde Facturación/Maestros o Ajustes.  
- [ ] Al abrir la pantalla se muestran los datos actuales (nombre legal, NIF, dirección, logo si existe).  
- [ ] El usuario puede modificar los campos y guardar; se muestra confirmación de éxito y los datos actualizados.  
- [ ] Si el backend devuelve error (validación), se muestra el mensaje al usuario.  
- [ ] Los datos guardados serán los que use el generador de PDF (MF-006); no es necesario implementar el PDF en esta tarea.

---

## [FRONT] MF-011 — Pantallas CRUD: Productos/tarifas — OPCIONAL

**Historia de usuario**: MF-011-US-005

**Descripción**  
Pantallas para el maestro **Productos** (o servicios): listado con filtros, formulario de alta/edición con nombre, unidad de medida, precio unitario e impuesto por defecto (selector desde API de impuestos). Solo implementar si el backend de productos está ya desarrollado y se prioriza esta US.

**Criterios de aceptación**  
- [ ] Listado de productos accesible desde Facturación/Maestros.  
- [ ] Crear y editar producto con nombre, unidad, precio e impuesto por defecto; validaciones (precio >= 0, impuesto existente).  
- [ ] Desactivar producto con confirmación; si está en uso, mostrar error de la API.  
- [ ] Filtros y búsqueda operativos.

---

