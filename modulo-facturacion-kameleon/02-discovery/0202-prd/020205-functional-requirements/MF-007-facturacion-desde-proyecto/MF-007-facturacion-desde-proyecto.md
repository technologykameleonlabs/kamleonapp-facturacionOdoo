# MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

**Fuente**: Propuesta Fase 2 + gap 6 (Relación proyectos). Modelo: **facturación mensual** en función de lo realizado.

**Descripción**: Los proyectos se facturan **mensualmente** en función de las tareas realizadas, horas registradas, hitos completados o fee mensual acordado. Desde la ficha del proyecto (o panel Facturación) se genera la factura del periodo (mes) con líneas derivadas de: tareas realizadas en el periodo, horas facturables registradas, hitos cerrados o importe de fee mensual. **Prevención de doble facturación**: no se puede facturar dos veces las mismas tareas, las mismas horas ni el mismo periodo/hito. **Trazabilidad**: toda factura vinculada a proyecto (proyecto_id) y, a nivel de línea, opcionalmente a tarea/hito/periodo para auditoría.

**Objetivo**: Facturar cada proyecto de forma mensual (o por periodo cerrado) según lo realmente ejecutado (tareas/horas/hitos/fee), con trazabilidad factura → proyecto y sin duplicar conceptos ya facturados.

**Alcance**:
- **Incluye**: Facturación por **periodo mensual** (o periodo configurable); líneas de factura generadas desde **tareas realizadas** en el periodo, **horas** registradas (facturables), **hitos** completados o **fee mensual** fijo; **prevención de doble facturación** (marcar tareas/horas/hitos/periodos ya facturados; bloquear o alertar si se intenta facturar de nuevo); **trazabilidad factura → proyecto** (listado de facturas por proyecto; en cada factura, proyecto y periodo facturado); prerellenar cliente desde el proyecto.
- **Excluye**: Facturación automática sin intervención (el usuario confirma periodo y líneas antes de publicar); pasarela de pago (MF-004/MF-009).

---

## Historias de usuario (índice)

| ID | Título | Prioridad |
|----|--------|-----------|
| MF-007-US-001 | Facturación mensual: seleccionar proyecto y periodo (mes) a facturar | Alta |
| MF-007-US-002 | Generar líneas desde tareas realizadas en el periodo (no facturadas previamente) | Alta |
| MF-007-US-003 | Generar líneas desde horas registradas facturables en el periodo (no facturadas) | Alta |
| MF-007-US-004 | Generar líneas desde hitos completados en el periodo (no facturados previamente) | Alta |
| MF-007-US-005 | Facturación por fee mensual: importe fijo por mes asociado al proyecto | Alta |
| MF-007-US-006 | Prevención doble facturación: marcar tareas/horas/hitos/periodos como facturados; alertas | Alta |
| MF-007-US-007 | Trazabilidad factura → proyecto; listado de facturas por proyecto y por periodo | Alta |
| MF-007-US-008 | Prerellenar cliente/contacto de facturación desde proyecto | Alta |
| MF-007-US-009 | Vista en proyecto: total facturado, pendiente por periodo, facturas del proyecto | Alta |

> Detalle en carpeta `/stories`
