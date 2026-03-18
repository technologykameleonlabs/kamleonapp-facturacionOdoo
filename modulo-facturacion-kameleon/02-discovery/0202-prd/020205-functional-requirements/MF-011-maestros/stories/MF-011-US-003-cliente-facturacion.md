# MF-011-US-003 — Cliente/contacto de facturación (extender o vincular cliente/área Kameleon)

**Epic**: MF-011 — Maestros

**Como** administrador o usuario de facturación, **quiero** mantener un maestro de clientes de facturación (o extender el cliente/contacto existente de Kameleon) con datos fiscales y término de pago por defecto, **para** asignarlos a las facturas y prerellenar datos al facturar desde proyecto (MF-007).

**Criterios de aceptación**: CRUD de cliente de facturación (o extensión de ficha cliente); campos mínimos: nombre, NIF/CIF, dirección fiscal, email, término de pago por defecto; cliente disponible al crear/editar factura y al vincular proyecto con cliente; NIF único si la normativa lo exige.

### Campos de datos

| Campo            | Descripción                                              | Tipo                      |
|------------------|----------------------------------------------------------|---------------------------|
| nombre           | Razón social o nombre del cliente de facturación        | Texto corto               |
| nif              | NIF/CIF u otro identificador fiscal                     | Texto corto               |
| direccion        | Dirección fiscal completa                               | Texto largo               |
| email            | Email de contacto para facturas y envío de PDF          | Texto (email)             |
| termino_pago_id  | Término de pago por defecto para este cliente           | Relación (FK a termino_pago) |
| activo           | Indica si el cliente se puede usar en nuevas facturas    | Booleano                  |

*Nota*: Si Kameleon ya dispone de entidad Cliente o Contacto, esta US puede consistir en extenderla con los campos de facturación (NIF, dirección fiscal, término de pago por defecto) y en vincularla al concepto "cliente del proyecto" para MF-007.

### Estimación de esfuerzo (con IA)

- Análisis de reutilización de entidad cliente/contacto existente: **0,25 días**.
- Modelo/migración o extensión + API CRUD: **0,5 días**.
- Pantallas de listado y formulario (o extensión de ficha cliente): **0,5 días**.
- Total estimado para esta US: **~1,25 días** de desarrollo efectivo.

**Prioridad**: Alta
