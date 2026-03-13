# EP-004-US-005 — Envío de convocatorias y sincronización con Google Calendar

### Epic padre
EP-004 — Agendamiento de reuniones

### Contexto/Descripción y valor
**Como** sistema centralizado,  
**quiero** enviar automáticamente la convocatoria al cliente y notificar al equipo, y sincronizar correctamente con Google Calendar sin comportamientos erráticos,  
**para** garantizar que todos tengan la información de la reunión y que el calendario de ONGAKU esté siempre actualizado.

### Alcance
**Incluye:**
- Envío automático de la convocatoria generada (EP-004-US-004) al email del cliente.
- Envío de notificación al equipo interno (Fátima/Paz) con detalles de la reunión.
- Creación/actualización del evento correspondiente en Google Calendar:
  - Asunto.
  - Fecha, hora y duración.
  - Invitados (cliente y equipo).
  - Ubicación (dirección o enlace Meet).
- Garantizar que no se generen comportamientos erráticos (ej. duplicados, enlaces Meet no deseados).

**Excluye:**
- Programación de recordatorios previos a la reunión (EP-004-US-006).

### Precondiciones
- Convocatoria está generada y completa (EP-004-US-004).
- Email del cliente es válido.
- Integración con sistema de envío de emails está operativa.
- Integración con Google Calendar está configurada.

### Postcondiciones
- Cliente ha recibido la convocatoria por email.
- Fátima/Paz han recibido notificación con detalles de la reunión.
- Evento está creado y sincronizado correctamente en Google Calendar.

### Flujo principal
1. Sistema recibe la convocatoria generada con todos los datos (lead, fecha/hora, modalidad, enlace o dirección).
2. Sistema prepara el email de convocatoria al cliente:
   - Destinatario: email del cliente.
   - Asunto: definido en la plantilla.
   - Cuerpo: texto de la convocatoria con todos los datos.
3. Sistema envía el email al cliente mediante el sistema de envío de correos.
4. Sistema prepara notificación al equipo interno (Fátima/Paz):
   - Destinatario: email del equipo o canal interno.
   - Contenido: datos del cliente, fecha/hora, modalidad, enlace/dirección.
5. Sistema envía la notificación al equipo.
6. Sistema crea/actualiza el evento en Google Calendar:
   - Título del evento.
   - Fecha/hora de inicio y fin.
   - Invitados (email del cliente y del equipo).
   - Ubicación (dirección o enlace Meet).
7. Sistema valida que el evento se ha creado/actualizado sin errores.
8. Sistema marca la reunión en el sistema interno como “Agendada” (lista para recordatorios y registro de información).

### Flujos alternos y excepciones

**Flujo alterno 1: Reenvío manual de convocatoria**
- Usuario de ONGAKU puede reenviar manualmente la convocatoria si el cliente lo solicita.
- Sistema registra reenvíos.

**Excepción 1: Error al enviar email al cliente**
- Si el email al cliente falla:
  - Sistema reintenta N veces.
  - Si sigue fallando, marca error y notifica al equipo.
  - Evento en Google Calendar puede seguir existiendo, pero se indica que cliente no fue notificado por email.

**Excepción 2: Error al crear evento en Google Calendar**
- Si la creación/actualización del evento falla:
  - Sistema reintenta N veces.
  - Si sigue fallando, marca error, notifica al equipo y deja constancia en el sistema.

**Excepción 3: Email del cliente inválido**
- Si el email del cliente es inválido:
  - Sistema no envía el email.
  - Sistema notifica al equipo para corrección.

### Validaciones y reglas de negocio
- Cliente debe ser incluido como invitado en Google Calendar (si la política de negocio lo requiere).
- No deben crearse eventos duplicados para la misma reunión:
  - Si ya existe evento asociado al `ID_REUNION`, se actualiza en lugar de crear uno nuevo.
- Se debe controlar que Google Calendar no genere automáticamente enlaces Meet adicionales no deseados:
  - La lógica de creación del evento debe ser explícita (solo un enlace Meet gestionado).

### Criterios BDD
- **Escenario 1: Envío exitoso de convocatoria y creación de evento**
  - *Dado* que una convocatoria ha sido generada y el email del cliente es válido
  - *Cuando* el sistema envía la convocatoria y sincroniza con Google Calendar
  - *Entonces* el cliente recibe el email con los detalles de la reunión y el evento aparece correctamente en Google Calendar con la información adecuada.

- **Escenario 2 (negativo): Error al enviar email al cliente**
  - *Dado* que el email del cliente es inválido
  - *Cuando* el sistema intenta enviar la convocatoria
  - *Entonces* el envío falla, el sistema notifica al equipo y no marca al cliente como correctamente notificado.

- **Escenario 3 (negativo): Error al crear evento en Google Calendar**
  - *Dado* que la integración con Google Calendar falla
  - *Cuando* el sistema intenta crear el evento
  - *Entonces* el sistema registra el error, notifica al equipo y no marca la sincronización como correcta.

### Notificaciones
- **Cliente:** Email con convocatoria.
- **Fátima/Paz:** Email/notificación interna con detalles de la reunión, especialmente si hay errores.

### Seguridad
- Acceso restringido a las credenciales de Google Calendar.
- Validación de emails para evitar abusos del sistema de envío.

### Analítica/KPIs
- Tasa de éxito de envío de convocatorias.
- Tasa de error en sincronización con Google Calendar.
- Número de reenvíos manuales de convocatorias.

### Definition of Ready
- [ ] Sistema de envío de emails configurado.
- [ ] Integración con Google Calendar operativa.
- [ ] Modelo de evento en calendario definido.

### Definition of Done
- [ ] Convocatorias se envían automáticamente al cliente y al equipo.
- [ ] Eventos se crean/actualizan correctamente en Google Calendar.
- [ ] Manejo de errores implementado para envíos de email y sincronización.
- [ ] Escenarios BDD pasados.

### Riesgos y supuestos
- **Riesgo:** Correos marcados como spam → Mitigación: configuración SPF/DKIM, textos claros, reputación del dominio.
- **Supuesto:** Los emails de clientes son correctos y revisados en etapas previas.

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-004-agendamiento-reuniones.md`
- Bloque funcional: Envío de convocatoria y sincronización con calendario.
- Paso(s): 5–8 del flujo principal (envío de convocatoria, sincronización con Google Calendar).

