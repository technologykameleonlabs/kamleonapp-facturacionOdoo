# MF-011-US-002 — Maestro Impuestos (nombre, %, incluido/no incluido; exenciones)

**Epic**: MF-011 — Maestros

**Como** administrador, **quiero** mantener un maestro de impuestos (nombre, porcentaje, tipo: incluido o no incluido en precio), **para** aplicarlos en las líneas de factura y que los totales se calculen correctamente.

**Criterios de aceptación**: CRUD de impuestos; porcentaje y tipo (incluido/no incluido); opcional: exenciones; disponibles al añadir línea de factura.

### Campos de datos

| Campo          | Descripción                                                          | Tipo               |
|----------------|----------------------------------------------------------------------|--------------------|
| nombre         | Nombre del impuesto (IVA 21%, IGIC 7%, etc.)                         | Texto corto        |
| porcentaje     | Porcentaje aplicable del impuesto                                   | Numérico (decimal) |
| tipo_calculo   | Cómo se aplica: incluido en precio o no incluido                    | Enumerado          |
| codigo_externo | Código opcional para integración contable / fiscal                  | Texto corto        |
| es_retencion   | Marca si el impuesto es una retención en vez de un impuesto al uso  | Booleano           |
| activo         | Indica si se puede usar en nuevas facturas                          | Booleano           |

### Estimación de esfuerzo (con IA)

- Diseño de entidad y migración inicial: **0,25 días**.
- API/servicio CRUD con validaciones de rango (%): **0,5 días**.
- Pantallas de alta/edición/listado con filtros por nombre/estado: **0,5 días**.
- Total estimado para esta US con ayuda de IA: **~1,25 días** de desarrollo efectivo.

**Prioridad**: Alta
