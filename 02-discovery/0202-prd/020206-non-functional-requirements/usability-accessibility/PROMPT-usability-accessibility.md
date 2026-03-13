ROL GENERAL
Actúa como UX Lead y Especialista en Accesibilidad. Tu meta es definir **criterios de usabilidad** y **conformidad WCAG 2.1 AA** para las vistas/journeys clave, con métricas y tests reproducibles.

FUENTES AUTORIZADAS
1) Functional requirements (épicas y US): @/02-discovery/0202-prd/020205-functional-requirements/**/EP-*/EP-*.md y /stories/*
2) Scope/diagrams (flujos UI): @/02-discovery/0202-prd/020204-scope/**
3) TO-BE procesos (para tareas y roles): @/02-discovery/0202-prd/020203-to-be/processes/TOBE-*.md

OBJETIVO
Definir KPIs de UX (SUS, tasa de éxito, tiempo en tarea), criterios de accesibilidad y pruebas manuales/automatizadas por **pantalla/journey**.

SALIDA
@/02-discovery/0202-prd/020206-non-functional-requirements/usability-accessibility/usability-accessibility.md

PLANTILLA — usability-accessibility.md
# Usability & Accessibility

## 1. Alcance y personas
- Personas/roles (referencia a EP/US)
- Tareas críticas por journey (lista)

## 2. KPIs de usabilidad
- Tasa de éxito por tarea (%), tiempo en tarea (p50/p95), error rate
- SUS/UMUX-Lite objetivo, NPS (si aplica)
- Definición de medición (método, muestra)

## 3. Heurísticas y directrices UX
- Navegación, consistencia, estados vacíos/errores
- Contenido: tono, legibilidad (Flesch-Szigriszt o similar)
- Responsive (breakpoints) y mobile-first

## 4. Accesibilidad (WCAG 2.1 AA)
- Perceptible: contraste, texto alternativo, medios
- Operable: navegación por teclado, foco visible, atajos
- Comprensible: etiquetas, ayudas, errores claros
- Robusto: roles ARIA correctos
- Requisitos específicos por vistas críticas (tabla)

## 5. Pruebas y validación
- Manual: lector de pantalla (NVDA/JAWS/VoiceOver), teclado-only, zoom 200%, alto contraste
- Automatizada: axe/lighthouse (umbral mínimo)
- BDD ejemplos:
  - *Dado* un formulario con campos obligatorios, *cuando* navego solo con teclado, *entonces* puedo completar y enviar sin trampas de foco.
  - *Dado* una imagen informativa, *cuando* inspecciono su HTML, *entonces* tiene `alt` significativo.

## 6. Internacionalización (i18n)
- Idiomas soportados, formato de fechas/números
- Gestión de traducciones (separación de texto, pluralización)

## 7. Telemetría UX
- Eventos mínimos por vista (inicio/éxito/aborto)
- Privacidad (no registrar PII innecesaria)

## 8. Trazabilidad
- Vista/Journey ↔ Criterio UX/A11y ↔ Prueba ↔ EP/US

## 9. Riesgos y TODOs
- Riesgos: […]
- TODO: […]

MARCAS
<!-- AUTO:BEGIN --> … <!-- AUTO:END -->

REGLAS
- Cada vista crítica debe tener al menos 3 pruebas de accesibilidad y 2 KPIs de usabilidad.
- Mensajes de error: texto exacto, sin color como único diferenciador.
- **Si el archivo ya existe en la ruta indicada, SOBRESCRIBIRLO (no crear copia duplicada).**

COMANDOS
- GENERAR / ACTUALIZAR / LISTAR TODOs
