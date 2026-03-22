# Tareas — MF-003 Facturación núcleo

Tareas separadas por **Backend** y **Frontend**. Cada bloque incluye descripción detallada y criterios de aceptación explícitos, mapeados a las historias `MF-003-US-00X`.

## **Épica**: MF-003 — Facturación núcleo
## **Historias de usuario**: US-001..US-011
---

# BACKEND

---

## [BACK] MF-003 — Listado de facturas (filtros por cliente y estado)

**Historia de usuario**: `MF-003-US-001`

**Descripción**
Implementar el endpoint y lógica de consulta para listar facturas con paginación y filtros (cliente y estado de documento/estado de pago).

**Detalle técnico**
- Crear endpoint `GET /api/facturas` (o ruta equivalente).
- Query params sugeridos:
  - `cliente_id` (opcional)
  - `estado_documento` (opcional)
  - `estado_pago` (opcional)
  - `fecha_desde` / `fecha_hasta` (opcional)
  - `page` / `pageSize` (según estándar del proyecto)
- Orden por defecto (ej. `fecha` desc).
- Respetar permisos/visibilidad según `MF-013` (si aplica desde el backend).

**Criterios de aceptación**
- [ ] Se puede listar con filtros por `cliente_id` y por `estado_documento` y `estado_pago`.
- [ ] La respuesta incluye columnas necesarias para la UI: número, fecha, cliente, total y estados.
- [ ] La paginación funciona y no rompe filtros.

---

## [BACK] MF-003 — Creación manual en borrador (cliente, líneas, impuestos, términos)

**Historia de usuario**: `MF-003-US-002`

**Descripción**
Implementar creación manual de factura en estado `Borrador` con líneas, impuestos por línea y término de pago. Totales y validaciones deben ser calculados/confirmados en backend.

**Detalle técnico**
- Endpoint `POST /api/facturas` para crear en borrador.
- Validar:
  - cliente obligatorio
  - mínimo una línea
  - cantidad > 0 y precio >= 0
  - término de pago seleccionado
  - total factura > 0
- Procesar líneas:
  - por cada línea: descripción, cantidad, precio unitario, impuesto_id, descuento_linea (si existe)
  - cálculo de importe línea y base/impuesto según tipo del impuesto (`incluido_en_precio` vs `no_incluido`, alineado con `MF-011`)
- Calcular totales de factura:
  - subtotal, total impuestos, total descuentos, total factura
- Vencimientos:
  - crear/actualizar estructura de vencimientos basada en `termino_pago` (preparación para `US-010`).
  - se permite recalcular solo mientras siga en borrador.
- Guardar factura sin número definitivo (el número definitivo se asigna en `US-004`).

**Criterios de aceptación**
- [ ] La factura se guarda en `estado_documento = Borrador` y sin número fiscal definitivo asignado todavía.
- [ ] Totales e impuestos por línea y totales globales son consistentes con los datos de entrada.
- [ ] Al crear, se generan los vencimientos (estructura) según el término de pago.
- [ ] Errores de validación devuelven códigos HTTP correctos y mensajes claros.

---

## [BACK] MF-003 — Edición de factura en borrador (líneas y descuentos)

**Historia de usuario**: `MF-003-US-003`

**Descripción**
Permitir editar una factura únicamente cuando esté en borrador: añadir/editar/eliminar líneas y aplicar descuentos por línea o descuento global, recalculando totales automáticamente.

**Detalle técnico**
- Endpoint `PUT/PATCH /api/facturas/:id` (o endpoints específicos) con reglas:
  - si `estado_documento != Borrador` rechazar con error claro.
- Operaciones sobre líneas:
  - añadir líneas
  - editar campos permitidos
  - eliminar líneas (si existe)
- Descuentos:
  - descuento por línea (porcentaje o importe)
  - descuento global (porcentaje o importe) y regla de aplicación (sobre base o total)
- Recalcular totales y vencimientos (solo en borrador).

**Criterios de aceptación**
- [ ] Solo se edita si `estado_documento = Borrador` (UI + backend).
- [ ] Se recalculan automáticamente subtotal, total impuestos, total descuentos y total factura ante cualquier cambio relevante.
- [ ] Validaciones al guardar: cliente, mínimo una línea, cantidades/precios, término de pago, total factura > 0.
- [ ] Cambios se reflejan en el detalle de la factura.

---

## [BACK] MF-003 — Publicar factura (asignar número definitivo y bloquear edición)

**Historia de usuario**: `MF-003-US-004`

**Descripción**
Implementar acción de publicar factura: asignar número definitivo según serie, cambiar a `Publicada` y bloquear edición de campos fiscales/contenido.

**Detalle técnico**
- Endpoint `POST /api/facturas/:id/publicar` (o similar).
- Reglas:
  - solo si factura en `Borrador`
  - reservar número fiscal con lógica atómica (usa `US-006`)
  - asignar `numero` y `serie_id` correspondiente
  - cambiar `estado_documento` a `Publicada`
- Bloqueos:
  - marcar campos como no modificables (backend debe validar incluso si alguien intenta editar por API).

**Criterios de aceptación**
- [ ] Al publicar se asigna número definitivo de la serie configurada.
- [ ] `estado_documento` pasa a `Publicada`.
- [ ] Se bloquean edición de importes, líneas, cliente, fechas fiscales y término de pago (y cualquier campo fiscal).
- [ ] Intentos de edición mediante API devuelven error claro.

---

## [BACK] MF-003 — Ciclo de vida (Enviada, Vencida, Parcialmente pagada, Pagada, Cancelada, Rectificada)

**Historia de usuario**: `MF-003-US-005`

**Descripción**
Implementar actualización consistente de estados del documento y estado de pago, integrando con:
  - MF-006 (envío/notificación) para pasar a `Enviada`
  - MF-004 (cobros) para mantener `estado_pago`
  - job/cálculo para `Vencida` según vencimientos

**Detalle técnico**
- Definir transiciones permitidas y validarlas en backend.
- Enviada:
  - crear endpoint/hook (llamado por MF-006) `POST /api/facturas/:id/enviada` o método de servicio expuesto.
- Vencida:
  - job/worker (ej. nocturno) que recalcule `estado_documento = Vencida` si:
    - existe al menos un vencimiento vencido
    - y la factura no está totalmente cubierta por pagos (según `MF-004`)
- Estado de pago:
  - integración con MF-004: al registrar cobros, MF-004 actualiza saldos y debe llamar a un servicio compartido para recalcular:
    - `estado_pago = No pagada | Parcialmente pagada | Pagada`
    - y coherencia con `estado_documento`
- Cancelada y Rectificada:
  - endpoints de transición con validación de estado permitido.
  - asegurar que luego aplican bloqueos fiscales como corresponde.

**Criterios de aceptación**
- [ ] Listado/detalle muestran `estado_documento` y `estado_pago` correctos.
- [ ] Al llamar el hook de MF-006, la factura pasa a `Enviada`.
- [ ] El job marca `Vencida` cuando corresponde.
- [ ] MF-004 actualiza `estado_pago` y se mantiene consistencia con el ciclo de vida.
- [ ] Se soporta anulación lógica a `Cancelada` sin permitir edición fiscal posterior.
- [ ] `Rectificada` se marca cuando aplica una NC rectificadora (MF-005).

---

## [BACK] MF-003 — Numeración fiscal (series, prefijos, control de huecos)

**Historia de usuario**: `MF-003-US-006`

**Descripción**
Implementar modelo y lógica para reservar/asignar números fiscales definitivos por series configuradas.

**Detalle técnico**
- Modelo/migración de `serie_documental` (mínimo):
  - `nombre` (string)
  - `prefijo` (string)
  - `siguiente_numero` (entero)
  - `ejercicio` (opcional) y/o alcance global
  - `empresa_id` (opcional, para multi-empresa)
  - parámetros de formato (padding u otros)
  - política de huecos (según requerimiento: impedir o alertar)
- CRUD series (backend) para permitir que el admin configure (si la UI se implementa en `FRONT`).
- Reserva transaccional:
  - al publicar, reservar el siguiente número con lock/transaction para evitar colisiones.
  - no reutilizar números ya asignados.
- Construcción del número:
  - `prefijo + padded(siguiente_numero)` (ej. `FAC-2026-00001`)
- Separación de series para NC:
  - preparar estructura (documentar diferenciación) aunque la NC se implemente en MF-005.

**Criterios de aceptación**
- [ ] Existe al menos una serie activa para “Factura de cliente”.
- [ ] Publicar asigna números siguiendo la serie configurada.
- [ ] La reserva evita colisiones concurrentes.
- [ ] No se reutilizan números.
- [ ] Se aplica la política de huecos (impedir o alertar, según configuración).

---

## [BACK] MF-003 — Reglas de bloqueo (inamovibles tras publicar) + cierre de periodo

**Historia de usuario**: `MF-003-US-007`

**Descripción**
Implementar validaciones de bloqueo a nivel backend: tras publicar no se pueden modificar campos fiscales y, opcionalmente, bloquear publicación por cierre de periodo.

**Detalle técnico**
- Guardas de seguridad:
  - en endpoints de edición (US-002/US-003), validar `estado_documento`.
  - en endpoints de publicar (US-004), validar reglas de bloqueo si aplica.
- UI de bloqueo (FRONT) depende de esto: backend debe asegurar consistencia.
- Cierre de periodo (si está activo en configuración):
  - validar que la `fecha` de la factura está en un periodo abierto antes de permitir publicar.
  - si no hay implementación completa de periodos, definir un contrato/flag mínimo para validar.

**Criterios de aceptación**
- [ ] Cambios a factura `Publicada` por API son rechazados con error claro.
- [ ] La UI refleja el bloqueo deshabilitando campos (consistente con backend).
- [ ] Si hay cierre de periodo habilitado, no se permite publicar en periodo cerrado.

---

## [BACK] MF-003 — Descuentos y recargos (pronto pago, mora) con cálculo consistente

**Historia de usuario**: `MF-003-US-008`

**Descripción**
Implementar motor de cálculo para descuentos por línea y globales, y preparar soporte de recargos (pronto pago/mora) cuando aplique.

**Detalle técnico**
- Motor de cálculo reutilizable:
  - entrada: líneas, impuestos (MF-011) y descuentos (línea/global).
  - salida: subtotal, base, impuestos (incluido/no incluido), descuentos, total.
- Regla de impuestos:
  - impuesto incluido: precio unitario incluye impuesto, desglosar base e impuesto.
  - impuesto no incluido: sumar impuesto sobre base.
- Recargos:
  - definir campos y estructuras para `recargo_pronto_pago` y/o `recargo_mora` (si el sistema ya tiene configuración; si no, mantener como placeholders controlados por flags).
  - aplicar recargos en los momentos definidos por ciclo (p.ej. al pasar a `Vencida`, o al recalcular estados).

**Criterios de aceptación**
- [ ] En borrador, descuentos por línea/global recalculan totales consistentemente.
- [ ] El desglose de impuestos respeta el tipo de impuesto (incluido/no incluido).
- [ ] Los recargos (si la lógica está activa) se reflejan en el total y se mantienen coherentes con cambios de estado.

---

## [BACK] MF-003 — Detalle de factura (cabecera y líneas) con totales e impuestos desglosados

**Historia de usuario**: `MF-003-US-009`

**Descripción**
Implementar endpoint para recuperar el detalle completo de una factura: cabecera, líneas, totales, impuestos agregados y vencimientos (si aplica desde `US-010`).

**Detalle técnico**
- Endpoint `GET /api/facturas/:id`.
- Respuesta debe incluir:
  - cabecera (número, fecha, cliente, término, estados, moneda si aplica)
  - líneas: descripción, cantidad, precio unitario, descuento, impuesto_id, base e importe impuesto, total línea
  - totales globales
  - impuestos agregados (por tipo/impuesto)
  - vencimientos (tabla) si la factura los tiene calculados

**Criterios de aceptación**
- [ ] La vista de detalle entrega todo lo necesario para renderizar cabecera + líneas + totales.
- [ ] Los totales del detalle coinciden con cálculos del motor (coherencia Borrador/Publicada).
- [ ] Se devuelve desglose de impuestos agregado.

---

## [BACK] MF-003 — Vencimientos múltiples (fechas de vencimiento) según término de pago

**Historia de usuario**: `MF-003-US-010`

**Descripción**
Implementar cálculo y persistencia de vencimientos múltiples por factura según la definición del término de pago.

**Detalle técnico**
- Crear entidad/tabla `factura_vencimiento` (si aplica) con:
  - `factura_id`
  - `orden`
  - `fecha_vencimiento`
  - `importe` y/o `porcentaje` asociado al vencimiento (según definición del término)
- Servicio de cálculo:
  - usar término de pago definido en MF-011
  - soportar múltiples vencimientos (por regla/patrones del término)
- Recalcular:
  - en borrador: recalcular al cambiar término de pago y/o definiciones permitidas
  - tras publicar: mantener coherencia; recalcular solo si hay reglas de rectificación/anulación (según MF-005)
- Integración con ciclo:
  - el job de `Vencida` (US-005) utiliza estos vencimientos y estado de pagos (MF-004).

**Criterios de aceptación**
- [ ] Si el término define múltiples vencimientos, se calculan y persisten correctamente.
- [ ] El detalle muestra fechas e importes/porcentajes por vencimiento.
- [ ] El estado `Vencida` se determina considerando al menos un vencimiento vencido y cobertura por pagos.
- [ ] Recalculado en borrador, coherencia tras publicar.

---

## [BACK] MF-003 — Tipos documentales: prefactura/proforma vs factura fiscal; numeración condicionada

**Historia de usuario**: `MF-003-US-011`

**Descripción**
Extender el modelo de factura/documento con **`tipo_documental`** y reglas de numeración distintas según tipo, para soportar la **prefactura de MF-001** (proforma sin correlativo fiscal vs documento fiscal) sin romper el flujo de **publicación (US-004)** ni **series (US-006)**.

**Detalle técnico**
- Modelo/migración en cabecera de factura (o documento equivalente Odoo):
  - `tipo_documental` (enumerado sugerido): `factura_ordinaria`, `anticipo`, `prefactura_proforma`, `prefactura_fiscal` (ajustar nombres al estándar del proyecto).
  - `proyecto_id` (opcional, FK) cuando el documento nace desde **MF-001** o facturación desde proyecto (**MF-007**).
- Configuración:
  - parámetro por empresa/módulo: **modo prefactura** = `proforma` | `fiscal` (hasta decisión negocio/legal definitiva).
  - opcional: serie específica para `prefactura_fiscal` distinta de factura ordinaria (**US-006**).
- **Publicar (`US-004`) — ramas**:
  - **`prefactura_proforma`**: no reservar número de **serie fiscal obligatoria**; permitir `numero` interno/prefijo no fiscal (ej. `PRE-YYYY-NNNN`) o null según política; no generar asiento fiscal definitivo si aplica integración contable.
  - **`prefactura_fiscal`** y **`factura_ordinaria`**: reservar correlativo de la serie fiscal configurada para ese tipo (misma atomicidad que US-006).
  - **`anticipo`**: alinear con **MF-008** (puede compartir serie con factura o serie dedicada según configuración).
- Validaciones:
  - transiciones de tipo: restricciones si el documento ya está publicado (solo corrección vía flujos permitidos, ej. NC **MF-005**).
  - coherencia: si `tipo_documental` implica prefactura, validar `proyecto_id` cuando el origen es MF-001.
- Listado (**US-001**):
  - extender `GET /api/facturas` con query param opcional `tipo_documental` (filtro).
  - incluir `tipo_documental` en DTO de listado y detalle (**US-009**).
- Integración **MF-001**:
  - endpoint interno o servicio compartido que cree documento en borrador (o estado inicial) con `tipo_documental` según configuración `proforma`/`fiscal`.

**Criterios de aceptación**
- [ ] Existe `tipo_documental` persistido y expuesto en creación, detalle y listado.
- [ ] Publicar **no** consume correlativo de serie fiscal cuando `tipo_documental = prefactura_proforma` (según reglas acordadas).
- [ ] Publicar **sí** asigna número fiscal desde serie cuando `tipo_documental` es `prefactura_fiscal` o `factura_ordinaria`.
- [ ] Filtro por `tipo_documental` en listado funciona y es compatible con paginación.
- [ ] Documentación/contrato API actualizado para front y para **MF-001**/**MF-008**.

---

# FRONTEND

---

## [FRONT] MF-003 — Listado de facturas (filtros por cliente y estado)

**Historia de usuario**: `MF-003-US-001`

**Descripción**
Pantalla de listado de facturas con filtros, paginación y columnas requeridas.

**Detalle técnico**
- Tabla con columnas: número, fecha, cliente, total, `estado_documento`, `estado_pago`.
- Filtros: cliente, estado documento, estado pago, rango de fechas (si se implementa).
- Paginación y ordenación.
- Integración en menú Facturación.

**Criterios de aceptación**
- [ ] Usuario puede filtrar por cliente y por estados.
- [ ] Paginación funciona.
- [ ] Los estados se muestran correctamente.

---

## [FRONT] MF-003 — Creación manual en borrador (cliente, líneas, impuestos, términos)

**Historia de usuario**: `MF-003-US-002`

**Descripción**
Pantalla/formulario para crear una factura manual en estado borrador con totales calculados.

**Detalle técnico**
- Formulario:
  - cliente de facturación (desde MF-011)
  - fecha (por defecto hoy)
  - término de pago (desde MF-011)
  - moneda si MF-012 aplica
- Líneas:
  - al menos 1 línea
  - por línea: descripción, cantidad, precio unitario, impuesto (desde MF-011)
  - descuento por línea (si aplica en UI)
- Totales:
  - recalcular en UI para ayudar al usuario (y confirmar en backend al guardar)
- Guardar:
  - crea factura en borrador sin número definitivo.

**Criterios de aceptación**
- [ ] Crear factura exige cliente, al menos una línea válida, término de pago y total > 0.
- [ ] Las líneas calculan importe e impuestos según el tipo de impuesto (incluido/no incluido).
- [ ] Se guarda como `Borrador` y aparece en listado.

---

## [FRONT] MF-003 — Edición de factura en borrador (líneas y descuentos)

**Historia de usuario**: `MF-003-US-003`

**Descripción**
Pantalla para editar una factura en borrador permitiendo gestionar líneas y descuentos.

**Detalle técnico**
- Al abrir factura:
  - si `estado_documento != Borrador`, bloquear edición (solo lectura).
- Gestión líneas:
  - añadir/editar/eliminar líneas
  - descuento por línea
- Descuento global:
  - campos y regla de aplicación para recalcular totales
- Validaciones en UI:
  - antes de enviar, mostrar errores de campos requeridos.

**Criterios de aceptación**
- [ ] El usuario solo puede editar en borrador.
- [ ] Al cambiar líneas/descuentos se recalculan totales.
- [ ] Se persisten los cambios y se reflejan al volver al detalle/listado.

---

## [FRONT] MF-003 — Publicar factura (asignar número y bloquear edición)

**Historia de usuario**: `MF-003-US-004`

**Descripción**
Acción “Publicar” desde la UI cuando la factura está en borrador.

**Detalle técnico**
- Botón “Publicar” con confirmación.
- Tras publicar:
  - mostrar número definitivo asignado
  - deshabilitar edición de campos bloqueados
- Manejo de errores:
  - si serie no disponible, bloqueo de periodo, u otros, mostrar mensaje.

**Criterios de aceptación**
- [ ] Publicar asigna número y cambia estado a `Publicada`.
- [ ] Al publicar se bloquean los campos fiscales y de contenido.

---

## [FRONT] MF-003 — Ciclo de vida (visualización y acciones auxiliares)

**Historia de usuario**: `MF-003-US-005`

**Descripción**
UI que muestra estado del documento y permite acciones permitidas (según permisos y reglas).

**Detalle técnico**
- Badges/etiquetas:
  - `estado_documento` y `estado_pago`
- Acciones:
  - “Enviar” (si existe integración con MF-006) -> marca `Enviada`
  - “Cancelar” -> marca `Cancelada` si permitido
- Mostrar vencimientos si ayudan a la interpretación (si US-010 implementada).

**Criterios de aceptación**
- [ ] El listado/detalle reflejan cambios de estado coherentes con el backend.
- [ ] “Enviar” cambia `estado_documento` a `Enviada` cuando se realiza vía integración.
- [ ] “Cancelar” bloquea edición y actualiza estado.

---

## [FRONT] MF-003 — Numeración fiscal (configuración de series)

**Historia de usuario**: `MF-003-US-006`

**Descripción**
Pantalla de configuración para gestionar series documentales de facturas (prefijos, siguiente número, alcance, etc.).

**Detalle técnico**
- Formulario de alta/edición de series:
  - nombre de serie
  - prefijo
  - siguiente número
  - alcance (ejercicio/global)
  - empresa (si multi-empresa)
  - padding/formato del número (si aplica)
  - política de huecos (impedir o alertar)
- Accesos:
  - solo admin/roles con permisos adecuados.

**Criterios de aceptación**
- [ ] Se puede crear/editar una serie para “Factura de cliente”.
- [ ] Al publicar una factura se usa la serie activa configurada.
- [ ] Se impide o alerta ante huecos según política.

---

## [FRONT] MF-003 — Bloqueos en UI tras publicar + (opcional) validación cierre de periodo

**Historia de usuario**: `MF-003-US-007`

**Descripción**
Ajustar UI para reflejar bloqueo de edición tras publicar y validar cierre de periodo si existe.

**Detalle técnico**
- Si `estado_documento != Borrador`:
  - campos bloqueados deshabilitados
  - ocultar controles de edición fiscal
- Al publicar:
  - si backend indica periodo cerrado, mostrar mensaje y no publicar.

**Criterios de aceptación**
- [ ] UI no permite editar campos bloqueados tras `Publicada`.
- [ ] Errores por periodo cerrado (si aplica) se muestran correctamente.

---

## [FRONT] MF-003 — Descuentos y recargos (UI + visualización en totales)

**Historia de usuario**: `MF-003-US-008`

**Descripción**
Incluir en pantallas de borrador/editor campos para descuentos por línea y globales, y mostrar recargos cuando se calculen.

**Detalle técnico**
- En editor de borrador:
  - controles de descuento por línea y global (según el motor definido)
- Visualización:
  - mostrar impacto en totales (subtotal, impuestos, descuentos, total)
  - mostrar recargos si están activos/corresponden

**Criterios de aceptación**
- [ ] Descuentos se aplican correctamente y se refleja el total.
- [ ] El cálculo de totales coincide con el backend.
- [ ] Recargos se muestran en totales cuando la lógica esté activa.

---

## [FRONT] MF-003 — Detalle de factura con impuestos desglosados y vencimientos

**Historia de usuario**: `MF-003-US-009`

**Descripción**
Pantalla de detalle que muestra cabecera, líneas, totales e impuestos agregados y vencimientos.

**Detalle técnico**
- Secciones:
  - Cabecera (número, fecha, cliente, término, estados)
  - Tabla líneas
  - Totales globales
  - Impuestos desglosados agregados
  - Vencimientos (si disponibles)

**Criterios de aceptación**
- [ ] La pantalla renderiza todo lo devuelto por `GET /api/facturas/:id`.
- [ ] Los totales e impuestos desglosados coinciden con los cálculos.
- [ ] Vencimientos se muestran correctamente cuando existan.

---

## [FRONT] MF-003 — Vencimientos múltiples (tabla de vencimientos en detalle)

**Historia de usuario**: `MF-003-US-010`

**Descripción**
Mostrar en la UI la(s) fecha(s) de vencimiento calculadas según término de pago.

**Detalle técnico**
- En detalle de factura:
  - tabla/listado de vencimientos con fecha y importe/porcentaje por vencimiento.
- En borrador:
  - cuando se cambia el término de pago, actualizar vencimientos en UI (y backend al guardar).

**Criterios de aceptación**
- [ ] Si el término define múltiples vencimientos, la UI los muestra.
- [ ] En borrador, cambios recalculan vencimientos.
- [ ] En publicada, la información permanece coherente.

---

## [FRONT] MF-003 — Tipos documentales y filtros (prefactura vs factura)

**Historia de usuario**: `MF-003-US-011`

**Descripción**
Mostrar el **tipo documental** en listado y detalle, permitir **filtrar** por tipo en el listado de facturas, y reflejar en UI si el documento tendrá **numeración fiscal** al publicar o comportamiento proforma (según configuración y tipo).

**Detalle técnico**
- **Listado (US-001)**:
  - columna o badge: tipo documental (etiquetas legibles: Factura, Anticipo, Prefactura proforma, Prefactura fiscal).
  - filtro select/multi-select `tipo_documental` enlazado al query param del backend.
- **Detalle / editor**:
  - mostrar `tipo_documental` en cabecera (solo lectura si viene de **MF-001** o flujo automático; editable solo si negocio lo permite en creación manual).
  - si el usuario puede crear borradores manuales con tipo: selector restringido por rol (**MF-013**).
- **Publicar**:
  - mensaje de confirmación distinto si el documento es `prefactura_proforma` (“Se confirmará sin número fiscal” / texto legal acordado).
  - si es fiscal, mantener flujo actual de US-004 (número definitivo).
- **Configuración (admin)**:
  - pantalla o sección en ajustes de facturación: “Modo prefactura MF-001: Proforma / Fiscal” (solo si el producto expone la decisión pendiente en UI).
- **Series (US-006)**:
  - si aplica serie distinta para prefactura fiscal, mostrar en maestro de series el tipo asociado.

**Criterios de aceptación**
- [ ] El listado permite filtrar por tipo documental y los resultados coinciden con el backend.
- [ ] Detalle muestra claramente el tipo y, si aplica, enlace a proyecto.
- [ ] El flujo de publicar comunica al usuario si habrá o no numeración fiscal según tipo/configuración.
- [ ] Estilos/accesibilidad: badges distinguibles sin depender solo del color.

---

