# MF-003 — Facturación núcleo

**Fuente**: Propuesta Fase 1 + gaps 1 (Numeración fiscal), 2 (Ciclo de vida), 8 (Descuentos/recargos), 12 (Reglas de bloqueo); ampliación **tipos documentales** (MF-003-US-011) por integración con **MF-001** (prefactura).

**Especificación detallada**: [REQUISITOS-FUNCIONALES-DETALLE.md](../REQUISITOS-FUNCIONALES-DETALLE.md) — sección **MF-003**.

---

**Contexto**: El núcleo de facturación es la **base** para MF-004 (cobros), MF-005 (NC), MF-006 (PDF/email), MF-007 (facturas desde proyecto) y MF-008 (aplicación de cupo/prefactura sobre facturas de periodo). Los documentos generados en **MF-001** (prefactura por importe total) deben respetar las mismas reglas de **cabecera, líneas, impuestos y numeración** que el resto de facturas, con variaciones según **tipo documental** (US-011).

**Descripción**: Facturas de cliente con creación manual, líneas de detalle, impuestos y términos de pago. Ciclo de vida: **Borrador → Publicada →** (Enviada, Vencida, Parcialmente Pagada, Pagada, Cancelada, Rectificada). Numeración fiscal por **serie** cuando el documento es fiscal; bloqueo de campos tras publicar. Soporte de **tipos documentales** para distinguir factura ordinaria, anticipo y **prefactura** (proforma o fiscal).

**Objetivo de negocio**: Emitir documentos de venta correctos fiscalmente, trazables y coherentes con el flujo Kameleon (proyecto → prefactura/cupo → facturas de periodo que consumen saldo).

**Integración con otras épicas**

| Épica | Relación con MF-003 |
|-------|---------------------|
| **MF-001** | La prefactura de activación se materializa como documento del núcleo; **MF-003-US-011** define numeración y tipo (proforma vs fiscal). |
| **MF-007** | Facturas de periodo: mismo modelo de borrador/publicación; `proyecto_id` y periodo en cabecera. |
| **MF-008** | Líneas o movimientos que **aplican** el cupo sobre facturas publicadas; validación de saldo al publicar (coherente con MF-007). |
| **MF-011** | Maestros: cliente, impuestos, términos de pago, series. |
| **MF-012** | Moneda y tipo de cambio (si aplica). |

**Nota (MF-001 / decisión fiscal)**: La prefactura puede ser **(A) proforma sin numeración fiscal** o **(B) factura fiscal** con serie propia. Hasta cerrar A o B, **MF-003-US-011** y la épica MF-001 contemplan ambas ramas. Evitar doble conteo en totales mostrados según la opción elegida.

---

### Alcance

- **Incluye**: Listado de facturas con filtros; creación manual en borrador; edición de líneas, descuentos y recargos; publicación con numeración por serie; ciclo de vida y estados; reglas de bloqueo post-publicación; detalle con totales e impuestos; vencimientos múltiples; **tipos documentales y series condicionadas** (MF-003-US-011).
- **Excluye**: Registro de cobros (**MF-004**); notas de crédito (**MF-005**); generación y envío de PDF/email (**MF-006**); lógica de **consumo de cupo** en facturas de periodo (**MF-008**, aunque MF-003 debe permitir metadatos y validaciones que MF-008 dispare).

---

## Historias de usuario (índice)

| ID            | Título                                                                                       | Estado   | Prioridad |
| ------------- | -------------------------------------------------------------------------------------------- | -------- | --------- |
| MF-003-US-001 | Listado de facturas con filtros por cliente y estado                                         | Definida | Alta      |
| MF-003-US-002 | Creación manual de factura en borrador (cliente, líneas, impuestos, términos)                | Definida | Alta      |
| MF-003-US-003 | Edición de factura en borrador (líneas, descuentos por línea o global)                       | Definida | Alta      |
| MF-003-US-004 | Publicar factura: asignar número definitivo (serie), pasar a Publicada, bloquear edición     | Definida | Alta      |
| MF-003-US-005 | Ciclo de vida: estados Enviada, Vencida, Parcialmente Pagada, Pagada, Cancelada, Rectificada | Definida | Alta      |
| MF-003-US-006 | Numeración fiscal: series por país/empresa, prefijos, control de huecos                      | Definida | Alta      |
| MF-003-US-007 | Reglas de bloqueo: campos inamovibles tras publicar; cierre de periodo (opcional)            | Definida | Media     |
| MF-003-US-008 | Descuentos por línea y descuento global; recargos (pronto pago, mora)                        | Definida | Media     |
| MF-003-US-009 | Detalle de factura (cabecera y líneas) con totales e impuestos desglosados                   | Definida | Alta      |
| MF-003-US-010 | Vencimientos múltiples según término de pago (fechas de vencimiento)                         | Definida | Media     |
| MF-003-US-011 | Tipos documentales: prefactura/proforma vs factura fiscal; series y numeración condicionada | Definida | Alta      |

**Orden sugerido de implementación (referencia)**: US-006 (series) y **US-011** (tipos documentales) antes o en paralelo con US-004; US-001 → US-002 → US-003 → US-004 como núcleo mínimo; US-005, US-007, US-008, US-009, US-010 en el orden que priorice el equipo.

**Tareas de desarrollo**: [TAREAS-MF-003-FACTURACION-NUCLEO.md](./TAREAS-MF-003-FACTURACION-NUCLEO.md) (incluye BACK/FRONT para **MF-003-US-011**).

> Detalle de cada US en carpeta `/stories`
