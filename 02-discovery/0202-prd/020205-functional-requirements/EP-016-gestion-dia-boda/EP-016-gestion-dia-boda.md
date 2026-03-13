# EP-016 — Gestión del día de la boda

**Descripción:** Asignación digital de equipo (filmmakers, fotógrafos), registro de material capturado por cada profesional, horarios reales e incidencias, uso de dron y trazabilidad completa del material generado durante el día de la boda.

**Proceso TO-BE origen:** TO-BE-016: Proceso de gestión del día de la boda

**Bloque funcional:** Asignación de equipo y trazabilidad — Desde inicio del día (2.5h antes ceremonia) hasta finalización (60 min después inicio fiesta).

**Objetivo de negocio:** Digitalizar la gestión del día de boda, asignar equipo con confirmación, registrar material por profesional y garantizar trazabilidad completa para postproducción (EP-017).

**Alcance y exclusiones:**
- **Incluye:**
  - Asignación digital de equipo por Paz (filmmakers, fotógrafos); confirmación de asistencia; asignación visible para equipo.
  - Equipo accede a detalles del día desde sistema (horarios, ubicaciones, música bloqueada, detalles especiales).
  - Registro de material capturado por cada profesional en tiempo real (vídeo, fotos); registro de uso de dron; registro de horarios reales e incidencias.
  - Trazabilidad completa: material por profesional, ubicación, estado (capturado, en proceso, listo), timestamp.
  - Confirmación por Paz al finalizar día: material por profesional, incidencias; material listo para postproducción.
- **Excluye:**
  - Preparación de bodas (EP-015).
  - Seguimiento de postproducción (EP-017).
  - Almacenamiento de archivos (EP-025).

**KPIs (éxito):**
- 100% de equipo asignado y confirmado.
- 100% de material capturado registrado con trazabilidad.
- Horarios reales registrados; incidencias documentadas.
- Tiempo de registro < 5 minutos por profesional.

**Actores y permisos (RBAC):**
- **Paz:** Asignar equipo, supervisar día, confirmar material al finalizar.
- **Equipo de producción (filmmakers, fotógrafos):** Acceder a detalles, registrar material, dron, horarios e incidencias.
- **Sistema centralizado:** Registrar asignaciones, material, trazabilidad.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-016-gestion-dia-boda.md`
- Pasos: 1–9 del flujo principal.

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-016-US-001 | Asignación digital de equipo por Paz | Como Paz, quiero asignar digitalmente el equipo (filmmakers, fotógrafos) para el día de la boda con confirmación de asistencia y que la asignación sea visible para el equipo, para que todos sepan quién cubre la boda | Definida | Alta |
| EP-016-US-002 | Equipo accede a detalles del día | Como miembro del equipo de producción, quiero acceder a los detalles del día desde el sistema (horarios, ubicaciones, música bloqueada, detalles especiales), para tener toda la información para la cobertura | Definida | Alta |
| EP-016-US-003 | Registro de material capturado por profesional | Como profesional del equipo, quiero registrar en tiempo real el material que capturo (vídeo, fotos) durante el día de boda, para que quede trazabilidad por profesional y el material esté listo para postproducción | Definida | Alta |
| EP-016-US-004 | Registro de uso de dron y horarios reales | Como profesional del equipo, quiero registrar el uso de dron si aplica y los horarios reales de la cobertura, para que quede documentado y se compare con lo planificado | Definida | Alta |
| EP-016-US-005 | Registro de incidencias | Como profesional del equipo o Paz, quiero registrar incidencias durante el día de boda, para que queden documentadas y se puedan tener en cuenta en postproducción | Definida | Alta |
| EP-016-US-006 | Trazabilidad completa y confirmación por Paz | Como sistema centralizado, quiero registrar la trazabilidad completa (material por profesional, ubicación, estado, timestamp) y como Paz quiero confirmar al finalizar el día el material capturado por cada profesional, para que el material quede listo para postproducción (EP-017) | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Asignación:** Filmmakers (1 o 2), Fotógrafos (1 o 2); confirmación de asistencia.
- **Material:** Tipo (vídeo, foto), profesional, timestamp, estado (capturado, en proceso, listo).
- **Horarios:** Inicio 2.5h antes ceremonia; finalización 60 min después inicio fiesta.

### Reglas de numeración/ID específicas
- Material y asignación vinculados por proyecto_id (boda) y profesional_id.
