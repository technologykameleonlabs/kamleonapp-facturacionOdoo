# EP-014 — Control de rentabilidad en tiempo real

**Descripción:** Visualización continua de ingresos previstos vs gastos actuales por proyecto, comparación de tiempo empleado vs presupuestado, alertas cuando se supera umbral de rentabilidad y métricas de éxito del proyecto en dashboard estilo Holded.

**Proceso TO-BE origen:** TO-BE-014: Proceso de control de rentabilidad en tiempo real

**Bloque funcional:** Visualización continua — Desde activación del proyecto hasta cierre, visualización continua de rentabilidad.

**Objetivo de negocio:** Dar visibilidad en tiempo real de rentabilidad (ingresos vs gastos, tiempo vs presupuestado), alertar cuando se supere umbral y permitir decisiones correctivas.

**Alcance y exclusiones:**
- **Incluye:**
  - Cálculo automático de rentabilidad en tiempo real: ingresos previstos (presupuesto), gastos actuales (EP-013), tiempo empleado vs presupuestado (EP-012), rentabilidad actual (ingresos - gastos).
  - Visualización en dashboard estilo Holded: gráfico ingresos vs gastos, indicador de rentabilidad (positiva/negativa), progreso del proyecto, métricas de éxito.
  - Evaluación de umbral configurable; alertas cuando gastos o tiempo superan umbral; notificación a CEO.
  - Actualización automática cada vez que se registra tiempo (EP-012) o gasto (EP-013).
  - Revisión por CEO: rentabilidad de todos los proyectos, comparación entre proyectos, análisis de tendencias.
- **Excluye:**
  - Registro de tiempo (EP-012) y registro de gastos (EP-013).
  - Activación del proyecto (EP-010).

**KPIs (éxito):**
- 100% de proyectos con visibilidad de rentabilidad en tiempo real.
- Alertas automáticas cuando se supera umbral.
- Métricas de éxito del proyecto visibles.
- Tiempo de actualización < 1 minuto.

**Actores y permisos (RBAC):**
- **Sistema centralizado:** Calcular rentabilidad, visualizar, evaluar umbral, notificar.
- **CEO (Javi):** Revisar rentabilidad de todos los proyectos; tomar decisiones.
- **Responsable del proyecto:** Ver rentabilidad de su proyecto.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-014-control-rentabilidad-tiempo-real.md`
- Pasos: 1–9 del flujo principal.

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-014-US-001 | Cálculo automático de rentabilidad en tiempo real | Como sistema centralizado, quiero calcular automáticamente la rentabilidad en tiempo real (ingresos previstos del presupuesto, gastos actuales de EP-013, tiempo empleado vs presupuestado de EP-012, rentabilidad = ingresos - gastos), para tener datos siempre actualizados | Definida | Alta |
| EP-014-US-002 | Visualización rentabilidad en dashboard estilo Holded | Como CEO o responsable del proyecto, quiero ver la rentabilidad en un dashboard con gráfico de ingresos vs gastos (estilo Holded), para tener visibilidad clara de la situación del proyecto | Definida | Alta |
| EP-014-US-003 | Indicador de rentabilidad y progreso del proyecto | Como CEO o responsable, quiero ver un indicador de rentabilidad (positiva/negativa) y el progreso del proyecto en el dashboard, para evaluar rápidamente el estado | Definida | Alta |
| EP-014-US-004 | Evaluación de umbral y alertas cuando se supera | Como sistema centralizado, quiero evaluar si la rentabilidad o los gastos/tiempo superan un umbral configurable y mostrar alertas visuales en el dashboard, para que se detecten desvíos a tiempo | Definida | Alta |
| EP-014-US-005 | Notificación a CEO cuando rentabilidad supera umbral | Como sistema centralizado, quiero notificar automáticamente al CEO cuando la rentabilidad sea negativa o se supere el umbral configurado, para que pueda tomar decisiones correctivas | Definida | Alta |
| EP-014-US-006 | Actualización automática al registrar tiempo o gasto | Como sistema centralizado, quiero actualizar automáticamente la visualización de rentabilidad cada vez que se registre tiempo (EP-012) o gasto (EP-013), para que el dashboard esté siempre actualizado en tiempo real | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Rentabilidad actual:** Ingresos previstos - Gastos actuales.
- **Umbral:** Configurable por proyecto o global; dispara alerta cuando se supera.
- **Métricas de éxito:** Rentabilidad, tiempo vs presupuestado, progreso.

### Reglas de numeración/ID específicas
- Rentabilidad vinculada por proyecto_id; datos de EP-012 y EP-013.
