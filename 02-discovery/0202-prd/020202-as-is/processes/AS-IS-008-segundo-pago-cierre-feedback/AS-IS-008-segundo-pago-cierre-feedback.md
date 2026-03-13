---
id: AS-IS-008
name: Segundo pago, cierre y feedback (Corporativo y Bodas)
slug: segundo-pago-cierre-feedback
status: READY
owner: Kameleonlabs@Kameleonlabs
product: ONGAKU
release: v1.0.0
locale: es-ES
gen_by: ASIS-PROMPT
hash: asis008_cierre_feedback_20260120
---

# Segundo pago, cierre y feedback (Corporativo y Bodas)

## 1. Descripción (AS-IS)

- **Propósito:** Gestionar el segundo pago (50% final), cerrar el proyecto y solicitar feedback del cliente para mejorar servicios y obtener valoraciones.
- **Frecuencia:** Por proyecto/boda (tras aceptación de segunda entrega)
- **Actores/roles:** 
  - **Corporativo**: Administración, cliente corporativo, responsable de proyecto
  - **Bodas**: Administración, novios
- **Herramientas actuales:** 
  - Facturación (generación de factura restante)
  - Pasarela de pago
  - Email (solicitud de feedback)
  - Google (vínculo para valoración)
- **Entradas → Salidas:** 
  - **Entradas**: Segunda entrega aceptada por cliente
  - **Salidas**: Factura restante generada, segundo pago recibido (50%), proyecto cerrado, feedback/valoración obtenido

## 2. Flujo actual paso a paso

### Para Corporativo:
1) Cliente acepta trabajo (segunda entrega)
2) Se genera automáticamente factura para pago final (50% restante)
3) Se abre pasarela de pago
4) Cliente realiza pago
5) Sistema envía notificación de pago recibido
6) Todos los movimientos visibles en panel del cliente
7) Se envía petición de valoración con vínculo a Google para que cliente publique recomendación (objetivo: 5 estrellas)
8) Proyecto se cierra

### Para Bodas:
1) Novios aceptan entrega final
2) Segundo pago ya realizado (50% hasta una semana antes de la boda)
3) Se solicita feedback/valoración
4) Proyecto se cierra

## 3. Problemas observados (desde entrevistas/notas. No te limites, registra cualquier problema detectado, empezando por los más relevantes, pero siempre dentro del proceso correspondiente)

- **P1**: Solicitud de feedback manual - se envía petición de valoración por email, proceso no automatizado _(Fuente: minute-01.md Sección 2)_
- **P2**: Falta de seguimiento de feedback - no hay sistema para asegurar que cliente complete valoración _(Fuente: minute-01.md Sección 2)_
- **P3**: Proceso de cierre no estructurado - cierre de proyecto requiere intervención manual _(Fuente: minute-01.md)_
- **P4**: Falta de registro de satisfacción - no hay base de datos estructurada de feedback recibido _(Fuente: minute-01.md)_

## 4. Oportunidades de mejora (sin diseñar solución. No te limites, registra cualquier oportunidad detectada, empezando por las más relevantes, pero siempre dentro del proceso correspondiente)

- **O1** (derivada de P1): Automatización de solicitud de feedback: envío automático tras aceptación de entrega final
- **O2** (derivada de P2): Sistema de seguimiento de feedback: recordatorios si no se completa, tracking de valoraciones recibidas
- **O3** (derivada de P3): Cierre automático de proyecto tras pago final y aceptación
- **O4** (derivada de P4): Base de datos de feedback: registro de valoraciones, comentarios, análisis de satisfacción
- **O5**: Integración con Google para valoraciones: vínculo directo, tracking de valoraciones publicadas
- **O6**: Portal de cliente para dejar feedback directamente sin salir de la plataforma
- **O7**: Análisis de feedback: métricas de satisfacción, tendencias, áreas de mejora

## 5. Artefactos y datos manipulados

- **Factura final**: número, monto (50% restante), fecha, cliente, concepto
- **Pago final**: monto, método de pago, fecha de pago, justificante, estado
- **Feedback/Valoración**: valoración (objetivo 5 estrellas), comentarios, vínculo a Google, fecha de publicación
- **Cierre de proyecto**: fecha de cierre, estado final, satisfacción del cliente
- **Retención/auditoría**: Registro de pagos finales, feedback recibido, valoraciones publicadas, análisis de satisfacción

## 6. Indicadores actuales (si existen)

- **Métrica**: Tasa de feedback recibido · **hoy**: Objetivo obtener valoración 5 estrellas, no medido sistemáticamente · Origen: Solicitud manual
- **Métrica**: Tiempo desde aceptación hasta pago final · **hoy**: Variable, depende de cliente · Origen: No medido sistemáticamente
- **Métrica**: Satisfacción promedio del cliente · **hoy**: No medido · Origen: No existe tracking estructurado

## 7. Consideraciones de accesibilidad e inclusión (si aplica)

- Sistema de feedback debe ser accesible (WCAG 2.1 AA)
- Proceso de valoración debe ser claro y fácil de completar
- Múltiples canales para dejar feedback (portal, email, Google)

## 8. Observaciones del cliente

- Objetivo de obtener valoración de 5 estrellas en Google
- Importancia de cerrar proyecto de forma estructurada
- Necesidad de registrar satisfacción para mejora continua

---

**Fuentes**: minute-01.md (Corporativo §2), company-info.md (Fase 6 Corporativo: Cierre)  
*GEN-BY:ASIS-PROMPT · hash:asis008_cierre_feedback_20260120 · 2026-01-20T00:00:00Z*
