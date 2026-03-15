# MF-007-US-001 — Facturación mensual: seleccionar proyecto y periodo (mes) a facturar

**Epic**: MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

**Como** usuario con permiso de facturación, **quiero** poder elegir un proyecto y un periodo (mes) a facturar desde la ficha del proyecto o desde el módulo Facturación, **para** generar la factura mensual con las tareas/horas/hitos/fee de ese periodo sin duplicar periodos ya facturados.

**Criterios de aceptación**:
- En proyecto: botón "Crear factura de periodo" / "Facturar mes". Selección de periodo (mes/año). Solo se ofrecen periodos con trabajo realizado y que no tengan ya factura para ese proyecto+periodo.
- Si el periodo ya está facturado: mensaje "Ya existe la factura [número] para este proyecto y periodo" y no permitir crear otra (salvo flujo de rectificación).
- Tras elegir periodo se abre el flujo de generación de líneas (MF-007-US-002 a US-005) y prevención doble facturación (MF-007-US-006).

**Prioridad**: Alta
