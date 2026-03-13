# Compliance

<!-- AUTO:BEGIN -->
Requisitos de cumplimiento normativo y gobernanza de datos para ONGAKU.
<!-- AUTO:END -->

## 1. Alcance normativo

- **Jurisdicciones y marcos aplicables:** UE/EEE (GDPR); España (LOPDGDD, normativa de firma electrónica); ISO 27001 como referencia de controles de seguridad; SOC 2 Type II objetivo para clientes enterprise; sector servicios (eventos/bodas) sin regulación sectorial específica adicional.
- **Datos y tratamientos alcanzados:** Datos de identificación y contacto (leads, clientes, empleados); datos de reuniones y acuerdos; presupuestos y contratos; firmas electrónicas; datos de proyectos y producción; registros de tiempo; comunicaciones (email, Discord); archivos y ubicación física de soportes.
- **Supuestos/limitaciones:** Responsable del tratamiento identificado (Kameleonlabs/entidad legal); subencargados (Supabase, Google, Discord, proveedor de firma) con DPAs; sin tratamiento de datos de salud ni pagos con tarjeta en scope inicial (facturación vía terceros).

## 2. Clasificación y gobernanza de datos

- **Esquema de clasificación:** Público | Interno | Confidencial | Sensible (datos personales/tratamientos especiales).
- **Mapeo de entidades de datos por épica y proceso:**

| Entidad | Épica(s) | Proceso | Clasificación | Data Owner |
|---------|----------|---------|---------------|------------|
| Leads, contactos | EP-001, EP-002 | Captación, cualificación | Confidencial | Comercial |
| Datos reunión, notas | EP-005 | Registro reunión | Confidencial | Comercial |
| Presupuestos, contratos | EP-006 a EP-009 | Negociación, firma | Confidencial | Dirección |
| Datos empleados, tiempo | EP-012, EP-013 | Registro tiempo, recursos | Sensible | RRHH/Operaciones |
| Datos proyecto, entregas | EP-015 a EP-021 | Producción, entrega | Confidencial | Operaciones |
| Facturación | EP-010, EP-022 | Activación, factura final | Confidencial | Administración |
| Archivos, ubicación discos | EP-025, EP-026, EP-027 | Almacenamiento, retención | Confidencial | Operaciones |

- **Responsables:** Data Owner por dominio; Data Steward por proceso; DPO designado para derechos y evaluación de impacto.

## 3. Controles requeridos (catálogo)

| Control | Norma/Referencia | Descripción | Evidencia requerida | Frecuencia | Dueño |
|---------|------------------|-------------|---------------------|------------|-------|
| Consentimiento y base legal | GDPR Art. 6, 7 | Base legal por finalidad; consentimiento cuando aplicable (newsletter, cookies) | Registro de consentimientos, textos legales | Por tratamiento | Legal/DPO |
| Minimización de datos | GDPR Art. 5 | Solo datos necesarios por finalidad | Análisis de campos por formulario/épica | Por cambio | Product |
| PIA/DPIA | GDPR Art. 35 | Evaluación de riesgo para tratamientos de alto riesgo | Documento DPIA, registro | Por tratamiento nuevo/riesgo | DPO |
| Derechos ARCO/DSR | GDPR Cap. III | Acceso, rectificación, supresión, limitación, portabilidad, oposición | Log de solicitudes, plazos, respuestas | Por solicitud | DPO/Legal |
| Registro de actividades de tratamiento | GDPR Art. 30 | Registro actualizado de tratamientos | RAT documentado y revisado | Anual / por cambio | DPO |
| Retención y borrado | GDPR Art. 5, 17 | Plazos por tipo de dato; borrado verificable | Política de retención, logs de borrado | Continuo | DPO + Tech |
| Destrucción segura | ISO 27001, GDPR | Borrado seguro (NIST SP 800-88 o equivalente) | Certificado/log de eliminación | Por eliminación | Infra |
| Segregación de funciones | SOC 2, interno | SoD en aprobaciones (presupuesto, pago) | Matriz de permisos, logs | Continuo | Security |
| Firma electrónica | eIDAS / normativa española | Integridad y no repudio en contratos | Proveedor cualificado, logs de firma | Por firma | Legal/Product |
| Auditoría inmutable | SOC 2, ISO 27001 | Logs de acceso y cambios críticos inmutables | Retención logs, WORM o equivalente | Continuo | Infra |

## 4. Retención y borrado

- **Política por tipo de dato (resumen):**

| Tipo de dato | Plazo retención | Base legal / motivo | Trigger de borrado |
|--------------|-----------------|----------------------|--------------------|
| Leads no convertidos | 2 años | Interés legítimo (prospección) | Automático tras plazo |
| Datos cliente (contrato activo) | Duración contrato + 5 años | Ejecución contrato, obligaciones legales | Cierre proyecto + plazo |
| Registros de tiempo / RRHH | 4 años (laboral España) | Obligación legal | Automático tras plazo |
| Facturación | 4 años (fiscal España) | Obligación legal | Automático tras plazo |
| Comunicaciones (email/Discord) | 2 años desde fin relación | Interés legítimo | Automático o bajo solicitud |
| Archivos de proyecto | Según EP-027 (política retención) | Ejecución contrato, interés legítimo | Según política + solicitud |

- **Workflows:** Retención legal hold (bloqueo de borrado bajo requerimiento legal) documentado; borrado verificable con log y, si aplica, certificado; derecho al olvido como flujo DSR con plazos GDPR.

## 5. Transferencias y terceros

- **Inventario de proveedores/subencargados (resumen):** Supabase (hosting/BD, EU); Google (Calendar, correo, posible storage, EU); Discord (comunicación, EE. UU. – cláusulas tipo o equivalentes); proveedor de firma electrónica (EU preferible). Finalidad, país y salvaguardas por proveedor en inventario formal.
- **Evaluaciones de riesgo y cláusulas:** DPAs con subencargados; evaluación de transferencias extra-UE (cláusulas tipo, DPA); revisión anual o por cambio de proveedor.

## 6. Seguridad como habilitador de compliance

- **Enlace a controles de Security NFR:** Cifrado (tránsito/reposo), KMS, IAM, logs, respuesta a incidentes según `security.md`. Los controles de seguridad sostienen la integridad, confidencialidad y disponibilidad exigidas por GDPR y SOC 2.
- **Trazabilidad y log no repudiable:** Operaciones críticas (firma, aprobación presupuesto, acceso a datos sensibles) registradas de forma inmutable; trazabilidad Control ↔ Norma ↔ Evidencia ↔ Proceso/Épica.

## 7. Evidencias de cumplimiento

- **Qué se captura:** Consentimientos, RAT, DPIA, solicitudes DSR, políticas de retención, logs de borrado, matrices de permisos, informes de auditoría.
- **Dónde se guarda:** Repositorio legal/compliance; logs en sistema con retención definida.
- **Por cuánto tiempo:** Según norma (ej. evidencias auditoría 5–7 años).
- **Paquetes de auditoría:** Muestras por control, reportes exportables, listado de evidencias por control.

## 8. Pruebas y monitoreo continuo

- **Controles automatizados:** Retención (borrado programado); revisión de accesos (cuentas inactivas); SoD (alertas por combinación de permisos no permitida).
- **Plan de auditoría interna:** Revisión anual de RAT y retención; revisión semestral de accesos y permisos; pruebas de DSR al menos una vez al año.

## 9. Matriz de trazabilidad

| Control | Norma | Evidencia | Proceso/Épica | Prueba |
|---------|-------|-----------|---------------|--------|
| Consentimiento | GDPR Art. 7 | Registro consentimientos | EP-001 (formulario leads) | Revisión formularios y textos |
| Retención/borrado | GDPR Art. 5, 17 | Política + logs borrado | EP-027, EP-025, EP-026 | Verificación borrados programados |
| Firma electrónica | eIDAS | Logs proveedor | EP-009 | Revisión integración y logs |
| SoD | SOC 2 | Matriz permisos | EP-006, EP-007, EP-010 | Revisión de roles y aprobaciones |
| Registro actividades | GDPR Art. 30 | RAT | Todas las épicas | Actualización y revisión RAT |

## 10. Riesgos/Excepciones

- **Excepciones formales:** Cualquier excepción a política (ej. retención extendida, transferencia sin cláusulas tipo) documentada con justificación, riesgo, fecha de vencimiento y plan de remediación; aprobación Legal/DPO.

## 11. TODOs

- **TODO:** Completar RAT con todos los tratamientos y bases legales. Dueño: DPO.
- **TODO:** Formalizar DPAs con Supabase, Google, Discord y proveedor de firma. Dueño: Legal.
- **TODO:** Implementar flujo DSR (solicitud → respuesta en plazo) en producto. Dueño: Product/Tech.
- **TODO:** Definir política de retención detallada por entidad (alineada con EP-027). Dueño: DPO + Product.

---

**Trazabilidad (fuentes):** EP-* en `02-discovery/0202-prd/020205-functional-requirements/`; TO-BE en `02-discovery/0202-prd/020203-to-be/processes/`; Scope en `02-discovery/0202-prd/020204-scope/`.
