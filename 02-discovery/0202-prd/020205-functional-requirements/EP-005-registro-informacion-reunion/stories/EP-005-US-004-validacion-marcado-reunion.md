# EP-005-US-004 — Validación de información crítica y marcado de reunión como Completada/No asistida

### Epic padre
EP-005 — Registro de información durante reunión

### Contexto/Descripción y valor
**Como** Fátima/Paz,  
**quiero** que el sistema valide que la información crítica está completa antes de poder marcar la reunión como "Completada", y poder marcarla también como "No asistida" o "Cancelada" con motivo,  
**para** reflejar correctamente el resultado de la reunión y garantizar que solo se generen presupuestos cuando la información sea suficiente.

### Alcance
**Incluye:**
- Validación de campos críticos antes de permitir marcar reunión como "Completada":
  - Corporativo: al menos un servicio de interés seleccionado (o nota libre que lo justifique)
  - Bodas: al menos un servicio de interés seleccionado, provincia/ubicación (o nota libre)
- Mensajes de error claros indicando qué campos faltan
- Cambio de estado de reunión:
  - "Completada" (solo si validación pasa)
  - "No asistida" (cliente no asistió, con motivo opcional)
  - "Cancelada" (reunión cancelada, con motivo opcional)
- Registro de motivo cuando se marca "No asistida" o "Cancelada"
- Bloqueo de botón "Completar reunión" si faltan campos críticos

**Excluye:**
- Exposición de información al motor de presupuestos (EP-005-US-005)
- Generación de presupuesto (EP-006)

### Precondiciones
- Formulario de reunión tiene información capturada (EP-005-US-002 o EP-005-US-003)
- Reunión está en estado "Agendada"
- Fátima/Paz tiene permisos para cambiar estado de la reunión
- Usuario está autenticado en el sistema

### Postcondiciones
- Reunión cambia a estado "Completada", "No asistida" o "Cancelada"
- Si "Completada", información queda validada y lista para motor de presupuestos
- Si "No asistida" o "Cancelada", motivo queda registrado y slot puede liberarse
- Sistema registra cambio de estado con timestamp y usuario responsable

### Flujo principal (marcar como Completada)
1. Fátima/Paz ha capturado información durante la reunión
2. Fátima/Paz hace clic en "Completar reunión" o "Marcar como Completada"
3. Sistema ejecuta validación de campos críticos:
   - Corporativo: verifica que al menos un servicio de interés esté seleccionado (o nota que lo justifique)
   - Bodas: verifica que al menos un servicio de interés y provincia/ubicación estén completos (o nota que lo justifique)
4. Si validación pasa:
   - Sistema cambia estado de reunión a "Completada"
   - Sistema guarda información estructurada definitivamente
   - Sistema registra cambio con timestamp y usuario
   - Información queda disponible para motor de presupuestos (EP-005-US-005)
5. Si validación falla:
   - Sistema muestra mensaje de error indicando campos faltantes
   - Sistema no cambia estado
   - Fátima/Paz completa campos faltantes y reintenta

### Flujo principal (marcar como No asistida o Cancelada)
1. Fátima/Paz accede al formulario de reunión o vista de detalle de reunión
2. Fátima/Paz selecciona "Marcar como No asistida" o "Cancelar reunión"
3. Sistema muestra campo opcional para motivo (texto libre)
4. Fátima/Paz puede escribir motivo o dejar en blanco
5. Fátima/Paz confirma el cambio de estado
6. Sistema cambia estado de reunión a "No asistida" o "Cancelada"
7. Sistema registra motivo (si se proporcionó) y cambio con timestamp y usuario
8. Sistema puede liberar slot en calendario (según diseño)
9. Sistema puede notificar al equipo (opcional)

### Flujos alternos y excepciones

**Flujo alterno 1: Completar información faltante antes de marcar Completada**
- Si faltan campos críticos, Fátima/Paz completa los campos indicados en el mensaje de error
- Sistema vuelve a validar al hacer clic en "Completar reunión"
- Si validación pasa, procede con cambio de estado

**Flujo alterno 2: Marcar No asistida sin motivo**
- Si Fátima/Paz marca "No asistida" sin escribir motivo:
- Sistema permite el cambio de estado (motivo es opcional)
- Sistema registra cambio sin motivo

**Excepción 1: Intentar marcar Completada sin información mínima**
- Si no hay ningún servicio de interés seleccionado y no hay nota que lo justifique:
- Sistema muestra error: "Debe registrar al menos un servicio de interés para completar la reunión"
- Sistema no permite marcar como Completada

**Excepción 2: Reunión ya en estado Completada/No asistida/Cancelada**
- Si la reunión ya fue marcada con uno de estos estados:
- Sistema no permite cambiar estado nuevamente (o solo con flujo específico de corrección)
- Sistema muestra mensaje informativo

**Excepción 3: Error al guardar cambio de estado**
- Si falla el guardado del cambio de estado:
- Sistema muestra error y no cambia estado
- Sistema intenta guardar nuevamente
- Si persiste el error, notifica al usuario

### Validaciones y reglas de negocio
- **Campos críticos Corporativo:** Al menos un servicio de interés (o nota libre que lo justifique)
- **Campos críticos Bodas:** Al menos un servicio de interés, provincia/ubicación (o nota libre que lo justifique)
- **Estado Completada:** Solo si validación de campos críticos pasa
- **Estado No asistida/Cancelada:** No requiere validación de campos críticos, motivo opcional
- **Unicidad de estado:** Una reunión solo puede estar en un estado final (Completada, No asistida o Cancelada)
- **Registro de auditoría:** Todo cambio de estado debe registrarse con timestamp y usuario

### Criterios BDD
- **Escenario 1: Marcado exitoso como Completada**
  - *Dado* que Fátima ha capturado necesidades, servicios de interés y presupuesto estimado en una reunión corporativa
  - *Cuando* hace clic en "Completar reunión"
  - *Entonces* el sistema valida que los campos críticos están completos, cambia el estado a "Completada" y la información queda disponible para el motor de presupuestos

- **Escenario 2 (negativo): Intentar marcar Completada sin servicios de interés**
  - *Dado* que Paz ha capturado información de una reunión de bodas pero no ha seleccionado ningún servicio de interés
  - *Cuando* hace clic en "Completar reunión"
  - *Entonces* el sistema muestra error indicando que debe registrar al menos un servicio de interés y no permite marcar como Completada

- **Escenario 3: Marcado como No asistida con motivo**
  - *Dado* que el cliente no asistió a la reunión agendada
  - *Cuando* Fátima selecciona "Marcar como No asistida" e indica "Cliente no se presentó"
  - *Entonces* el sistema cambia el estado a "No asistida", registra el motivo y el cambio con timestamp

### Notificaciones
- **Fátima/Paz:** Mensajes de error si validación falla (campos faltantes)
- **Equipo (opcional):** Notificación cuando reunión se marca como No asistida o Cancelada

### Seguridad
- Validación de permisos antes de permitir cambio de estado
- Solo el usuario responsable de la reunión (o con permisos) puede cambiar estado
- Registro de auditoría de todos los cambios de estado

### Analítica/KPIs
- Tasa de reuniones marcadas como Completada vs No asistida vs Cancelada
- Tasa de intentos fallidos de marcar Completada (validación de campos críticos)
- Tiempo promedio desde fin de reunión hasta marcado como Completada
- Frecuencia de uso de motivo en No asistida/Cancelada

### Definition of Ready
- [ ] Definición de campos críticos por línea de negocio (Corporativo/Bodas)
- [ ] Reglas de validación documentadas
- [ ] Flujo de cambio de estado implementado
- [ ] Sistema de registro de auditoría implementado

### Definition of Done
- [ ] Validación de campos críticos funciona correctamente
- [ ] Marcado como Completada solo permite si validación pasa
- [ ] Marcado como No asistida/Cancelada funciona con motivo opcional
- [ ] Mensajes de error son claros y específicos
- [ ] Registro de auditoría funciona correctamente
- [ ] Manejo de errores implementado (guardado fallido, estado ya cambiado)
- [ ] Pruebas de aceptación pasadas (todos los escenarios BDD)

### Riesgos y supuestos
- **Riesgo:** Validación demasiado estricta bloquea reuniones válidas
  - **Probabilidad:** Media | **Impacto:** Medio
  - **Mitigación:** Definir campos críticos mínimos, permitir notas libres que justifiquen excepciones
- **Supuesto:** Campos críticos están bien definidos y son conocidos por Fátima/Paz
- **Supuesto:** Solo se marca Completada cuando la reunión realmente ocurrió y la información es suficiente

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-005-registro-informacion-reunion.md`
- Bloque funcional: Captura estructurada en tiempo real durante reunión
- Paso(s): Pasos 4-5 del flujo principal (completar información faltante, marcar reunión como Completada)
