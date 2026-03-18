# Backlog — Módulo de facturación Kameleon App

**Origen**: EPICS-INDEX.md (análisis Módulo Finanzas HTML + Propuesta de desarrollo).  
**Épicas**: 14 (MF-001 a MF-014). **Historias de usuario**: 71 (véase EPICAS-Y-HISTORIAS-USUARIO.md).

**Orden de desarrollo (prioridad Maestros → Núcleo → Facturación proyecto)**: ver **[ORDEN-DESARROLLO.md](ORDEN-DESARROLLO.md)**.

---

## Resumen por fases

| Fase | Épicas | Objetivo |
|------|--------|----------|
| **Fase 0** | MF-011, MF-013 | Maestros y roles listos para facturación |
| **Fase 1 — Núcleo** | MF-003, MF-004, MF-005, MF-006, MF-014, (MF-012) | Facturas, cobros, NC, PDF/email, auditoría |
| **Flujo Kameleon** | MF-001, MF-002 | Activación sin pago obligatorio, factura de cierre por saldo pendiente |
| **Fase 2 — Ampliación** | MF-007, MF-008, MF-009, MF-010 | Desde proyecto, anticipos, portal, dashboard |

---

## Orden sugerido de implementación

1. **MF-011** (Maestros), **MF-013** (Roles y permisos).  
2. **MF-003** (Facturación núcleo): listado, creación manual, publicar, ciclo de vida, numeración.  
3. **MF-004** (Cobros), **MF-005** (Notas de crédito), **MF-006** (PDF y email), **MF-014** (Auditoría).  
4. **MF-001**, **MF-002** (integrar con núcleo cuando esté disponible).  
5. **MF-007**, **MF-008**, **MF-009**, **MF-010** (Fase 2).  
6. **MF-012** (Moneda) cuando se requiera multi-moneda.

---

## Backlog por épica (resumen)

| Epic | # US | Prioridad épica |
|------|------|-----------------|
| MF-001 Activación de proyecto (sin pago inicial obligatorio) | 5 | Alta |
| MF-002 Factura de cierre / liquidación y registro de pago | 4 | Alta |
| MF-003 Facturación núcleo | 10 | Alta |
| MF-004 Cobros y estado de pago | 6 | Alta |
| MF-005 Notas de crédito | 4 | Alta |
| MF-006 PDF y envío por email | 3 | Alta |
| MF-007 Facturación desde proyecto (mensual por tareas/horas/hitos/fee) | 9 | Fase 2 |
| MF-008 Anticipos y facturación parcial (en contexto mensual) | 4 | Fase 2 |
| MF-009 Portal del cliente | 4 | Fase 2 |
| MF-010 Dashboard y reportes | 5 | Fase 2 |
| MF-011 Maestros | 6 | Alta (Fase 0) |
| MF-012 Moneda y tipo de cambio | 3 | Media |
| MF-013 Roles y permisos | 4 | Alta (Fase 0) |
| MF-014 Auditoría y trazabilidad | 4 | Alta |

Detalle de cada épica y sus US en la carpeta de la épica y en el índice dentro de cada `MF-0XX-*.md`.

---

*Backlog · modulo-facturacion-kameleon · Fuentes: analisis-modulo-finanzas-y-propuesta.md, Módulo_Facturación.html, propuesta-desarrollo-facturacion-kameleon.md*
