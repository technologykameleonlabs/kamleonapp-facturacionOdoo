# Requisitos funcionales detallados — Módulo de facturación Kameleon App

**Documento para desarrolladores**: especificación en profundidad de cada funcionalidad del módulo de facturación, con procesos, reglas de negocio, validaciones y criterios de aceptación.

**Índice rápido**: [MF-001](#mf-001--activación-de-proyecto-sin-pago-inicial-obligatorio) | [MF-002](#mf-002--factura-de-cierre--liquidación-y-registro-de-pago) | [MF-003](#mf-003--facturación-núcleo) | [MF-004](#mf-004--cobros-y-estado-de-pago) | [MF-005](#mf-005--notas-de-crédito) | [MF-006](#mf-006--pdf-y-envío-por-email) | [MF-007](#mf-007--facturación-desde-proyecto) | [MF-008](#mf-008--anticipos-y-facturación-parcial) | [MF-009](#mf-009--portal-del-cliente) | [MF-010](#mf-010--dashboard-y-reportes) | [MF-011](#mf-011--maestros) | [MF-012](#mf-012--moneda-y-tipo-de-cambio) | [MF-013](#mf-013--roles-y-permisos) | [MF-014](#mf-014--auditoría-y-trazabilidad)

---

## Cómo usar este documento

- Cada sección corresponde a una **épica** (bloque funcional). Dentro se describe **qué debe hacer el sistema y el usuario**, **en qué orden** y **con qué reglas**.
- **Proceso detallado**: pasos que debe implementar el flujo (backend + frontend).
- **Reglas de negocio**: condiciones que la lógica debe cumplir siempre.
- **Validaciones**: qué comprobar antes de guardar o cambiar de estado.
- **Historias de usuario**: se referencian al final de cada épica; el detalle por US está en las carpetas `MF-0XX-*/stories/`.

---

## MF-001 — Activación de proyecto (sin pago inicial obligatorio)

### Objetivo
El proyecto se **activa** (cambio de estado a "Activo") por contrato firmado, por acción manual del usuario o por otra regla de negocio configurable. Opcionalmente se puede registrar un anticipo o pago inicial acordado (cualquier importe) y generar una factura por ese monto; en ese caso se notifica al cliente y se deja trazabilidad. La facturación principal del proyecto será **mensual** (MF-007).

### Alcance
- **Incluye**: Activación del proyecto (estado "Activo", fecha de activación); disparador por evento (ej. contrato firmado) o por acción manual; opcional: registro de anticipo/pago inicial (importe acordado) y generación de factura por ese importe; reserva de fecha en calendario; notificaciones a equipo y cliente; registro de activación para trazabilidad.
- **Excluye**: Pasarela de pago integrada.

### Actores
- **Usuario/Administración**: activa el proyecto manualmente o el sistema lo hace al detectar contrato firmado; opcionalmente registra anticipo.
- **Sistema**: activa proyecto, opcionalmente genera factura de anticipo, reserva fecha, notifica, registra activación.
- **Equipo y Cliente**: receptores de notificaciones.

### Proceso detallado (qué debe hacer el sistema)

1. **Activación del proyecto**
   - **Disparador**: (a) El usuario ejecuta la acción "Activar proyecto" en la ficha del proyecto (con permiso adecuado), o (b) el sistema detecta que el contrato está firmado (integración con flujo de contratos) y activa automáticamente, o (c) otra regla configurable (ej. "proyecto aprobado").
   - El proyecto pasa a estado "Activo" y se registra la fecha (y hora) de activación.
   - Comprobar que el proyecto no esté ya activo (idempotencia). Si ya está activo, no duplicar activación.

2. **Opcional: registro de anticipo y factura**
   - Si el negocio acuerda un anticipo con el cliente, el usuario puede **opcionalmente** registrar que se ha recibido ese anticipo (importe acordado) y solicitar la generación de una factura por ese importe.
   - Flujo: desde el proyecto recién activado (o en cualquier momento), acción "Registrar anticipo" o "Generar factura de anticipo". Usuario indica el monto recibido/acordado. El sistema genera una factura (tipo "Anticipo" o "Factura inicial") con número, fecha, cliente del proyecto, concepto (ej. "Proyecto [nombre] – Anticipo"), importe = el indicado. Se asocia al proyecto y queda disponible para descontar en facturas mensuales (MF-008).
   - Si no hay anticipo, se omite este paso; el proyecto sigue activo y se facturará mensualmente (MF-007).

3. **Reserva de fecha (opcional)**
   - Si aplica integración con calendario: obtener la fecha del proyecto/evento y reservar/bloquear en el calendario. Invocar la lógica existente de reserva si la hay.

4. **Notificaciones**
   - **A equipo**: "Proyecto [nombre] activado." (+ fecha reservada si aplica; + "Factura de anticipo [número] generada" si hubo anticipo).
   - **A cliente**: "Proyecto activado." Si hubo factura de anticipo: "Factura [número] generada" con enlace o adjunto según configuración.
   - Enviar por canal configurado (email, notificación in-app).

5. **Registro de activación**
   - Guardar registro de "Activación": proyecto_id, timestamp, usuario o evento que disparó, referencia de factura de anticipo (si existe), fecha reservada (si aplica). Para auditoría y para no repetir activación.

### Reglas de negocio
- La activación **no depende** de ningún pago. El proyecto puede activarse sin factura de anticipo.
- Si se genera factura de anticipo, debe usar la misma moneda que el proyecto; número por serie configurada; una factura de anticipo por proyecto (o política clara si se permiten varias).
- Un proyecto solo se activa una vez (estado "Activo" es persistente hasta cierre).

### Validaciones
- Proyecto en estado que permita activación (ej. contrato firmado, o pendiente de activación). No activar si ya está activo.
- Si se registra anticipo: monto > 0; cliente de facturación con datos mínimos; serie de facturas disponible.

### Estados implicados
- **Proyecto**: de "Pendiente de activación" (o similar) a "Activo".

### Campos principales

| Campo                          | Descripción                                                                                   | Tipo                          |
|--------------------------------|-----------------------------------------------------------------------------------------------|-------------------------------|
| proyecto.id                    | Identificador único del proyecto                                                              | Entero / UUID                 |
| proyecto.estado                | Estado del proyecto (pendiente_activacion, activo, cerrado, etc.)                            | Enumerado                     |
| proyecto.fecha_activacion      | Fecha y hora en la que el proyecto pasa a estado Activo                                       | Fecha/hora                    |
| proyecto.activado_por          | Usuario o proceso que disparó la activación (usuario_id o código de sistema)                 | Relación / Texto corto        |
| proyecto.disparador_activacion | Tipo de disparador (acción_manual, contrato_firmado, regla_configurada)                      | Enumerado                     |
| anticipo.importe               | Importe del anticipo/pago inicial registrado (si aplica)                                     | Numérico (decimal)            |
| anticipo.moneda                | Moneda del anticipo (si MF-012 está activo)                                                  | Enumerado / Código moneda     |
| anticipo.factura_id            | Referencia a la factura de anticipo generada                                                 | Relación (FK a factura)       |
| calendario.evento_id           | Identificador del evento en calendario asociado a la reserva de fecha (si aplica)           | Texto / Relación externa      |
| notificacion.equipo_enviada    | Indicador de que se envió notificación al equipo                                             | Booleano                      |
| notificacion.cliente_enviada   | Indicador de que se envió notificación al cliente                                            | Booleano                      |
| activacion.registro_id         | Identificador del registro de activación almacenado para trazabilidad                       | Entero / UUID                 |

### Estimación de esfuerzo (con soporte de IA)

- Diseño de modelo de activación, anticipo y registro de activación: **0,5–0,75 días**.
- Lógica de activación (disparadores, validaciones, registro) + API/servicio: **1–1,5 días**.
- Ajustes de UI en ficha de proyecto (botón Activar, registrar anticipo, indicadores de estado) y notificaciones: **1–1,5 días**.
- Estimación total para MF-001 con apoyo de IA (sin contar QA manual ni despliegue): **~2,5–3,5 días**.

### Criterios de aceptación (resumen)
- Activar proyecto sin pago previo (manual o por evento). Opcional: registrar anticipo y generar factura por monto acordado; notificaciones y registro de activación guardados. Trazabilidad: desde proyecto, fecha de activación y factura de anticipo si existe.

### Historias de usuario
| ID | Título |
|----|--------|
| MF-001-US-001 | Activación del proyecto (manual o por evento: contrato firmado) |
| MF-001-US-002 | Opcional: registro de anticipo/pago inicial y generación de factura por monto acordado |
| MF-001-US-003 | Registro de fecha de activación y notificaciones a equipo y cliente |
| MF-001-US-004 | Reserva automática de fecha en calendario (si aplica) |
| MF-001-US-005 | Registro de activación (timestamp, referencia factura si hay anticipo) para trazabilidad |

---

## MF-002 — Factura de cierre / liquidación y registro de pago

### Objetivo
Cuando el proyecto se cierra o se acepta la última entrega (según flujo de proyectos), el sistema genera una **factura de cierre** (o de liquidación) por el **saldo pendiente de facturar**: lo que falte por facturar respecto al total acordado/presupuesto, después de descontar lo ya facturado mensualmente (MF-007) y los anticipos ya descontados (MF-008). Si el saldo pendiente es 0 (todo ya facturado), no se genera factura. Notificación al cliente, registro de pago y confirmación por administración para habilitar el cierre formal del proyecto.

### Alcance
- **Incluye**: Detección de evento de cierre (proyecto listo para cerrar, última entrega aceptada o "cerrar facturación"); cálculo del saldo pendiente (total acordado − facturas ya emitidas para el proyecto − anticipos ya descontados); generación de factura de cierre por ese saldo (solo si saldo > 0); notificación al cliente; registro de factura y estado de pago; confirmación por administración de la recepción del pago.
- **Excluye**: Pasarela de pago integrada.

### Actores
- **Sistema**: detecta cierre, calcula saldo, genera factura si hay saldo, notifica, registra estado de pago.
- **Cliente**: recibe notificación y paga fuera del sistema.
- **Administración**: confirma recepción del pago para habilitar cierre del proyecto.

### Proceso detallado (qué debe hacer el sistema)

1. **Detección de cierre del proyecto**
   - El flujo de proyectos debe exponer un evento o estado "Proyecto listo para cerrar" o "Última entrega aceptada" (o equivalente) por proyecto_id.
   - El módulo de facturación se suscribe a ese evento o lo consulta y, cuando se cumpla, ejecuta el flujo de factura de cierre.
   - El proyecto puede haberse facturado solo por facturas mensuales (MF-007).

2. **Cálculo del saldo pendiente de facturar**
   - Obtener el **total acordado** del proyecto (presupuesto, contrato o suma de conceptos facturables según configuración).
   - Obtener el **total ya facturado** para ese proyecto: suma de todas las facturas asociadas al proyecto (facturas mensuales de periodo, facturas de anticipo no descontadas en otras, etc.). En MF-008 el "anticipo" se descuenta en facturas; aquí se considera "ya facturado" lo emitido (las facturas de anticipo cuentan como facturado; el descuento en facturas mensuales no reduce "total facturado" sino que es un ajuste en el cobro).
   - **Saldo pendiente** = total acordado − total ya facturado. Si el negocio define "total acordado" como presupuesto y las facturas mensuales ya cubren ese total, el saldo puede ser 0.
   - Si **saldo pendiente ≤ 0**: no se genera factura de cierre; se puede registrar "Facturación cerrada sin saldo pendiente" y el proyecto queda listo para cierre (el módulo de cierre comprobará que no hay facturas pendientes de cobro o que la condición de cierre se cumple). Ir al paso 5 si aplica.
   - Si **saldo pendiente > 0**: continuar al paso 3.

3. **Generación de la factura de cierre**
   - Crear factura con: número por serie, fecha actual, cliente del proyecto, concepto (ej. "Proyecto [nombre] – Factura de cierre / liquidación"), importe = saldo pendiente calculado.
   - Estado: "Publicada"/"Emitida". Estado de pago: "Pendiente".
   - Vincular al proyecto (factura_cierre_id o relación proyecto–facturas). Tipo o etiqueta "Factura de cierre" para distinguirla de las mensuales.
   - Guardar. Tiempo objetivo: factura generada en menos de 2 minutos desde el evento de cierre.

4. **Notificación y registro de pago**
   - Notificar al cliente (email y/o portal) que la factura de cierre está disponible; enlace o adjunto PDF. Registrar envío (MF-014).
   - La factura queda con estado de pago "Pendiente". El módulo de cierre del proyecto puede comprobar "factura de cierre cobrada" (o "todas las facturas del proyecto cobradas") para permitir el cierre formal.

5. **Confirmación de recepción de pago (administración)**
   - El usuario con permiso ejecuta "Confirmar recepción de pago" en la factura de cierre (o "Marcar como cobrado"). El sistema actualiza estado de pago a "Recibido" y registra fecha y usuario.
   - Con esto el proyecto cumple la condición de "pago de cierre recibido" (si aplica) para el cierre formal.

### Reglas de negocio
- La factura de cierre tiene como importe el **saldo pendiente** resultante de total acordado − ya facturado.
- Solo una factura de cierre por proyecto en este flujo (idempotencia: si ya existe factura de cierre para el proyecto, no generar otra salvo rectificación vía NC y nueva liquidación).
- Si no hay saldo pendiente, no se crea factura; el cierre del proyecto puede basarse en "no hay facturas pendientes de emitir" y "facturas pendientes de cobro" según política.

### Validaciones
- Proyecto en estado que permita "factura de cierre" (evento de cierre recibido).
- Total acordado y total ya facturado calculables correctamente; cliente de facturación disponible.
- Serie de facturas disponible cuando saldo > 0.

### Campos principales

| Campo                          | Descripción                                                                                   | Tipo                          |
|--------------------------------|-----------------------------------------------------------------------------------------------|-------------------------------|
| proyecto.id                    | Identificador del proyecto al que se vincula la factura de cierre                            | Entero / UUID                 |
| proyecto.total_acordado        | Importe total acordado/presupuestado para el proyecto                                        | Numérico (decimal)            |
| proyecto.total_facturado       | Suma de importes de todas las facturas asociadas al proyecto                                 | Numérico (decimal)            |
| proyecto.saldo_pendiente       | Diferencia entre total_acordado y total_facturado                                            | Numérico (decimal)            |
| cierre.evento_id               | Identificador del evento de cierre (última_entrega_aceptada / listo_para_cerrar)            | Texto corto / Enumerado       |
| factura_cierre.id              | Identificador interno de la factura de cierre                                                 | Entero / UUID                 |
| factura_cierre.numero          | Número fiscal de la factura de cierre                                                         | Texto corto                   |
| factura_cierre.fecha           | Fecha de emisión de la factura de cierre                                                      | Fecha                         |
| factura_cierre.importe_total   | Importe total de la factura de cierre (saldo pendiente)                                      | Numérico (decimal)            |
| factura_cierre.estado_documento| Estado del documento (borrador, publicada, etc.)                                             | Enumerado                     |
| factura_cierre.estado_pago     | Estado de pago (pendiente, parcialmente_pagada, pagada)                                      | Enumerado                     |
| factura_cierre.cliente_id      | Referencia al cliente de facturación                                                         | Relación (FK a cliente)       |

### Estimación de esfuerzo (con soporte de IA)

- Cálculo de saldo pendiente y consolidación de totales por proyecto: **0,75–1 día**.
- Generación automática de factura de cierre (modelo, API, numeración, vínculos a proyecto) y lógica de notificación: **1–1,5 días**.
- UI para configuración de evento de cierre + controles en cierre de proyecto: **0,75–1 día**.
- Estimación total para MF-002 con apoyo de IA: **~2,5–3,5 días**.

### Criterios de aceptación (resumen)
- Al cerrar proyecto: si hay saldo pendiente > 0, factura de cierre generada en < 2 min, cliente notificado, factura con estado "Pendiente". Si saldo = 0, no se genera factura y el proyecto puede cerrarse según reglas. Tras confirmación de administración: estado de pago "Recibido"; proyecto listo para cierre formal.

### Historias de usuario
| ID | Título |
|----|--------|
| MF-002-US-001 | Detección de cierre de proyecto / última entrega y cálculo de saldo pendiente de facturar |
| MF-002-US-002 | Generación de factura de cierre por saldo pendiente (si > 0) |
| MF-002-US-003 | Notificación al cliente y registro de factura y estado de pago |
| MF-002-US-004 | Administración confirma recepción de pago (habilita cierre formal del proyecto) |

---

## MF-003 — Facturación núcleo

### Objetivo
Permitir crear, editar en borrador y publicar facturas de cliente con líneas, impuestos y términos de pago, con numeración fiscal por serie, ciclo de vida definido (Borrador → Publicada → Enviada, Vencida, Parcialmente Pagada, Pagada, Cancelada, Rectificada) y bloqueo de campos tras publicar, para cumplir reglas fiscales y de negocio.

### Alcance
- **Incluye**: Listado de facturas con filtros (cliente, estado documento, estado pago); creación manual en borrador (cliente, líneas con descripción/cantidad/precio/impuesto, término de pago); edición en borrador (líneas, descuentos por línea o global, recargos si aplica); acción Publicar (asignar número por serie, pasar a Publicada, bloquear edición de campos fiscales); gestión de estados del ciclo de vida; numeración fiscal (series por país/empresa, prefijos, control de huecos); reglas de bloqueo (campos inamovibles tras publicar; cierre de periodo opcional); detalle de factura con totales e impuestos; vencimientos múltiples según término de pago.
- **Excluye**: Registro de cobros (MF-004), notas de crédito (MF-005), generación/envió de PDF (MF-006).

### Actores
- Usuario con permisos de facturación (crear, editar, publicar según matriz MF-013).

### Proceso detallado (qué debe hacer el sistema)

1. **Listado de facturas**
   - Mostrar tabla con columnas: número, fecha, cliente, total, estado de documento (Borrador, Publicada, Enviada, Vencida, Parcialmente Pagada, Pagada, Cancelada, Rectificada), estado de pago (No pagada, Parcial, Pagada).
   - Filtros: por cliente (selector o búsqueda), por estado de documento, por estado de pago, por rango de fechas.
   - Ordenación por defecto (ej. fecha descendente). Paginación.
   - Permisos: solo ver facturas según visibilidad (todos los clientes o solo "mis clientes" según MF-013).

2. **Creación manual en borrador**
   - Formulario: selección de cliente de facturación (desde maestro MF-011); fecha de factura (por defecto hoy); término de pago (desde maestro); moneda (si MF-012 está activo).
   - Líneas: al menos una. Por línea: descripción, cantidad, precio unitario, impuesto (desde maestro). Cálculo automático: importe línea = cantidad × precio; impuesto según tipo (incluido o no en precio); total línea. Descuento por línea opcional (% o importe).
   - Descuento global opcional (% o importe) aplicado sobre base imponible o total según regla.
   - Totales: subtotal, total impuestos, total descuentos, total factura. Recalcular al cambiar cualquier dato.
   - Al guardar: estado = Borrador; no se asigna número definitivo (se puede usar borrador "BORR-XXX" o sin número hasta publicar).
   - Validaciones: cliente obligatorio; al menos una línea con importe > 0; total factura > 0; término de pago seleccionado.

3. **Edición en borrador**
   - Mismos campos que creación. Permitir añadir, editar y eliminar líneas; cambiar descuentos. No permitir editar si estado ≠ Borrador.

4. **Publicar factura**
   - Solo si estado = Borrador. Acción "Publicar" (o "Confirmar").
   - Asignar número definitivo: obtener siguiente número de la serie configurada para facturas (por empresa/país si aplica); formato según prefijo y secuencia (ej. FAC-2026-00001). Control de huecos según política (alertar si hay hueco o no, según normativa).
   - Cambiar estado a "Publicada".
   - Bloquear edición: no permitir modificar importes, líneas, cliente, fechas fiscales. Solo permitir acciones permitidas sobre factura publicada (enviar, registrar cobro, crear NC, anular, etc.).
   - Opcional: generar y guardar snapshot del PDF en este momento (MF-014).

5. **Ciclo de vida (estados)**
   - **Borrador**: editable.
   - **Publicada**: documento oficial; no editable en contenido fiscal.
   - **Enviada**: se marca cuando se envía por email (desde MF-006) o cuando se notifica al cliente (automático o manual).
   - **Vencida**: cuando la fecha de vencimiento (según término de pago) ha pasado y la factura no está pagada. Puede ser cálculo en tiempo real o job nocturno que actualice estado.
   - **Parcialmente Pagada / Pagada**: actualizados por MF-004 al aplicar cobros.
   - **Cancelada**: factura anulada (no tiene efecto fiscal; no se elimina, solo se marca). Definir si se puede "anular" desde la UI y con qué permiso.
   - **Rectificada**: cuando existe una nota de crédito que la rectifica (MF-005). Opcional mostrar en listado.

6. **Numeración fiscal**
   - Series: configurar al menos una serie para "Factura de cliente" (nombre, prefijo, siguiente número, ejercicio o global). Por empresa si hay multi-empresa.
   - Al publicar: reservar número de la serie; no reutilizar números ya usados; no permitir huecos si la normativa lo exige (o permitir y alertar).
   - Notas de crédito: serie o prefijo distinto (MF-005).

7. **Reglas de bloqueo**
   - Tras "Publicada": no editar cliente, fechas, líneas, importes, impuestos, descuentos. Campos de solo lectura en UI.
   - Cierre de periodo (opcional): si se implementa, no permitir publicar facturas con fecha en un periodo cerrado; solo usuarios con permiso pueden reabrir periodo (fuera de alcance mínimo).

8. **Vencimientos múltiples**
   - Si el término de pago define varios vencimientos (ej. 50% a 30 días, 50% a 60 días), calcular fechas de vencimiento y mostrarlas en la factura o en detalle; el estado "Vencida" puede considerar "algún vencimiento pasado sin pagar" según regla.

### Reglas de negocio
- Una factura en Borrador no tiene número fiscal; el número se asigna una sola vez al publicar.
- No se puede eliminar físicamente una factura publicada; solo cancelar (anulación lógica).
- Redondeo de totales: definir política (por línea o por total; decimales según moneda). Típico: 2 decimales; total = suma de líneas redondeada.
- Impuestos: si el impuesto es "incluido en precio", el precio unitario incluye impuesto; desglosar base e impuesto para el total. Si "no incluido", el impuesto se suma al importe de la línea.

### Validaciones
- Cliente con datos mínimos (nombre, NIF si obligatorio).
- Todas las líneas con cantidad > 0, precio ≥ 0, impuesto seleccionado.
- Total factura > 0.
- Fecha de factura dentro de periodo abierto (si hay cierre de periodo).
- Serie con siguiente número disponible.

### Entidades implicadas
- Factura (cabecera): número, fecha, cliente_id, término_pago_id, estado, estado_pago, totales, moneda, proyecto_id (opcional), serie_id.
- Línea de factura: factura_id, orden, descripción, cantidad, precio_unitario, impuesto_id, descuento_linea, importe_total_linea, base_imponible, importe_impuesto.
- Serie documental: id, nombre, prefijo, siguiente_numero, ejercicio, empresa_id (opcional).

### Campos principales

| Campo                         | Descripción                                                                           | Tipo                          |
|-------------------------------|---------------------------------------------------------------------------------------|-------------------------------|
| factura.id                   | Identificador interno de la factura                                                   | Entero / UUID                 |
| factura.numero               | Número fiscal definitivo de la factura                                               | Texto corto                   |
| factura.serie_id             | Serie documental asociada                                                             | Relación (FK serie)          |
| factura.fecha                | Fecha de emisión de la factura                                                        | Fecha                         |
| factura.cliente_id           | Cliente de facturación                                                                | Relación (FK cliente)        |
| factura.termino_pago_id      | Término de pago aplicado                                                              | Relación (FK término pago)   |
| factura.estado_documento     | Estado del documento (borrador, publicada, enviada, vencida, cancelada, etc.)        | Enumerado                     |
| factura.estado_pago          | Estado de pago (no_pagada, parcial, pagada)                                          | Enumerado                     |
| factura.moneda               | Moneda de la factura (si MF-012 activo)                                              | Enumerado / código ISO       |
| factura.total_base           | Base imponible total                                                                  | Numérico (decimal)           |
| factura.total_impuestos      | Suma de impuestos                                                                     | Numérico (decimal)           |
| factura.total_descuentos     | Suma de descuentos (línea + global)                                                  | Numérico (decimal)           |
| factura.total                | Importe total de la factura                                                           | Numérico (decimal)           |
| linea.id                     | Identificador de la línea de factura                                                  | Entero / UUID                 |
| linea.factura_id             | Referencia a la factura                                                               | Relación (FK factura)        |
| linea.descripcion            | Descripción de la línea                                                               | Texto                         |
| linea.cantidad               | Cantidad                                                                              | Numérico (decimal)           |
| linea.precio_unitario        | Precio unitario                                                                       | Numérico (decimal)           |
| linea.impuesto_id            | Impuesto asociado a la línea                                                          | Relación (FK impuesto)       |
| linea.descuento              | Descuento aplicado a la línea (importe o porcentaje)                                  | Numérico / Estructurado      |
| linea.importe_total          | Importe total de la línea (tras descuento e impuestos)                               | Numérico (decimal)           |

### Estimación de esfuerzo (con soporte de IA)

- Modelado de factura, líneas, series y estados + migraciones: **1–1,5 días**.
- Servicios/API CRUD y lógica de ciclo de vida (publicar, numerar, bloquear, estados): **2–3 días**.
- UI de listado, detalle y edición en borrador (con filtros y validaciones) apoyada en IA: **2–3 días**.
- Estimación total para MF-003: **~5–7 días** de desarrollo efectivo con IA (sin contar QA/manual ni despliegue).

### Criterios de aceptación (resumen)
- Crear factura en borrador con líneas e impuestos; totales correctos; guardar sin número definitivo.
- Publicar: número asignado por serie, estado Publicada, campos bloqueados.
- Listado con filtros y estados correctos; detalle con totales e impuestos desglosados.

### Historias de usuario
| ID | Título |
|----|--------|
| MF-003-US-001 | Listado de facturas con filtros por cliente y estado |
| MF-003-US-002 | Creación manual de factura en borrador (cliente, líneas, impuestos, términos) |
| MF-003-US-003 | Edición de factura en borrador (líneas, descuentos por línea o global) |
| MF-003-US-004 | Publicar factura: asignar número definitivo (serie), pasar a Publicada, bloquear edición |
| MF-003-US-005 | Ciclo de vida: estados Enviada, Vencida, Parcialmente Pagada, Pagada, Cancelada, Rectificada |
| MF-003-US-006 | Numeración fiscal: series por país/empresa, prefijos, control de huecos |
| MF-003-US-007 | Reglas de bloqueo: campos inamovibles tras publicar; cierre de periodo (opcional) |
| MF-003-US-008 | Descuentos por línea y descuento global; recargos (pronto pago, mora) |
| MF-003-US-009 | Detalle de factura (cabecera y líneas) con totales e impuestos desglosados |
| MF-003-US-010 | Vencimientos múltiples según término de pago (fechas de vencimiento) |

---

## MF-004 — Cobros y estado de pago

### Objetivo
Registrar los cobros recibidos (entidad Pago/Cobro), aplicarlos a una o varias facturas (total o parcial), y mantener actualizado el estado de pago de cada factura (No pagada, Parcialmente pagada, Pagada) con trazabilidad.

### Alcance
- **Incluye**: Asistente o formulario para registrar un pago (fecha, importe, método de pago, referencia); aplicación de ese pago a una factura (importe a aplicar: total o parcial); aplicación de un mismo pago a varias facturas (reparto manual o por orden); actualización del saldo pendiente y del estado de pago de la factura; listado de cobros con relación cobro ↔ factura(s); reverso de una aplicación (anular aplicación y devolver estado de la factura).
- **Excluye**: Pasarela de pago online (MF-009); lógica de anticipos y descuento en factura (MF-008).

### Actores
- Usuario con permiso "Registrar cobros" (MF-013).

### Proceso detallado (qué debe hacer el sistema)

1. **Registrar un pago (crear entidad Pago/Cobro)**
   - Formulario o asistente: fecha del cobro (fecha valor), importe total del pago, método de pago (selector desde configuración: transferencia, efectivo, tarjeta, etc.), referencia (número de operación, cheque, etc.), opcional nota.
   - Guardar como registro "Pago" o "Cobro" con estado "Pendiente de aplicar" o "Parcialmente aplicado" / "Aplicado" según si ya se ha aplicado todo el importe a facturas.
   - No se asocia aún a ninguna factura en este paso (o se puede ir directo al paso 2 en el mismo flujo).

2. **Aplicar pago a una factura**
   - Desde el pago: acción "Aplicar a factura(s)". Seleccionar factura (solo facturas del mismo cliente que el pago, si el pago tiene cliente; o facturas en estado No pagada o Parcialmente pagada). Indicar importe a aplicar (≤ saldo pendiente de la factura y ≤ importe disponible del pago).
   - Desde la factura: acción "Registrar cobro". Seleccionar pago existente o crear uno nuevo; indicar importe a aplicar.
   - Crear registro "Aplicación de pago" (o "Línea de cobro"): pago_id, factura_id, importe_aplicado, fecha.
   - Actualizar saldo pendiente de la factura: saldo_pendiente -= importe_aplicado.
   - Actualizar estado de pago de la factura: si saldo_pendiente == 0 → "Pagada"; si 0 < saldo_pendiente < total_factura → "Parcialmente pagada"; si no aplicado nada aún → "No pagada".
   - Actualizar importe "restante" del pago: importe_disponible = importe_pago − suma(importes aplicados). Si importe_disponible == 0, el pago está "Aplicado" por completo.

3. **Aplicar un pago a varias facturas**
   - Mismo pago puede aplicarse a varias facturas en sucesivas aplicaciones (o en una pantalla donde se reparte el importe entre varias facturas).
   - Validar: suma de importes aplicados ≤ importe del pago; por factura, importe aplicado ≤ saldo pendiente.
   - Orden sugerido: por fecha de factura o por vencimiento (el usuario elige a qué factura aplicar primero).

4. **Listado de cobros**
   - Tabla: fecha, importe, método de pago, referencia, cliente (si el pago tiene cliente), estado (Pendiente aplicado / Parcial / Aplicado), detalle de facturas aplicadas (enlace o sublista).
   - Filtros: por fecha, cliente, método de pago.

5. **Reverso de aplicación**
   - Acción "Anular aplicación" en una línea de aplicación (pago X aplicado a factura Y por importe Z).
   - Eliminar o marcar como anulada esa aplicación; devolver el importe Z al saldo pendiente de la factura Y; actualizar estado de pago de Y; aumentar el importe disponible del pago X en Z.
   - Solo permitir si no hay restricciones (ej. periodo cerrado; definir política).

### Reglas de negocio
- El importe aplicado a una factura no puede superar el saldo pendiente de la factura ni el importe disponible del pago.
- Una factura en estado "Cancelada" no debe recibir aplicaciones de pago.
- Saldo pendiente de factura = total_factura − suma(importes aplicados a esa factura). Recalcular si hay reversos.
- Estado de pago: derivado siempre del saldo pendiente (no editable manualmente de forma independiente).

### Validaciones
- Fecha de cobro coherente (no futura si el sistema no lo permite).
- Importe del pago > 0.
- Al aplicar: factura en estado que permita cobro (Publicada, no Cancelada); mismo cliente (si el pago está asociado a cliente).

### Entidades implicadas
- Pago/Cobro: id, fecha, importe, metodo_pago_id, referencia, cliente_id (opcional), estado_aplicacion.
- Aplicación de pago: id, pago_id, factura_id, importe_aplicado, fecha_aplicacion. (Permite trazabilidad y reverso.)
- Factura: saldo_pendiente, estado_pago (calculado o persistido).

### Campos principales

| Campo                         | Descripción                                                                           | Tipo                          |
|-------------------------------|---------------------------------------------------------------------------------------|-------------------------------|
| pago.id                      | Identificador del pago/cobro                                                         | Entero / UUID                 |
| pago.fecha                   | Fecha valor del cobro                                                                 | Fecha                         |
| pago.importe_total           | Importe total registrado para el pago                                               | Numérico (decimal)           |
| pago.metodo_pago_id          | Método de pago (transferencia, efectivo, tarjeta, etc.)                              | Relación (FK método)         |
| pago.referencia              | Referencia externa (nº operación, cheque, etc.)                                      | Texto corto                   |
| pago.cliente_id              | Cliente al que se asocia el pago (si aplica)                                         | Relación (FK cliente)        |
| pago.estado_aplicacion       | Estado del pago (pendiente_aplicar, parcial, aplicado)                               | Enumerado                     |
| aplicacion_pago.id           | Identificador de la aplicación de pago a factura                                     | Entero / UUID                 |
| aplicacion_pago.pago_id      | Referencia al pago                                                                   | Relación (FK pago)           |
| aplicacion_pago.factura_id   | Referencia a la factura                                                              | Relación (FK factura)        |
| aplicacion_pago.importe      | Importe aplicado de ese pago a esa factura                                           | Numérico (decimal)           |
| factura.saldo_pendiente      | Saldo sin cobrar de la factura                                                       | Numérico (decimal)           |
| factura.estado_pago          | Estado de pago de la factura derivado de sus aplicaciones                           | Enumerado                     |

### Estimación de esfuerzo (con soporte de IA)

- Diseño de entidades Pago y AplicaciónPago + migraciones: **0,5–0,75 días**.
- Lógica de aplicación/reverso de cobros y actualización de saldo/estado de factura: **1–1,5 días**.
- UI de registro de pagos, asistente de aplicación y listado de cobros: **1–1,5 días**.
- Estimación total para MF-004: **~3–4 días** de desarrollo apoyado en IA.

### Criterios de aceptación (resumen)
- Registrar pago; aplicarlo a una o varias facturas; ver estado de pago actualizado en la factura y en el listado.
- Reverso: anular aplicación y ver saldos y estados correctos.

### Historias de usuario
| ID | Título |
|----|--------|
| MF-004-US-001 | Asistente Registrar pago: fecha, importe, método de pago, referencia |
| MF-004-US-002 | Aplicar pago a una factura (total o parcial); actualizar saldo pendiente |
| MF-004-US-003 | Aplicar un pago a varias facturas (reparto manual o por orden) |
| MF-004-US-004 | Estado de pago en factura: No pagada, Parcialmente pagada, Pagada |
| MF-004-US-005 | Listado de cobros y relación cobro ↔ factura(s) aplicadas |
| MF-004-US-006 | Reverso de aplicación de pago (anular aplicación, devolver estado) |

---

## MF-005 — Notas de crédito

### Objetivo
Emitir notas de crédito (abonos) vinculadas a una factura ya publicada, con importes o líneas a revertir, numeración propia y trazabilidad con la factura original.

### Alcance
- **Incluye**: Acción "Crear nota de crédito" desde una factura publicada; formulario con importes o líneas a revertir; documento tipo "Nota de crédito" con serie/prefijo distinto; vinculación factura original; publicar NC y actualizar trazabilidad (factura "Rectificada" o relación NC ↔ Factura).
- **Excluye**: Notas de débito (fuera de alcance inicial).

### Proceso detallado
1. Desde la ficha de una factura en estado Publicada (y no Cancelada), el usuario con permiso ejecuta "Crear nota de crédito".
2. Se abre formulario de NC: factura original ya vinculada (solo lectura). Opciones: (a) revertir total de la factura, (b) revertir importe parcial, (c) revertir por líneas (seleccionar líneas y cantidades/importes). Totales de la NC se calculan (negativos o como abono según representación).
3. La NC se guarda en borrador; se puede editar y luego "Publicar". Al publicar: se asigna número por serie de "Nota de crédito" (prefijo ej. NC- o R-); estado NC = Publicada; factura original se marca como "Rectificada" o se guarda relación factura_id → nc_id.
4. No se permite eliminar la factura original; la NC es el documento que rectifica. Contablemente el efecto es reducir el débito del cliente (abono).

### Reglas de negocio
- Solo una factura en estado Publicada (no Cancelada) puede tener una NC asociada (o varias NC si el negocio lo permite; el total de NC no debe superar el total de la factura).
- Numeración de NC independiente de la de facturas (serie o prefijo distinto).
- La NC tiene los mismos datos fiscales de cliente y fechas coherentes (misma fecha o posterior).

### Validaciones
- Total NC ≤ total factura original (si es parcial). Total NC > 0.
- Factura original no cancelada.

### Campos principales

| Campo                    | Descripción                                                                  | Tipo                    |
|--------------------------|------------------------------------------------------------------------------|-------------------------|
| factura_original.id      | Identificador de la factura que será rectificada                            | Entero / UUID          |
| factura_original.numero  | Número de la factura original                                               | Texto corto            |
| factura_original.total   | Importe total de la factura original                                       | Numérico (decimal)     |
| nc.id                    | Identificador de la nota de crédito                                         | Entero / UUID          |
| nc.numero                | Número de la nota de crédito (serie/prefijo propio)                         | Texto corto            |
| nc.fecha                 | Fecha de emisión de la nota de crédito                                      | Fecha                  |
| nc.total                 | Importe total de la nota de crédito (positivo o negativo según modelo)      | Numérico (decimal)     |
| nc.motivo                | Motivo o descripción de la rectificación                                    | Texto                  |
| nc.lineas                | Colección de líneas rectificadas (referencia a líneas de factura)           | Colección / relación   |
| nc.estado_documento      | Estado de la NC (borrador, publicada, cancelada, etc.)                      | Enumerado              |
| relacion.factura_id      | Referencia desde NC a factura original                                      | Relación (FK factura)  |

### Estimación de esfuerzo (con soporte de IA)

- Modelado de notas de crédito y relación con factura original: **0,5–0,75 días**.
- Lógica de creación desde factura, cálculo de importes y publicación/anulación: **1–1,25 días**.
- Ajustes de UI (acción “Crear NC”, formulario, listados) con apoyo de IA: **0,75–1 día**.
- Estimación total para MF-005: **~2,25–3 días** de desarrollo efectivo.

### Criterios de aceptación (resumen)
- Crear NC desde factura; definir importes/líneas a revertir; publicar con número; vinculación visible en factura y en NC.

### Historias de usuario
| ID | Título |
|----|--------|
| MF-005-US-001 | Crear nota de crédito desde factura publicada (acción en factura) |
| MF-005-US-002 | Definir importes o líneas a revertir en la NC |
| MF-005-US-003 | Vincular NC a factura original; numeración con serie/prefijo para NC |
| MF-005-US-004 | Publicar NC y actualizar trazabilidad (factura rectificada / estado) |

---

## MF-006 — PDF y envío por email

### Objetivo
Generar el documento oficial de la factura (o nota de crédito) en PDF con diseño estándar y datos de empresa y cliente; permitir descargar el PDF desde la ficha y enviar la factura por email al cliente con el PDF adjunto.

### Proceso detallado
1. **Generar PDF**: A partir de los datos de la factura (cabecera, líneas, totales, impuestos, datos empresa desde MF-011, datos cliente), generar un archivo PDF con diseño estándar (logo, tabla de líneas, totales, condiciones si aplican). Mismo criterio para nota de crédito con indicación clara de "Nota de crédito" y referencia a factura original.
2. **Descargar PDF**: En la ficha de factura (o NC), botón "Descargar PDF" que genera (o recupera si está cacheado) el PDF y lo sirve para descarga.
3. **Enviar por email**: Botón "Enviar por email"; formulario con destinatario (por defecto email del cliente), asunto y cuerpo opcional; adjuntar el PDF generado; enviar y registrar envío (MF-014: destinatario, fecha, tipo). Marcar factura como "Enviada" si aplica.

### Reglas de negocio
- Solo facturas/NC publicadas pueden tener PDF oficial y envío.
- El PDF debe ser reproducible (mismos datos → mismo contenido) para auditoría.

### Campos principales

| Campo                 | Descripción                                                        | Tipo                 |
|-----------------------|--------------------------------------------------------------------|----------------------|
| factura.id            | Identificador de la factura/NC                                    | Entero / UUID        |
| factura.numero        | Número a mostrar en el PDF                                        | Texto corto          |
| factura.fecha         | Fecha de la factura                                               | Fecha                |
| factura.cliente_id    | Cliente de facturación                                            | Relación (FK cliente)|
| factura.total         | Importe total a mostrar                                           | Numérico (decimal)   |
| factura.moneda        | Moneda de la factura                                              | Enumerado / código   |
| factura.direccion_empresa | Datos fiscales de la empresa emisora                        | Texto / compuesto    |
| factura.direccion_cliente | Datos de facturación del cliente                             | Texto / compuesto    |
| pdf.ruta_almacenamiento  | Ruta o identificador del PDF generado                         | Texto (ruta/URL)     |
| pdf.plantilla_id      | Identificador de la plantilla de diseño de PDF                    | Relación / texto     |
| envio.id              | Identificador del registro de envío                               | Entero / UUID        |
| envio.destinatario    | Email al que se envía la factura                                  | Texto (email)        |
| envio.fecha_envio     | Fecha/hora en que se envía el email                              | Fecha/hora           |
| envio.asunto          | Asunto del correo                                                 | Texto corto          |

### Estimación de esfuerzo (con soporte de IA)

- Integración con generador de PDF (plantilla, datos, snapshot) y almacenamiento: **1–1,5 días**.
- Lógica de descarga y endpoint/acción de envío por email + registro en auditoría: **1–1,25 días**.
- Ajustes de UI (botones Descargar PDF / Enviar por email) y pruebas básicas: **0,5–0,75 días**.
- Estimación total para MF-006: **~2,5–3,5 días** de desarrollo apoyado en IA.

### Criterios de aceptación (resumen)
- PDF generado correctamente con todos los datos; descarga desde ficha; envío por email con adjunto y registro.

### Historias de usuario
| ID | Título |
|----|--------|
| MF-006-US-001 | Generar PDF oficial de factura (diseño estándar, datos empresa y cliente) |
| MF-006-US-002 | Descargar PDF desde la ficha de factura o nota de crédito |
| MF-006-US-003 | Enviar factura por email al cliente con PDF adjunto (desde ficha) |

---

## MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

### Objetivo
Los proyectos se facturan **mensualmente** en función de lo realizado en cada periodo: **tareas realizadas**, **horas registradas** (facturables), **hitos completados** o **fee mensual** acordado. El sistema debe permitir generar la factura del periodo con líneas derivadas de esos conceptos, **evitando doble facturación** (no facturar dos veces la misma tarea, las mismas horas ni el mismo hito/periodo) y manteniendo **trazabilidad factura → proyecto** (y, a nivel de línea, factura → tarea/hito/periodo cuando aplique).

### Alcance
- **Incluye**: Facturación por **periodo mensual** (o periodo configurable); líneas generadas desde tareas realizadas en el periodo (no facturadas antes), horas facturables del periodo (no facturadas), hitos completados en el periodo (no facturados) o fee mensual; **prevención de doble facturación** (marcar como facturados tareas/horas/hitos/periodos; bloquear o alertar si se intenta facturar de nuevo); **trazabilidad** factura ↔ proyecto y listado de facturas por proyecto; prerellenar cliente desde el proyecto.
- **Excluye**: Facturación totalmente automática sin revisión del usuario (el usuario debe poder revisar y ajustar líneas antes de publicar).

### Actores
- Usuario con permisos de facturación y acceso al proyecto (responsable, administración).

### Proceso detallado (qué debe hacer el sistema)

1. **Inicio: facturación mensual desde proyecto**
   - En la ficha del proyecto (o panel "Facturación"), botón "Crear factura de periodo" o "Facturar mes".
   - El usuario selecciona el **periodo a facturar** (ej. mes enero 2026). El sistema debe permitir solo periodos para los que existan tareas/horas/hitos realizados y que **no hayan sido ya facturados** (prevención doble facturación).
   - Si el periodo ya tiene una factura asociada al proyecto, el sistema debe indicarlo y no permitir crear otra factura para el mismo proyecto+periodo (o permitir solo si hay concepto "rectificación" vía NC y nueva factura según política).

2. **Generación de líneas según tipo de facturación**
   - **Por tareas realizadas**: Consultar tareas del proyecto con estado "Completada" (o equivalente) cuya fecha de cierre esté dentro del periodo seleccionado y que **no tengan ya asociada una factura** (campo factura_id o tabla facturación_tarea). Por cada tarea: línea de factura con descripción (nombre tarea), importe (precio o horas × tarifa según configuración). Al confirmar la factura, marcar esas tareas como "facturadas" (factura_id o registro en tabla de líneas facturadas).
   - **Por horas**: Consultar registros de tiempo (timesheet) del proyecto en el periodo marcados como "facturables", que **no estén ya vinculados a una factura**. Agrupar por concepto o por recurso; línea de factura por agrupación (descripción, horas, tarifa, importe). Al confirmar, marcar esas horas como facturadas (factura_id en el registro de tiempo o en tabla resumen).
   - **Por hitos**: Consultar hitos del proyecto con estado "Completado" en el periodo y **no facturados**. Por cada hito: línea con descripción (nombre hito) e importe (presupuestado o fijo). Marcar hitos como facturados al publicar la factura.
   - **Por fee mensual**: Si el proyecto tiene configurado un "fee mensual" (importe fijo por mes), una línea con ese importe para el periodo seleccionado. Validar que ese mes no esté ya facturado (no existe ya factura para proyecto + ese mes con concepto fee).
   - El usuario puede combinar varios tipos (ej. horas + un hito + fee) en la misma factura del periodo. Las líneas se generan automáticamente pero el usuario puede **revisar, editar en borrador o excluir** líneas antes de publicar (según MF-003: factura en borrador editable).

3. **Cliente y cabecera de factura**
   - Cliente de facturación = cliente/contacto del proyecto (prerellenado). Proyecto_id = proyecto actual. Periodo facturado = mes (o rango) seleccionado; guardar en la factura (campo periodo_facturado o fecha_desde/fecha_hasta) para trazabilidad y prevención de doble facturación.
   - La factura se crea en estado **Borrador** (MF-003); el usuario puede ajustar líneas o importes y luego **Publicar**. Al publicar se asignan número definitivo y se **marcan como facturados** todos los conceptos (tareas/horas/hitos/periodo fee) incluidos en las líneas.

4. **Prevención de doble facturación**
   - **Por periodo**: Para un mismo proyecto y mismo mes (o periodo), solo puede existir una factura "de periodo" publicada. Al intentar crear una nueva factura para el mismo proyecto y mes, el sistema debe advertir: "Ya existe la factura [número] para este proyecto y periodo" y no permitir duplicar (o permitir solo si se anula la anterior y se rectifica con NC).
   - **Por tarea/hora/hito**: Cada tarea, cada registro de horas facturables y cada hito solo pueden estar asociados a **una** factura. En la pantalla de "Facturar periodo", solo se listan tareas/horas/hitos **aún no facturados** en ese periodo. Si por error se intentara incluir un concepto ya facturado, el sistema debe validar y rechazar o advertir.
   - **Fee mensual**: Para proyecto + mes, el fee solo puede facturarse una vez (una línea de fee por mes en una sola factura).

5. **Trazabilidad factura → proyecto**
   - Toda factura generada desde proyecto tiene **proyecto_id** no nulo y opcionalmente **periodo_facturado** (mes/año o rango).
   - En la ficha del **proyecto**: sección "Facturación" con listado de facturas del proyecto (número, fecha, periodo, total, estado de pago). Resumen: "Total facturado: X" (suma de facturas del proyecto), "Pendiente de cobro: Y", y si hay presupuesto "Presupuesto: Z" (para comparar).
   - En la ficha de la **factura**: campo/etiqueta "Proyecto: [nombre]" con enlace al proyecto; "Periodo facturado: [mes/año]". Opcional: desglose "Líneas generadas desde: tareas X, Y; horas Z; hito W; fee mes M".

6. **Vista en proyecto: total facturado y pendiente por periodo**
   - Mostrar por proyecto: facturas emitidas (lista), total facturado, total pendiente de cobro, y por cada mes (o periodo) si hay factura o no ("Enero 2026: Factura FAC-001" o "Enero 2026: Pendiente de facturar"). Facilita saber qué periodos faltan por facturar y evita olvidos.

### Reglas de negocio
- Una factura de periodo está asociada a **un solo proyecto** y a **un solo periodo** (mes o rango). No se puede reasignar a otro proyecto.
- Ninguna tarea, registro de horas ni hito puede estar en más de una factura (campo factura_id o tabla de asignación factura–concepto).
- El periodo a facturar debe ser coherente con las fechas de las tareas/horas/hitos (ej. solo incluir tareas cerradas en ese mes).
- Si el proyecto tiene presupuesto total, el sistema puede alertar (no bloquear necesariamente) si el total facturado supera el presupuesto (MF-008).

### Validaciones
- Proyecto existe y usuario tiene permiso. Periodo no futuro (o según política).
- Al menos una línea con importe > 0 para poder publicar.
- No existir ya factura publicada para el mismo proyecto + mismo periodo (salvo flujo de rectificación).
- Cliente de facturación del proyecto con datos mínimos.

### Entidades implicadas
- **Factura**: proyecto_id, periodo_facturado (mes/año o fecha_desde/fecha_hasta), cliente_id (desde proyecto).
- **Línea de factura**: factura_id, origen_tipo (tarea | horas | hito | fee_mensual), origen_id (tarea_id, registro horas, hito_id, o null para fee), descripción, importe.
- **Tarea / Registro tiempo / Hito**: campo factura_id (o tabla facturacion_linea_origen) para marcar como facturado.
- **Proyecto**: configuración opcional fee_mensual, presupuesto_total.

### Campos principales

| Campo                          | Descripción                                                                       | Tipo                          |
|--------------------------------|-----------------------------------------------------------------------------------|-------------------------------|
| proyecto.id                    | Identificador del proyecto                                                        | Entero / UUID                 |
| proyecto.cliente_id           | Cliente asociado al proyecto                                                      | Relación (FK cliente)        |
| proyecto.fee_mensual          | Importe fijo mensual configurado (si aplica)                                      | Numérico (decimal)           |
| proyecto.presupuesto_total    | Presupuesto total del proyecto                                                    | Numérico (decimal)           |
| proyecto.periodo_facturado[]  | Lista de periodos ya facturados para prevención de doble facturación             | Colección / estructura       |
| factura.id                    | Identificador de la factura de periodo                                            | Entero / UUID                 |
| factura.periodo_facturado     | Periodo (mes/año o rango) que cubre la factura                                    | Texto estructurado / fecha   |
| factura.proyecto_id           | Proyecto desde el que se ha generado la factura                                  | Relación (FK proyecto)       |
| linea.id                      | Identificador de la línea de factura                                              | Entero / UUID                 |
| linea.origen_tipo             | Tipo de origen de la línea (tarea, horas, hito, fee_mensual)                     | Enumerado                     |
| linea.origen_id               | Identificador del elemento origen (tarea_id, registro_tiempo_id, hito_id, etc.)  | Entero / UUID / Null         |
| linea.descripcion             | Descripción generada (nombre tarea, hito, resumen de horas, etc.)                | Texto                         |
| linea.importe                 | Importe de la línea                                                               | Numérico (decimal)           |
| origen.facturado              | Marca en tarea/registro/hito de que ya ha sido facturado                         | Booleano                      |

### Estimación de esfuerzo (con soporte de IA)

- Integración entre proyectos y facturación (modelo, vínculos, periodo facturado): **1–1,5 días**.
- Lógica de generación de líneas por tareas/horas/hitos/fee y prevención de doble facturación: **2–3 días**.
- UI en ficha de proyecto (selector de periodo, vista de facturas por periodo, totales) con apoyo de IA: **1,5–2 días**.
- Estimación total para MF-007: **~4,5–6,5 días** de desarrollo efectivo.

### Criterios de aceptación (resumen)
- Crear factura de periodo (mes) desde proyecto; líneas generadas desde tareas realizadas, horas facturables, hitos o fee mensual; solo conceptos no facturados previamente; al publicar, conceptos quedan marcados como facturados; no se puede crear segunda factura para el mismo proyecto+periodo; trazabilidad visible en proyecto (listado facturas, total facturado) y en factura (proyecto, periodo).

### Historias de usuario
| ID | Título |
|----|--------|
| MF-007-US-001 | Facturación mensual: seleccionar proyecto y periodo (mes) a facturar |
| MF-007-US-002 | Generar líneas desde tareas realizadas en el periodo (no facturadas previamente) |
| MF-007-US-003 | Generar líneas desde horas registradas facturables en el periodo (no facturadas) |
| MF-007-US-004 | Generar líneas desde hitos completados en el periodo (no facturados previamente) |
| MF-007-US-005 | Facturación por fee mensual: importe fijo por mes asociado al proyecto |
| MF-007-US-006 | Prevención doble facturación: marcar tareas/horas/hitos/periodos como facturados; alertas |
| MF-007-US-007 | Trazabilidad factura → proyecto; listado de facturas por proyecto y por periodo |
| MF-007-US-008 | Prerellenar cliente/contacto de facturación desde proyecto |
| MF-007-US-009 | Vista en proyecto: total facturado, pendiente por periodo, facturas del proyecto |

---

## MF-008 — Anticipos y facturación parcial (en contexto de facturación mensual)

### Objetivo
Soportar **anticipos** (importe o % sobre proyecto) facturados al inicio y su **descuento en las facturas mensuales** (o en factura de cierre) del mismo proyecto. **Facturación parcial** en este modelo son las **múltiples facturas mensuales** por proyecto (MF-007); aquí se añade el control de **total facturado vs presupuesto** y la gestión de anticipos pendientes de descontar.

### Alcance
- Anticipos asociados a proyecto; descuento del anticipo repartido en facturas mensuales posteriores (o en una sola factura de cierre).
- Vista de anticipos pendientes de descontar por proyecto/cliente.
- Total facturado por proyecto (suma de facturas mensuales + anticipos) vs presupuesto; alertas si se supera.

### Proceso detallado
1. **Factura de anticipo**: Crear factura con tipo "Anticipo", asociada a proyecto/cliente; importe = anticipo (fijo o % del presupuesto). Al publicar, se registra como anticipo pendiente de descontar (importe restante a descontar = importe del anticipo). Tabla o campo: anticipo_id, proyecto_id, importe_total, importe_descontado.
2. **Descontar en facturas mensuales**: Al crear una factura de periodo (MF-007) para el mismo proyecto, el sistema muestra "Anticipos pendientes de descontar: X". El usuario puede añadir una línea negativa (descuento) por todo o parte del anticipo pendiente. Al publicar la factura, se actualiza importe_descontado del anticipo; no se puede descontar más del pendiente. Opción: reparto automático (ej. descontar X% del anticipo en cada factura mensual hasta agotar).
3. **Total facturado vs presupuesto**: En la vista de facturación del proyecto (MF-007), mostrar "Total facturado: X" (suma de todas las facturas del proyecto, incluidas de anticipo y mensuales) y "Presupuesto: Y". Alerta (warning) si X > Y. No bloquear por defecto la emisión si se supera (decisión de negocio).
4. **Vista anticipos pendientes**: Listado por proyecto o por cliente: anticipos con importe_descontado < importe_total; indicar "Pendiente de descontar: Z".

### Reglas de negocio
- Un anticipo solo puede descontarse hasta su importe total (suma de descuentos aplicados en facturas ≤ importe anticipo).
- Total descontado en una factura ≤ anticipo pendiente de ese proyecto en el momento de publicar.

### Campos principales

| Campo                         | Descripción                                                                       | Tipo                          |
|-------------------------------|-----------------------------------------------------------------------------------|-------------------------------|
| anticipo.id                  | Identificador del anticipo                                                        | Entero / UUID                 |
| anticipo.proyecto_id         | Proyecto al que está asociado el anticipo                                         | Relación (FK proyecto)       |
| anticipo.importe_total       | Importe total del anticipo                                                        | Numérico (decimal)           |
| anticipo.importe_descontado  | Importe del anticipo ya aplicado en facturas                                      | Numérico (decimal)           |
| anticipo.importe_pendiente   | Importe aún pendiente de descontar                                                | Numérico (decimal)           |
| anticipo.moneda              | Moneda del anticipo                                                               | Enumerado / código           |
| factura.id                   | Identificador de la factura donde se descuenta el anticipo                        | Entero / UUID                 |
| factura.proyecto_id          | Proyecto de la factura                                                            | Relación (FK proyecto)       |
| factura.linea_descuento_id   | Línea (o líneas) de descuento asociadas al anticipo                               | Relación / colección         |
| proyecto.total_facturado     | Total facturado del proyecto (incluye anticipos y facturas mensuales)            | Numérico (decimal)           |
| proyecto.presupuesto_total   | Presupuesto de referencia para comparativa                                        | Numérico (decimal)           |

### Estimación de esfuerzo (con soporte de IA)

- Modelo de anticipo y relación con proyecto/facturas: **0,75–1 día**.
- Lógica de descuento automático/manualmente configurable en facturas mensuales + control de pendiente: **1–1,5 días**.
- UI para gestión de anticipos y vista de total facturado vs presupuesto: **1–1,5 días**.
- Estimación total para MF-008: **~3–4 días** con apoyo de IA.

### Criterios de aceptación (resumen)
- Crear factura anticipo; descontar anticipo en facturas mensuales (o cierre); ver total facturado por proyecto y anticipos pendientes; alerta si total facturado > presupuesto.

### Historias de usuario
| ID | Título |
|----|--------|
| MF-008-US-001 | Crear factura de anticipo (importe o %) asociada a proyecto/cliente |
| MF-008-US-002 | Descontar anticipo en facturas mensuales (reparto por factura o en cierre) |
| MF-008-US-003 | Facturación parcial: total facturado por proyecto (mensual + anticipos) vs presupuesto |
| MF-008-US-004 | Vista de anticipos pendientes de descontar por proyecto/cliente |

---

## MF-009 — Portal del cliente

### Objetivo
Dar al cliente un área (portal) donde ver y descargar sus facturas sin acceder al back-office, mediante token mágico o autenticación por cliente, con evidencia de visualización/descarga si se requiere.

### Proceso detallado
1. **Acceso**: URL del portal (ej. /facturacion-portal o enlace con token). Si es token: parámetro ?token=XXX que identifica al cliente o a la sesión; validar token y mostrar solo facturas de ese cliente. Si es login: usuario "cliente" con ámbito restringido a sus facturas.
2. **Listado**: Mostrar facturas del cliente (número, fecha, total, estado de pago, enlace "Descargar PDF").
3. **Descarga**: Al descargar un PDF, opcionalmente registrar "evidencia de visualización" (fecha, IP, documento) en MF-014.
4. Opcional: pasarela de pago online (fuera de alcance inicial; si se añade, el pago registrado actualizaría estado de pago vía MF-004).

### Reglas de negocio
- Un cliente solo ve sus propias facturas (filtro por cliente_id según identidad del token/usuario).
- Token con caducidad o uso único según política de seguridad.

### Criterios de aceptación (resumen)
- Acceso seguro; listado de facturas del cliente; descarga PDF; opcional evidencia de visualización.

### Historias de usuario
| ID | Título |
|----|--------|
| MF-009-US-001 | Acceso al portal de facturación con token mágico o login cliente |
| MF-009-US-002 | Historial de facturas del cliente (listado con estado de pago) |
| MF-009-US-003 | Descargar PDF de factura y nota de crédito desde el portal |
| MF-009-US-004 | Registro de evidencia de visualización/descarga (auditoría) |

---

## MF-010 — Dashboard y reportes operativos

### Objetivo
Ofrecer una vista resumen (dashboard) y reportes de facturación y cobro: pendiente de cobro, cobrado por período, por cliente/proyecto, aging de saldos y exportaciones.

### Proceso detallado
1. **Dashboard**: Tarjetas o KPIs: "Total pendiente de cobro" (suma de saldos pendientes de facturas no canceladas); "Total cobrado en [período]" (suma de cobros con fecha en el período); opcional "Facturación emitida en [período]". Filtro por fechas y opcionalmente por cliente.
2. **Resumen por cliente**: Tabla cliente, total facturado, total cobrado, pendiente de cobro.
3. **Resumen por proyecto**: Si hay proyecto_id en facturas: proyecto, total facturado, total cobrado, pendiente.
4. **Aging**: Listado de facturas con saldo pendiente > 0, con columnas "0-30 días", "31-60", "61-90", ">90" según días desde vencimiento (o desde fecha factura). Totales por antigüedad.
5. **Exportar**: Botón exportar listado de facturas o de cobros a Excel/CSV con columnas configuradas (número, fecha, cliente, total, estado pago, saldo, etc.).

### Reglas de negocio
- Cálculos en tiempo real desde datos de facturas y aplicaciones de pago (o vistas materializadas si hay volumen).
- Filtros de fecha coherentes con zona horaria y periodo contable si aplica.

### Criterios de aceptación (resumen)
- Dashboard con pendiente y cobrado; aging; exportación Excel/CSV.

### Historias de usuario
| ID | Título |
|----|--------|
| MF-010-US-001 | Dashboard: facturas pendientes de cobro y total cobrado por período |
| MF-010-US-002 | Resumen por cliente y por proyecto (facturado, cobrado, pendiente) |
| MF-010-US-003 | Reporte aging (antigüedad de saldos por factura/cliente) |
| MF-010-US-004 | Exportar listados a Excel/CSV (facturas, cobros) |
| MF-010-US-005 | Filtros por fecha, estado de pago, cliente, proyecto |

---

## MF-011 — Maestros

### Objetivo
Mantener los datos base necesarios para facturación: términos de pago, impuestos, cliente/contacto de facturación (o extensión del cliente/área de Kameleon), configuración de empresa para documentos, y opcionalmente productos/tarifas y precios por cliente.

### Proceso detallado

1. **Términos de pago**: CRUD. Campos: nombre, tipo (contado, 30 días, 60 días, etc.), definición de vencimientos (días desde fecha factura, o fechas fijas, o porcentaje a 30/60 días). Usado al crear factura para calcular fecha(s) de vencimiento.
2. **Impuestos**: CRUD. Campos: nombre, porcentaje, tipo (incluido en precio / no incluido), cuenta contable si aplica (fuera de alcance mínimo). Opcional: exenciones, retenciones. Al añadir línea de factura se selecciona impuesto; el sistema calcula base e importe de impuesto según el tipo.
3. **Cliente/contacto de facturación**: Reutilizar o extender entidad "cliente" o "contacto" de Kameleon. Campos mínimos: nombre, NIF/CIF, dirección, email, término de pago por defecto. Vincular a proyecto (cliente del proyecto) para prerellenar en MF-007.
4. **Configuración empresa**: Datos para el pie o cabecera del PDF: nombre legal, NIF, dirección, logo (URL o archivo). Una empresa por defecto si no hay multi-empresa.
5. **Productos/tarifas (opcional)**: Catálogo de productos o servicios con descripción, unidad de medida, precio, impuesto por defecto. Al añadir línea en factura se puede elegir producto y rellenar cantidad y precio. Opcional: precios por cliente o tarifa.

### Campos principales (maestros)

| Campo                         | Descripción                                                                 | Tipo                          |
|-------------------------------|-----------------------------------------------------------------------------|-------------------------------|
| termino_pago.nombre          | Nombre visible del término de pago (p.ej. Contado, 30 días)                | Texto corto                   |
| termino_pago.tipo            | Clasificación del término (contado, 30 días, 60 días, personalizado, etc.) | Enumerado                     |
| termino_pago.definicion      | Regla de vencimiento (días desde factura, fechas fijas, % a 30/60 días…)   | Texto estructurado / JSON    |
| impuesto.nombre              | Nombre del impuesto (p.ej. IVA 21%)                                         | Texto corto                   |
| impuesto.porcentaje          | Porcentaje aplicable                                                        | Numérico (decimal)           |
| impuesto.tipo_calculo        | Indicador de si el impuesto va incluido o no en el precio                  | Enumerado                     |
| impuesto.activo              | Marca para usar / no usar en nuevas facturas                               | Booleano                     |
| cliente_facturacion.nombre   | Razón social / nombre del cliente de facturación                           | Texto corto                   |
| cliente_facturacion.nif      | NIF/CIF u otro identificador fiscal                                         | Texto corto                   |
| cliente_facturacion.direccion| Dirección fiscal                                                            | Texto largo                   |
| cliente_facturacion.email    | Email de contacto para facturas                                            | Texto (email)                |
| cliente_facturacion.termino_pago_id | Término de pago por defecto para este cliente                       | Relación (FK a termino_pago) |
| empresa.nombre_legal         | Nombre legal que se mostrará en el PDF                                     | Texto corto                   |
| empresa.nif                  | NIF/CIF de la empresa emisora                                              | Texto corto                   |
| empresa.direccion            | Dirección fiscal de la empresa                                             | Texto largo                   |
| empresa.logo_url             | Ruta o URL del logo a usar en PDFs                                         | Texto (URL / ruta)           |
| producto.nombre              | Nombre del producto/servicio                                               | Texto corto                   |
| producto.unidad_medida       | Unidad de medida (hora, unidad, servicio, etc.)                            | Texto corto / Enumerado      |
| producto.precio_unitario     | Precio unitario por defecto                                                | Numérico (decimal)           |
| producto.impuesto_id         | Impuesto por defecto del producto                                          | Relación (FK a impuesto)     |

### Estimación de esfuerzo (con soporte de IA)

- **Configuración básica de maestros (términos, impuestos, empresa)**: ~ **2–3 días** de desarrollo efectivo usando IA (modelado, API, pantallas CRUD, validaciones).
- **Extensión cliente/contacto de facturación + vínculo con proyectos**: ~ **1–1,5 días**.
- **Productos/tarifas y precios por cliente (opcional)**: ~ **1,5–2 días**.
- Total estimado para MF-011 (end-to-end, sin contar QA/manual ni despliegue): alrededor de **4,5–6,5 días** de trabajo apoyado en IA.

### Reglas de negocio
- No eliminar término de pago ni impuesto si están en uso en facturas existentes; solo desactivar o marcar "no usar en nuevas".
- Cliente con NIF único si la normativa lo exige.

### Criterios de aceptación (resumen)
- CRUD de términos e impuestos; cliente facturación disponible en facturas; datos empresa en PDF; opcional productos/tarifas.

### Historias de usuario
| ID | Título |
|----|--------|
| MF-011-US-001 | Maestro Términos de pago (nombre, tipo, días, vencimientos) |
| MF-011-US-002 | Maestro Impuestos (nombre, %, incluido/no incluido; exenciones) |
| MF-011-US-003 | Cliente/contacto de facturación (extender o vincular cliente/área Kameleon) |
| MF-011-US-004 | Configuración empresa: nombre, NIF, logo para PDF |
| MF-011-US-005 | Maestro Productos/tarifas y unidades de medida (opcional) |
| MF-011-US-006 | Precios por cliente o tarifa (opcional para líneas) |

---

## MF-012 — Moneda y tipo de cambio

### Objetivo
Soportar facturas en moneda distinta de la moneda base de la empresa; fijar el tipo de cambio al emitir la factura para mantener coherencia en cobros y reportes.

### Proceso detallado
1. **Configuración**: Moneda base de la empresa (ej. EUR). Opcional: monedas permitidas y origen del tipo de cambio (manual o proveedor).
2. **Al crear/editar factura**: Selector de moneda (por defecto moneda base). Si se elige otra moneda, campo "Tipo de cambio" (ej. 1 EUR = 1,08 USD). El tipo de cambio se congela al guardar/publicar (no se recalcula después).
3. **Totales**: En factura en otra moneda: total en moneda factura y opcionalmente total en moneda base (total_factura * tipo_cambio). En listados y reportes: indicar moneda y opcional columna en moneda base.

### Reglas de negocio
- Una vez publicada la factura, el tipo de cambio no debe modificarse (bloqueo como el resto de campos fiscales).
- Cobros en otra moneda: definir si el pago se registra en moneda factura o en moneda base y si se generan diferencias de cambio (habitualmente fase posterior).

### Campos principales

| Campo                   | Descripción                                                           | Tipo                    |
|-------------------------|-----------------------------------------------------------------------|-------------------------|
| empresa.moneda_base     | Moneda base configurada para la empresa                              | Enumerado / código ISO  |
| moneda.codigo           | Código de moneda permitido (EUR, USD, etc.)                          | Enumerado / texto corto |
| moneda.nombre           | Nombre descriptivo de la moneda                                      | Texto corto             |
| tipo_cambio.fecha       | Fecha en la que se fija el tipo de cambio                            | Fecha                   |
| tipo_cambio.moneda      | Moneda a la que se aplica la tasa                                    | Enumerado / código ISO  |
| tipo_cambio.valor       | Valor de la tasa (p.ej. 1 EUR = 1,08 USD)                            | Numérico (decimal)      |
| factura.moneda          | Moneda de la factura                                                 | Enumerado / código ISO  |
| factura.tipo_cambio     | Tipo de cambio aplicado a la factura                                 | Numérico (decimal)      |
| factura.total_moneda    | Total en moneda de la factura                                        | Numérico (decimal)      |
| factura.total_base      | Total equivalente en moneda base                                     | Numérico (decimal)      |

### Estimación de esfuerzo (con soporte de IA)

- Configuración de monedas y tipos de cambio (modelo y mantenimiento): **0,75–1 día**.
- Adaptación de facturación para manejar moneda y tipo de cambio congelado en factura: **1–1,25 días**.
- Ajustes de listados/reportes para mostrar importes en moneda factura y moneda base: **0,75–1 día**.
- Estimación total para MF-012: **~2,5–3,25 días** con apoyo de IA.

### Criterios de aceptación (resumen)
- Factura en moneda base u otra; tipo de cambio fijado al publicar; totales en ambas monedas si aplica.

### Historias de usuario
| ID | Título |
|----|--------|
| MF-012-US-001 | Seleccionar moneda de la factura; moneda base de la empresa |
| MF-012-US-002 | Tipo de cambio fijado al crear/publicar factura (tasa congelada) |
| MF-012-US-003 | Mostrar importes en moneda factura y en moneda base en listados/detalle |

---

## MF-013 — Roles y permisos de facturación

### Objetivo
Definir quién puede ver, crear, editar, publicar, anular facturas y registrar cobros, y si la visibilidad es "solo mis clientes" o "todos los clientes", alineado con los roles de Kameleon.

### Proceso detallado
1. **Permisos por rol**: Asociar a cada rol (o crear roles de facturación) permisos como: "Ver facturación" (acceso al menú y listados), "Crear/editar facturas en borrador", "Publicar facturas", "Anular/rectificar facturas", "Registrar cobros", "Ver todos los clientes" vs "Ver solo clientes asignados".
2. **Menú Facturación**: Solo visible si el usuario tiene "Ver facturación". Ítems (Facturas, Cobros, Maestros, etc.) según permisos.
3. **Listado de facturas**: Si "Ver solo clientes asignados", filtrar facturas por cliente_id donde el usuario tenga asignación (o por equipo/área). Si "Ver todos", sin ese filtro.
4. **Acciones en ficha**: Mostrar/ocultar botones Publicar, Anular, Registrar cobro, Crear NC según permisos.
5. **Módulo activable**: En Configuración → Módulos, el módulo "Facturación" se puede activar/desactivar para la instancia (o por empresa).

### Reglas de negocio
- Sin permiso "Publicar" no se puede confirmar/publicar una factura.
- Sin permiso "Registrar cobros" no se puede aplicar un pago a facturas.
- Anulación suele requerir permiso específico por riesgo fiscal.

### Campos principales

| Campo                    | Descripción                                                        | Tipo                    |
|--------------------------|--------------------------------------------------------------------|-------------------------|
| rol.id                   | Identificador del rol                                             | Entero / UUID          |
| rol.nombre               | Nombre del rol (Admin facturación, Operador, etc.)               | Texto corto            |
| permiso.id               | Identificador del permiso (accion_ver, accion_publicar, etc.)    | Entero / UUID          |
| permiso.codigo           | Código de permiso (ver_facturacion, publicar_facturas, etc.)     | Texto corto            |
| rol_permiso.rol_id       | Rol al que se asigna el permiso                                  | Relación (FK rol)      |
| rol_permiso.permiso_id   | Permiso asignado                                                  | Relación (FK permiso)  |
| usuario.id               | Identificador de usuario                                          | Entero / UUID          |
| usuario.rol_id           | Rol o roles asociados al usuario                                  | Relación / colección   |
| visibilidad.tipo         | Tipo de visibilidad (todos_los_clientes, solo_mis_clientes)      | Enumerado              |
| modulo_facturacion.activo| Indica si el módulo de facturación está activo                    | Booleano               |

### Estimación de esfuerzo (con soporte de IA)

- Diseño de modelo de roles/permisos y asignación a usuarios: **0,75–1 día**.
- Aplicación de permisos en menú, listados y acciones clave de facturación: **1–1,5 días**.
- UI de administración de roles/permisos (lista, alta/edición rápida) con IA: **0,75–1 día**.
- Estimación total para MF-013: **~2,5–3,5 días** de desarrollo efectivo.

### Criterios de aceptación (resumen)
- Permisos aplicados en menú, listados y acciones; visibilidad por cliente según rol.

### Historias de usuario
| ID | Título |
|----|--------|
| MF-013-US-001 | Permisos: ver listado y detalle de facturas (por rol) |
| MF-013-US-002 | Permisos: crear y editar facturas en borrador; publicar factura |
| MF-013-US-003 | Permisos: anular/rectificar factura; registrar cobros |
| MF-013-US-004 | Visibilidad: ver solo facturas de mis clientes vs ver todas |

---

## MF-014 — Auditoría y trazabilidad

### Objetivo
Registrar cambios en facturas y cobros, envíos de email y opcionalmente snapshot del PDF emitido, para auditoría y cumplimiento.

### Proceso detallado
1. **Log de cambios en factura**: En cada actualización de una factura (crear, editar campo, cambiar estado), registrar: usuario_id, timestamp, entidad (factura), id, tipo de cambio (creación / modificación / cambio de estado), y detalle (campo modificado, valor anterior, valor nuevo; o JSON de diff). Almacenar en tabla "audit_log" o "historial_cambios". Consultable desde la ficha de la factura (pestaña "Historial" o "Auditoría").
2. **Trazabilidad de envíos por email**: Al enviar una factura por email (MF-006), registrar: factura_id, destinatario, fecha_envio, asunto, indicador de adjunto (PDF). No almacenar cuerpo del email por privacidad; solo metadatos.
3. **Trazabilidad de cobros aplicados**: Cada aplicación de pago (MF-004) ya es un registro (pago_id, factura_id, importe, fecha). Incluir usuario que aplicó. Para reversos, registrar también "reverso de aplicación X por usuario Y en fecha Z".
4. **Snapshot PDF (opcional)**: Al publicar una factura o al enviar por primera vez, generar el PDF y guardarlo en almacenamiento (blob o archivo) asociado a la factura y versión (ej. "PDF en momento de publicación"). Así se puede demostrar qué se emitió en una fecha dada.

### Reglas de negocio
- Los logs no deben ser editables ni eliminables por usuarios normales (solo lectura para admins).
- Retención de logs según política de cumplimiento (ej. 5 años).

### Campos principales

| Campo                        | Descripción                                                                 | Tipo                    |
|------------------------------|-----------------------------------------------------------------------------|-------------------------|
| audit_log.id                | Identificador del registro de auditoría                                     | Entero / UUID          |
| audit_log.entidad           | Tipo de entidad (factura, cobro, nota_credito, etc.)                        | Texto corto / Enumerado|
| audit_log.entidad_id        | Identificador de la entidad afectada                                        | Entero / UUID          |
| audit_log.usuario_id        | Usuario que realizó la acción                                               | Relación (FK usuario)  |
| audit_log.fecha             | Fecha/hora del cambio                                                       | Fecha/hora             |
| audit_log.tipo_cambio       | Tipo de cambio (creacion, modificacion, cambio_estado, reverso_pago, etc.) | Enumerado              |
| audit_log.detalle           | Detalle del cambio (campo anterior/nuevo, diff JSON, etc.)                 | Texto / JSON           |
| envio_log.id                | Identificador de registro de envío de email                                 | Entero / UUID          |
| envio_log.factura_id        | Factura asociada al envío                                                   | Relación (FK factura)  |
| envio_log.destinatario      | Dirección de email a la que se envió                                        | Texto (email)          |
| envio_log.fecha_envio       | Fecha/hora de envío                                                         | Fecha/hora             |
| envio_log.adjunto_pdf       | Indicador de que se adjuntó el PDF                                          | Booleano               |
| cobro_log.id                | Identificador de registro de aplicación/reverso de cobro                    | Entero / UUID          |
| cobro_log.pago_id           | Pago asociado                                                                | Relación (FK pago)     |
| cobro_log.factura_id        | Factura asociada                                                             | Relación (FK factura)  |
| cobro_log.importe           | Importe aplicado o revertido                                                | Numérico (decimal)     |

### Estimación de esfuerzo (con soporte de IA)

- Implementación de tabla de auditoría genérica y hooks en operaciones clave (facturas, cobros, envíos): **1–1,5 días**.
- UI de consulta de historial (pestaña Historial en factura, listados de logs básicos): **1–1,25 días**.
- Gestión de snapshots PDF (opcional) y políticas de retención: **0,75–1 día**.
- Estimación total para MF-014: **~3–3,75 días** de desarrollo efectivo.

### Criterios de aceptación (resumen)
- Historial de cambios en factura visible; registro de envíos de email y de aplicaciones de pago; opcional snapshot PDF.

### Historias de usuario
| ID | Título |
|----|--------|
| MF-014-US-001 | Log de cambios en factura (quién, cuándo, campo modificado) |
| MF-014-US-002 | Trazabilidad de envíos por email (destinatario, fecha, adjunto) |
| MF-014-US-003 | Trazabilidad de cobros aplicados (pago, factura, importe, fecha) |
| MF-014-US-004 | Snapshot del PDF emitido al publicar o al enviar (opcional) |

---

*Documento de requisitos funcionales detallados · Módulo de facturación Kameleon App · Para uso del equipo de desarrollo.*
