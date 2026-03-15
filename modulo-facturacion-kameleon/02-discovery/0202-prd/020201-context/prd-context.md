# Contexto — Módulo de facturación Kameleon App

**Análisis de fuentes**: Ver `analisis-modulo-finanzas-y-propuesta.md` (Revisión Módulo Finanzas HTML + Propuesta de desarrollo). Los requisitos funcionales se derivan de ese análisis.

## Producto

**Kameleon App**: aplicación de gestión operativa y comercial (proyectos, clientes, entregas, facturación). Este documento describe el contexto del **módulo de facturación** dentro de la app.

## Objetivo del módulo de facturación

- **Facturación de proyectos**: los proyectos se facturan **mensualmente** en función de lo realizado en cada periodo: **tareas realizadas**, **horas** registradas (facturables), **hitos** completados o **fee mensual**. Facturación por hito/horas/tareas/fee mensual; **prevención de doble facturación** (no facturar dos veces las mismas tareas, horas ni el mismo periodo/hito); **trazabilidad factura → proyecto** (MF-007).
- **Activación de proyecto**: el proyecto se activa por contrato firmado o manual; opcionalmente se puede registrar un anticipo y generar factura por ese importe (MF-001).
- **Factura de cierre**: al cierre del proyecto se genera una factura por el saldo pendiente de facturar (si lo hay); notificación al cliente y registro de pago para permitir el cierre formal (MF-002).
- **Trazabilidad**: registro de facturas y estados de pago asociados a proyectos; sin pasarela de pago integrada en scope inicial (pago gestionado fuera del sistema o por terceros).

## Actores

- **Sistema**: generación automática de facturas, notificaciones, registro de estados.
- **Administración**: confirmación de recepción de pagos, consulta de facturas y estados.
- **Cliente**: recepción de notificación y acceso/adjunto a factura; pago fuera del sistema.

## Relación con la guía

- Basado en el contexto de flujo comercial del paquete de referencia (ONGAKU/Kameleon): activación sin pago obligatorio; facturación mensual (MF-007) y factura de cierre por saldo pendiente (MF-002).
- Integración futura con módulo Finanzas de Odoo o otros sistemas según decisiones de producto.

---

*Completar con datos específicos de Kameleon App (entidad legal, monedas, series de facturación, etc.) cuando estén definidos.*
