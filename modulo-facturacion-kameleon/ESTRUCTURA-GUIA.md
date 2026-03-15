# Estructura guía — Relación con el paquete de referencia

Este paquete (**módulo de facturación Kameleon App**) replica la estructura del paquete de referencia (`kamleonapp-facturacionOdoo`) para usarla como **guía de implementación**. Aquí solo se desarrollan los requisitos y artefactos relativos al **módulo de facturación**.

## Mapeo de estructura

| Carpeta / documento | En el paquete de referencia | En este paquete (módulo facturación) |
|--------------------|----------------------------|---------------------------------------|
| `01-lead/` | Brief del proyecto ONGAKU | Brief del módulo de facturación para Kameleon App |
| `02-discovery/0202-prd/020201-context` | Contexto cliente (ONGAKU) | Contexto del módulo y de Kameleon App |
| `02-discovery/0202-prd/020202-as-is` | 9 procesos AS-IS | Procesos AS-IS de facturación (proforma, final, pagos) |
| `02-discovery/0202-prd/020203-to-be` | 27 procesos TO-BE | Procesos TO-BE de facturación (subconjunto) |
| `02-discovery/0202-prd/020204-scope` | SCOPE.md (27 procesos) | SCOPE.md solo procesos de facturación |
| `02-discovery/0202-prd/020205-functional-requirements` | 27 épicas, 133 US | Épicas e historias de usuario del módulo facturación |
| `02-discovery/0202-prd/020206..0211` | NFR, constraints, etc. | Adaptados al módulo facturación |
| `03-poc/` | SQL, seeds, frontend | POC de datos e integración del módulo facturación |

## Procesos y épicas de referencia usados como guía

Del paquete de referencia se usan explícitamente como guía:

- **TO-BE-010 — Activación automática de proyectos**  
  → Activación por contrato firmado o manual; opcional factura de anticipo.  
  → En este paquete: procesos y épicas de **activación de proyecto**.

- **TO-BE-022 — Generación automática de factura final**  
  → Factura de cierre por saldo pendiente, notificación, registro de pago.  
  → En este paquete: procesos y épicas de **factura de cierre y registro de pago**.

Las historias de usuario de este paquete se numeran de forma **independiente** (por ejemplo MF-001, MF-002 para “Módulo Facturación”) o se mantiene prefijo EP-0XX si se desea trazabilidad 1:1 con la guía.

## Cómo usar esta estructura

1. **Mantener la misma jerarquía** de carpetas que en el paquete de referencia.
2. **Completar solo lo relativo a facturación**: contexto, AS-IS/TO-BE, scope, épicas e historias de usuario del módulo.
3. **Referenciar la guía** en cada documento cuando corresponda (p. ej. “Basado en EP-010 / TO-BE-010 del paquete de referencia”).
4. **03-poc**: usar para esquemas SQL, contratos de API o maquetas de UI del módulo de facturación.

---

*Documento de trazabilidad estructura · modulo-facturacion-kameleon*
