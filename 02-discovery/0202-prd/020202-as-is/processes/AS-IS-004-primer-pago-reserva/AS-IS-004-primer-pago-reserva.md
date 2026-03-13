---
id: AS-IS-004
name: Primer pago y reserva de fecha (Corporativo y Bodas)
slug: primer-pago-reserva
status: READY
owner: Kameleonlabs@Kameleonlabs
product: ONGAKU
release: v1.0.0
locale: es-ES
gen_by: ASIS-PROMPT
hash: asis004_pago_reserva_20260120
---

# Primer pago y reserva de fecha (Corporativo y Bodas)

## 1. Descripción (AS-IS)

- **Propósito:** Gestionar el primer pago (50% del presupuesto), reservar/bloquear la fecha del proyecto/boda y activar la fase de ejecución/producción.
- **Frecuencia:** Periódica (tras firma de contrato)
- **Actores/roles:** 
  - **Corporativo**: Administración, cliente corporativo, responsable de proyecto
  - **Bodas**: Paz, administración, novios
- **Herramientas actuales:** 
  - Factura proforma (Corporativo)
  - Pasarela de pago (parcialmente implementada)
  - Email corporativo (justificantes de pago)
  - Cuenta bancaria: ES3300495457242516162711 (Banco Santander)
  - Google Calendar (reserva de fechas, con problemas)
- **Entradas → Salidas:** 
  - **Entradas**: Contrato firmado, datos de pago del cliente
  - **Salidas**: Pago recibido (50%), justificante de pago, fecha reservada/bloqueada, proyecto activado

## 2. Flujo actual paso a paso

### Para Corporativo:
1) Cliente firma contrato
2) Se genera factura proforma (50% del presupuesto)
3) En anverso de proforma pueden constar cláusulas de prestación del servicio
4) Cliente realiza pago mediante pasarela de pago
5) Se envía factura después de cada pago (si se usa proforma, se consolida con último pago)
6) Se concreta fecha, lugar y necesidades de grabación
7) Se activa fase de ejecución del proyecto
8) Cliente tiene acceso a panel para ver estado del proyecto

### Para Bodas:
1) Novios firman contrato
2) Reserva de fecha se hace efectiva mediante pago del 50%
3) Novios realizan pago (50% a la firma)
4) Justificante de pago se envía al email corporativo (info@ongakuagency.com)
5) Concepto: nombre novios y fecha de la boda
6) Fecha queda reservada/bloqueada
7) Pago restante (50%) se realiza hasta una semana antes de la boda

## 3. Problemas observados (desde entrevistas/notas. No te limite, registra cualquier problema detectado, empezando por los más relevantes, pero siempre dentro del proceso correspondiente)

- **P1**: Proceso manual de gestión de justificantes - justificantes enviados por email, requieren procesamiento manual _(Fuente: minute-01.md Sección 8, company-info.md)_
- **P2**: Falta de automatización en activación de proyecto - activación tras pago requiere intervención manual _(Fuente: minute-01.md Sección 3)_
- **P3**: Google Calendar con problemas - reserva de fechas puede tener errores de sincronización _(Fuente: minute-01.md Sección 6)_
- **P4**: Falta de visibilidad de estado de pago - no hay seguimiento automático de pagos pendientes o recibidos _(Fuente: minute-01.md)_
- **P5**: Proceso de facturación no completamente integrado - facturas se envían después de cada pago pero proceso no está automatizado _(Fuente: minute-01.md Sección 2)_

## 4. Oportunidades de mejora (sin diseñar solución. No te limites, registra cualquier oportunidad detectada, empezando por las más relevantes, pero siempre dentro del proceso correspondiente)

- **O1** (derivada de P1): Automatización de recepción y procesamiento de justificantes de pago
- **O2** (derivada de P2): Activación automática de proyecto/boda al recibir pago del 50%
- **O3** (derivada de P4): Panel de cliente con visibilidad de estado de pagos (pendiente, recibido, confirmado)
- **O4** (derivada de P5): Integración completa de facturación con pasarela de pago, generación automática de facturas
- **O5** (derivada de P3): Integración correcta con Google Calendar para reserva automática de fechas
- **O6**: Notificaciones automáticas: aviso cuando pago se recibe, aviso cuando fecha queda reservada, recordatorio de pago restante (bodas)
- **O7**: Portal de cliente para subir justificantes de pago y ver estado de facturación

## 5. Artefactos y datos manipulados

- **Pago**: monto (50% inicial), método de pago, fecha de pago, justificante, estado (pendiente/recibido/confirmado)
- **Factura proforma**: número, monto, fecha, cliente, concepto
- **Reserva de fecha**: fecha del proyecto/boda, estado (reservada/bloqueada), cliente/proyecto asociado
- **Justificante de pago**: archivo, fecha de recepción, validación
- **Retención/auditoría**: Registro de todos los pagos, justificantes archivados, trazabilidad de reservas de fecha

## 6. Indicadores actuales (si existen)

- **Métrica**: Tiempo desde firma contrato hasta primer pago · **hoy**: Variable, depende de cliente · Origen: No medido sistemáticamente
- **Métrica**: Tasa de pagos que requieren seguimiento manual · **hoy**: Todos requieren procesamiento manual · Origen: Observaciones del equipo
- **Métrica**: Tiempo de procesamiento de justificantes · **hoy**: Manual, variable · Origen: No medido

## 7. Consideraciones de accesibilidad e inclusión (si aplica)

- Pasarela de pago debe ser accesible (WCAG 2.1 AA)
- Proceso de pago debe ser claro y fácil de entender
- Soporte para múltiples métodos de pago

## 8. Observaciones del cliente

- Necesidad de automatización para reducir trabajo manual
- Importancia de visibilidad clara del estado de pagos para clientes
- Reserva de fecha debe ser automática al recibir pago

---

**Fuentes**: minute-01.md (Corporativo §2, Bodas §8), company-info.md (Fase 3: Contratación, Fase 4 Bodas: Pago y Reserva)  
*GEN-BY:ASIS-PROMPT · hash:asis004_pago_reserva_20260120 · 2026-01-20T00:00:00Z*
