---
id: AS-IS-003
name: Gestión de contratos y firma (Corporativo y Bodas)
slug: gestion-contratos-firma
status: READY
owner: Kameleonlabs@Kameleonlabs
product: ONGAKU
release: v1.0.0
locale: es-ES
gen_by: ASIS-PROMPT
hash: asis003_contratos_firma_20260120
---

# Gestión de contratos y firma (Corporativo y Bodas)

## 1. Descripción (AS-IS)

- **Propósito:** Generar, personalizar, revisar y gestionar la firma digital de contratos para ambas líneas de negocio una vez aceptada la propuesta/presupuesto.
- **Frecuencia:** Periódica (cuando hay aceptación de propuesta/presupuesto)
- **Actores/roles:** 
  - **Corporativo**: Fátima, administración, cliente corporativo
  - **Bodas**: Paz, ONGAKU (firma), novios (firma)
- **Herramientas actuales:** 
  - Modelo de contrato (Anexo 4 para bodas)
  - Edición manual de documentos (Word/PDF)
  - Email (envío y revisión)
  - Firma digital (parcialmente implementada)
  - Portal de cliente (parcial, para revisión)
- **Entradas → Salidas:** 
  - **Entradas**: Propuesta/presupuesto aceptado, datos del cliente, condiciones excepcionales
  - **Salidas**: Contrato personalizado, contrato firmado por ambas partes, notificaciones de estado

## 2. Flujo actual paso a paso

### Para Corporativo:
1) Cliente acepta propuesta y presupuesto
2) Se genera contrato con firma digital
3) En anverso de proforma pueden constar cláusulas de prestación del servicio
4) Cliente firma contrato
5) ONGAKU firma contrato
6) Contrato queda registrado en sistema

### Para Bodas:
1) Presupuesto negociado y aceptado
2) Se edita manualmente Modelo de Contrato (Anexo 4) cambiando palabras resaltadas
3) Se incluyen condiciones excepcionales en apartado 4 si las hay
4) Se envía contrato sin firmar a novios para revisión
5) Cuando novios aceptan, se firma por ONGAKU
6) Se manda contrato firmado por ONGAKU a novios para que ellos lo firmen
7) Novios firman contrato

## 3. Problemas observados (desde entrevistas/notas. No te limites, registra cualquier problema detectado, empezando por los más relevantes, pero siempre dentro del proceso correspondiente)

- **P1**: Edición manual muy lenta - coger Modelo de Contrato y cambiar palabras resaltadas es lento y propenso a errores _(Fuente: minute-01.md Sección 7)_
- **P2**: Olvidos de cambios - a veces se pasa por alto cambiar algunas palabras en el contrato _(Fuente: minute-01.md Sección 7)_
- **P3**: Olvidos de firma - se olvida que los novios firmen y nunca firman, o se olvida firmar directamente por parte de ONGAKU _(Fuente: minute-01.md Sección 7)_
- **P4**: Falta de seguimiento de estado - no hay visibilidad clara del estado de las firmas (pendiente cliente, pendiente ONGAKU, completado) _(Fuente: minute-01.md Sección 7)_
- **P5**: Proceso no automatizado - requiere intervención manual en cada paso, sin notificaciones automáticas _(Fuente: minute-01.md Sección 7)_
- **P6**: Falta de trazabilidad - no queda registro claro de quién firmó cuándo y en qué orden _(Fuente: minute-01.md Sección 7)_

## 4. Oportunidades de mejora (sin diseñar solución. No te limites, registra cualquier oportunidad detectada, empezando por las más relevantes, pero siempre dentro del proceso correspondiente)

- **O1** (derivada de P1, P2): Generación automática de contrato personalizado desde formulario con datos del cliente, permitiendo edición posterior si es necesario
- **O2** (derivada de P3, P4): Sistema de seguimiento de estado de firmas con notificaciones automáticas en cada etapa
- **O3** (derivada de P5): Notificaciones automáticas: aviso cuando contrato está preparado, aviso cuando cliente firma, aviso cuando ONGAKU debe firmar, aviso cuando ambas partes han firmado
- **O4** (derivada de P6): Trazabilidad completa de firmas: quién, cuándo, orden de firma, IP, dispositivo
- **O5** (derivada de P1): Portal de cliente donde contrato queda disponible para revisión y firma sin necesidad de email
- **O6**: Automatización completa del proceso de contrato y pago con firma digital al 100%
- **O7**: Integración de cláusulas en proforma para simplificar proceso (Corporativo)

## 5. Artefactos y datos manipulados

- **Contrato**: datos del cliente/novios, condiciones del servicio, precio, cláusulas, condiciones excepcionales (apartado 4 en bodas), fecha de firma
- **Firmas**: estado (pendiente cliente, pendiente ONGAKU, completado), fecha de cada firma, orden de firma, trazabilidad
- **Modelo de contrato**: Anexo 4 (bodas), plantilla corporativa
- **Retención/auditoría**: Contratos firmados archivados, registro de cambios, historial de firmas

## 6. Indicadores actuales (si existen)

- **Métrica**: Tiempo desde aceptación propuesta hasta contrato firmado · **hoy**: Variable, lento por edición manual · Origen: No medido sistemáticamente
- **Métrica**: Tasa de contratos que se olvidan de firmar · **hoy**: Reportado como problema frecuente · Origen: Observaciones del equipo
- **Métrica**: Tiempo de edición manual de contrato · **hoy**: Lento, propenso a errores · Origen: Observaciones del equipo

## 7. Consideraciones de accesibilidad e inclusión (si aplica)

- Portal de firma debe ser accesible (WCAG 2.1 AA)
- Proceso de firma debe ser claro y fácil de entender
- Soporte para múltiples dispositivos (móvil, tablet, desktop)

## 8. Observaciones del cliente

- Necesidad crítica de automatización para eliminar olvidos
- Importancia de seguimiento claro del estado de firmas
- Contrato debe quedar en portal del cliente para fácil acceso

---

**Fuentes**: minute-01.md (Corporativo §2, Bodas §7), company-info.md (Fase 3: Contratación, Fase 3 Bodas: Contrato)  
*GEN-BY:ASIS-PROMPT · hash:asis003_contratos_firma_20260120 · 2026-01-20T00:00:00Z*
