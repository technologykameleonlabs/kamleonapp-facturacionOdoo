# MF-003-US-006 — Numeración fiscal: series por país/empresa, prefijos, control de huecos

**Epic**: MF-003 — Facturación núcleo

**Como** administrador o usuario con permisos de facturación, **quiero** que la facturación asigne números fiscales definitivos siguiendo series documentales configuradas, **para** cumplir requisitos fiscales y garantizar unicidad, orden y trazabilidad.

**Criterios de aceptación**: Existe configuración de series (nombre, prefijo, siguiente número y alcance) y al publicar se asigna el número fiscal de forma transaccional sin reutilización, respetando la política de huecos.

### Campos de datos

| Campo                           | Descripción                                                | Tipo |
|---------------------------------|------------------------------------------------------------|------|
| serie_documental.id            | Identificador de la serie                                 | Entero |
| serie_documental.nombre       | Nombre de la serie                                        | Texto |
| serie_documental.tipo         | Tipo (por ejemplo: Factura de cliente / NC)              | Enumerado |
| serie_documental.prefijo      | Prefijo del número                                        | Texto |
| serie_documental.siguiente_numero | Secuencia siguiente reservada/consumida            | Entero |
| serie_documental.ejercicio    | Ejercicio (si aplica)                                    | Texto/Entero |
| serie_documental.empresa_id   | Asociación a empresa (multi-empresa)                    | Relación (FK) |
| serie_documental.padding      | Longitud/format del padding (si aplica)                  | Entero |
| serie_documental.politica_huecos | Política ante huecos (impedir/alertar)               | Enumerado |
| factura.serie_id              | Serie usada por la factura al publicar                    | Relación (FK) |
| factura.numero                 | Número fiscal asignado                                     | Texto |

### Estimación de esfuerzo (con IA)

- Modelo/migración de series documentales + validaciones: **0,25 días**.
- Lógica de reserva transaccional y construcción de número: **0,25 días**.
- API/servicio de series (lectura/actualización si aplica): **0,15 días**.
- Integración con publicar (consumo de secuencia): **0,1 días**.
- Total estimado para esta US: **~0,75 días** de desarrollo efectivo.

**Prioridad**: Alta

