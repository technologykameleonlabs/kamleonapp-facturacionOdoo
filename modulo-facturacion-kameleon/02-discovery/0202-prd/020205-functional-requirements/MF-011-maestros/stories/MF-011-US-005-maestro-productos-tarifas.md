# MF-011-US-005 — Maestro Productos/tarifas y unidades de medida (opcional)

**Epic**: MF-011 — Maestros

**Como** usuario de facturación, **quiero** mantener un catálogo de productos o servicios con descripción, unidad de medida y precio e impuesto por defecto, **para** al añadir una línea en la factura poder elegir un producto y que se rellenen automáticamente descripción, precio unitario e impuesto, reduciendo errores y tiempo de carga.

**Criterios de aceptación**: CRUD de productos/tarifas; campos: nombre/descripción, unidad de medida (hora, unidad, servicio, etc.), precio unitario por defecto, impuesto por defecto (desde maestro MF-011-US-002); al añadir línea en factura (MF-003) se puede seleccionar un producto y se prerrellenan cantidad (editable), precio e impuesto; no eliminar producto si está en uso en líneas de factura, solo desactivar.

### Campos de datos

| Campo           | Descripción                                        | Tipo                      |
|-----------------|----------------------------------------------------|---------------------------|
| nombre          | Nombre del producto o servicio                    | Texto corto               |
| unidad_medida   | Unidad de medida (hora, unidad, servicio, etc.)   | Texto corto / Enumerado   |
| precio_unitario | Precio unitario por defecto                        | Numérico (decimal)        |
| impuesto_id     | Impuesto por defecto del producto                 | Relación (FK a impuesto)  |
| activo          | Indica si el producto se puede usar en nuevas líneas | Booleano              |

### Estimación de esfuerzo (con IA)

- Modelo, migración y API CRUD de productos: **0,5 días**.
- Pantallas de listado y formulario con selector de impuesto: **0,5 días**.
- Integración en pantalla de líneas de factura (selector de producto y prerrelleno): **0,25 días**.
- Total estimado para esta US: **~1,25 días** de desarrollo efectivo.

**Prioridad**: Media (opcional en alcance mínimo)
