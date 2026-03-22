# MF-003-US-011 — Tipos documentales: prefactura/proforma vs factura fiscal; series y numeración condicionada

**Epic**: MF-003 — Facturación núcleo  
**Relacionado con**: MF-001 (prefactura en activación), MF-008 (cupo aplicable)

**Como** responsable de facturación, **quiero** que el sistema distinga el **tipo documental** de la prefactura generada en activación (proforma sin numeración fiscal vs factura fiscal con serie), **para** cumplir la decisión legal/contable y no asignar números fiscales donde no correspondan.

**Criterios de aceptación**:
- Existe configuración o metadato **`tipo_documental`** (o equivalente) en cabecera de documento con al menos: `factura_ordinaria`, `anticipo`, **`prefactura_proforma`**, **`prefactura_fiscal`** (nombres ajustables al modelo Odoo).
- **Rama A — Prefactura proforma / no fiscal**:
  - Al crear documento desde MF-001 con esta opción: **no** se consume correlativo de serie fiscal obligatoria; puede usarse prefijo interno (ej. `PRE-…`) o sin número hasta conversión.
  - El documento puede permanecer en estado que no implique asiento fiscal definitivo (según integración contable).
- **Rama B — Prefactura como factura fiscal**:
  - Al publicar: se asigna **número definitivo** de la **serie** configurada para ese tipo (MF-003-US-006).
  - Misma moneda, cliente e impuestos que una factura ordinaria según normativa.
- Los listados y filtros permiten distinguir prefactura/proforma de facturas de periodo.
- Hasta que negocio **cierre la decisión fiscal**, el sistema puede exponer parámetro de módulo o configuración por empresa para elegir A o B (documentado en MF-001).

### Campos de datos

| Campo | Descripción | Tipo |
|-------|-------------|------|
| factura.tipo_documental | Clasificación del documento | Enumerado |
| factura.serie_id | Serie aplicada al publicar (si fiscal) | Relación (FK) |
| factura.proyecto_id | Proyecto asociado (prefactura MF-001) | Relación (FK) |

### Estimación de esfuerzo (con IA)

- Modelo + reglas de numeración condicionada: **0,35–0,5 días**.
- UI/configuración y pruebas por rama: **0,25–0,35 días**.
- Total estimado: **~0,6–0,85 días**.

**Prioridad**: Alta (bloqueante para cerrar MF-001 en Odoo según opción fiscal)
