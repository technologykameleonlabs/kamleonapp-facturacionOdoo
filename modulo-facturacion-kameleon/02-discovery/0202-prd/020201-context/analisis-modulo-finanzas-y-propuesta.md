# Análisis: Revisión Módulo Finanzas (HTML) + Propuesta de desarrollo

**Fuentes**:  
- `Módulo_Facturación.html` — Revisión Módulo Finanzas Kameleon (benchmark Odoo).  
- `propuesta-desarrollo-facturacion-kameleon.md` — Propuesta de desarrollo (Enfoque C: facturación propia en Kameleon).

**Objetivo**: Consolidar ambas fuentes para derivar los **requisitos funcionales** del módulo de facturación Kameleon App.

---

## 1. Resumen de la propuesta de desarrollo

- **Enfoque C**: Facturación nativa en Kameleon, sin Odoo. Referencia funcional: Odoo 15.
- **Fase 1 (núcleo)**: Facturas de cliente, creación manual, líneas/impuestos/términos, borrador→publicada, notas de crédito, registro de cobro, estado de pago, PDF y envío por email.
- **Fase 2 (ampliación)**: Facturación desde proyecto, anticipos, facturación parcial, portal del cliente, dashboard.
- **Fuera de alcance inicial**: Facturas de proveedor, plan contable completo, EDI/facturación electrónica regulada.
- **Modelo de datos (núcleo)**: Cliente/Contacto facturación, Factura, Línea de factura, Término de pago, Impuesto, Pago/Cobro, Nota de crédito. Secuencias por tipo de documento.

---

## 2. Fortalezas ya reconocidas (HTML)

- Objetivo claro: facturación nativa, eliminar dependencia de Odoo.
- Alcance por fases (Fase 1 núcleo, Fase 2 ampliación).
- Funciones base: facturas, manuales, líneas, impuestos, términos, cobros, PDF, envío email.
- Enfoque de producto: control UX, modularidad, autonomía tecnológica.
- Modelo inicial: Cliente, Factura, Líneas.

---

## 3. Los 15 gaps críticos (HTML) → Requisitos a cubrir

| # | Gap | Requerimiento detallado | Epica / Área |
|---|-----|-------------------------|--------------|
| 1 | **Numeración fiscal** | Series por país/empresa, prefijos, control de huecos, bloqueo tras publicación, numeración para notas de crédito vinculadas. | MF-003 Facturación núcleo |
| 2 | **Ciclo de vida** | Flujo completo: Borrador, Publicada, Enviada, Vencida, Parcialmente Pagada, Pagada, Cancelada, Rectificada. Separar estado de documento, cobro, envío y fiscal. | MF-003 |
| 3 | **Gestión de impuestos** | Impuestos por línea, múltiples tipos, exenciones, retenciones, recargos, internacionales, reglas de redondeo. | MF-011 Maestros + MF-003 |
| 4 | **Moneda y cambio** | Multi-moneda, tasa congelada al emitir, impacto en cobros parciales, diferencias de cambio. | MF-012 Moneda |
| 5 | **Modelo de cobros** | Entidad Pago/Cobro, conciliación, pagos anticipados, saldo a favor, métodos de pago, fecha valor, reversos. | MF-004 Cobros |
| 6 | **Relación proyectos** | Facturación por hito/horas/tareas/fee mensual; prevención doble facturación; trazabilidad factura→proyecto. | MF-007 Facturación desde proyecto |
| 7 | **Catálogo/Productos** | Tarifas, unidades de medida, precios por cliente, cuentas/categorías para evitar carga manual. | MF-011 Maestros |
| 8 | **Descuentos y recargos** | Descuentos por línea y globales, anticipos %, vencimientos múltiples, pronto pago, mora. | MF-003 / MF-008 |
| 9 | **Portal del cliente** | Token mágico, historial facturas, descarga NC, evidencia de visualización, pasarelas de pago online. | MF-009 Portal |
| 10 | **Roles y permisos** | Matriz: quién publica, anula, registra cobros; quién ve solo sus clientes vs todo. | MF-013 Roles |
| 11 | **Auditoría** | Log de cambios (quién/cuándo), snapshot PDF emitido, trazabilidad emails y cobros aplicados. | MF-014 Auditoría |
| 12 | **Reglas de bloqueo** | Campos inamovibles tras publicar, cierre de periodo, borrado físico vs lógico. | MF-003 |
| 13 | **Reportes operativos** | Aging, cobrado vs pendiente, facturación por período/proyecto, exportaciones Excel/CSV. | MF-010 Dashboard/Reportes |
| 14 | **Puente contable** | Asiento futuro, mapeo ERPs, bases imponibles para reporte fiscal. | Fase posterior / diferido |
| 15 | **Requisitos NF** | Rendimiento, integridad transaccional, concurrencia, versionado documentos, cumplimiento legal. | NFR |

---

## 4. Hoja de ruta 2.0 (HTML) — 5 bloques a consolidar

1. **Reglas de negocio**: Validaciones, bloqueos, lógica fiscal.  
2. **Ciclo de vida**: Definición de estados y transiciones.  
3. **Modelo ampliado**: Cobros, conciliación, multi-moneda.  
4. **Roles y permisos**: Matriz de acceso y responsabilidades.  
5. **Auditoría y NF**: Logs, reportes, requerimientos técnicos.

---

## 5. Modelo de datos mínimo recomendado (HTML)

- Cliente / Dirección de facturación  
- Factura / Líneas  
- Impuestos / Tasas  
- Términos de pago  
- Cobros / Aplicación de pago  
- Nota de crédito  
- Serie documental  
- Moneda / Tipo de cambio  
- Auditoría / Historial  

---

## 6. Mapeo a épicas para requisitos funcionales

A partir de la propuesta (Fases 1 y 2) y de los 15 gaps se definen las siguientes épicas en `020205-functional-requirements`:

| ID | Épica | Origen | Fase propuesta |
|----|-------|--------|-----------------|
| MF-001 | Activación de proyecto (sin pago inicial obligatorio) | Flujo Kameleon existente | — |
| MF-002 | Factura de cierre / liquidación y registro de pago | Flujo Kameleon existente | — |
| MF-003 | Facturación núcleo (facturas, líneas, impuestos, términos, ciclo de vida, numeración) | Propuesta Fase 1 + gaps 1, 2, 8, 12 | Fase 1 |
| MF-004 | Cobros y estado de pago | Propuesta Fase 1 + gap 5 | Fase 1 |
| MF-005 | Notas de crédito | Propuesta Fase 1 + gap 1 (numeración NC) | Fase 1 |
| MF-006 | PDF y envío por email | Propuesta Fase 1 | Fase 1 |
| MF-007 | Facturación desde proyecto | Propuesta Fase 2 + gap 6 | Fase 2 |
| MF-008 | Anticipos y facturación parcial | Propuesta Fase 2 + gap 8 | Fase 2 |
| MF-009 | Portal del cliente | Propuesta Fase 2 + gap 9 | Fase 2 |
| MF-010 | Dashboard y reportes operativos | Propuesta Fase 2 + gap 13 | Fase 2 |
| MF-011 | Maestros (impuestos, términos, productos/tarifas) | Propuesta 4.0 + gaps 3, 7 | Fase 1 |
| MF-012 | Moneda y tipo de cambio | Gap 4 | Fase 1 o 2 |
| MF-013 | Roles y permisos de facturación | Propuesta Fase 0 + gap 10 | Fase 0/1 |
| MF-014 | Auditoría y trazabilidad | Gap 11 | Fase 1 |

---

## 7. Criterios de aceptación (propuesta) — Trazabilidad

- Ver facturas (listado y detalle) desde Kameleon. → MF-003, MF-010  
- Crear factura (manual o desde proyecto) con líneas, impuestos, términos; publicar con numeración definitiva. → MF-003, MF-007  
- Registrar cobro sobre factura; estado de pago actualizado. → MF-004  
- Enviar factura por email en PDF; descargar PDF oficial. → MF-006  
- Notas de crédito desde factura publicada, vinculadas a factura original. → MF-005  
- Cliente/área como cliente de facturación (maestro único). → MF-011 / modelo  
- Fase 2: facturación desde proyecto y resumen facturas/cobros. → MF-007, MF-010  

---

*Documento de análisis para generación de requisitos funcionales · modulo-facturacion-kameleon*
