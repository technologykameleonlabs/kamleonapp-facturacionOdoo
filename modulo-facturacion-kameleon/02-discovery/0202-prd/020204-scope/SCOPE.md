# SCOPE — Módulo de facturación Kameleon App

**Fecha**: 2026-03  
**Paquete**: modulo-facturacion-kameleon  
**Fuentes**: Propuesta de desarrollo (Enfoque C), Revisión Módulo Finanzas (HTML), análisis en `020201-context/analisis-modulo-finanzas-y-propuesta.md`

## Resumen

Alcance del **módulo de facturación** para Kameleon App: facturación nativa en Kameleon (sin Odoo), por **fases**. Los **proyectos se facturan mensualmente** en función de las tareas realizadas, horas registradas, hitos completados o fee mensual; con **prevención de doble facturación** y **trazabilidad factura → proyecto**. Incluye activación de proyecto con **prefactura por importe total** (MF-001) y factura de cierre por saldo pendiente (MF-002), **núcleo** (facturas, líneas, cobros, NC, PDF, email) y **ampliación** (facturación mensual desde proyecto MF-007, consumo de cupo/anticipos MF-008, portal, dashboard).

## Fases

| Fase | Contenido | Épicas principales |
|------|-----------|---------------------|
| **Fase 0** | Diseño, modelo de datos, numeración, roles y permisos | MF-011 Maestros, MF-013 Roles |
| **Fase 1 — Núcleo** | Facturas manuales, ciclo de vida, numeración fiscal, cobros, NC, PDF/email, maestros, auditoría | MF-003, MF-004, MF-005, MF-006, MF-011, MF-014 |
| **Fase 2 — Ampliación** | Facturación desde proyecto, anticipos, facturación parcial, portal cliente, dashboard/reportes | MF-007, MF-008, MF-009, MF-010 |
| **Opcional / posterior** | Moneda y tipo de cambio, puente contable, EDI | MF-012, etc. |

## Procesos / bloques en alcance (por épica)

| ID | Proceso / Bloque | Fase | Descripción |
|----|------------------|------|-------------|
| MF-TO-BE-01 | Activación de proyecto (sin pago obligatorio) | — | Activación por contrato/manual; opcional factura de anticipo (MF-001). |
| MF-TO-BE-02 | Factura de cierre / liquidación y registro de pago | — | Factura por saldo pendiente al cierre; confirmación de pago (MF-002). |
| MF-003 | Facturación núcleo | 1 | Facturas manuales, líneas, impuestos, términos, ciclo de vida (Borrador→Publicada→…), numeración fiscal, reglas de bloqueo. |
| MF-004 | Cobros | 1 | Registro de pago, aplicación a facturas, estado de pago (no pagada/parcial/pagada). |
| MF-005 | Notas de crédito | 1 | NC vinculadas a factura publicada; numeración. |
| MF-006 | PDF y envío email | 1 | Generación PDF oficial, envío por email. |
| MF-007 | Facturación desde proyecto (mensual) | 2 | Facturación **mensual** por tareas/horas/hitos/fee; prevención doble facturación; trazabilidad factura→proyecto. |
| MF-008 | Anticipos y facturación parcial | 2 | Anticipos (importe/%); descuento en facturas mensuales; total facturado vs presupuesto. |
| MF-009 | Portal del cliente | 2 | Cliente ve/descarga facturas (token); evidencia de visualización. |
| MF-010 | Dashboard y reportes | 2 | Resumen cobrado/pendiente, por período/proyecto; aging; exportaciones. |
| MF-011 | Maestros | 0/1 | Impuestos, términos de pago, productos/tarifas (catálogo). |
| MF-012 | Moneda y tipo de cambio | 1/2 | Multi-moneda, tasa congelada al emitir (opcional). |
| MF-013 | Roles y permisos | 0/1 | Quién publica, anula, registra cobros; visibilidad por cliente. |
| MF-014 | Auditoría y trazabilidad | 1 | Log de cambios, snapshot PDF, trazabilidad emails y cobros. |

## Fuera de alcance inicial

- Facturas de proveedor / compras.  
- Plan contable completo, diarios contables (puente contable en fase posterior).  
- EDI / facturación electrónica regulada (valorar después).  
- Pasarela de pago integrada (opcional en portal, Fase 2).

## Dependencias entre épicas

- MF-003, MF-004, MF-005, MF-006 dependen de MF-011 (maestros) y MF-013 (permisos).  
- MF-007 depende de MF-003 y del modelo de proyectos en Kameleon.  
- MF-001 y MF-002 pueden integrarse con MF-003/MF-004 cuando el núcleo esté definido.

---

*Documento de alcance · modulo-facturacion-kameleon*
