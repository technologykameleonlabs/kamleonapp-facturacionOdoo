# EP-027 — Gestión de retención y eliminación

**Descripción:** Control automático de fechas de retención por tipo de archivo/proyecto, avisos antes de la fecha de eliminación (ej. 30 días antes), eliminación programada o archivado definitivo según política, y registro de eliminación para auditoría.

**Proceso TO-BE origen:** TO-BE-027: Proceso de control automático de retención y eliminación

**Bloque funcional:** Control automático de retención — Desde archivos archivados (EP-025) con ubicación (EP-026) hasta aplicación de política de retención, avisos y eliminación programada.

**Objetivo de negocio:** Aplicar políticas de retención de forma automática, avisar antes de eliminación y eliminar o archivar definitivamente según política, manteniendo trazabilidad y cumplimiento.

**Alcance y exclusiones:**
- **Incluye:**
  - Configuración de política de retención por tipo de archivo/proyecto (plazo en años/meses).
  - Cálculo automático de fecha de eliminación a partir de fecha de subida (EP-025) y política.
  - Avisos automáticos antes de la fecha de eliminación (ej. 30 días antes) a administración.
  - Eliminación programada o archivado definitivo según política (eliminar de nube y/o marcar en disco).
  - Registro de eliminación (qué, cuándo, por qué política) para auditoría.
- **Excluye:**
  - Almacenamiento en nube (EP-025); registro de ubicación en discos (EP-026).
  - Definición de políticas legales (fuera de alcance funcional; se configuran en sistema).

**KPIs (éxito):**
- 100% de archivos/proyectos con fecha de retención calculada según política.
- Avisos enviados con antelación configurada; eliminación ejecutada en fecha programada.
- Registro de eliminación completo para auditoría.

**Actores y permisos (RBAC):**
- **Administración:** Configurar políticas de retención; recibir avisos; aprobar o posponer eliminación (si aplica).
- **Sistema centralizado:** Calcular fechas, enviar avisos, ejecutar eliminación programada, registrar eliminación.

**Trazabilidad (fuentes):**
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-027-gestion-retencion-eliminacion-archivos.md`

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-027-US-001 | Configuración de política de retención | Como administración, quiero configurar la política de retención por tipo de archivo o proyecto (plazo en años/meses), para que el sistema calcule automáticamente las fechas de eliminación | Definida | Alta |
| EP-027-US-002 | Cálculo automático de fecha de eliminación | Como sistema centralizado, quiero calcular automáticamente la fecha de eliminación de cada archivo/proyecto a partir de la fecha de subida (EP-025) y la política de retención, para aplicar la política sin intervención manual | Definida | Alta |
| EP-027-US-003 | Avisos antes de la fecha de eliminación | Como sistema centralizado, quiero enviar avisos automáticos a administración antes de la fecha de eliminación (ej. 30 días antes), para que puedan revisar o posponer si aplica | Definida | Alta |
| EP-027-US-004 | Eliminación programada o archivado definitivo | Como sistema centralizado, quiero ejecutar la eliminación programada (eliminar de nube y/o marcar en disco según política) o archivado definitivo en la fecha calculada, para cumplir la política de retención | Definida | Alta |
| EP-027-US-005 | Registro de eliminación para auditoría | Como sistema centralizado, quiero registrar qué archivos/proyectos se eliminaron, cuándo y por qué política, para auditoría y cumplimiento | Definida | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`
