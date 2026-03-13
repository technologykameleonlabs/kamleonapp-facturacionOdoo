# NFR — Otros (mantenibilidad, observabilidad, portabilidad, i18n, soporte, coste)

<!-- AUTO:BEGIN -->
Requisitos transversales no cubiertos por Availability, Compliance, Performance, Security ni Usability-Accessibility.
<!-- AUTO:END -->

## 1. Mantenibilidad

- **Estándares de código:** Linters (ESLint/Prettier para frontend, equivalente para backend); cobertura de tests mínima 70 % en código crítico (reglas de negocio, integraciones); convenciones de nombres y estructura por capa (feature-based o por dominio).
- **Modularidad y límites de contexto:** Módulos por dominio/épica donde sea posible; APIs internas con contratos claros; evitar acoplamiento directo entre épicas en la misma capa.
- **Política de deprecación y compatibilidad:** Deprecación de APIs con aviso mínimo 2 versiones o 6 meses; documentación de breaking changes; compatibilidad hacia atrás en datos (migraciones versionadas).
- **DoD/DoR de arquitectura por épica:** DoD incluye revisión de impacto en rendimiento, seguridad y dependencias; DoR incluye alcance técnico claro y criterios de aceptación verificables.

## 2. Observabilidad

- **Métricas obligatorias por servicio (RED/USE):** Rate (req/s), Errors (%), Duration (latencia) por endpoint; Utilization, Saturation, Errors por recurso (CPU, memoria, disco) donde aplique.
- **Trazas distribuidas:** Propagación de trace-id entre frontend, API y workers; sampling configurable (100 % en staging, muestreo en producción); retención trazas 7–30 días.
- **Logs estructurados:** Formato JSON; niveles (error, warn, info, debug); política PII: no loguear datos personales en texto plano; retención según política (ej. 90 días).
- **Dashboards mínimos por EP (muestra):** EP-001 (leads): tasa de envío, errores de formulario; EP-004 (agendamiento): citas creadas, fallos de integración; EP-006/EP-008: generaciones de presupuesto/contrato, tiempo de generación; EP-019/EP-020: accesos al portal, comentarios; salud global: disponibilidad, latencia p95, error rate.

## 3. Portabilidad e interoperabilidad

- **Contenedorización e IaC:** Aplicación ejecutable en contenedores (Docker); orquestación (Kubernetes o servicio gestionado) opcional pero recomendada; infraestructura como código (Terraform o equivalente) para entornos reproducibles.
- **Compatibilidad BD:** Uso estándar de SQL (PostgreSQL); sin dependencias de proveedor específicas sin justificación; migraciones versionadas y reversibles cuando sea posible.
- **Contratos API:** Versionado semántico (v1, v2); breaking changes solo en nueva versión mayor; documentación (OpenAPI/Swagger) actualizada; idempotencia en operaciones críticas (ej. creación con idempotency key).

## 4. Soporteabilidad

- **Runbooks y tiempos objetivo por severidad:** Runbooks para incidentes frecuentes (BD lenta, integración caída, disco lleno); P1 (crítico): respuesta 15 min, resolución 4 h; P2: respuesta 1 h, resolución 24 h; P3: respuesta 1 día, resolución 1 semana.
- **Procedimiento on-call y escalamiento:** Turnos definidos; escalamiento según severidad (primero equipo técnico, luego responsable producto/infra); registro de incidentes y post-mortem para P1/P2.
- **Catálogo de errores/mensajes estándar:** Códigos de error internos y mensajes de usuario amigables; documentación de causas y acciones; sin exponer detalles internos en mensajes al usuario.

## 5. i18n/l10n

- **Idiomas soportados:** Español (es) principal; inglés (en) para portal cliente si aplica (alineado con Usability NFR).
- **Estrategia de locales:** Archivos de traducción por idioma; pluralización según reglas del idioma; formato de fechas, números y moneda según locale.
- **Separación de textos, RTL:** Textos fuera del código; RTL no requerido en MVP.

## 6. Coste/FinOps

- **Presupuestos por ambiente:** Límite mensual por ambiente (dev, staging, prod); alertas al 80 % y 100 % del presupuesto.
- **Etiquetas obligatorias:** Recursos etiquetados con proyecto, ambiente, épica o componente; uso de etiquetas para reportes de coste.
- **Métricas de costo:** Coste por ambiente; coste por transacción o por journey clave (opcional, para optimización).

## 7. Sostenibilidad (GreenOps)

- **Objetivos de consumo:** Uso eficiente de recursos (rightsizing); políticas de apagado de entornos no productivos en horarios definidos (ej. dev/staging por la noche).
- **Métricas de eficiencia:** Uso CPU/memoria por workload; identificación de recursos infrautilizados; revisión trimestral de opciones de eficiencia (instancias, regiones).

## 8. Pruebas/aceptación (BDD ejemplos)

- *Dado* un servicio nuevo, *cuando* se despliega a staging, *entonces* existen métricas RED y trazas para los endpoints críticos.
- *Dado* una API con breaking change, *cuando* se versiona a v2, *entonces* v1 se mantiene al menos 6 meses con deprecación documentada.
- *Dado* un incidente P1, *cuando* se declara, *entonces* se activa el runbook y se notifica al on-call en menos de 15 min.

## 9. Trazabilidad y riesgos

- **EP-* ↔ Atributo ↔ Métrica/Prueba:** Mantenibilidad: cobertura y linters por repo; Observabilidad: dashboards por EP crítico; Soporte: runbooks por tipo de incidente; Coste: alertas por ambiente.
- **Riesgos:** Crecimiento de deuda técnica si no se mantienen estándares; coste cloud puede crecer sin alertas; mitigación: DoD estricto, revisión FinOps trimestral.

## 10. TODOs

- **TODO:** Definir umbrales exactos de cobertura por tipo de código (crítico vs. no crítico). Dueño: Tech Lead.
- **TODO:** Implementar propagación de trace-id en toda la pila (frontend + API + workers). Dueño: Backend/DevOps.
- **TODO:** Crear runbooks para los 3 incidentes más probables (BD, integración, disco). Dueño: Infra/DevOps.
- **TODO:** Configurar alertas de presupuesto por ambiente en la herramienta de cloud. Dueño: FinOps/Infra.

---

**Trazabilidad (fuentes):** EP-* en `02-discovery/0202-prd/020205-functional-requirements/`; TO-BE en `02-discovery/0202-prd/020203-to-be/processes/`; Scope en `02-discovery/0202-prd/020204-scope/`.
