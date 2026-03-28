# MF-007-US-001 — Facturación mensual: seleccionar proyecto y periodo (mes) a facturar

**Epic**: MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

**Como** usuario con permiso de facturación, **quiero** poder elegir un proyecto y un periodo (mes) a facturar desde la ficha del proyecto o desde el módulo Facturación, **para** generar la factura mensual con las tareas/horas/hitos/fee de ese periodo sin duplicar periodos ya facturados.

**Criterios de aceptación**:
- En proyecto: botón "Crear factura de periodo" / "Facturar mes". Selección de periodo (mes/año o rango según política). Solo se ofrecen periodos con trabajo realizado y que no tengan ya factura publicada para ese proyecto+periodo (salvo rectificación).
- Si el periodo ya está facturado: mensaje "Ya existe la factura [número] para este proyecto y periodo" y no permitir crear otra (salvo flujo de rectificación).
- Tras elegir periodo se crea factura en **Borrador** (MF-003) con `proyecto_id` y `periodo_facturado` y se abre el flujo de generación de líneas (MF-007-US-002 a US-005) y prevención doble facturación (MF-007-US-006).
- Periodo no futuro (o según política de negocio).

### Campos de datos

| Campo | Descripción | Tipo |
|-------|-------------|------|
| factura.proyecto_id | Proyecto desde el que se factura | Relación (FK) |
| factura.periodo_facturado | Mes/año o rango facturado | Texto estructurado / fechas |
| factura.fecha_desde / fecha_hasta | Límites del periodo (si aplica) | Fecha |
| proyecto.id | Contexto del selector | Relación (FK) |
| ui.periodo_seleccionado | Periodo elegido por el usuario antes de crear borrador | Estructura (mes/año) |

### Estimación de esfuerzo (con IA)

- UI selector periodo + validación proyecto+periodo único: **0,25–0,5 días**.
- API crear borrador con cabecera proyecto/periodo: **0,25 días**.
- Total estimado para esta US: **~0,5–0,75 días** de desarrollo efectivo.

**Prioridad**: Alta
