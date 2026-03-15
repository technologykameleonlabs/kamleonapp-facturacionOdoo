# MF-014 — Auditoría y trazabilidad

**Fuente**: Gap 11 (Auditoría).

**Descripción**: Log de cambios en facturas y cobros (quién, cuándo, qué); snapshot del PDF emitido (versión enviada); trazabilidad de emails enviados y de cobros aplicados.

**Objetivo**: Trazabilidad para auditoría y cumplimiento.

**Alcance**: Registro de cambios en factura (estado, importes, etc.); historial de envíos de email; registro de aplicaciones de pago; opcional: guardar copia del PDF en el momento de publicar/enviar. Excluye: auditoría a nivel de base de datos completa (se asume registro de auditoría existente en Kameleon).

---

## Historias de usuario (índice)

| ID | Título | Prioridad |
|----|--------|-----------|
| MF-014-US-001 | Log de cambios en factura (quién, cuándo, campo modificado) | Alta |
| MF-014-US-002 | Trazabilidad de envíos por email (destinatario, fecha, adjunto) | Alta |
| MF-014-US-003 | Trazabilidad de cobros aplicados (pago, factura, importe, fecha) | Alta |
| MF-014-US-004 | Snapshot del PDF emitido al publicar o al enviar (opcional) | Media |

> Detalle en carpeta `/stories`
