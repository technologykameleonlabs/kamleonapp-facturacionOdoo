# EP-012 — Registro de tiempo por proyecto

**Descripción:** Captura facilitada del tiempo empleado por el responsable del proyecto, con desglose por fase (planificación, rodaje, edición), comparación automática con tiempo presupuestado y alertas cuando el tiempo real supera el presupuestado.

**Proceso TO-BE origen:** TO-BE-012: Proceso de registro de tiempo por proyecto

**Bloque funcional:** Registro facilitado con desglose — Desde activación del proyecto hasta cierre, registro continuo de tiempo empleado.

**Objetivo de negocio:** Facilitar el registro de tiempo empleado, permitir desglose por fase, comparar automáticamente con tiempo presupuestado y alertar cuando se supere para mejorar el control de rentabilidad (EP-014).

**Alcance y exclusiones:**
- **Incluye:**
  - Formulario rápido de registro de tiempo con campos predefinidos, accesible desde dashboard del proyecto.
  - Registro por sesión: selección de fase (planificación, rodaje, edición), tiempo empleado (horas, minutos), notas opcionales.
  - Cálculo automático: tiempo total por fase, tiempo total del proyecto.
  - Comparación automática con tiempo presupuestado y diferencia (positiva o negativa).
  - Alertas cuando tiempo real supera presupuestado o se acerca al límite; notificación a CEO si aplica.
  - Revisión de tiempo registrado por CEO en dashboard.
- **Excluye:**
  - Activación del proyecto (EP-010).
  - Control de rentabilidad en tiempo real (EP-014) — consume los datos de tiempo.
  - Gestión de recursos y gastos (EP-013).

**KPIs (éxito):**
- 100% de tiempo empleado registrado por fase.
- Comparación automática con tiempo presupuestado.
- Alertas cuando tiempo real supera presupuestado.
- Tiempo de registro < 2 minutos por sesión.

**Actores y permisos (RBAC):**
- **Responsable del proyecto:** Registrar tiempo empleado desde dashboard.
- **Sistema centralizado:** Calcular totales, comparar con presupuestado, mostrar alertas, notificar.
- **CEO (Javi):** Revisar tiempo registrado en dashboard.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-012-registro-tiempo-proyecto.md`
- Pasos: 1–9 del flujo principal.

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-012-US-001 | Acceso al formulario de registro de tiempo desde dashboard | Como responsable del proyecto, quiero acceder al formulario de registro de tiempo desde el dashboard del proyecto con campos predefinidos, para registrar el tiempo empleado en menos de 2 minutos por sesión | Definida | Alta |
| EP-012-US-002 | Registro de tiempo por fase con horas y notas | Como responsable del proyecto, quiero registrar el tiempo empleado seleccionando fase (planificación, rodaje, edición), ingresando horas y minutos y añadiendo notas opcionales, para tener desglose por fase y contexto | Definida | Alta |
| EP-012-US-003 | Cálculo automático de tiempo total por fase y proyecto | Como sistema centralizado, quiero calcular automáticamente el tiempo total por fase y el tiempo total del proyecto a partir de los registros guardados, para tener visibilidad actualizada sin cálculos manuales | Definida | Alta |
| EP-012-US-004 | Comparación automática con tiempo presupuestado | Como sistema centralizado, quiero comparar automáticamente el tiempo real registrado con el tiempo presupuestado y mostrar la diferencia (positiva o negativa), para que el responsable y el CEO vean si el proyecto va dentro de margen | Definida | Alta |
| EP-012-US-005 | Alertas cuando tiempo supera presupuestado y revisión CEO | Como sistema centralizado, quiero mostrar alertas cuando el tiempo real supere el presupuestado o se acerque al límite, y notificar al CEO si aplica; y como CEO, quiero revisar el tiempo registrado por fase y proyecto en el dashboard, para detectar desvíos y tomar decisiones | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Fases:** Planificación, Rodaje, Edición.
- **Registro de tiempo:** proyecto_id, fase, horas, minutos, notas opcionales, timestamp, usuario.
- **Tiempo presupuestado:** definido en presupuesto por fase o total.

### Reglas de numeración/ID específicas
- Registro vinculado por proyecto_id y timestamp de sesión.
