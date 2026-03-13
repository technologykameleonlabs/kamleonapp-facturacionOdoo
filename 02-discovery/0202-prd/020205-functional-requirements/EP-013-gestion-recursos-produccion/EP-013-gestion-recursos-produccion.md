# EP-013 — Gestión de recursos de producción

**Descripción:** Registro centralizado de recursos necesarios (iluminación, equipos, casting, localización, transporte, alojamiento), seguimiento de gastos en tiempo real e integración con control de rentabilidad (EP-014).

**Proceso TO-BE origen:** TO-BE-013: Proceso de gestión de recursos de producción

**Bloque funcional:** Registro centralizado de recursos — Desde activación del proyecto hasta cierre, registro y seguimiento de recursos y gastos.

**Objetivo de negocio:** Centralizar el registro de recursos y gastos, permitir elementos predeterminados y personalizados, y alimentar el control de rentabilidad en tiempo real.

**Alcance y exclusiones:**
- **Incluye:**
  - Formulario de recursos con elementos predeterminados (iluminación, equipos, casting, localización, transporte, alojamiento, otros) y posibilidad de añadir recursos personalizados.
  - Registro por recurso: tipo, detalles, costo/gasto, notas opcionales; guardado con timestamp y proyecto_id.
  - Cálculo automático: total de gastos por tipo, total de gastos del proyecto.
  - Integración con control de rentabilidad (EP-014).
  - Revisión de gastos por CEO en dashboard.
- **Excluye:**
  - Activación del proyecto (EP-010).
  - Control de rentabilidad en tiempo real (EP-014) — consume los gastos registrados.
  - Registro de tiempo (EP-012).

**KPIs (éxito):**
- 100% de recursos registrados centralizadamente.
- Seguimiento de gastos en tiempo real.
- Integración con control de rentabilidad.
- Tiempo de registro < 3 minutos por recurso.

**Actores y permisos (RBAC):**
- **Responsable del proyecto:** Registrar recursos y gastos desde dashboard.
- **Sistema centralizado:** Calcular totales, integrar con rentabilidad.
- **CEO (Javi):** Revisar gastos en dashboard.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-013-gestion-recursos-produccion.md`
- Pasos: 1–8 del flujo principal.

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-013-US-001 | Acceso al formulario de recursos desde dashboard | Como responsable del proyecto, quiero acceder al formulario de recursos desde el dashboard del proyecto con elementos predeterminados, para registrar recursos en menos de 3 minutos por recurso | Definida | Alta |
| EP-013-US-002 | Registro de recurso (tipo, detalles, costo) | Como responsable del proyecto, quiero registrar un recurso seleccionando tipo (iluminación, equipos, casting, localización, transporte, alojamiento, otros o personalizado), ingresando detalles y costo/gasto y añadiendo notas opcionales, para tener trazabilidad de gastos | Definida | Alta |
| EP-013-US-003 | Cálculo automático de total de gastos por tipo y proyecto | Como sistema centralizado, quiero calcular automáticamente el total de gastos por tipo de recurso y el total del proyecto a partir de los registros guardados, para tener visibilidad actualizada sin cálculos manuales | Definida | Alta |
| EP-013-US-004 | Integración con control de rentabilidad | Como sistema centralizado, quiero exponer los gastos registrados al control de rentabilidad (EP-014) para que ingresos vs gastos se calculen en tiempo real, para análisis de rentabilidad | Definida | Alta |
| EP-013-US-005 | Revisión de gastos por CEO en dashboard | Como CEO, quiero revisar los gastos del proyecto en el dashboard (gastos por tipo, total, comparación con presupuesto), para análisis de rentabilidad y toma de decisiones | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Tipos de recurso:** Iluminación, Equipos, Casting, Localización, Transporte, Alojamiento, Otros (personalizado).
- **Registro de recurso:** proyecto_id, tipo, detalles, costo/gasto, notas opcionales, timestamp, usuario.

### Reglas de numeración/ID específicas
- Registro vinculado por proyecto_id y timestamp.
