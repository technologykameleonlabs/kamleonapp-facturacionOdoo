---
id: AS-IS-001
name: Captación unificada de leads (Corporativo y Bodas)
slug: captacion-leads-unificada
status: READY
owner: Kameleonlabs@Kameleonlabs
product: ONGAKU
release: v1.0.0
locale: es-ES
gen_by: ASIS-PROMPT
hash: asis001_captacion_leads_20260120
---

# Captación unificada de leads (Corporativo y Bodas)

## 1. Descripción (AS-IS)

- **Propósito:** Centralizar y captar consultas de clientes potenciales (leads) de ambas líneas de negocio (Corporativo y Bodas) a través de múltiples canales de contacto, proporcionando una base de datos estructurada y consultable para el seguimiento comercial.
- **Frecuencia:** Continua/diaria
- **Actores/roles:** 
  - **Corporativo**: Fátima (responsable línea), Javi (CEO, contacto directo móvil), equipo comercial
  - **Bodas**: Paz (responsable línea), Javi (CEO, Instagram y teléfono), equipo comercial
- **Herramientas actuales:** 
  - Web (Squarespace con formularios)
  - LinkedIn (contactos directos)
  - Facebook (canal B2B)
  - Instagram (@ongaku.bodas - mensajes directos)
  - Email corporativo
  - Teléfono de Javi (WhatsApp/llamadas)
  - Teléfono de ONGAKU (WhatsApp)
  - Google Sheets "Bodas actualizadas" (verificación disponibilidad)
  - Post-its (anotaciones manuales)
  - Capturas de pantalla (Instagram)
- **Entradas → Salidas:** 
  - **Entradas**: Consultas por múltiples canales (web, redes sociales, email, teléfono)
  - **Salidas**: Base de datos de leads con información básica, correos modelo enviados (Anexo 1, 2, 3), verificación de disponibilidad

## 2. Flujo actual paso a paso

### Para Corporativo:
1) Lead entra por web (formulario Squarespace), LinkedIn, Facebook o contacto directo al móvil de Javi
2) Fátima o Javi reciben la consulta
3) Se evalúa el lead y se segmenta según packs por sectores (3 packs para colegios, 4 packs para empresas) o presupuesto del cliente
4) Se contacta al cliente para entender necesidades (llamada o email)
5) Lead queda registrado de forma manual/dispersa

### Para Bodas:
1) Lead entra por una de 5 vías:
   - **Instagram**: Javi dedica 30 min diarios respondiendo mensajes directos, pide datos y correo, hace captura de pantalla y la envía a Paz
   - **Página web**: Formulario Squarespace, llegan correos, Paz verifica disponibilidad en Google Sheets "Bodas actualizadas"
   - **Correo electrónico**: Consultas directas (a veces detalladas, a veces solo "precio???")
   - **Teléfono de Javi**: Llamadas o WhatsApp, Javi anota en post-it (riesgo de pérdida)
   - **Teléfono de ONGAKU**: WhatsApp, se pide información y se envía correo modelo
2) Paz comprueba disponibilidad en Google Sheets "Bodas actualizadas"
3) Paz rellena correo modelo (Anexo 1) con nombre novios, fecha boda, disponibilidad y link del dossier según ubicación
4) Se envía correo modelo al lead

## 3. Problemas observados (desde entrevistas/notas. No te limites, registra cualquier problema detectado, empezando por los más relevantes, pero siempre dentro del proceso correspondiente)

- **P1**: Proceso completamente manual y disperso - información en múltiples lugares (post-its, capturas de pantalla, emails, Google Sheets) _(Fuente: minute-01.md Sección 5, company-info.md)_
- **P2**: Falta de centralización - no hay base de datos unificada para buscar y seguir leads eficientemente _(Fuente: minute-01.md Sección 5, company-info.md)_
- **P3**: Alto riesgo de pérdida de información - post-its que se pierden, capturas de pantalla que se olvidan _(Fuente: minute-01.md Sección 5)_
- **P4**: Olvidos frecuentes de respuesta - muchas veces son los propios clientes quienes recuerdan que no han recibido respuesta _(Fuente: minute-01.md Sección 5)_
- **P5**: Proceso lento y propenso a errores - en periodos de mucho trabajo o vacaciones se acumula y se traspapele información _(Fuente: minute-01.md Sección 5)_
- **P6**: Formulario web incompleto - no especifica que novios deben indicar ciudad o día de boda, resultando en consultas genéricas "precio???" que alargan el proceso una semana _(Fuente: minute-01.md Sección 5)_
- **P7**: Dependencia de memoria del equipo - proceso muy dependiente de que el equipo se acuerde de seguirlo _(Fuente: minute-01.md Sección 5)_
- **P8**: Dificultad para cambiar proceso del teléfono de Javi - novios amigos/familiares llaman directamente, proceso difícil de digitalizar _(Fuente: minute-01.md Sección 5)_

## 4. Oportunidades de mejora (sin diseñar solución. No te limites, registra cualquier oportunidad detectada, empezando por las más relevantes, pero siempre dentro del proceso correspondiente)

- **O1** (derivada de P1, P2): Centralizar todos los canales en un formulario unificado que llegue a una base de datos única y consultable
- **O2** (derivada de P3, P4): Automatizar la captura de leads desde todos los canales (web, LinkedIn, Facebook, Instagram, email, teléfono) eliminando post-its y capturas de pantalla
- **O3** (derivada de P6): Mejorar formulario web para solicitar todos los datos relevantes desde el inicio (nombre novios, teléfonos, correos, fecha boda, ubicación, cómo nos conocieron)
- **O4** (derivada de P4, P5): Implementar sistema de recordatorios automáticos para asegurar respuesta a todos los leads
- **O5** (derivada de P2): Habilitar búsqueda avanzada por múltiples criterios (nombre, fecha, país, provincia, ciudad, estado) para facilitar gestión y seguimiento
- **O6** (derivada de P1): Integrar LinkedIn y Facebook para que contactos directos lleguen automáticamente al CRM
- **O7**: Implementar chatbot o agente virtual para segmentación automática de leads corporativos
- **O8**: Canalizar Instagram mediante link a formulario unificado en lugar de capturas de pantalla manuales
- **O9**: Integrar teléfono de Javi y ONGAKU para que datos se recojan y canalicen al mismo formulario unificado

## 5. Artefactos y datos manipulados

- **Lead/Contacto**: nombre, teléfono, email, fecha consulta, canal origen, estado (nuevo/en seguimiento/convertido), línea de negocio (Corporativo/Bodas)
- **Lead Bodas**: nombre novia, nombre novio, teléfonos ambos, correos ambos, fecha boda, país, provincia, ciudad, cómo nos conocieron, disponibilidad
- **Lead Corporativo**: empresa, sector, presupuesto estimado, tipo de pack de interés
- **Google Sheets "Bodas actualizadas"**: verificación de disponibilidad por fechas
- **Correos modelo**: Anexo 1 (disponibilidad), Anexo 2 (sin disponibilidad), Anexo 3 (recordatorio)
- **Retención/auditoría**: Registro de origen del lead y fecha de contacto para análisis de canales efectivos

## 6. Indicadores actuales (si existen)

- **Métrica**: Tiempo de respuesta a leads · **hoy**: Variable, propenso a olvidos · Origen: Manual, sin seguimiento sistemático
- **Métrica**: Tasa de conversión por canal · **hoy**: No medido · Origen: No existe tracking
- **Métrica**: Leads perdidos por falta de seguimiento · **hoy**: Desconocido, pero reportado como problema frecuente · Origen: Observaciones del equipo

## 7. Consideraciones de accesibilidad e inclusión (si aplica)

- Formulario unificado debe ser accesible (WCAG 2.1 AA) para personas con discapacidades
- Soporte para múltiples idiomas si se expande internacionalmente
- Comunicación clara y estructurada para facilitar comprensión

## 8. Observaciones del cliente

- Proceso crítico que requiere digitalización urgente
- Necesidad de mantener flexibilidad para canales personales (teléfono Javi para amigos/familiares)
- Importancia de no perder ningún lead por olvidos

---

**Fuentes**: minute-01.md (Corporativo §2, Bodas §5), company-info.md (Canales de Venta, Canales de Captación de Leads)  
*GEN-BY:ASIS-PROMPT · hash:asis001_captacion_leads_20260120 · 2026-01-20T00:00:00Z*
