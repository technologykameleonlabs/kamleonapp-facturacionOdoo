# EP-005 — Registro de información durante reunión

**Descripción:** Formulario guiado y estructurado que permite a Fátima (Corporativo) y Paz (Bodas) capturar en tiempo real, durante la reunión con el cliente, todos los servicios de interés, necesidades, preferencias y acuerdos clave, dejando la información lista para que el sistema genere automáticamente un presupuesto al finalizar la reunión, sin depender de la memoria posterior.

**Proceso TO-BE origen:** TO-BE-005: Proceso de registro de información durante reunión

**Bloque funcional:** Captura estructurada en tiempo real — Flujo completo desde el inicio de la reunión agendada hasta el registro completo y validado de la información necesaria para generar el presupuesto.

**Objetivo de negocio:** Eliminar los olvidos y retrasos en la generación de presupuestos causados por notas sueltas o memoria posterior, asegurando que el 100% de la información relevante se capture durante la reunión en un formato estructurado, de forma que se pueda generar un presupuesto automático inmediatamente después, reduciendo tiempos de respuesta y mejorando la percepción profesional del cliente.

**Alcance y exclusiones:**  
- **Incluye:**  
  - Formulario estructurado de registro de reunión vinculado al lead y a la reunión agendada.  
  - Secciones específicas para Corporativo y Bodas con campos predefinidos (servicios de interés, presupuesto estimado, provincia, extras, características especiales…).  
  - Validación de campos críticos antes de poder marcar la reunión como “Completada”.  
  - Posibilidad de registrar notas libres y servicios no estándar.  
  - Cambio de estado de la reunión a “Completada” / “No asistida” / “Cancelada”.  
  - Dejar información lista para el proceso de generación automática de presupuestos (EP-006).  
- **Excluye:**  
  - Generación automática de presupuestos (EP-006).  
  - Agendamiento de la reunión (EP-004).  
  - Envío del presupuesto al cliente (EP-006/EP-007).  
  - Grabación de audio/vídeo de la reunión.  

**KPIs (éxito):**  
- 100% de reuniones realizadas tienen un registro de reunión marcado como “Completado” el mismo día.  
- 100% de presupuestos generados automáticamente disponen de toda la información crítica necesaria.  
- Tiempo adicional de registro durante la reunión ≤ 5 minutos.  
- Reducción significativa de olvidos de envío de presupuestos (objetivo: 0 casos por falta de información).  

**Actores y permisos (RBAC):**  
- **Fátima (Corporativo):**  
  - Puede crear/editar registros de reunión para leads corporativos asociados a sus reuniones.  
  - Puede marcar la reunión como “Completada”, “No asistida” o “Cancelada” con motivo.  
- **Paz (Bodas):**  
  - Puede crear/editar registros de reunión para leads de bodas.  
  - Puede marcar la reunión como “Completada”, “No asistida” o “Cancelada” con motivo.  
- **Sistema centralizado:**  
  - Proporciona formularios preconfigurados según línea de negocio.  
  - Valida campos críticos antes de permitir completar la reunión.  
  - Cambia el estado de la reunión y expone la información al motor de presupuestos.  
- **Usuario administrador (opcional):**  
  - Configura campos del formulario, catálogos de servicios y reglas de validación.  

**Trazabilidad (fuentes):**  
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-005-registro-informacion-reunion.md`  
- Bloque funcional: Captura estructurada en tiempo real durante reunión.  
- Pasos: 1–6 del flujo principal (acceso al formulario, captura durante reunión, validación, marcado como completada y exposición a TO-BE-006).  

---

## Historias de usuario (índice)

| ID | Título | Story | Estado | Prioridad |
|----|--------|-------|--------|-----------|
| EP-005-US-001 | Apertura de formulario de reunión vinculado al lead | Como Fátima/Paz, quiero poder abrir un formulario de registro de reunión ya vinculado al lead y a la reunión agendada, para empezar a registrar la información desde el inicio sin tener que buscar datos manualmente | Pendiente | Alta |
| EP-005-US-002 | Captura estructurada durante reunión — Corporativo | Como Fátima, quiero registrar durante la reunión corporativa las necesidades, servicios de interés, presupuesto estimado y notas clave en un formulario estructurado, para que la información quede lista para la generación automática de presupuesto corporativo | Pendiente | Alta |
| EP-005-US-003 | Captura estructurada durante reunión — Bodas | Como Paz, quiero registrar durante la reunión de bodas los servicios de interés, provincia, extras, características especiales y número de profesionales recomendados en un formulario estructurado, para que la información quede lista para la generación automática de presupuesto de bodas | Pendiente | Alta |
| EP-005-US-004 | Validación de información crítica y marcado de reunión como Completada/No asistida | Como Fátima/Paz, quiero que el sistema valide que la información crítica está completa antes de poder marcar la reunión como “Completada”, y poder marcarla también como “No asistida” o “Cancelada” con motivo, para reflejar correctamente el resultado de la reunión | Pendiente | Alta |
| EP-005-US-005 | Exposición de la información de reunión al motor de presupuestos | Como sistema centralizado, quiero exponer la información estructurada de la reunión al motor de generación automática de presupuestos, para que al finalizar la reunión el presupuesto pueda generarse inmediatamente sin pasos manuales intermedios | Pendiente | Alta |

> Las historias de usuario detalladas se encuentran en archivos independientes en la carpeta `/stories`

---

## Anexos del epic (opcional)

### Diccionario de datos específico
- **Registro de reunión:** Conjunto de datos capturados durante la reunión, vinculados a un lead y a una reunión agendada.  
- **Servicios de interés (Corporativo):** Packs, servicios adicionales, combinaciones específicas mencionadas por el cliente corporativo.  
- **Servicios de interés (Bodas):** Fotografía (1/2 fotógrafos), vídeo, dron, etc.  
- **Presupuesto estimado:** Cantidad o rango económico que el cliente menciona como referencia durante la reunión.  
- **Provincia:** Ubicación geográfica de la boda/evento para cálculo de desplazamientos.  
- **Extras:** Conceptos adicionales (transporte, horas extra, etc.).  
- **Estado de reunión:** Agendada, Completada, No asistida, Cancelada.  

### Reglas de numeración/ID específicas
- Formato de ID de registro de reunión: `REU-REG-{ID_REUNION}`.  

### Mockups o enlaces a UI
- [Pendiente de diseño] Vista de detalle de reunión con botón “Abrir formulario de registro”.  
- [Pendiente de diseño] Formulario Corporativo con secciones de necesidades, servicios, presupuesto y notas.  
- [Pendiente de diseño] Formulario Bodas con secciones de servicios, provincia, extras, características especiales.  
- [Pendiente de diseño] Pantalla de cambio de estado de reunión con validación de campos críticos.  

