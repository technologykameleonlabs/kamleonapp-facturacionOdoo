# Requisitos funcionales — Índice de épicas (Módulo facturación)

**Documento detallado para desarrolladores**: [REQUISITOS-FUNCIONALES-DETALLE.md](./REQUISITOS-FUNCIONALES-DETALLE.md) — especificación en profundidad de cada épica (procesos, reglas de negocio, validaciones y criterios de aceptación).

## Resumen

- **Fuentes**: Propuesta de desarrollo (Enfoque C), Revisión Módulo Finanzas (15 gaps), ver `020201-context/analisis-modulo-finanzas-y-propuesta.md`.
- **Épicas**: 14 (MF-001 a MF-014).
- **Historias de usuario**: Ver tabla por épica; estimación inicial ~60–70 US.

## Épicas

| ID | Epic | Fase | # US est. | Origen |
|----|------|------|-----------|--------|
| MF-001 | Activación de proyecto (sin pago inicial obligatorio) | Flujo Kameleon | 5 | TO-BE-010 |
| MF-002 | Factura de cierre / liquidación y registro de pago | Flujo Kameleon | 4 | TO-BE-022 |
| MF-003 | Facturación núcleo (facturas, líneas, ciclo de vida, numeración) | Fase 1 | 10 | Propuesta F1 + gaps 1, 2, 8, 12 |
| MF-004 | Cobros y estado de pago | Fase 1 | 6 | Propuesta F1 + gap 5 |
| MF-005 | Notas de crédito | Fase 1 | 4 | Propuesta F1 + gap 1 |
| MF-006 | PDF y envío por email | Fase 1 | 3 | Propuesta F1 |
| MF-007 | Facturación desde proyecto (mensual por tareas/horas/hitos/fee) | Fase 2 | 9 | Propuesta F2 + gap 6 |
| MF-008 | Anticipos y facturación parcial (en contexto mensual) | Fase 2 | 4 | Propuesta F2 + gap 8 |
| MF-009 | Portal del cliente | Fase 2 | 4 | Propuesta F2 + gap 9 |
| MF-010 | Dashboard y reportes operativos | Fase 2 | 5 | Propuesta F2 + gap 13 |
| MF-011 | Maestros (impuestos, términos, productos/tarifas) | Fase 0/1 | 6 | Propuesta 4.0 + gaps 3, 7 |
| MF-012 | Moneda y tipo de cambio | Fase 1/2 | 3 | Gap 4 |
| MF-013 | Roles y permisos de facturación | Fase 0/1 | 4 | Propuesta F0 + gap 10 |
| MF-014 | Auditoría y trazabilidad | Fase 1 | 4 | Gap 11 |

## Dependencias entre épicas

- **MF-011** (Maestros) y **MF-013** (Roles) son base para MF-003, MF-004, MF-005, MF-006.
- **MF-003** (Facturación núcleo) es base para MF-004, MF-005, MF-006, MF-007, MF-008.
- **MF-007** requiere modelo de proyectos Kameleon y MF-003.
- **MF-001** y **MF-002** se integran con MF-003/MF-004 cuando el núcleo esté disponible.

## Orden sugerido de implementación

1. Fase 0: MF-011 (Maestros), MF-013 (Roles).  
2. Fase 1: MF-003 → MF-004, MF-005, MF-006, MF-014; opcional MF-012.  
3. Flujo Kameleon: MF-001, MF-002 (pueden desarrollarse en paralelo o después del núcleo).  
4. Fase 2: MF-007, MF-008, MF-009, MF-010.

---

*Índice de épicas · modulo-facturacion-kameleon*
