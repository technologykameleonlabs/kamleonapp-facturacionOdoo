# MF-011 — Maestros (impuestos, términos, productos/tarifas)

**Fuente**: Propuesta 4.0 + gaps 3 (Gestión impuestos), 7 (Catálogo/productos).

**Descripción**: Maestros configurables en Kameleon: Cliente/contacto de facturación (o extensión de cliente/área); Términos de pago (nombre, tipo, días o fechas de vencimiento); Impuestos (nombre, %, incluido/no incluido en precio; exenciones, retenciones si aplica); opcionalmente Productos/tarifas y unidades de medida para evitar carga manual en líneas.

**Objetivo**: Datos base para facturas, líneas y cobros; configuración de empresa (nombre, NIF, logo) para PDF.

**Alcance**: CRUD de términos de pago, impuestos; cliente de facturación (vinculado a proyecto/cliente Kameleon); productos/tarifas opcionales; datos empresa para documentos. Excluye: plan contable (fuera de alcance).

---

## Historias de usuario (índice)

| ID | Título | Prioridad |
|----|--------|-----------|
| MF-011-US-001 | Maestro Términos de pago (nombre, tipo, días, vencimientos) | Alta |
| MF-011-US-002 | Maestro Impuestos (nombre, %, incluido/no incluido; exenciones) | Alta |
| MF-011-US-003 | Cliente/contacto de facturación (extender o vincular cliente/área Kameleon) | Alta |
| MF-011-US-004 | Configuración empresa: nombre, NIF, logo para PDF | Alta |
| MF-011-US-005 | Maestro Productos/tarifas y unidades de medida (opcional) | Media |
| MF-011-US-006 | Precios por cliente o tarifa (opcional para líneas) | Baja |

**Fichas detalladas** (carpeta `stories/`):

| ID | Archivo |
|----|---------|
| US-001 | `MF-011-US-001-maestro-terminos-pago.md` |
| US-002 | `MF-011-US-002-maestro-impuestos.md` |
| US-003 | `MF-011-US-003-cliente-facturacion.md` |
| US-004 | `MF-011-US-004-configuracion-empresa.md` |
| US-005 | `MF-011-US-005-maestro-productos-tarifas.md` |
| US-006 | `MF-011-US-006-precios-por-cliente-tarifa.md` |
