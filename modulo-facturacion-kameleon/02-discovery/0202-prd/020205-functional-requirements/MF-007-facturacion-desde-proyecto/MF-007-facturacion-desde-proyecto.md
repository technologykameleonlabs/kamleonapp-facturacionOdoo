# MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

**Fuente**: Propuesta Fase 2 + gap 6 (Relación proyectos); alineación con **MF-001** (cupo prefactura), **MF-008** (consumo de saldo) y **MF-003** (borrador/publicación).

**Especificación detallada**: [REQUISITOS-FUNCIONALES-DETALLE.md](../REQUISITOS-FUNCIONALES-DETALLE.md) — sección **MF-007**.

---

**Contexto**: Tras **activar el proyecto** y registrar la **prefactura por importe total** (MF-001), las **facturas de periodo** generadas desde el proyecto **consumen** el saldo del cupo vía **MF-008**. MF-007 define **cómo** se construye cada factura mensual (periodo, líneas desde tareas/horas/hitos/fee o manual en MVP), la **prevención de doble facturación** y la **trazabilidad** proyecto ↔ factura.

**Descripción**: Los proyectos se facturan **por periodo** (típicamente mensual) según tareas completadas, horas facturables, hitos cerrados o **fee mensual**. El usuario elige periodo y revisa líneas en **borrador** (MF-003) antes de publicar. Se evita facturar dos veces el mismo concepto o el mismo proyecto+periodo.

**Objetivo de negocio**: Emitir facturas de periodo alineadas al trabajo realizado, con visibilidad de **saldo prefactura**, totales por proyecto y cumplimiento del tope de cupo al publicar.

**Integración con otras épicas**


| Épica      | Relación con MF-007                                                                                                          |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------- |
| **MF-001** | El proyecto activo tiene cupo/prefactura; MF-007 muestra **saldo** y crea facturas que luego aplican cupo (MF-008).          |
| **MF-003** | Factura de periodo = mismo ciclo **Borrador → Publicada**; líneas editables en borrador; `proyecto_id`, `periodo_facturado`. |
| **MF-008** | Al publicar, validar **aplicación al cupo** ≤ saldo pendiente; líneas de aplicación o descuento según diseño.                |
| **MF-002** | Cierre de proyecto: coherencia de totales y saldo (véase detalle MF-002 en requisitos).                                      |
| **MF-011** | Cliente, impuestos, términos desde maestros.                                                                                 |


**Nota (MVP)**: Puede implementarse primero **factura de periodo manual** (líneas añadidas a mano + fee) con **saldo prefactura** visible y reglas MF-008; ampliar después US-002–US-005 (auto desde tareas/horas/hitos).

---

### Alcance

- **Incluye**: Selección de proyecto y periodo; generación de líneas desde **tareas**, **horas**, **hitos** y/o **fee mensual**; combinación de tipos en una misma factura de periodo; **prevención de doble facturación**; **trazabilidad** y listados por proyecto/periodo; prerrelleno de cliente; **vista de facturación en proyecto** (totales, periodos, **saldo prefactura**); validación de publicación contra **saldo de cupo** (con MF-008).
- **Excluye**: Facturación 100 % automática sin revisión del usuario; pasarela de pago (**MF-004**/**MF-009**); lógica interna del motor de cupo (**MF-008**, salvo contratos/API compartidos).

---

## Historias de usuario (índice)


| ID            | Título                                                                                    | Estado   | Prioridad |
| ------------- | ----------------------------------------------------------------------------------------- | -------- | --------- |
| MF-007-US-001 | Facturación mensual: seleccionar proyecto y periodo (mes) a facturar                      | Definida | Alta      |
| MF-007-US-002 | Generar líneas desde tareas realizadas en el periodo (no facturadas previamente)          | Definida | Alta      |
| MF-007-US-003 | Generar líneas desde horas registradas facturables en el periodo (no facturadas)          | Definida | Alta      |
| MF-007-US-004 | Generar líneas desde hitos completados en el periodo (no facturados previamente)          | Definida | Alta      |
| MF-007-US-005 | Facturación por fee mensual: importe fijo por mes asociado al proyecto                    | Definida | Alta      |
| MF-007-US-006 | Prevención doble facturación: marcar tareas/horas/hitos/periodos como facturados; alertas | Definida | Alta      |
| MF-007-US-007 | Trazabilidad factura → proyecto; listado de facturas por proyecto y por periodo           | Definida | Alta      |
| MF-007-US-008 | Prerellenar cliente/contacto de facturación desde proyecto                                | Definida | Alta      |
| MF-007-US-009 | Vista en proyecto: total facturado, pendiente por periodo, facturas, saldo prefactura     | Definida | Alta      |


**Orden sugerido de implementación (referencia)**: US-008 (cliente) y US-001 (selector periodo) + cabecera `proyecto_id`/`periodo_facturado`; US-006 (reglas anti-duplicado) en paralelo al núcleo; US-002–US-005 según prioridad de negocio (MVP: US-005 + manual); US-007 y US-009 para vistas y listados; publicación siempre coordinada con **MF-008**.

**Tareas de desarrollo**: [TAREAS-MF-007-FACTURACION-DESDE-PROYECTO.md](./TAREAS-MF-007-FACTURACION-DESDE-PROYECTO.md).

> Detalle de cada US en carpeta `/stories`

