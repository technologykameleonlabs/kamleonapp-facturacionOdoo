# Usability & Accessibility

<!-- AUTO:BEGIN -->
Requisitos de usabilidad y accesibilidad (WCAG 2.1 AA) para ONGAKU.
<!-- AUTO:END -->

## 1. Alcance y personas

- **Personas/roles (referencia a EP/US):** Usuario interno (comercial, operaciones, administración) — EP-001 a EP-027; cliente/lead (formulario web, portal, firma) — EP-001, EP-004, EP-019 a EP-021, EP-023; usuario con necesidades de accesibilidad (teclado, lector de pantalla, contraste).
- **Tareas críticas por journey:** Enviar formulario de contacto/lead (EP-001); elegir fecha y hora de reunión (EP-004); rellenar datos en reunión (EP-005); revisar y aceptar presupuesto/contrato (EP-006, EP-007, EP-008, EP-009); ver y comentar material entregado (EP-019, EP-020); completar feedback (EP-023).

## 2. KPIs de usabilidad

- **Tasa de éxito por tarea:** Formulario leads >= 95 % (envío completado sin abandono por error); agendamiento >= 90 %; portal entrega (ver + comentar) >= 90 %; feedback >= 85 %.
- **Tiempo en tarea (p50/p95):** Formulario leads < 2 min; selección de cita < 3 min; primer comentario en material < 5 min.
- **Error rate:** < 5 % en formularios (errores de validación que impiden envío); < 2 % en acciones críticas (firma, aceptación).
- **SUS/UMUX-Lite objetivo:** SUS >= 70 (post-MVP); UMUX-Lite equivalente si se usa.
- **Definición de medición:** Método: telemetría de eventos (inicio, éxito, abandono) + muestreo de sesiones; muestra: representativa por rol y journey; revisión trimestral.

## 3. Heurísticas y directrices UX

- **Navegación:** Estructura clara y consistente; breadcrumbs en flujos largos; máximo 3 clics para tareas frecuentes; salida clara (cerrar sesión, volver).
- **Consistencia:** Misma convención de botones (primario/secundario); iconografía y términos coherentes entre vistas; patrones de formulario unificados.
- **Estados vacíos y errores:** Mensajes claros en listas vacías; errores con texto explicativo y acción sugerida; validación en línea sin bloquear en cada tecla; resumen de errores en envío.
- **Contenido:** Tono profesional y cercano; legibilidad (Flesch-Szigriszt o similar) objetivo "fácil" en textos clave; lenguaje inclusivo.
- **Responsive y mobile-first:** Breakpoints: móvil (320-767), tablet (768-1023), desktop (1024+); formulario leads y agendamiento usables en móvil; portal cliente usable en tablet y desktop como mínimo.

## 4. Accesibilidad (WCAG 2.1 AA)

- **Perceptible:** Contraste mínimo 4,5:1 (texto normal), 3:1 (texto grande); texto alternativo significativo en imágenes informativas; medios con subtítulos/transcripción si aplica; no usar solo color para transmitir información.
- **Operable:** Navegación completa por teclado; foco visible en todos los elementos interactivos; sin trampas de foco; atajos documentados y evitando conflictos; tiempo suficiente para completar tareas (o ampliable); sin contenido que parpadee más de 3 veces por segundo.
- **Comprensible:** Etiquetas y nombres accesibles (labels, aria-label); instrucciones y mensajes de error claros; ayuda contextual cuando sea necesario; comportamiento predecible (sin cambios de contexto inesperados).
- **Robusto:** Marcado válido; roles ARIA correctos cuando el HTML semántico no baste; compatibilidad con lectores de pantalla actuales.
- **Requisitos por vistas críticas (resumen):**

| Vista / Journey | Requisitos específicos A11y |
|-----------------|----------------------------|
| Formulario leads (EP-001) | Labels, agrupación de campos, errores asociados, contraste, teclado |
| Calendario agendamiento (EP-004) | Navegación por teclado, nombres de celdas/fechas, estado seleccionado |
| Formulario reunión (EP-005) | Campos obligatorios marcados, mensajes de error asociados |
| Vista presupuesto/contrato (EP-006, EP-008) | Estructura de encabezados, contraste en PDF o vista web |
| Portal entrega y comentarios (EP-019, EP-020) | Navegación por galería/listado, formulario de comentarios accesible |
| Formulario feedback (EP-023) | Campos y botones accesibles por teclado y lector de pantalla |

## 5. Pruebas y validación

- **Manual:** Lector de pantalla (NVDA/JAWS/VoiceOver) en flujos críticos; navegación solo con teclado; zoom 200 %; tema de alto contraste (donde se soporte).
- **Automatizada:** axe-core integrado en CI; Lighthouse (accesibilidad) con umbral mínimo (ej. 90); revisión de nuevas vistas antes de merge.
- **BDD ejemplos:**
  - *Dado* un formulario con campos obligatorios (EP-001), *cuando* navego solo con teclado, *entonces* puedo completar y enviar sin trampas de foco.
  - *Dado* una imagen informativa en el portal (EP-019), *cuando* inspecciono su HTML, *entonces* tiene alt significativo.
  - *Dado* un mensaje de error de validación, *cuando* se muestra, *entonces* está asociado al campo (aria-describedby o equivalente) y no se comunica solo por color.

## 6. Internacionalización (i18n)

- **Idiomas soportados (MVP):** Español (es) como principal; inglés (en) como secundario para portal cliente si aplica.
- **Formato de fechas y números:** Locale es-ES por defecto; fechas en formato claro (DD/MM/AAAA o texto); números con separador de miles y decimales según locale.
- **Gestión de traducciones:** Textos en recursos separados; clave de traducción por cadena; pluralización según idioma; no strings hardcodeados en código.

## 7. Telemetría UX

- **Eventos mínimos por vista:** Vista cargada; inicio de tarea (ej. "inicio envío formulario"); éxito (ej. "formulario enviado"); abandono (ej. "salida sin enviar"). Sin registrar PII en la telemetría (IDs opacos, sin email/nombre en eventos).
- **Privacidad:** Cumplir política de privacidad y minimización; sin tracking de terceros no esencial sin consentimiento.

## 8. Trazabilidad

| Vista / Journey | Criterio UX/A11y | Prueba | EP/US |
|-----------------|------------------|--------|-------|
| Formulario leads | Tasa éxito >= 95 %, teclado, contraste | Manual + axe + telemetría | EP-001 |
| Agendamiento | Tasa éxito >= 90 %, teclado, nombres | Manual + axe | EP-004 |
| Portal entrega | Tasa éxito >= 90 %, alt en medios, formulario | Manual + axe + telemetría | EP-019, EP-020 |
| Feedback | Tasa éxito >= 85 %, teclado, labels | Manual + axe | EP-023 |

## 9. Riesgos y TODOs

- **Riesgos:** Componentes de terceros (calendario, visor de archivos) pueden no cumplir AA; PDFs generados pueden requerir revisión de accesibilidad por separado.
- **TODO:** Definir componentes de calendario y visor que cumplan WCAG 2.1 AA o plan de mejora. Dueño: Frontend.
- **TODO:** Incluir criterios de accesibilidad en DoD de cada US que implique nueva vista. Dueño: Product/QA.

---

**Trazabilidad (fuentes):**
- EP-* y stories: `02-discovery/0202-prd/020205-functional-requirements/`
- TO-BE: `02-discovery/0202-prd/020203-to-be/processes/`
- Scope: `02-discovery/0202-prd/020204-scope/`
