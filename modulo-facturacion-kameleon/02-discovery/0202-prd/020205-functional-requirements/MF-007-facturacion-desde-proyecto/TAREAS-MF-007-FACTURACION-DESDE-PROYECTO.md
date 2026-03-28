# Tareas — MF-007 Facturación desde proyecto

Tareas separadas por **Backend** y **Frontend**. Cada bloque incluye descripción, detalle técnico y criterios de aceptación, mapeados a las historias `MF-007-US-001` … `MF-007-US-009`.

**Dependencias**: MF-003 (factura borrador/publicación, `proyecto_id` en modelo si aplica), MF-011 (cliente), MF-001/MF-008 (cupo y validación al publicar).

## **Épica**: MF-007 — Facturación desde proyecto (mensual por tareas/horas/hitos/fee)

## **Historias de usuario**: US-001 … US-009

---

# BACKEND

---

## [BACK] MF-007 — Crear factura de periodo (proyecto + periodo, borrador)

**Historia de usuario**: `MF-007-US-001`

**Descripción**  
Endpoint(s) para iniciar una factura de periodo vinculada a `proyecto_id` y `periodo_facturado` (mes/año o rango), en estado Borrador, validando que no exista otra factura **publicada** para el mismo proyecto+periodo.

**Detalle técnico**

- `POST /api/proyectos/:id/facturas-periodo` (o `POST /api/facturas` con payload `proyecto_id`, `periodo`).
- Validar permisos sobre proyecto y facturación.
- Comprobar unicidad proyecto+periodo para `estado_documento = Publicada` (coordinado con US-006).
- Normalizar periodo (primer/último día del mes o rango explícito).
- Opcional: endpoint `GET` periodos facturables (periodos con actividad y sin factura publicada).

**Criterios de aceptación**

- Se crea factura en Borrador con `proyecto_id` y periodo persistidos.
- Rechazo claro si ya existe factura publicada para mismo proyecto+periodo.
- Periodo futuro rechazado si la política lo exige.

---

## [BACK] MF-007 — Generar líneas desde tareas del periodo

**Historia de usuario**: `MF-007-US-002`

**Descripción**  
Servicio que, dada una factura borrador con proyecto y periodo, añade líneas por tareas completadas en el periodo no facturadas, con `origen_tipo = tarea` y `origen_id`.

**Detalle técnico**

- Filtro: proyecto, fechas de cierre en periodo, estado completado, `factura_id` nulo.
- Cálculo de importe por tarea (precio fijo o horas × tarifa según modelo de datos Kameleon).
- `POST /api/facturas/:id/generar-lineas` con body `{ fuente: "tareas" }` o equivalente.
- Idempotencia: no duplicar líneas si se invoca dos veces (o limpiar borrador según regla de producto).

**Criterios de aceptación**

- Solo tareas elegibles generan línea.
- Líneas llevan origen_tipo/origen_id correctos.
- Tras publicar (MF-003 + US-006), tareas quedan vinculadas a la factura.

---

## [BACK] MF-007 — Generar líneas desde horas facturables

**Historia de usuario**: `MF-007-US-003`

**Descripción**  
Agregar líneas agrupando registros de tiempo facturables del periodo no vinculados a factura.

**Detalle técnico**

- Política de agrupación configurable (por usuario/recurso/tipo).
- Campos en línea: descripción resumen, cantidad horas, tarifa, importe.
- Marcar registros al publicar (transacción con publicación).

**Criterios de aceptación**

- Excluye registros no facturables o ya facturados.
- Totales de línea coherentes con suma de horas × tarifa.
- Vínculo persistido tras publicar.

---

## [BACK] MF-007 — Generar líneas desde hitos completados

**Historia de usuario**: `MF-007-US-004`

**Descripción**  
Líneas por hitos completados en el periodo y no facturados.

**Detalle técnico**

- Criterio de “hitos en periodo” (fecha completado vs fecha planificada — alinear con negocio).
- Importe desde presupuesto de hito o importe fijo del hito.

**Criterios de aceptación**

- Hitos ya facturados no aparecen en propuesta.
- `origen_tipo = hito` y marcado al publicar.

---

## [BACK] MF-007 — Línea fee mensual

**Historia de usuario**: `MF-007-US-005`

**Descripción**  
Si el proyecto tiene `fee_mensual`, permitir añadir una línea fee para el periodo seleccionado.

**Detalle técnico**

- Validar que no exista fee ya facturado para proyecto+mes en factura publicada.
- Línea con `origen_tipo = fee_mensual`, `origen_id` null.

**Criterios de aceptación**

- Un solo fee aplicable por proyecto+periodo en facturas publicadas.
- Importe tomado de configuración de proyecto salvo edición en borrador permitida.

---

## [BACK] MF-007 — Prevención doble facturación y marcado al publicar

**Historia de usuario**: `MF-007-US-006`

**Descripción**  
Validaciones transaccionales al crear/publicar: unicidad proyecto+periodo; imposibilidad de asignar mismo origen a dos facturas publicadas.

**Detalle técnico**

- Índices/unique constraints donde aplique (p. ej. factura publicada por par proyecto+periodo normalizado).
- En `publicar` (MF-003 hook o servicio MF-008): bloquear si algún `origen_id` ya facturado.
- Rollback si falla parte del marcado.

**Criterios de aceptación**

- No se publica si hay conflicto de origen o periodo duplicado.
- Tras publicación exitosa, todos los orígenes de líneas quedan marcados.

---

## [BACK] MF-007 — Trazabilidad y consultas listado por proyecto

**Historia de usuario**: `MF-007-US-007`

**Descripción**  
Exponer en API detalle de factura con proyecto y periodo; listar facturas filtradas por `proyecto_id` con datos para UI.

**Detalle técnico**

- `GET /api/proyectos/:id/facturas` con orden por fecha.
- Incluir en `GET /api/facturas/:id` campos `proyecto`, `periodo_facturado`, desglose opcional de orígenes.

**Criterios de aceptación**

- Listado y detalle muestran vínculo proyecto ↔ factura.
- Filtros coherentes con permisos.

---

## [BACK] MF-007 — Prerrelleno de cliente desde proyecto

**Historia de usuario**: `MF-007-US-008`

**Descripción**  
Al crear borrador desde proyecto, asignar `cliente_id` desde `proyecto.cliente_id` si existe.

**Detalle técnico**

- Hook en creación de factura de periodo (US-001).
- Validación de datos mínimos del cliente antes de publicar (mensaje alineado con MF-011).

**Criterios de aceptación**

- Cliente copiado al crear borrador desde proyecto.
- Error claro si falta cliente en proyecto o datos mínimos incompletos al publicar.

---

## [BACK] MF-007 — Agregados para vista proyecto (totales, periodos, saldo prefactura)

**Historia de usuario**: `MF-007-US-009`

**Descripción**  
Endpoint(s) de resumen: total facturado, pendiente de cobro, estado por periodo, **saldo prefactura** (total cupo, aplicado, pendiente) integrando MF-001/MF-008.

**Detalle técnico**

- `GET /api/proyectos/:id/resumen-facturacion` o campos en `GET /api/proyectos/:id`.
- Definición de “total facturado” alineada con documentos fiscales vs proforma (documentar en respuesta o contrato API).
- Cálculo de saldo pendiente del cupo con mismas reglas que MF-008.

**Criterios de aceptación**

- Resumen devuelve totales y lista periodo → factura o pendiente.
- Incluye saldo prefactura cuando el proyecto tiene cupo MF-001.

---

# FRONTEND

---

## [FRONT] MF-007 — UI selección de periodo e inicio de factura

**Historia de usuario**: `MF-007-US-001`

**Descripción**  
Botón “Crear factura de periodo” / “Facturar mes” en ficha proyecto; selector de mes/año; mensajes si periodo no disponible o ya facturado.

**Criterios de aceptación**

- Flujo crea borrador y navega a edición de factura (MF-003).
- Mensajes de error claros (periodo duplicado, sin permiso, periodo futuro).

---

## [FRONT] MF-007 — Acciones “Generar desde tareas / horas / hitos / fee”

**Historia de usuario**: `MF-007-US-002`, `MF-007-US-003`, `MF-007-US-004`, `MF-007-US-005`

**Descripción**  
En pantalla de factura borrador con proyecto, botones o asistente para disparar generación por fuente; preview de líneas a añadir; respeto de edición MF-003.

**Criterios de aceptación**

- Usuario ve líneas generadas y puede eliminar/editar antes de publicar.
- Fee solo ofrecido si proyecto tiene fee y periodo válido.
- Estados de carga y error por llamada API.

---

## [FRONT] MF-007 — Feedback de doble facturación

**Historia de usuario**: `MF-007-US-006`

**Descripción**  
Toast/modales ante intentos de crear segundo borrador publicable o errores de publicación por conflicto de origen.

**Criterios de aceptación**

- Mensajes alineados con textos de historia (referencia a factura existente).
- No se pierde borrador sin aviso cuando backend rechaza.

---

## [FRONT] MF-007 — Enlaces proyecto ↔ factura

**Historia de usuario**: `MF-007-US-007`

**Descripción**  
En ficha factura: bloque proyecto y periodo con enlace. En proyecto: tabla de facturas con enlaces a detalle.

**Criterios de aceptación**

- Navegación bidireccional funcional.
- Columnas: número, fecha, periodo, total, estado.

---

## [FRONT] MF-007 — Cliente prerrellenado

**Historia de usuario**: `MF-007-US-008`

**Descripción**  
Mostrar cliente en cabecera de factura al abrir borrador creado desde proyecto; indicador si viene del proyecto.

**Criterios de aceptación**

- Cliente visible al cargar factura nueva desde proyecto.
- Validación visual antes de publicar si faltan datos (con MF-011).

---

## [FRONT] MF-007 — Panel Facturación en proyecto

**Historia de usuario**: `MF-007-US-009`

**Descripción**  
Sección en ficha proyecto: KPIs (total facturado, pendiente cobro, presupuesto si existe), **saldo prefactura**, rejilla o timeline por mes (facturado vs pendiente), acceso a crear factura de periodo.

**Criterios de aceptación**

- Saldo prefactura visible cuando aplica.
- Coherencia visual con datos del resumen API.
- Enlace a MF-008 (aplicación cupo) si la UI lo requiere en la misma pantalla o subvista.

---

