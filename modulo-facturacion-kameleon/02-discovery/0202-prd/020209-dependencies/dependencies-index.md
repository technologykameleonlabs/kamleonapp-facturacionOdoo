# Dependencias — Módulo de facturación

## Dependencias de entrada (el módulo requiere)

- **Contrato firmado** (o criterio de negocio) y datos del presupuesto/proyecto para activación (MF-001); opcional para factura de anticipo.
- **Evento de cierre del proyecto** (última entrega aceptada o "listo para cerrar") para factura de cierre (MF-002).
- **Datos de cliente** (nombre, NIF, dirección, etc.) para generación de facturas.
- **Presupuesto/proyecto** con importe total (o total acordado) para calcular saldo pendiente de facturar en MF-002.

## Dependencias de salida (otros módulos usan)

- **Estado de proyecto “Activo”** y fecha de activación (MF-001) → usados por producción, calendario, etc.
- **Estado de pago “Recibido”** de la factura de cierre (MF-002), cuando existe, → condición para cierre formal de proyecto.
- **Facturas registradas** → reportes, contabilidad, integración Odoo (si aplica).

## Referencia

En la guía: EP-010 y EP-022 dependen de EP-009 (contrato firmado) y EP-021 (segunda entrega aceptada) respectivamente.
