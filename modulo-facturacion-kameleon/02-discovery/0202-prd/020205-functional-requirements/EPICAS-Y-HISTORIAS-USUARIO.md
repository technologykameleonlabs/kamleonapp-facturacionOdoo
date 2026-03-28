# Detalle de épicas e historias de usuario — Módulo de facturación Kameleon App

Cada épica se describe con su **objetivo**, **alcance** (cuando aplica) y la lista de **historias de usuario** asociadas. El detalle de cada US está en las carpetas `MF-0XX-*/stories/`.

---

## MF-001 — Activación de proyecto y prefactura por importe total

**Objetivo**  
El proyecto se activa (cambio de estado a "Activo") por contrato firmado, por acción manual del usuario o por otra regla de negocio configurable. **En la versión actual** se registra una **prefactura (cupo)** por el **importe total acordado** del proyecto; las facturas mensuales consumen ese saldo hasta cero (MF-007 + MF-008). No se exige pasarela de pago en la activación.

**Alcance**  
- **Incluye**: Activación del proyecto (estado "Activo", fecha de activación); disparador por evento (ej. contrato firmado) o por acción manual; **prefactura por importe total** vinculada a la activación (una por proyecto en v1); reserva de fecha en calendario; notificaciones a equipo y cliente; registro de activación para trazabilidad; decisión fiscal documentada (proforma vs factura — MF-003-US-011).  
- **Excluye**: Pasarela de pago integrada.

**Historias de usuario**

| ID | Título |
|----|--------|
| MF-001-US-001 | Activación del proyecto (manual o por evento: contrato firmado) |
| MF-001-US-002 | Prefactura por importe total al activar (cupo consumible en facturas mensuales) |
| MF-001-US-003 | Registro de fecha de activación y notificaciones a equipo y cliente |
| MF-001-US-004 | Reserva automática de fecha en calendario (si aplica) |
| MF-001-US-005 | Registro de activación (timestamp, referencia prefactura) para trazabilidad |

---

## MF-002 — Factura de cierre / liquidación y registro de pago

**Objetivo**  
Cuando el proyecto se cierra o se acepta la última entrega (según flujo de proyectos), el sistema genera una factura de cierre (o de liquidación) por el saldo pendiente de facturar: lo que falte por facturar respecto al total acordado/presupuesto, después de descontar lo ya facturado mensualmente (MF-007) y los anticipos ya descontados (MF-008). Si el saldo pendiente es 0, no se genera factura. Notificación al cliente, registro de pago y confirmación por administración para habilitar el cierre formal del proyecto.

**Alcance**  
- **Incluye**: Detección de evento de cierre; cálculo del saldo pendiente (total acordado − facturas ya emitidas − anticipos ya descontados); generación de factura de cierre por ese saldo (solo si saldo > 0); notificación al cliente; registro de factura y estado de pago; confirmación por administración de la recepción del pago.  
- **Excluye**: Pasarela de pago integrada.

**Historias de usuario**

| ID | Título |
|----|--------|
| MF-002-US-001 | Detección de cierre de proyecto / última entrega y cálculo de saldo pendiente de facturar |
| MF-002-US-002 | Generación de factura de cierre por saldo pendiente (si > 0) |
| MF-002-US-003 | Notificación al cliente y registro de factura y estado de pago |
| MF-002-US-004 | Administración confirma recepción de pago (habilita cierre formal del proyecto) |

---

## MF-003 — Facturación núcleo

**Objetivo**  
Permitir crear, editar en borrador y publicar facturas de cliente con líneas, impuestos y términos de pago, con numeración fiscal por serie, ciclo de vida definido (Borrador → Publicada → Enviada, Vencida, Parcialmente Pagada, Pagada, Cancelada, Rectificada) y bloqueo de campos tras publicar, para cumplir reglas fiscales y de negocio.

**Alcance**  
- **Incluye**: Listado de facturas con filtros (cliente, estado documento, estado pago); creación manual en borrador (cliente, líneas con descripción/cantidad/precio/impuesto, término de pago); edición en borrador (líneas, descuentos por línea o global, recargos si aplica); acción Publicar (asignar número por serie, pasar a Publicada, bloquear edición de campos fiscales); gestión de estados del ciclo de vida; numeración fiscal; **tipos documentales prefactura/proforma vs fiscal (MF-003-US-011, MF-001)**; reglas de bloqueo; detalle de factura con totales e impuestos; vencimientos múltiples según término de pago.  
- **Excluye**: Registro de cobros (MF-004), notas de crédito (MF-005), generación/envió de PDF (MF-006).

**Historias de usuario**

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
| MF-003-US-011 | Tipos documentales: prefactura/proforma vs factura fiscal; series y numeración condicionada |

---

## MF-004 — Cobros y estado de pago

**Objetivo**  
Registrar los cobros recibidos (entidad Pago/Cobro), aplicarlos a una o varias facturas (total o parcial), y mantener actualizado el estado de pago de cada factura (No pagada, Parcialmente pagada, Pagada) con trazabilidad.

**Alcance**  
- **Incluye**: Asistente o formulario para registrar un pago (fecha, importe, método de pago, referencia); aplicación de ese pago a una factura (total o parcial); aplicación de un mismo pago a varias facturas (reparto manual o por orden); actualización del saldo pendiente y del estado de pago de la factura; listado de cobros con relación cobro ↔ factura(s); reverso de una aplicación (anular aplicación y devolver estado de la factura).  
- **Excluye**: Pasarela de pago online (MF-009); lógica de anticipos y descuento en factura (MF-008).

**Historias de usuario**

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

**Objetivo**  
Emitir notas de crédito (abonos) vinculadas a una factura ya publicada, con importes o líneas a revertir, numeración propia y trazabilidad con la factura original.

**Alcance**  
- **Incluye**: Acción "Crear nota de crédito" desde una factura publicada; formulario con importes o líneas a revertir; documento tipo "Nota de crédito" con serie/prefijo distinto; vinculación factura original; publicar NC y actualizar trazabilidad (factura "Rectificada" o relación NC ↔ Factura).  
- **Excluye**: Notas de débito (fuera de alcance inicial).

**Historias de usuario**

| ID | Título |
|----|--------|
| MF-005-US-001 | Crear nota de crédito desde factura publicada (acción en factura) |
| MF-005-US-002 | Definir importes o líneas a revertir en la NC |
| MF-005-US-003 | Vincular NC a factura original; numeración con serie/prefijo para NC |
| MF-005-US-004 | Publicar NC y actualizar trazabilidad (factura rectificada / estado) |

---

## MF-006 — PDF y envío por email

**Objetivo**  
Generar el documento oficial de la factura (o nota de crédito) en PDF con diseño estándar y datos de empresa y cliente; permitir descargar el PDF desde la ficha y enviar la factura por email al cliente con el PDF adjunto.

**Historias de usuario**

| ID | Título |
|----|--------|
| MF-006-US-001 | Generar PDF oficial de factura (diseño estándar, datos empresa y cliente) |
| MF-006-US-002 | Descargar PDF desde la ficha de factura o nota de crédito |
| MF-006-US-003 | Enviar factura por email al cliente con PDF adjunto (desde ficha) |

---

## MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

**Objetivo**  
Los proyectos se facturan mensualmente en función de lo realizado en cada periodo: tareas realizadas, horas registradas (facturables), hitos completados o fee mensual acordado. El sistema debe permitir generar la factura del periodo con líneas derivadas de esos conceptos, evitando doble facturación y manteniendo trazabilidad factura → proyecto (y, a nivel de línea, factura → tarea/hito/periodo cuando aplique).

**Alcance**  
- **Incluye**: Facturación por periodo mensual (o configurable); líneas generadas desde tareas realizadas, horas facturables, hitos completados o fee mensual; prevención de doble facturación (marcar como facturados tareas/horas/hitos/periodos; bloquear o alertar si se intenta facturar de nuevo); trazabilidad factura ↔ proyecto y listado de facturas por proyecto; prerellenar cliente desde el proyecto.  
- **Excluye**: Facturación totalmente automática sin revisión del usuario (el usuario debe poder revisar y ajustar líneas antes de publicar).

**Historias de usuario**

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

**Documentación detallada**: [Épica MF-007](./MF-007-facturacion-desde-proyecto/MF-007-facturacion-desde-proyecto.md) · [Tareas BACK/FRONT](./MF-007-facturacion-desde-proyecto/TAREAS-MF-007-FACTURACION-DESDE-PROYECTO.md) · historias en `./MF-007-facturacion-desde-proyecto/stories/`.

---

## MF-008 — Anticipos y facturación parcial (en contexto de facturación mensual)

**Objetivo**  
Soportar anticipos (importe o % sobre proyecto) o el **cupo de prefactura total (MF-001)** y su **aplicación** en las facturas mensuales (o en factura de cierre) del mismo proyecto. Facturación parcial en este modelo son las múltiples facturas mensuales por proyecto (MF-007); aquí se añade el control de total facturado vs presupuesto y la gestión del **saldo pendiente** del cupo.

**Alcance**  
- Anticipos / cupos asociados a proyecto; aplicación o descuento repartido en facturas mensuales posteriores (o en una sola factura de cierre).
- Vista de **saldo prefactura** / anticipos pendientes por proyecto/cliente.
- Total facturado por proyecto (definición coherente con tipo documental de MF-001) vs presupuesto; alertas si se supera.

**Historias de usuario**

| ID | Título |
|----|--------|
| MF-008-US-001 | Crear factura de anticipo o cupo prefactura (importe, % o total proyecto MF-001) asociada a proyecto/cliente |
| MF-008-US-002 | Aplicar o descontar cupo/anticipo en facturas mensuales (reparto por factura o en cierre) |
| MF-008-US-003 | Facturación parcial: total facturado por proyecto (mensual + documentos iniciales) vs presupuesto |
| MF-008-US-004 | Vista de saldo prefactura / anticipos pendientes por proyecto/cliente |

---

## MF-009 — Portal del cliente

**Objetivo**  
Dar al cliente un área (portal) donde ver y descargar sus facturas sin acceder al back-office, mediante token mágico o autenticación por cliente, con evidencia de visualización/descarga si se requiere.

**Historias de usuario**

| ID | Título |
|----|--------|
| MF-009-US-001 | Acceso al portal de facturación con token mágico o login cliente |
| MF-009-US-002 | Historial de facturas del cliente (listado con estado de pago) |
| MF-009-US-003 | Descargar PDF de factura y nota de crédito desde el portal |
| MF-009-US-004 | Registro de evidencia de visualización/descarga (auditoría) |

---

## MF-010 — Dashboard y reportes operativos

**Objetivo**  
Ofrecer una vista resumen (dashboard) y reportes de facturación y cobro: pendiente de cobro, cobrado por período, por cliente/proyecto, aging de saldos y exportaciones.

**Historias de usuario**

| ID | Título |
|----|--------|
| MF-010-US-001 | Dashboard: facturas pendientes de cobro y total cobrado por período |
| MF-010-US-002 | Resumen por cliente y por proyecto (facturado, cobrado, pendiente) |
| MF-010-US-003 | Reporte aging (antigüedad de saldos por factura/cliente) |
| MF-010-US-004 | Exportar listados a Excel/CSV (facturas, cobros) |
| MF-010-US-005 | Filtros por fecha, estado de pago, cliente, proyecto |

---

## MF-011 — Maestros

**Objetivo**  
Mantener los datos base necesarios para facturación: términos de pago, impuestos, cliente/contacto de facturación (o extensión del cliente/área de Kameleon), configuración de empresa para documentos, y opcionalmente productos/tarifas y precios por cliente.

**Historias de usuario**

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

**Objetivo**  
Soportar facturas en moneda distinta de la moneda base de la empresa; fijar el tipo de cambio al emitir la factura para mantener coherencia en cobros y reportes.

**Historias de usuario**

| ID | Título |
|----|--------|
| MF-012-US-001 | Seleccionar moneda de la factura; moneda base de la empresa |
| MF-012-US-002 | Tipo de cambio fijado al crear/publicar factura (tasa congelada) |
| MF-012-US-003 | Mostrar importes en moneda factura y en moneda base en listados/detalle |

---

## MF-013 — Roles y permisos de facturación

**Objetivo**  
Definir quién puede ver, crear, editar, publicar, anular facturas y registrar cobros, y si la visibilidad es "solo mis clientes" o "todos los clientes", alineado con los roles de Kameleon.

**Historias de usuario**

| ID | Título |
|----|--------|
| MF-013-US-001 | Permisos: ver listado y detalle de facturas (por rol) |
| MF-013-US-002 | Permisos: crear y editar facturas en borrador; publicar factura |
| MF-013-US-003 | Permisos: anular/rectificar factura; registrar cobros |
| MF-013-US-004 | Visibilidad: ver solo facturas de mis clientes vs ver todas |

---

## MF-014 — Auditoría y trazabilidad

**Objetivo**  
Registrar cambios en facturas y cobros, envíos de email y opcionalmente snapshot del PDF emitido, para auditoría y cumplimiento.

**Historias de usuario**

| ID | Título |
|----|--------|
| MF-014-US-001 | Log de cambios en factura (quién, cuándo, campo modificado) |
| MF-014-US-002 | Trazabilidad de envíos por email (destinatario, fecha, adjunto) |
| MF-014-US-003 | Trazabilidad de cobros aplicados (pago, factura, importe, fecha) |
| MF-014-US-004 | Snapshot del PDF emitido al publicar o al enviar (opcional) |

---

## Resumen

| Concepto | Total |
|----------|-------|
| Épicas | 14 |
| Historias de usuario | 72 |

*Fuente: REQUISITOS-FUNCIONALES-DETALLE.md*
