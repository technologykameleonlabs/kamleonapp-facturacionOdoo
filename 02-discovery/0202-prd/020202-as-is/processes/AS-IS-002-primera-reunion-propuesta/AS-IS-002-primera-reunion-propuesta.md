---
id: AS-IS-002
name: Primera reunión y propuesta/presupuesto (Corporativo y Bodas)
slug: primera-reunion-propuesta
status: READY
owner: Kameleonlabs@Kameleonlabs
product: ONGAKU
release: v1.0.0
locale: es-ES
gen_by: ASIS-PROMPT
hash: asis002_reunion_propuesta_20260120
---

# Primera reunión y propuesta/presupuesto (Corporativo y Bodas)

## 1. Descripción (AS-IS)

- **Propósito:** Coordinar reuniones iniciales con leads cualificados, entender sus necesidades, presentar servicios y generar propuestas/presupuestos personalizados para ambas líneas de negocio.
- **Frecuencia:** Periódica (según llegada de leads cualificados)
- **Actores/roles:** 
  - **Corporativo**: Fátima, Javi (CEO), equipo comercial
  - **Bodas**: Paz, Javi, Fátima (negociación presupuestos)
- **Herramientas actuales:** 
  - Google Calendar (con problemas de sincronización)
  - Google Meet (videollamadas)
  - Email (coordinación)
  - WhatsApp (coordinación rápida)
  - Oficina física (reuniones presenciales)
  - Procesos manuales de generación de propuestas/presupuestos
- **Entradas → Salidas:** 
  - **Entradas**: Lead cualificado, necesidades del cliente
  - **Salidas**: Reunión realizada, propuesta/presupuesto generado, servicios de interés registrados

## 2. Flujo actual paso a paso

### Para Corporativo:
1) Cliente explica necesidades por llamada telefónica o email
2) Se coordina videollamada de 20 minutos para entender requerimientos
3) Durante videollamada se toman notas de todo lo discutido
4) En días siguientes se envía propuesta con idea (storyboard simplificado) y plan de rodaje
5) Propuesta puede compartirse en línea para feedback del cliente

### Para Bodas:
1) Dependiendo de la pareja, novios tienen reunión o piden presupuesto directamente
2) Coordinación de reunión (presencial preferida, online disponible):
   - Por email (lento, problemas de comunicación si no hay teléfono)
   - Por WhatsApp (rápido, se envía convocatoria Google Meet)
3) Si presencial: se facilita dirección oficina, fecha boda, día y hora reunión
4) Si online: aparece enlace Google Meet en vez de dirección
5) En reunión se explica: servicios fotografía (1 o 2 fotógrafos), servicios vídeo, funcionamiento equipo día boda, asesoramiento número profesionales, características especiales boda
6) Al finalizar reunión, se queda en que Paz manda presupuesto (normalmente al día siguiente, pero se olvida)
7) Presupuesto se negocia en persona o por teléfono (Javi, Fátima o Paz)

## 3. Problemas observados (desde entrevistas/notas. No te limites, registra cualquier problema detectado, empezando por los más relevantes, pero siempre dentro del proceso correspondiente)

- **P1**: Google Calendar errático - pone automáticamente llamada Google Meet sin solicitud, genera confusión sobre si reunión es presencial u online _(Fuente: minute-01.md Sección 6)_
- **P2**: Olvidos frecuentes de convocatorias - no se manda convocatoria Google Meet porque se olvida, resultando en solapamiento de reuniones, olvidos de citas, o incluso dos parejas a la misma hora _(Fuente: minute-01.md Sección 6)_
- **P3**: Olvidos de envío de presupuesto - reuniones a última hora o fuera horario laboral, Paz deja presupuesto para mañana siguiente pero se olvida de enviarlo _(Fuente: minute-01.md Sección 6)_
- **P4**: Proceso de coordinación lento - por email es muy lento y con problemas de comunicación, especialmente cuando no se tiene acceso al teléfono _(Fuente: minute-01.md Sección 6)_
- **P5**: Generación manual de propuestas/presupuestos - proceso lento, propenso a errores, requiere múltiples pasos _(Fuente: minute-01.md Secciones 2, 6)_
- **P6**: Falta de registro durante reunión - no se registran servicios de interés mientras ocurre la reunión _(Fuente: minute-01.md Sección 6)_

## 4. Oportunidades de mejora (sin diseñar solución. No te limites, registra cualquier oportunidad detectada, empezando por las más relevantes, pero siempre dentro del proceso correspondiente)

- **O1** (derivada de P1, P2): Sistema de agendamiento automático con calendario de horas disponibles, permitiendo elegir presencial u online
- **O2** (derivada de P2, P3): Recordatorios automáticos cada mañana con horas de reunión del día y datos de contacto de clientes
- **O3** (derivada de P5): Generación automática de presupuestos con pocos clicks (ej: seleccionando provincia, servicios, extras)
- **O4** (derivada de P6): Registro en tiempo real durante reunión de servicios de interés, permitiendo enviar presupuesto inmediatamente
- **O5** (derivada de P4): Portal de cliente con enlace para convocar reunión, calendario integrado
- **O6** (derivada de P5): Propuesta compartida en línea con notificaciones automáticas cuando cliente modifica o visualiza
- **O7**: Integración con Google Calendar para sincronización correcta sin comportamientos erráticos

## 5. Artefactos y datos manipulados

- **Reunión**: fecha, hora, modalidad (presencial/online), participantes, ubicación/enlace, motivo
- **Propuesta Corporativo**: idea (storyboard simplificado), plan de rodaje, presupuesto, referencias visuales
- **Presupuesto Bodas**: servicios seleccionados (fotografía 1/2 fotógrafos, vídeo, dron), provincia, extras (transporte, tiempo extra), precio total
- **Servicios de interés**: registro de lo que interesa al cliente durante reunión
- **Retención/auditoría**: Registro de reuniones realizadas, propuestas enviadas, estado de negociación

## 6. Indicadores actuales (si existen)

- **Métrica**: Tiempo entre lead cualificado y primera reunión · **hoy**: Variable, depende de coordinación manual · Origen: No medido sistemáticamente
- **Métrica**: Tasa de conversión reunión → propuesta aceptada · **hoy**: No medido · Origen: No existe tracking
- **Métrica**: Tiempo de generación de propuesta/presupuesto · **hoy**: Manual, normalmente al día siguiente pero con olvidos frecuentes · Origen: Observaciones del equipo

## 7. Consideraciones de accesibilidad e inclusión (si aplica)

- Sistema de agendamiento debe ser accesible para personas con discapacidades
- Opción de reunión online para facilitar acceso a clientes con movilidad reducida
- Comunicación clara y estructurada en reuniones

## 8. Observaciones del cliente

- Reuniones presenciales preferidas pero online debe estar disponible
- Necesidad de mantener teléfono ONGAKU para casos especiales (agendar fuera horario laboral)
- Importancia de generar presupuestos rápidamente durante o inmediatamente después de reunión

---

**Fuentes**: minute-01.md (Corporativo §2, Bodas §6), company-info.md (Fase 2: Contacto y Propuesta, Fase 2 Bodas: Negociación y Primera Reunión)  
*GEN-BY:ASIS-PROMPT · hash:asis002_reunion_propuesta_20260120 · 2026-01-20T00:00:00Z*
