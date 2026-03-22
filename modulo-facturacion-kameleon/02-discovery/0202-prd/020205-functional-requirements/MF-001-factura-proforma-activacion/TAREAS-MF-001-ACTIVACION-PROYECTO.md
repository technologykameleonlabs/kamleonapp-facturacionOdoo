# Tareas — MF-001 Activación de proyecto

Tareas separadas por **Backend** y **Frontend**. Cada bloque incluye descripción detallada y criterios de aceptación explícitos, mapeados a las historias `MF-001-US-00X`.

## **Épica**: MF-001 — Activación de proyecto y prefactura por importe total
## **Historias de usuario**: US-001..US-005
---

# BACKEND

---

## [BACK] MF-001 — Activación del proyecto (manual o por evento: contrato firmado)

**Historia de usuario**: `MF-001-US-001`

**Descripción**
Implementar la lógica de activación del proyecto (cambio a `Activo`) con disparador manual o por evento/regla (ej. contrato firmado) e idempotencia.

**Detalle técnico**
- Servicio/endpoint para ejecutar “Activar proyecto” con validación de permisos (US-001).
- Detectar disparadores (manual y/o evento “contrato firmado” o regla configurable).
- Validar que el proyecto está en un estado habilitado para activación y que no está ya activo.
- Idempotencia:
  - si el proyecto ya está en `Activo`, no duplicar efectos ni registros equivalentes.
- Persistir:
  - `proyecto.estado = Activo`
  - `proyecto.fecha_activacion` (fecha/hora)
  - información del disparador (`disparador_activacion`) y quién lo ejecutó (`activated_by`)
- Orquestar con US-002: tras activación válida, invocar o encolar flujo de **prefactura por total** (misma transacción o saga según diseño).

**Criterios de aceptación**
- [ ] Al ejecutar activación, el proyecto pasa a `Activo` y se registra `fecha_activacion`.
- [ ] El flujo es idempotente (no re-activa ni duplica registros si ya está activo).
- [ ] Solo se activa cuando el proyecto está en estado válido para activación.
- [ ] El disparador se registra correctamente (manual / contrato_firmado / regla).

---

## [BACK] MF-001 — Prefactura por importe total al activar (cupo / MF-008)

**Historia de usuario**: `MF-001-US-002`

**Descripción**
Implementar la generación del **cupo de prefactura** asociado al proyecto con importe = **total acordado**, en el contexto de activación, dejando saldo listo para aplicación en facturas mensuales (MF-008).

**Detalle técnico**
- Endpoint/servicio ligado al flujo de activación o invocado inmediatamente después.
- Validaciones:
  - proyecto activo (o transición en curso según política transaccional)
  - `total_acordado` > 0 (o equivalente en modelo de proyecto)
  - no existe ya **prefactura/cupo** para el proyecto (una por proyecto en v1)
  - datos del cliente de facturación disponibles
  - según **decisión fiscal** (MF-001 épica): si documento fiscal, serie configurada; si proforma, tipo `prefactura_proforma` sin numeración obligatoria
- Crear registro prefactura/cupo:
  - `proyecto_id`, `importe_total` = total acordado, `importe_aplicado` = 0, moneda del proyecto
  - vínculo a `documento_id` si se materializa en `account.move` u orden de venta
- Idempotencia: no crear segundo cupo en reintentos del mismo flujo de activación.

**Criterios de aceptación**
- [ ] El cupo se crea con importe igual al total acordado del proyecto.
- [ ] No se duplica cupo para el mismo proyecto en condiciones normales de reintento.
- [ ] El registro es consumible por MF-008 (aplicación en facturas de periodo).
- [ ] Comportamiento coherente con la variante fiscal elegida (numeración solo si aplica).

---

## [BACK] MF-001 — Notificaciones al equipo y al cliente

**Historia de usuario**: `MF-001-US-003`

**Descripción**
Tras una activación exitosa y la prefactura (cuando corresponda), disparar notificaciones al equipo y al cliente incluyendo datos relevantes.

**Detalle técnico**
- Integración con sistema de notificaciones (email y/o in-app).
- Construcción de mensaje/plantilla:
  - equipo: `Proyecto [nombre] activado` (+ reserva calendario + referencia prefactura/cupo)
  - cliente: `Proyecto activado` (+ enlace/ID/pdf prefactura según tipo documental)
- Persistir flags de trazabilidad:
  - `notificacion.equipo_enviada`
  - `notificacion.cliente_enviada`
  - fecha/hora y canal
- Manejo de errores:
  - si falla envío, registrar error y permitir reintento (según estándar del sistema).

**Criterios de aceptación**
- [ ] Tras activación, el sistema envía notificación al equipo con mensaje correcto.
- [ ] Tras activación, el sistema envía notificación al cliente con mensaje correcto.
- [ ] Si existe prefactura, se incluye su referencia en la notificación.
- [ ] Se registran flags de envío y fecha/canal.

---

## [BACK] MF-001 — Reserva automática de fecha en calendario (si aplica)

**Historia de usuario**: `MF-001-US-004`

**Descripción**
Reservar/bloquear la fecha del proyecto en el calendario cuando la funcionalidad de calendario esté habilitada y exista fecha definida.

**Detalle técnico**
- Obtener la fecha desde el proyecto/contrato/evento.
- Verificar si calendario está habilitado en configuración.
- Crear/registrar “evento calendario” y bloquear la fecha.
- Validar solapamientos según reglas del calendario.
- Persistir referencia:
  - `calendario.evento_id`
  - `calendario.fecha_reservada`
- Si no hay soporte de calendario, el flujo no debe romper activación (solo se omite).

**Criterios de aceptación**
- [ ] Si calendario está habilitado, la fecha se reserva al activar el proyecto.
- [ ] Si hay conflicto de calendario, el sistema lo detecta y aplica la política definida (evitar / alertar / reintento).
- [ ] Se registra `evento_id` y `fecha_reservada`.
- [ ] Si calendario no está soportado, no se generan errores en el flujo de activación.

---

## [BACK] MF-001 — Registro de activación (timestamp y trazabilidad)

**Historia de usuario**: `MF-001-US-005`

**Descripción**
Persistir un registro de activación para auditoría, trazabilidad y evitar ejecuciones duplicadas del flujo.

**Detalle técnico**
- Crear/actualizar entidad “Activación” vinculada a `proyecto_id`.
- Incluir campos:
  - `timestamp`
  - `disparador_activacion` y `activated_by`
  - referencia a `prefactura_id` / `documento_id` si existe cupo
  - referencia a `calendario_evento_id` si existe reserva
- Idempotencia:
  - evitar duplicados equivalentes ante reintentos del flujo.

**Criterios de aceptación**
- [ ] Existe registro de activación persistido por proyecto/evento.
- [ ] El registro contiene timestamp, disparador y referencias opcionales (prefactura y calendario).
- [ ] No se crean duplicados ante reintentos (idempotencia).

---

# FRONTEND

---

## [FRONT] MF-001 — Acción y estado de activación del proyecto

**Historia de usuario**: `MF-001-US-001`

**Descripción**
Implementar en la UI de la ficha del proyecto la acción para activar (manual) y mostrar el estado/fecha de activación.

**Detalle técnico**
- Botón/acción “Activar proyecto” visible para usuarios con permisos.
- Validar en UI que el proyecto no esté ya activado (si aplica, deshabilitar).
- Al activar:
  - mostrar confirmación
  - actualizar campos visibles: `estado = Activo`, `fecha_activacion`, disparador (si se muestra).
- Manejo de errores (permiso/estado inválido):
  - mensajes claros según error del backend.

**Criterios de aceptación**
- [ ] Usuario puede activar un proyecto pendiente.
- [ ] Al activar se refrescan estado y fecha de activación.
- [ ] Si el proyecto ya está activo, no se permite reactivar (o se muestra mensaje coherente).

---

## [FRONT] MF-001 — UI prefactura por total (paso de activación)

**Historia de usuario**: `MF-001-US-002`

**Descripción**
Mostrar el paso de **confirmación o captura del total acordado** y el resultado de la prefactura/cupo generado.

**Detalle técnico**
- En asistente post-“Activar” o pantalla unificada: mostrar **total acordado** (readonly si viene del proyecto; editable solo si negocio lo permite).
- Acción “Generar prefactura / confirmar cupo” que llama al backend.
- Tras éxito: mostrar identificador/número según tipo documental, saldo inicial = total, enlace a documento si existe.
- Errores: total no definido, cliente incompleto, serie no configurada (si fiscal), cupo ya existente.

**Criterios de aceptación**
- [ ] El usuario completa el flujo de prefactura con total coherente con el proyecto.
- [ ] Tras guardar, se muestra referencia del documento/cupo y saldo pendiente inicial.
- [ ] Reintentos no duplican cupo en UI (mensaje claro si backend rechaza).

---

## [FRONT] MF-001 — Mostrar indicadores de notificación y trazabilidad de activación

**Historia de usuario**: `MF-001-US-003`

**Descripción**
Actualizar la UI para informar que se enviaron notificaciones al equipo y al cliente tras la activación (y referencia a prefactura si aplica).

**Detalle técnico**
- Mostrar flags/estado en ficha del proyecto:
  - `notificacion.equipo_enviada`
  - `notificacion.cliente_enviada`
  - fecha/canal si la UI lo consume
- Si se generó prefactura:
  - mostrar link o ID en la sección informativa.
- Mostrar mensajes si el backend informa de fallo de envío y habilitar reintento si el sistema lo soporta.

**Criterios de aceptación**
- [ ] La UI muestra indicadores de envío al equipo y al cliente.
- [ ] Si hubo prefactura, la UI muestra la referencia al documento/cupo.

---

## [FRONT] MF-001 — Visualización de fecha reservada en calendario

**Historia de usuario**: `MF-001-US-004`

**Descripción**
Mostrar la fecha reservada en la UI (en proyecto) y/o integrarla con el calendario embebido si existe.

**Detalle técnico**
- Mostrar `calendario.fecha_reservada` asociada al proyecto (si existe).
- Si hay conflicto y el backend rechaza reserva, mostrar mensaje y dejar claro qué ocurrió.
- Si calendario no está soportado, no mostrar sección o mostrarla deshabilitada.

**Criterios de aceptación**
- [ ] Si el calendario está habilitado, la fecha reservada aparece en la UI.
- [ ] Errores de conflicto de calendario se muestran con mensajes claros.

---

## [FRONT] MF-001 — Vista/consulta del registro de activación (auditoría)

**Historia de usuario**: `MF-001-US-005`

**Descripción**
Permitir a perfiles con permisos ver el registro de activación (timestamp, disparador, referencias de prefactura y calendario).

**Detalle técnico**
- Sección “Trazabilidad” en la ficha de proyecto:
  - mostrar `activacion.timestamp`
  - `disparador_activacion`
  - referencias opcionales: prefactura/cupo y evento de calendario
- Consultar endpoint/servicio del backend para recuperar el registro.

**Criterios de aceptación**
- [ ] La UI muestra el registro de activación con la información persistida.
- [ ] Las referencias opcionales aparecen solo cuando existen.

---

