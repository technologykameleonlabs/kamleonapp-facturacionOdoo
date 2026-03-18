# MF-011-US-004 — Configuración empresa: nombre, NIF, logo para PDF

**Epic**: MF-011 — Maestros

**Como** administrador, **quiero** configurar los datos de la empresa emisora (nombre legal, NIF, dirección, logo), **para** que se muestren correctamente en el encabezado o pie de las facturas y notas de crédito en PDF (MF-006).

**Criterios de aceptación**: Existe una pantalla o sección de configuración donde se pueden editar nombre legal, NIF, dirección y logo (URL o subida de archivo); los datos se persisten y están disponibles para el generador de PDF; si no hay multi-empresa, una única configuración por defecto.

### Campos de datos

| Campo         | Descripción                                          | Tipo               |
|---------------|------------------------------------------------------|--------------------|
| nombre_legal   | Nombre legal de la empresa que aparece en el PDF    | Texto corto        |
| nif           | NIF/CIF de la empresa emisora                       | Texto corto        |
| direccion     | Dirección fiscal de la empresa                     | Texto largo        |
| logo_url      | Ruta o URL del logo a usar en cabecera del PDF     | Texto (URL / ruta) |

*Nota*: En entornos multi-empresa, asociar esta configuración a cada empresa (empresa_id). En alcance mínimo, una sola configuración global.

### Estimación de esfuerzo (con IA)

- Modelo y migración (o extensión de entidad empresa): **0,25 días**.
- API de lectura y actualización de configuración: **0,25 días**.
- Pantalla de edición (formulario con nombre, NIF, dirección, logo): **0,25 días**.
- Total estimado para esta US: **~0,75 días** de desarrollo efectivo.

**Prioridad**: Alta
