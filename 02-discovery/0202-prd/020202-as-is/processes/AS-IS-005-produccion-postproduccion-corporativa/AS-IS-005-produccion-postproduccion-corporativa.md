---
id: AS-IS-005
name: Producción y postproducción corporativa
slug: produccion-postproduccion-corporativa
status: READY
owner: Kameleonlabs@Kameleonlabs
product: ONGAKU
release: v1.0.0
locale: es-ES
gen_by: ASIS-PROMPT
hash: asis005_produccion_corporativa_20260120
---

# Producción y postproducción corporativa

## 1. Descripción (AS-IS)

- **Propósito:** Gestionar la ejecución completa del proyecto corporativo desde la activación (tras primer pago) hasta tener el material listo para la primera entrega, incluyendo planificación, grabación/rodaje, edición y postproducción.
- **Frecuencia:** Por proyecto (desde activación hasta entrega)
- **Actores/roles:** 
  - Responsable del proyecto (asignado)
  - CEO (Javi) - revisión y aprobación
  - Administración - presupuesto y tiempo
  - Equipo de producción (filmmakers, fotógrafos, gaffers, etc.)
- **Herramientas actuales:** 
  - Reuniones internas
  - Google Calendar (fechas inicio/fin, con problemas)
  - Procesos manuales de registro de tiempo
  - Herramientas de edición/postproducción
  - Frame.io (para visualización, mencionado en entregas)
  - Holded (referencia para visualización rentabilidad)
- **Entradas → Salidas:** 
  - **Entradas**: Proyecto activado, presupuesto, tiempo disponible, necesidades de grabación
  - **Salidas**: Material grabado, material editado/postproducido listo para primera entrega, control de rentabilidad, material aprovechable para RRSS

## 2. Flujo actual paso a paso

1) Reunión interna para valorar proyecto (respuesta en 3 días)
2) Asignación de responsable del proyecto
3) Responsable genera propuesta con idea y referencias visuales
4) Administración concreta presupuesto y tiempo disponible, comunica al responsable
5) Se genera automáticamente en Google Calendar fecha de inicio y fecha fin
6) Responsable registra tiempo empleado durante ejecución
7) Responsable informa al CEO cuando trabajo está listo para revisión
8) CEO da indicaciones (registradas en sistema)
9) Responsable recibe observaciones, realiza ajustes y vuelve a dar aviso
10) Si recibe luz verde, habilita galería/plataforma para que cliente vea propuesta y presupuesto
11) Al recibir pago del 50%, se activa fase de ejecución
12) Se señalan pasos a dar, quién los ejecuta y fecha prevista para cada uno
13) Sistema se actualiza conforme se van consiguiendo ítems
14) Gestión de recursos: iluminación con gaffer, alquiler de equipos, casting, localización, alquiler de coches, reserva de hotel, compra de billetes
15) Visualización de ingresos previstos vs gastos finales (estilo Holded)
16) Registro de material aprovechable para RRSS (en primera entrega, material fresco)
17) Grabación/rodaje del proyecto
18) Edición/postproducción corporativa
19) Material listo para primera entrega

## 3. Problemas observados (desde entrevistas/notas. No te limites, registra cualquier problema detectado, empezando por los más relevantes, pero siempre dentro del proceso correspondiente)

- **P1**: Falta de visibilidad de rentabilidad en tiempo real - no se puede ver ingresos vs gastos durante ejecución, solo al final _(Fuente: minute-01.md Sección 3)_
- **P2**: Registro manual de tiempos - responsable debe registrar tiempo empleado manualmente, propenso a olvidos _(Fuente: minute-01.md Sección 3)_
- **P3**: Falta de trazabilidad de recursos - gestión de recursos (iluminación, casting, alquileres, viajes) no está centralizada _(Fuente: minute-01.md Sección 3)_
- **P4**: Google Calendar con problemas - generación automática de fechas puede tener errores de sincronización _(Fuente: minute-01.md Sección 3)_
- **P5**: Control de rentabilidad limitado - aunque ONGAKU no trabaja por horas, es fundamental conocer tiempo real vs presupuestado pero no hay sistema claro _(Fuente: minute-01.md Sección 2)_
- **P6**: Material para RRSS se registra tarde - se rellena en primera entrega cuando material está fresco, pero puede olvidarse _(Fuente: minute-01.md Sección 3)_

## 4. Oportunidades de mejora (sin diseñar solución. No te limites, registra cualquier oportunidad detectada, empezando por las más relevantes, pero siempre dentro del proceso correspondiente)

- **O1** (derivada de P1): Visualización en tiempo real de rentabilidad: ingresos previstos vs gastos actuales (estilo Holded)
- **O2** (derivada de P2): Sistema de registro automático o facilitado de tiempo empleado por proyecto
- **O3** (derivada de P3): Centralización de gestión de recursos con elementos predeterminados (iluminación, casting, alquileres, viajes) pero posibilidad de añadir otros
- **O4** (derivada de P5): Métricas de rentabilidad: horas necesarias para éxito, umbral de rentabilidad, tiempo real vs presupuestado
- **O5** (derivada de P6): Registro temprano de material aprovechable para RRSS durante producción, no solo en entrega
- **O6** (derivada de P4): Integración correcta con Google Calendar para fechas de inicio y fin sin errores
- **O7**: Seguimiento visual de avances: pasos, responsables, fechas, estado de cada ítem
- **O8**: Notificaciones automáticas cuando trabajo está listo para revisión, cuando se reciben indicaciones, cuando se habilita galería

## 5. Artefactos y datos manipulados

- **Proyecto**: responsable asignado, presupuesto, tiempo disponible, fecha inicio, fecha fin, estado
- **Tiempo empleado**: registro por responsable, tiempo real vs presupuestado
- **Recursos**: iluminación, equipos (alquiler), casting, localización, transporte (alquiler coches, billetes), alojamiento (hotel), otros
- **Gastos**: registro de gastos por recurso, total gastos vs ingresos previstos
- **Material en bruto**: grabaciones, fotografías
- **Material editado**: versión lista para primera entrega
- **Material RRSS**: registro de ideas/matices aprovechables para redes sociales
- **Retención/auditoría**: Registro completo de tiempos, gastos, decisiones, material generado

## 6. Indicadores actuales (si existen)

- **Métrica**: Tiempo real vs tiempo presupuestado · **hoy**: Registrado manualmente, no siempre · Origen: Registro manual del responsable
- **Métrica**: Rentabilidad del proyecto (ingresos vs gastos) · **hoy**: Visualizado al final, no en tiempo real · Origen: Cálculo manual o referencia Holded
- **Métrica**: Tiempo desde activación hasta material listo · **hoy**: Variable según proyecto · Origen: No medido sistemáticamente

## 7. Consideraciones de accesibilidad e inclusión (si aplica)

- Sistema de registro debe ser accesible para todo el equipo
- Visualización de rentabilidad debe ser clara y comprensible
- Notificaciones deben llegar a todos los responsables

## 8. Observaciones del cliente

- Control de rentabilidad es fundamental aunque no se trabaje por horas
- Necesidad de visibilidad en tiempo real de gastos vs ingresos
- Importancia de registrar material para RRSS cuando está fresco

---

**Fuentes**: minute-01.md (Corporativo §3), company-info.md (Proceso Interno Corporativo, Fase 4: Ejecución)  
*GEN-BY:ASIS-PROMPT · hash:asis005_produccion_corporativa_20260120 · 2026-01-20T00:00:00Z*
