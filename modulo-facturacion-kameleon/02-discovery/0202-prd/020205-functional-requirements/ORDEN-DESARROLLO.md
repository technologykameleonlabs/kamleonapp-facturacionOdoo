# Orden de desarrollo — Módulo de facturación Kameleon App

Prioridad: **Maestros → Facturación núcleo → Activación/prefactura y facturación desde proyecto → Cobro y cierre → Reportes → Portal**. El detalle funcional está en [REQUISITOS-FUNCIONALES-DETALLE.md](./REQUISITOS-FUNCIONALES-DETALLE.md).

**Flujo de negocio (versión actual)**: activación del proyecto con **prefactura por importe total** (cupo); **facturas de periodo** que **consumen** ese saldo hasta **0** (MF-008). MF-007 cubre la facturación mensual desde proyecto; la generación automática desde tareas/horas/hitos puede ir por fases.

---

## Prioridad 1 — Fundamentos (Maestros y soporte)

Sin estos no se puede facturar ni aplicar permisos ni multi-moneda.

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 1.1 | **MF-011** | Maestros (términos de pago, impuestos, cliente, empresa, opcional productos) | Ninguna |
| 1.2 | **MF-013** | Roles y permisos de facturación | Ninguna |
| 1.3 | **MF-012** | Moneda y tipo de cambio | Ninguna (opcional: después del núcleo si no hay multi-moneda al inicio) |

**Entregable**: Datos base y permisos listos para crear y publicar facturas.

---

## Prioridad 2 — Facturación núcleo

Permite crear, editar en borrador y publicar facturas con líneas, impuestos y términos de pago.

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 2.1 | **MF-003** | Facturación núcleo: listado, borrador, publicar, ciclo de vida, numeración, bloqueos, vencimientos; **MF-003-US-011** (tipos documentales prefactura/proforma vs fiscal) antes o en paralelo con publicación si ya se implementa **MF-001** | MF-011, MF-013 |

**Entregable**: Facturas de cliente coherentes con normativa (sin cobros ni PDF en esta prioridad, si se desea iterar).

**Nota**: Si el sprint incluye **MF-001**, priorizar **US-011** dentro de MF-003 para no bloquear la emisión de prefactura.

---

## Prioridad 3 — Activación, prefactura y facturación desde proyecto

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 3.1 | **MF-001** | Activación de proyecto y **prefactura por importe total** (cupo consumible) | Integración con proyectos; **MF-003** (mínimo borrador + publicar según tipo documental); **MF-003-US-011** |
| 3.2 | **MF-007** | Facturación desde proyecto: periodo mensual; líneas desde tareas/horas/hitos/fee **o** factura manual/fee en **MVP**; trazabilidad; **vista saldo prefactura** | MF-003, MF-011, MF-001 (recomendado) |
| 3.3 | **MF-008** | Aplicación del cupo / anticipo en facturas de periodo; validación de saldo al publicar (hasta saldo 0) | MF-007, MF-003 |

**Entregable**: Proyecto activo con cupo; facturas de periodo que rebajan saldo; no publicar consumo por encima del saldo (salvo política explícita de solo advertencia).

**MVP sugerido**: MF-007 con **creación manual** de factura de periodo (y opcional fee) + MF-008 aplicando cupo; ampliar después la generación automática de líneas (MF-007-US-002…US-005).

**Secuencia práctica**: puede avanzarse **MF-008** en paralelo a la parte “rica” de MF-007 en cuanto exista factura vinculada a `proyecto_id` y borrador/publicación en MF-003.

---

## Prioridad 4 — Cobro, documentos y cierre

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 4.1 | **MF-004** | Cobros y estado de pago | MF-003 |
| 4.2 | **MF-005** | Notas de crédito | MF-003 |
| 4.3 | **MF-006** | PDF y envío por email | MF-003, MF-011 |
| 4.4 | **MF-002** | Factura de cierre / liquidación y registro de pago | MF-007, MF-003; **MF-008** (recomendado: coherencia saldo prefactura / total facturado) |
| 4.5 | **MF-014** | Auditoría y trazabilidad | MF-003; MF-004, MF-006 (recomendado); puede iniciarse con hooks mínimos desde P2 |

**Entregable**: Facturar → enviar PDF → cobrar → NC si aplica → factura de cierre al cerrar proyecto; trazas de cambios y envíos.

---

## Prioridad 5 — Reportes

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 5.1 | **MF-010** | Dashboard y reportes (pendiente de cobro, cobrado, aging, exportar) | MF-003, MF-004 |

**Entregable**: KPIs operativos y exportaciones.

---

## Prioridad 6 — Portal del cliente (opcional / fase posterior)

| Orden | Épica | Descripción | Dependencias |
|-------|--------|-------------|--------------|
| 6.1 | **MF-009** | Portal del cliente (ver y descargar facturas con token o login) | MF-006, MF-003 |

**Entregable**: Cliente accede a sus facturas sin back-office.

---

## Resumen del orden

| Prioridad | Épicas | Foco |
|-----------|--------|------|
| **1** | MF-011, MF-013, (MF-012) | Maestros y roles |
| **2** | MF-003 (+ US-011 si hay MF-001 en roadmap) | Facturación núcleo |
| **3** | MF-001, MF-007, MF-008 | Activación, prefactura total, facturas de periodo y consumo de cupo |
| **4** | MF-004, MF-005, MF-006, MF-002, MF-014 | Cobros, NC, PDF, cierre, auditoría |
| **5** | MF-010 | Dashboard |
| **6** | MF-009 | Portal cliente |

---

## Diagrama de dependencias (simplificado)

```
MF-011 Maestros ──────┬──────────────────────────────────────────────────────────► MF-003 Facturación núcleo
MF-013 Roles ─────────┤                    (numeración + MF-003-US-011 tipos documentales / prefactura)
MF-012 Moneda (opt) ──┘                                                                    │
                                                                                           ├──► MF-004 Cobros
                                                                                           ├──► MF-005 NC
                                                                                           ├──► MF-006 PDF
                                                                                           ├──► MF-014 Auditoría
                                                                                           │
Integración proyectos + MF-003 ─────────────────────────────────────────────────────────► MF-001 Activación
                                                                                           │   y prefactura total
                                                                                           ▼
                                                                                    MF-007 Fact. proyecto
                                                                                           │
                                                                                           ├──► MF-008 Consumo cupo
                                                                                           │
                                                                                           └──► MF-002 Factura cierre

MF-003, MF-004 ─────────────────────────────────────────────────────────────────────────► MF-010 Dashboard
MF-003, MF-006 ─────────────────────────────────────────────────────────────────────────► MF-009 Portal
```

---

*Orden de desarrollo · Módulo de facturación Kameleon App · Maestros → Núcleo (US-011 si aplica) → Proyecto + cupo → Cobro/cierre → Reportes → Portal.*
