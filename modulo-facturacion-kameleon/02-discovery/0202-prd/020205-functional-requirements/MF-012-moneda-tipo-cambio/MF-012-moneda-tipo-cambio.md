# MF-012 — Moneda y tipo de cambio

**Fuente**: Gap 4 (Moneda y cambio).

**Descripción**: Facturas en moneda de curso legal y opcionalmente en otra moneda; tasa de cambio congelada al emitir la factura; impacto en cobros parciales y diferencias de cambio si aplica.

**Objetivo**: Soportar multi-moneda cuando el negocio lo requiera.

**Alcance**: Moneda de la factura; tipo de cambio al emitir; totales en moneda factura y en moneda base (si aplica). Excluye en v1: contabilidad de diferencias de cambio (fase posterior).

---

## Historias de usuario (índice)

| ID | Título | Prioridad |
|----|--------|-----------|
| MF-012-US-001 | Seleccionar moneda de la factura; moneda base de la empresa | Media |
| MF-012-US-002 | Tipo de cambio fijado al crear/publicar factura (tasa congelada) | Media |
| MF-012-US-003 | Mostrar importes en moneda factura y en moneda base en listados/detalle | Media |

> Detalle en carpeta `/stories`
