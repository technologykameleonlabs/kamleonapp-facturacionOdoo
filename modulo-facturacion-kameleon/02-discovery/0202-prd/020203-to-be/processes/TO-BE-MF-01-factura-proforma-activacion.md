# Proceso TO-BE-MF-01: Activación de proyecto (sin pago obligatorio)

**Guía**: Basado en TO-BE-010 del paquete de referencia (Activación automática de proyectos).

**Propósito**: Activar el proyecto (estado "Activo") por contrato firmado, por acción manual del usuario o por regla configurable. Opcionalmente: registrar un anticipo/pago inicial (importe acordado) y generar factura por ese monto; reservar fecha en calendario; notificar a equipo y cliente.

**Scope**: Desde disparador de activación (manual o evento) hasta proyecto activado, opcional factura de anticipo generada, notificaciones enviadas y registro de activación.

**Actores**: Sistema (activación, opcional generación de factura de anticipo), Usuario/Administración (activar manualmente o registrar anticipo), Equipo y Cliente (notificaciones).

**Criterios de éxito**:
- Proyecto pasa a estado Activo sin requerir pago previo.
- Si se registra anticipo: factura generada por el importe acordado en < 2 minutos.
- Fecha de activación registrada; trazabilidad (proyecto ↔ factura de anticipo si existe).

**Salidas**: Proyecto en estado Activo; opcional factura de anticipo asociada; notificaciones a equipo y cliente; registro de activación.

---

*Documento TO-BE · modulo-facturacion-kameleon · Referencia: TO-BE-010*
