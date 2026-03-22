# Orden de desarrollo — Módulo de facturación Kameleon App

Prioridad: **Maestros → Facturación núcleo → Facturación desde proyecto**. El resto de épicas se ordenan según dependencias y valor de negocio.

---

## Prioridad 1 — Fundamentos (Maestros y soporte)

Sin estos no se puede facturar ni aplicar permisos ni multi-moneda.

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 1.1 | **MF-011** | Maestros (términos de pago, impuestos, cliente, empresa, opcional productos) | Ninguna |
| 1.2 | **MF-013** | Roles y permisos de facturación | Ninguna |
| 1.3 | **MF-012** | Moneda y tipo de cambio | Ninguna (opcional incluir después del núcleo si no hay multi-moneda al inicio) |

**Entregable**: Datos base y permisos listos para crear y publicar facturas.

---

## Prioridad 2 — Facturación núcleo

Permite crear, editar en borrador y publicar facturas con líneas, impuestos y términos de pago.

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 2.1 | **MF-003** | Facturación núcleo (listado, borrador, publicar, ciclo de vida, numeración, tipos documentales US-011, bloqueos, vencimientos) | MF-011, MF-013 |

**Entregable**: Facturas de cliente completas (sin cobros ni PDF en esta prioridad si se desea iterar).

---

## Prioridad 3 — Facturación desde proyecto

Activación con **prefactura por importe total** (MF-001), facturación por periodo (MF-007) y **consumo del cupo** en cada factura (MF-008). La generación automática de líneas desde tareas/horas/hitos puede ir por fases dentro de MF-007.

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 3.1 | **MF-001** | Activación y prefactura por importe total (cupo consumible) | Integración proyectos; **MF-003** + **MF-003-US-011** para tipo documental/numeración |
| 3.2 | **MF-007** | Facturación desde proyecto (periodo mensual, líneas desde tareas/horas/hitos/fee o manual, trazabilidad, **saldo prefactura**) | MF-003, MF-011, MF-001 (recomendado) |
| 3.3 | **MF-008** | Aplicación del cupo/anticipo en facturas de periodo (saldo hasta 0) | MF-007, MF-003 |

**Entregable**: Proyectos activados con cupo total; facturas mensuales que rebajan el saldo; vista de saldo en proyecto; sin superar el cupo al publicar (salvo política de solo advertencia).

---

## Prioridad 4 — Cobro, documentos y cierre

Cobros, notas de crédito, PDF/email y factura de cierre.

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 4.1 | **MF-004** | Cobros y estado de pago | MF-003 |
| 4.2 | **MF-005** | Notas de crédito | MF-003 |
| 4.3 | **MF-006** | PDF y envío por email | MF-003, MF-011 (datos empresa/cliente) |
| 4.4 | **MF-002** | Factura de cierre / liquidación y registro de pago | MF-007, MF-003 |
| 4.5 | **MF-014** | Auditoría y trazabilidad | MF-003, MF-004, MF-006 (recomendado integrar desde el inicio en núcleo) |

**Entregable**: Ciclo completo: facturar → enviar PDF → cobrar → NC si aplica → factura de cierre al cerrar proyecto.

---

## Prioridad 5 — Reportes

Dashboard y exportaciones (el consumo de cupo / anticipos en facturas mensuales está en **Prioridad 3** con MF-008).

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 5.1 | **MF-010** | Dashboard y reportes operativos (pendiente de cobro, cobrado, aging, exportar) | MF-003, MF-004 |

**Entregable**: Vista de negocio (KPIs y exportaciones).

---

## Prioridad 6 — Portal del cliente (opcional / fase posterior)

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 6.1 | **MF-009** | Portal del cliente (ver y descargar facturas con token o login) | MF-006, MF-003 |

**Entregable**: Cliente puede ver y descargar sus facturas sin acceder al back-office.

---

## Resumen del orden

| Prioridad | Épicas | Foco |
|-----------|--------|------|
| **1** | MF-011, MF-013, (MF-012) | Maestros y roles |
| **2** | MF-003 | Facturación núcleo |
| **3** | MF-001, MF-007, MF-008 | Activación, prefactura total, facturación periodo y consumo de cupo |
| **4** | MF-004, MF-005, MF-006, MF-002, MF-014 | Cobros, NC, PDF, factura cierre, auditoría |
| **5** | MF-010 | Dashboard y reportes |
| **6** | MF-009 | Portal del cliente |

---

## Diagrama de dependencias (simplificado)

```
MF-011 Maestros ──────┬──────────────────────────────────────────────────────────► MF-003 Facturación núcleo
MF-013 Roles ─────────┤                                                                    │
MF-012 Moneda (opt) ───┘                                                                    │
                                                                                           ├──► MF-004 Cobros
                                                                                           ├──► MF-005 NC
                                                                                           ├──► MF-006 PDF
                                                                                           ├──► MF-014 Auditoría
MF-001 Activación ──────────────────────────────────────────────────────────────► MF-007 Fact. proyecto ──► MF-008 Consumo cupo
                                                                                           │
                                                                                           ├──► MF-002 Factura cierre
                                                                                           │
MF-003, MF-004 ─────────────────────────────────────────────────────────────────────────► MF-010 Dashboard
MF-003, MF-006 ─────────────────────────────────────────────────────────────────────────► MF-009 Portal
```

---

*Orden de desarrollo · Módulo de facturación Kameleon App · Prioridad: Maestros → Núcleo → Facturación proyecto.*
