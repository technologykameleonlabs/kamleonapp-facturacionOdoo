# EP-002-US-001 — Segmentación automática sugerida y asignación de pack para corporativo

### Epic padre
EP-002 — Registro y cualificación de leads

### Contexto/Descripción y valor
**Como** usuario de ONGAKU,  
**quiero** que el sistema sugiera automáticamente la segmentación (pack o servicio) según sector, presupuesto y palabras clave del lead, y poder asignar el pack de interés,  
**para** acelerar la cualificación sin tener que decidir manualmente entre todos los packs posibles (3 packs para colegios, 4 packs para empresas)

### Alcance
**Incluye:**
- Sugerencia automática de segmentación basada en sector del lead (colegio → 3 packs posibles, empresa → 4 packs posibles)
- Sugerencia automática basada en presupuesto mencionado en la consulta
- Sugerencia automática basada en palabras clave en el mensaje/consulta
- Visualización de sugerencias con justificación (por qué se sugiere cada pack)
- Lista de packs/servicios disponibles según sector detectado
- Asignación de pack de interés seleccionado por usuario
- Posibilidad de corregir/modificar la sugerencia automática
- Posibilidad de asignar pack manualmente sin usar sugerencia
- Visualización de información del pack asignado

**Excluye:**
- Verificación de disponibilidad para bodas (EP-001-US-001)
- Marcar lead como cualificado (EP-002-US-002)
- Gestión de packs/servicios (crear, editar packs)
- Análisis avanzado de calidad del lead
- Scoring automático de probabilidad de conversión

### Precondiciones
- Lead existe en el sistema con línea de negocio "Corporativo"
- Usuario de ONGAKU tiene sesión iniciada en el sistema
- Usuario de ONGAKU tiene permisos para cualificar leads corporativos
- Lead tiene información básica capturada (nombre, email, teléfono, mensaje/consulta)
- Sistema tiene configurados los packs disponibles por sector (3 packs para colegios, 4 packs para empresas)

### Postcondiciones
- Pack de interés asignado al lead corporativo
- Segmentación registrada en el lead (sector detectado, pack asignado)
- Lead listo para ser marcado como cualificado (si cumple otros requisitos)
- Información de pack asignado visible en el lead

### Flujo principal
1. Usuario de ONGAKU accede al detalle de un lead con línea de negocio "Corporativo"
2. Usuario hace clic en sección "Segmentación" o botón "Cualificar lead"
3. Sistema analiza automáticamente la información del lead:
   - Detecta sector (colegio, empresa, otro) según palabras clave en mensaje/consulta o información capturada
   - Identifica presupuesto mencionado (si existe)
   - Analiza palabras clave en el mensaje/consulta
4. Sistema genera sugerencia automática de segmentación:
   - Si sector es "colegio" → muestra 3 packs posibles para colegios
   - Si sector es "empresa" → muestra 4 packs posibles para empresas
   - Ordena packs según relevancia (presupuesto, palabras clave)
5. Sistema muestra sugerencias con:
   - Lista de packs sugeridos ordenados por relevancia
   - Justificación de cada sugerencia (ejemplo: "Sugerido por mención de presupuesto X€")
   - Información básica de cada pack (nombre, descripción breve)
6. Usuario revisa las sugerencias automáticas
7. Usuario selecciona un pack de la lista sugerida o busca otro pack manualmente
8. Usuario hace clic en "Asignar pack" o "Confirmar segmentación"
9. Sistema registra el pack asignado en el lead
10. Sistema actualiza el estado del lead (marca como "En cualificación" si no estaba)
11. Sistema muestra confirmación: "Pack asignado correctamente"
12. Lead queda con pack asignado y listo para ser marcado como cualificado

### Flujos alternos y excepciones

**Flujo alterno 1: Sector no detectado automáticamente**
- Si el sistema no puede detectar el sector automáticamente, muestra mensaje: "No se pudo detectar el sector automáticamente. Por favor, selecciona el sector manualmente"
- Sistema muestra lista completa de packs disponibles (todos los packs de colegios y empresas)
- Usuario selecciona sector manualmente y luego asigna pack

**Flujo alterno 2: Usuario corrige sugerencia automática**
- Si usuario considera que la sugerencia no es correcta, puede hacer clic en "Ver todos los packs" o "Buscar otro pack"
- Sistema muestra lista completa de packs disponibles según sector
- Usuario selecciona un pack diferente al sugerido
- Sistema registra el pack seleccionado manualmente

**Flujo alterno 3: Presupuesto no mencionado**
- Si no hay presupuesto mencionado en la consulta, sistema sugiere packs basándose solo en sector y palabras clave
- Sistema muestra mensaje informativo: "No se detectó presupuesto. Se sugieren packs según sector y necesidades mencionadas"
- Usuario puede asignar pack sin presupuesto

**Flujo alterno 4: Múltiples packs igualmente relevantes**
- Si varios packs tienen la misma relevancia según el análisis, sistema muestra todos con igual prioridad
- Usuario selecciona el pack más adecuado según su criterio

**Excepción 1: Error en análisis automático**
- Si falla el análisis automático (error en procesamiento de texto, falta de información), sistema muestra mensaje: "No se pudo generar sugerencia automática. Por favor, selecciona el pack manualmente"
- Sistema muestra lista completa de packs disponibles
- Usuario asigna pack manualmente

**Excepción 2: Pack no disponible**
- Si el pack seleccionado ya no está disponible o fue eliminado, sistema muestra mensaje: "Este pack ya no está disponible. Por favor, selecciona otro pack"
- Sistema muestra lista actualizada de packs disponibles

**Excepción 3: Información insuficiente para sugerencia**
- Si el lead tiene información muy limitada (solo nombre y email), sistema muestra mensaje: "Información insuficiente para sugerencia automática. Por favor, completa más información del lead o selecciona pack manualmente"
- Usuario puede completar información del lead (EP-001-US-002) o asignar pack manualmente

### Validaciones y reglas de negocio
- **Sector detectado:** Sistema intenta detectar sector automáticamente según palabras clave (colegio, escuela, instituto → colegio; empresa, corporativo, organización → empresa)
- **Packs por sector:** Colegios tienen 3 packs posibles, empresas tienen 4 packs posibles
- **Orden de sugerencias:** Packs se ordenan por relevancia según: 1) coincidencia de presupuesto, 2) palabras clave en consulta, 3) sector detectado
- **Asignación obligatoria:** Para marcar lead como cualificado (EP-002-US-002), debe tener pack asignado si es corporativo
- **Unicidad:** Solo se puede asignar un pack por lead
- **Validación de pack:** Pack asignado debe existir y estar activo en el sistema
- **Justificación de sugerencia:** Cada sugerencia debe mostrar razón (sector, presupuesto, palabras clave)

### Criterios BDD
- **Escenario 1: Sugerencia automática exitosa para colegio**
  - *Dado* que un usuario de ONGAKU está cualificando un lead corporativo con sector "colegio" detectado automáticamente
  - *Cuando* el sistema analiza la información y genera sugerencias
  - *Entonces* el sistema muestra los 3 packs disponibles para colegios ordenados por relevancia, con justificación de cada sugerencia, y el usuario puede asignar uno de ellos

- **Escenario 2: Asignación de pack sugerido**
  - *Dado* que un usuario de ONGAKU está viendo las sugerencias automáticas de packs para un lead corporativo
  - *Cuando* selecciona un pack de las sugerencias y hace clic en "Asignar pack"
  - *Entonces* el sistema registra el pack asignado en el lead, muestra confirmación "Pack asignado correctamente", y el lead queda listo para ser marcado como cualificado

- **Escenario 3: Corrección manual de sugerencia**
  - *Dado* que un usuario de ONGAKU está viendo las sugerencias automáticas pero considera que no son adecuadas
  - *Cuando* hace clic en "Ver todos los packs" y selecciona un pack diferente al sugerido
  - *Entonces* el sistema registra el pack seleccionado manualmente y muestra confirmación, independientemente de la sugerencia automática

- **Escenario 4: Sector no detectado automáticamente**
  - *Dado* que un usuario de ONGAKU está cualificando un lead corporativo pero el sistema no puede detectar el sector automáticamente
  - *Cuando* el sistema intenta generar sugerencias
  - *Entonces* el sistema muestra mensaje "No se pudo detectar el sector automáticamente" y muestra lista completa de todos los packs disponibles (colegios y empresas) para selección manual

- **Escenario 5: Error en análisis automático**
  - *Dado* que un usuario de ONGAKU está cualificando un lead corporativo
  - *Cuando* el sistema intenta analizar la información pero falla el procesamiento
  - *Entonces* el sistema muestra mensaje de error "No se pudo generar sugerencia automática" y permite asignar pack manualmente desde lista completa

### Notificaciones
- **Usuario de ONGAKU:** Mensaje de confirmación tras asignar pack: "Pack asignado correctamente"
- **Sistema:** Registro en auditoría de pack asignado (pack anterior si había uno, pack nuevo, usuario, timestamp)
- **No hay notificaciones a otros usuarios en esta US**

### Seguridad
- **Autenticación:** Usuario debe estar autenticado para asignar packs
- **Autorización:** Solo usuarios de ONGAKU con permisos para cualificar leads corporativos pueden asignar packs
- **Validación de datos:** Pack asignado debe existir y estar activo en el sistema
- **Auditoría:** Registro completo de asignación de pack (pack asignado, usuario, timestamp, si fue sugerencia automática o manual)

### Analítica/KPIs
- **Métricas a instrumentar:**
  - Tasa de aceptación de sugerencias automáticas (cuántas veces se acepta la sugerencia vs se corrige)
  - Tiempo promedio desde visualización de sugerencias hasta asignación de pack
  - Precisión de detección automática de sector (colegio vs empresa)
  - Packs más frecuentemente asignados por sector
  - Tasa de corrección manual de sugerencias
- **Objetivo:** 70% de aceptación de sugerencias automáticas, tiempo de asignación < 2 minutos

### Definition of Ready
- [ ] Packs disponibles definidos y configurados en el sistema (3 para colegios, 4 para empresas)
- [ ] Reglas de detección de sector definidas (palabras clave para colegio vs empresa)
- [ ] Algoritmo de sugerencia automática diseñado (cómo se calcula relevancia)
- [ ] Diseño de interfaz de segmentación aprobado (UI/UX)
- [ ] Permisos RBAC definidos para asignación de packs
- [ ] Endpoints del backend disponibles para análisis y asignación
- [ ] Base de datos con estructura de packs y segmentación

### Definition of Done
- [ ] Sugerencia automática de segmentación funciona correctamente según sector, presupuesto y palabras clave
- [ ] Visualización de sugerencias con justificación implementada
- [ ] Asignación de pack funciona correctamente (sugerido o manual)
- [ ] Corrección manual de sugerencia funciona correctamente
- [ ] Manejo de errores implementado (sector no detectado, error en análisis, pack no disponible)
- [ ] Validaciones de seguridad implementadas (autenticación, autorización)
- [ ] Auditoría de asignaciones registrada correctamente
- [ ] Mensajes de confirmación y error se muestran correctamente
- [ ] Pruebas de aceptación pasadas (todos los escenarios BDD)
- [ ] Documentación técnica actualizada
- [ ] Desplegado en entorno de producción

### Riesgos y supuestos
- **Riesgo:** Sugerencias automáticas incorrectas pueden llevar a asignación de pack inadecuado
  - **Probabilidad:** Media
  - **Impacto:** Medio
  - **Mitigación:** Usuario siempre puede corregir manualmente, justificación clara de sugerencias, posibilidad de ver todos los packs

- **Riesgo:** Sector no detectado correctamente puede afectar sugerencias
  - **Probabilidad:** Media
  - **Impacto:** Bajo
  - **Mitigación:** Selección manual de sector disponible, lista completa de packs si no se detecta sector

- **Riesgo:** Información insuficiente del lead limita efectividad de sugerencias
  - **Probabilidad:** Media
  - **Impacto:** Bajo
  - **Mitigación:** Asignación manual siempre disponible, mensaje informativo si información es insuficiente

- **Supuesto:** Packs disponibles están correctamente configurados en el sistema (3 para colegios, 4 para empresas)
- **Supuesto:** Usuario de ONGAKU tiene conocimiento de los packs disponibles para poder validar sugerencias

### Trazabilidad (fuentes)
- Proceso TO-BE: `02-discovery/0202-prd/020203-to-be/processes/TO-BE-002-registro-cualificacion-leads.md`
- Bloque funcional: Segmentación automática sugerida para corporativo
- Paso(s): Pasos 3-5 del flujo principal (sistema sugiere segmentación, usuario valida/corrige, asigna pack)
