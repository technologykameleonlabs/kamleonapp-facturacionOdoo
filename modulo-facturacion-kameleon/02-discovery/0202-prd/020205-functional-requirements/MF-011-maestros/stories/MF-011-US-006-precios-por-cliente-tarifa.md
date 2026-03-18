# MF-011-US-006 — Precios por cliente o tarifa (opcional para líneas)

**Epic**: MF-011 — Maestros

**Como** usuario de facturación, **quiero** definir precios específicos por cliente o por tarifa para determinados productos, **para** que al añadir una línea de factura para ese cliente se sugiera o aplique automáticamente el precio acordado en lugar del precio base del producto.

**Criterios de aceptación**: Se pueden definir tarifas o reglas de precio por cliente (y opcionalmente por producto): precio unitario o descuento aplicable; al crear/editar línea de factura, si hay cliente y producto seleccionados, el sistema ofrece el precio de la tarifa/cliente si existe, si no el precio por defecto del producto; opcional: listado de tarifas por cliente o por producto para consulta y mantenimiento.

### Campos de datos

| Campo            | Descripción                                                | Tipo                        |
|------------------|------------------------------------------------------------|-----------------------------|
| cliente_id       | Cliente al que aplica la tarifa o precio especial          | Relación (FK a cliente)     |
| producto_id      | Producto al que aplica el precio (opcional: tarifa global por cliente) | Relación (FK a producto) |
| precio_unitario  | Precio unitario acordado para este cliente/producto       | Numérico (decimal)          |
| descuento_pct    | Alternativa: descuento porcentual sobre precio base        | Numérico (decimal, opcional)|
| vigente_desde    | Fecha desde la que aplica la tarifa                       | Fecha (opcional)            |
| vigente_hasta    | Fecha hasta la que aplica la tarifa                       | Fecha (opcional)            |

*Nota*: En alcance mínimo puede simplificarse a "precio por cliente y producto" sin fechas de vigencia. La prioridad es baja; puede implementarse en una fase posterior.

### Estimación de esfuerzo (con IA)

- Modelo y migración de tarifas/precios por cliente: **0,25 días**.
- API para consultar precio aplicable (cliente + producto) y CRUD de tarifas: **0,5 días**.
- Lógica en líneas de factura para sugerir precio según cliente/producto: **0,25 días**.
- Pantallas de mantenimiento de tarifas (opcional): **0,5 días**.
- Total estimado para esta US: **~1,5 días** de desarrollo efectivo.

**Prioridad**: Baja (opcional para líneas; fase posterior)
