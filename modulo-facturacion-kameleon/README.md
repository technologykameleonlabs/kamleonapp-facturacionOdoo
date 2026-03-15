# Módulo de facturación — Kameleon App

Requisitos e implementación del **módulo de facturación** para la aplicación Kameleon (KameleonLabs).

## Propósito

Este paquete contiene la definición de requisitos funcionales y no funcionales, procesos TO-BE y épicas/historias de usuario específicas del **módulo de facturación** de Kameleon App. La estructura sigue la del repositorio de referencia (`kamleonapp-facturacionOdoo`) para mantener coherencia y trazabilidad.

## Estructura (guía)

Se mantiene la misma estructura que el paquete de referencia:

```
modulo-facturacion-kameleon/
├── README.md                 (este archivo)
├── ESTRUCTURA-GUIA.md        (relación con la estructura de referencia)
├── 01-lead/                  Brief y contexto del módulo
├── 02-discovery/             PRD: contexto, AS-IS, TO-BE, alcance, requisitos
│   ├── 0201-interviews/
│   └── 0202-prd/
│       ├── 020201-context/
│       ├── 020202-as-is/
│       ├── 020203-to-be/
│       ├── 020204-scope/
│       ├── 020205-functional-requirements/
│       ├── 020206-non-functional-requirements/
│       ├── 020207-constraints/
│       ├── 020208-assumptions/
│       ├── 020209-dependencies/
│       ├── 020210-glossary/
│       └── 020211-open-questions/
└── 03-poc/                   POC de base de datos y/o integración
    ├── 0301-database/
    └── 0302-frontend/
```

## Alcance del módulo de facturación

- **Activación de proyecto**: por contrato firmado o manual; opcional factura de anticipo (equivalente TO-BE-010 / EP-010 del paquete de referencia).
- **Factura de cierre**: por saldo pendiente de facturar al cierre del proyecto, notificación y registro de pago (equivalente TO-BE-022 / EP-022 del paquete de referencia).
- **Estados de pago**, trazabilidad y posibles integraciones (Odoo, pasarelas, etc.) según decisiones de producto.

## Referencia

- **Estructura y guía**: repositorio raíz `kamleonapp-facturacionOdoo` (análisis funcional ONGAKU / Odoo).
- **Épicas de facturación en la guía**: EP-010 (activación + factura proforma), EP-022 (factura final).

---

*KameleonLabs · Módulo de facturación Kameleon App*
