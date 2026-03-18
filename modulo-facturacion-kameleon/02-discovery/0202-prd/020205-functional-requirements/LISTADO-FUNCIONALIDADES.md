# Listado de funcionalidades — Módulo de facturación Kameleon App

## Por épicas (bloques funcionales)

| # | Código | Funcionalidad | Historias de usuario |
|---|--------|----------------|----------------------|
| 1 | MF-001 | Activación de proyecto (sin pago inicial obligatorio) | 5 |
| 2 | MF-002 | Factura de cierre / liquidación y registro de pago | 4 |
| 3 | MF-003 | Facturación núcleo | 10 |
| 4 | MF-004 | Cobros y estado de pago | 6 |
| 5 | MF-005 | Notas de crédito | 4 |
| 6 | MF-006 | PDF y envío por email | 3 |
| 7 | MF-007 | Facturación desde proyecto (mensual por tareas/horas/hitos/fee) | 9 |
| 8 | MF-008 | Anticipos y facturación parcial (en contexto de facturación mensual) | 4 |
| 9 | MF-009 | Portal del cliente | 4 |
| 10 | MF-010 | Dashboard y reportes operativos | 5 |
| 11 | MF-011 | Maestros | 6 |
| 12 | MF-012 | Moneda y tipo de cambio | 3 |
| 13 | MF-013 | Roles y permisos de facturación | 4 |
| 14 | MF-014 | Auditoría y trazabilidad | 4 |

---

## Detalle por épica (historias de usuario)

### MF-001 — Activación de proyecto (5)
- MF-001-US-001 — Activación del proyecto (manual o por evento: contrato firmado)
- MF-001-US-002 — Opcional: registro de anticipo/pago inicial y generación de factura por monto acordado
- MF-001-US-003 — Registro de fecha de activación y notificaciones a equipo y cliente
- MF-001-US-004 — Reserva automática de fecha en calendario (si aplica)
- MF-001-US-005 — Registro de activación (timestamp, referencia factura si hay anticipo) para trazabilidad

### MF-002 — Factura de cierre / liquidación (4)
- MF-002-US-001 — Detección de cierre de proyecto / última entrega y cálculo de saldo pendiente de facturar
- MF-002-US-002 — Generación de factura de cierre por saldo pendiente (si > 0)
- MF-002-US-003 — Notificación al cliente y registro de factura y estado de pago
- MF-002-US-004 — Administración confirma recepción de pago (habilita cierre formal del proyecto)

### MF-003 — Facturación núcleo (10)
- MF-003-US-001 — Listado de facturas con filtros por cliente y estado
- MF-003-US-002 — Creación manual de factura en borrador (cliente, líneas, impuestos, términos)
- MF-003-US-003 — Edición de factura en borrador (líneas, descuentos por línea o global)
- MF-003-US-004 — Publicar factura: asignar número definitivo (serie), pasar a Publicada, bloquear edición
- MF-003-US-005 — Ciclo de vida: estados Enviada, Vencida, Parcialmente Pagada, Pagada, Cancelada, Rectificada
- MF-003-US-006 — Numeración fiscal: series por país/empresa, prefijos, control de huecos
- MF-003-US-007 — Reglas de bloqueo: campos inamovibles tras publicar; cierre de periodo (opcional)
- MF-003-US-008 — Descuentos por línea y descuento global; recargos (pronto pago, mora)
- MF-003-US-009 — Detalle de factura (cabecera y líneas) con totales e impuestos desglosados
- MF-003-US-010 — Vencimientos múltiples según término de pago (fechas de vencimiento)

### MF-004 — Cobros y estado de pago (6)
- MF-004-US-001 — Asistente Registrar pago: fecha, importe, método de pago, referencia
- MF-004-US-002 — Aplicar pago a una factura (total o parcial); actualizar saldo pendiente
- MF-004-US-003 — Aplicar un pago a varias facturas (reparto manual o por orden)
- MF-004-US-004 — Estado de pago en factura: No pagada, Parcialmente pagada, Pagada
- MF-004-US-005 — Listado de cobros y relación cobro ↔ factura(s) aplicadas
- MF-004-US-006 — Reverso de aplicación de pago (anular aplicación, devolver estado)

### MF-005 — Notas de crédito (4)
- MF-005-US-001 — Crear nota de crédito desde factura publicada (acción en factura)
- MF-005-US-002 — Definir importes o líneas a revertir en la NC
- MF-005-US-003 — Vincular NC a factura original; numeración con serie/prefijo para NC
- MF-005-US-004 — Publicar NC y actualizar trazabilidad (factura rectificada / estado)

### MF-006 — PDF y envío por email (3)
- MF-006-US-001 — Generar PDF oficial de factura (diseño estándar, datos empresa y cliente)
- MF-006-US-002 — Descargar PDF desde la ficha de factura o nota de crédito
- MF-006-US-003 — Enviar factura por email al cliente con PDF adjunto (desde ficha)

### MF-007 — Facturación desde proyecto (9)
- MF-007-US-001 — Facturación mensual: seleccionar proyecto y periodo (mes) a facturar
- MF-007-US-002 — Generar líneas desde tareas realizadas en el periodo (no facturadas previamente)
- MF-007-US-003 — Generar líneas desde horas registradas facturables en el periodo (no facturadas)
- MF-007-US-004 — Generar líneas desde hitos completados en el periodo (no facturados previamente)
- MF-007-US-005 — Facturación por fee mensual: importe fijo por mes asociado al proyecto
- MF-007-US-006 — Prevención doble facturación: marcar tareas/horas/hitos/periodos como facturados; alertas
- MF-007-US-007 — Trazabilidad factura → proyecto; listado de facturas por proyecto y por periodo
- MF-007-US-008 — Prerellenar cliente/contacto de facturación desde proyecto
- MF-007-US-009 — Vista en proyecto: total facturado, pendiente por periodo, facturas del proyecto

### MF-008 — Anticipos y facturación parcial (4)
- MF-008-US-001 — Crear factura de anticipo (importe o %) asociada a proyecto/cliente
- MF-008-US-002 — Descontar anticipo en facturas mensuales (reparto por factura o en cierre)
- MF-008-US-003 — Facturación parcial: total facturado por proyecto (mensual + anticipos) vs presupuesto
- MF-008-US-004 — Vista de anticipos pendientes de descontar por proyecto/cliente

### MF-009 — Portal del cliente (4)
- MF-009-US-001 — Acceso al portal de facturación con token mágico o login cliente
- MF-009-US-002 — Historial de facturas del cliente (listado con estado de pago)
- MF-009-US-003 — Descargar PDF de factura y nota de crédito desde el portal
- MF-009-US-004 — Registro de evidencia de visualización/descarga (auditoría)

### MF-010 — Dashboard y reportes operativos (5)
- MF-010-US-001 — Dashboard: facturas pendientes de cobro y total cobrado por período
- MF-010-US-002 — Resumen por cliente y por proyecto (facturado, cobrado, pendiente)
- MF-010-US-003 — Reporte aging (antigüedad de saldos por factura/cliente)
- MF-010-US-004 — Exportar listados a Excel/CSV (facturas, cobros)
- MF-010-US-005 — Filtros por fecha, estado de pago, cliente, proyecto

### MF-011 — Maestros (6)
- MF-011-US-001 — Maestro Términos de pago (nombre, tipo, días, vencimientos)
- MF-011-US-002 — Maestro Impuestos (nombre, %, incluido/no incluido; exenciones)
- MF-011-US-003 — Cliente/contacto de facturación (extender o vincular cliente/área Kameleon)
- MF-011-US-004 — Configuración empresa: nombre, NIF, logo para PDF
- MF-011-US-005 — Maestro Productos/tarifas y unidades de medida (opcional)
- MF-011-US-006 — Precios por cliente o tarifa (opcional para líneas)

### MF-012 — Moneda y tipo de cambio (3)
- MF-012-US-001 — Seleccionar moneda de la factura; moneda base de la empresa
- MF-012-US-002 — Tipo de cambio fijado al crear/publicar factura (tasa congelada)
- MF-012-US-003 — Mostrar importes en moneda factura y en moneda base en listados/detalle

### MF-013 — Roles y permisos de facturación (4)
- MF-013-US-001 — Permisos: ver listado y detalle de facturas (por rol)
- MF-013-US-002 — Permisos: crear y editar facturas en borrador; publicar factura
- MF-013-US-003 — Permisos: anular/rectificar factura; registrar cobros
- MF-013-US-004 — Visibilidad: ver solo facturas de mis clientes vs ver todas

### MF-014 — Auditoría y trazabilidad (4)
- MF-014-US-001 — Log de cambios en factura (quién, cuándo, campo modificado)
- MF-014-US-002 — Trazabilidad de envíos por email (destinatario, fecha, adjunto)
- MF-014-US-003 — Trazabilidad de cobros aplicados (pago, factura, importe, fecha)
- MF-014-US-004 — Snapshot del PDF emitido al publicar o al enviar (opcional)

---

## Totalizaciones

| Concepto | Total |
|----------|-------|
| **Épicas (bloques funcionales)** | **14** |
| **Historias de usuario (funcionalidades detalladas)** | **71** |

*Documento generado a partir de REQUISITOS-FUNCIONALES-DETALLE.md*
