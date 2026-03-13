# EP-024 — Cierre automático de proyecto

**Descripción:** Cierre automático del proyecto cuando se cumplen condiciones (pago final recibido y segunda entrega aceptada), actualización de estado, archivo de documentación, registro de satisfacción del cliente (feedback si aplica) y generación de reporte final.

**Proceso TO-BE origen:** TO-BE-024: Proceso de cierre automático de proyecto

**Bloque funcional:** Cierre y archivo estructurado — Desde pago final recibido hasta proyecto cerrado y archivado.

**Objetivo de negocio:** Cerrar automáticamente los proyectos cuando se cumplen condiciones, archivar documentación y generar reporte final para EP-025 (almacenamiento archivos).

**Alcance y exclusiones:**
- **Incluye:**
  - Detección de condiciones de cierre: pago final recibido (EP-022) y segunda entrega aceptada (EP-021); feedback recibido (opcional, EP-023).
  - Cierre automático: actualización de estado del proyecto a "Cerrado"; archivo de documentación del proyecto; registro de satisfacción (feedback si aplica); generación de reporte final.
  - Notificación al equipo de proyecto y al cliente de cierre; notificación a administración con reporte final.
- **Excluye:**
  - Generación factura final (EP-022); solicitud feedback (EP-023).
  - Almacenamiento automático de archivos (EP-025) — se ejecuta tras cierre.

**KPIs (éxito):**
- 100% de proyectos cerrados automáticamente cuando se cumplen condiciones.
- Documentación archivada completamente; satisfacción del cliente registrada; reporte final generado.
- Tiempo de cierre < 5 minutos.

**Actores y permisos (RBAC):**
- **Sistema centralizado:** Cerrar proyecto automáticamente, archivar documentación, generar reporte final.
- **Equipo de proyecto:** Recibir notificación de cierre.
- **Cliente:** Recibir confirmación de cierre.
- **Administración:** Recibir reporte final.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-024-cierre-automatico-proyecto.md`

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-024-US-001 | Detección de condiciones de cierre (pago final y segunda entrega aceptada) | Como sistema centralizado, quiero detectar cuando se cumplen las condiciones de cierre (pago final recibido EP-022 y segunda entrega aceptada EP-021; feedback opcional EP-023), para ejecutar cierre automático | Definida | Alta |
| EP-024-US-002 | Cierre automático y actualización de estado a Cerrado | Como sistema centralizado, quiero cerrar automáticamente el proyecto y actualizar el estado a "Cerrado" cuando se cumplen las condiciones, para que el proyecto quede cerrado sin intervención manual | Definida | Alta |
| EP-024-US-003 | Archivo de documentación del proyecto | Como sistema centralizado, quiero archivar la documentación del proyecto (contrato, presupuesto, facturas, entregas, comentarios, feedback) de forma estructurada, para EP-025 y consultas | Definida | Alta |
| EP-024-US-004 | Generación de reporte final y notificaciones | Como sistema centralizado, quiero generar el reporte final del proyecto y notificar al equipo de proyecto, al cliente y a administración (con reporte final), para que todas las partes tengan constancia del cierre | Definida | Alta |
| EP-024-US-005 | Registro de satisfacción (feedback) en cierre | Como sistema centralizado, quiero registrar la satisfacción del cliente (feedback recibido EP-023 si aplica) en el cierre del proyecto, para reportes y mejora continua | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`
