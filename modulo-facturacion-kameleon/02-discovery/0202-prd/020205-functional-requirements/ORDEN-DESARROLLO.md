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
| 2.1 | **MF-003** | Facturación núcleo (listado, borrador, publicar, ciclo de vida, numeración, bloqueos, vencimientos) | MF-011, MF-013 |

**Entregable**: Facturas de cliente completas (sin cobros ni PDF en esta prioridad si se desea iterar).

---

## Prioridad 3 — Facturación desde proyecto

Facturación mensual por tareas/horas/hitos/fee, con trazabilidad a proyecto y prevención de doble facturación.

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 3.1 | **MF-001** | Activación de proyecto (sin pago obligatorio; opcional anticipo) | Ninguna (integración con proyectos) |
| 3.2 | **MF-007** | Facturación desde proyecto (periodo mensual, líneas desde tareas/horas/hitos/fee, trazabilidad) | MF-003, MF-011, MF-001 (recomendado) |

**Entregable**: Proyectos que se activan y se facturan por periodo con líneas generadas desde trabajo realizado.

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

## Prioridad 5 — Anticipos y reportes

Anticipos descontables en facturas mensuales, dashboard y exportaciones.

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 5.1 | **MF-008** | Anticipos y facturación parcial (descuento en facturas mensuales; total vs presupuesto) | MF-007, MF-003 |
| 5.2 | **MF-010** | Dashboard y reportes operativos (pendiente de cobro, cobrado, aging, exportar) | MF-003, MF-004 |

**Entregable**: Anticipos gestionados y vista de negocio (KPIs y exportaciones).

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
| **3** | MF-001, MF-007 | Activación y facturación desde proyecto |
| **4** | MF-004, MF-005, MF-006, MF-002, MF-014 | Cobros, NC, PDF, factura cierre, auditoría |
| **5** | MF-008, MF-010 | Anticipos y dashboard |
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
MF-001 Activación ──────────────────────────────────────────────────────────────► MF-007 Fact. proyecto
                                                                                           │
                                                                                           ├──► MF-002 Factura cierre
                                                                                           ├──► MF-008 Anticipos
                                                                                           │
MF-003, MF-004 ─────────────────────────────────────────────────────────────────────────► MF-010 Dashboard
MF-003, MF-006 ─────────────────────────────────────────────────────────────────────────► MF-009 Portal
```

---

*Orden de desarrollo · Módulo de facturación Kameleon App · Prioridad: Maestros → Núcleo → Facturación proyecto.*
