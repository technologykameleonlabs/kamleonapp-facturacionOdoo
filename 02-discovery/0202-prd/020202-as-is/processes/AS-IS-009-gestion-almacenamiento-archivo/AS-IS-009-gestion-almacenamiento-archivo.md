---
id: AS-IS-009
name: Gestión de almacenamiento y archivo (Corporativo y Bodas)
slug: gestion-almacenamiento-archivo
status: READY
owner: Kameleonlabs@Kameleonlabs
product: ONGAKU
release: v1.0.0
locale: es-ES
gen_by: ASIS-PROMPT
hash: asis009_almacenamiento_20260120
---

# Gestión de almacenamiento y archivo (Corporativo y Bodas)

## 1. Descripción (AS-IS)

- **Propósito:** Gestionar el almacenamiento, organización y conservación de todos los archivos de proyectos y bodas tanto en la nube como en discos duros físicos, con trazabilidad de ubicación y avisos de eliminación.
- **Frecuencia:** Continua (durante y después de cada proyecto/boda)
- **Actores/roles:** 
  - Equipo de producción
  - Administración
  - Responsables de proyecto
- **Herramientas actuales:** 
  - Nube (almacenamiento en la nube)
  - Discos duros físicos (nombrados con piezas de ajedrez: TABLERO, ALFIL, etc.)
  - Procesos manuales de organización y nombrado
- **Entradas → Salidas:** 
  - **Entradas**: Material en bruto, material final, archivos del proyecto/boda
  - **Salidas**: Archivos organizados y nombrados, ubicación registrada (nube y disco físico), avisos de eliminación/decisión de conservación

## 2. Flujo actual paso a paso

1) Después de entregar producto final, se suben brutos y archivos a la nube
2) Archivos se nombran de manera ordenada
3) Se registra fecha en que se sube proyecto a la nube
4) Se archivan en discos duros físicos
5) Se registra en qué disco duro está guardado (nombres de piezas de ajedrez: TABLERO, ALFIL, etc.)
6) Archivos deben estar al menos un año en la nube
7) Al año debe salir aviso para valorar si se continúa conservando o no el material en su totalidad o en parte
8) Para bodas: aviso cuando hayan pasado 8 meses desde entrega del último archivo final para eliminar archivos finales y brutos de la nube
9) Estructura de almacenamiento:
   - Carpetas principales: PROYECTOS y BODAS
   - Dentro de cada proyecto/boda: presupuesto, facturas, contrato, estado del proyecto, disco duro físico donde está guardado
   - Carpetas de discos duros físicos: cada disco (TABLERO, ALFIL, etc.) contiene proyectos/bodas
   - Dentro de cada proyecto en disco: BRUTOS (por profesional), DRON, FINALES
   - Para bodas en FINALES: FOTOS, TEASER, PELÍCULA, HOMILÍA, CARTAS

## 3. Problemas observados (desde entrevistas/notas. No te limites, registra cualquier problema detectado, empezando por los más relevantes, pero siempre dentro del proceso correspondiente)

- **P1**: Falta de trazabilidad de ubicación - no hay registro claro y centralizado de en qué disco duro físico está cada proyecto _(Fuente: minute-01.md Almacenamiento)_
- **P2**: Avisos manuales de eliminación - avisos al año o a los 8 meses (bodas) requieren intervención manual, pueden olvidarse _(Fuente: minute-01.md Almacenamiento, company-info.md)_
- **P3**: Organización manual de archivos - subida y nombrado de archivos es manual, propenso a errores _(Fuente: minute-01.md Sección 3)_
- **P4**: Falta de estructura clara - no hay sistema centralizado para ver qué archivos están en cada disco físico _(Fuente: minute-01.md Almacenamiento)_
- **P5**: Retención mínima no automatizada - archivos deben estar 1 año en nube pero no hay control automático _(Fuente: minute-01.md Sección 3, company-info.md)_

## 4. Oportunidades de mejora (sin diseñar solución. No te limites, registra cualquier oportunidad detectada, empezando por las más relevantes, pero siempre dentro del proceso correspondiente)

- **O1** (derivada de P1): Sistema de trazabilidad: registro automático de ubicación en nube y disco físico para cada proyecto/boda
- **O2** (derivada de P2): Avisos automáticos de eliminación: alerta al año (proyectos) o 8 meses (bodas) para decidir conservación
- **O3** (derivada de P3): Organización automática de archivos: subida con nombrado estructurado, organización por carpetas
- **O4** (derivada de P4): Estructura visual clara: vista de carpetas PROYECTOS/BODAS, vista de discos físicos, vista de archivos por proyecto
- **O5** (derivada de P5): Control automático de retención: tracking de fechas de subida, alertas de vencimiento de retención mínima
- **O6**: Búsqueda avanzada: encontrar proyectos/bodas por nombre, fecha, disco físico, tipo de archivo
- **O7**: Gestión de espacio: control de espacio utilizado en nube y discos físicos
- **O8**: Backup y redundancia: control de copias de seguridad, verificación de integridad

## 5. Artefactos y datos manipulados

- **Archivos en nube**: material en bruto, material final, organización por carpetas, fecha de subida, fecha de eliminación
- **Archivos en discos físicos**: ubicación (disco: TABLERO, ALFIL, etc.), organización por carpetas (BRUTOS, DRON, FINALES), estructura de archivos
- **Proyecto/Boda**: presupuesto, facturas, contrato, estado, disco físico asociado
- **Retención**: fecha de subida, fecha de vencimiento (1 año proyectos, 8 meses bodas), decisión de conservación
- **Retención/auditoría**: Registro completo de ubicación de archivos, fechas de subida/eliminación, decisiones de conservación

## 6. Indicadores actuales (si existen)

- **Métrica**: Espacio utilizado en nube · **hoy**: No medido sistemáticamente · Origen: No existe tracking
- **Métrica**: Archivos por disco físico · **hoy**: Organización manual, no centralizada · Origen: Registro manual
- **Métrica**: Tasa de archivos que superan retención mínima · **hoy**: No medido · Origen: Avisos manuales

## 7. Consideraciones de accesibilidad e inclusión (si aplica)

- Sistema de búsqueda debe ser accesible (WCAG 2.1 AA)
- Estructura de carpetas debe ser clara y fácil de navegar
- Información de ubicación debe ser comprensible

## 8. Observaciones del cliente

- Importancia crítica de trazabilidad: saber exactamente dónde está cada archivo
- Necesidad de avisos automáticos para gestión de retención
- Estructura debe permitir búsqueda rápida y eficiente

---

**Fuentes**: minute-01.md (Almacenamiento, Corporativo §3), company-info.md (Archivo y Almacenamiento)  
*GEN-BY:ASIS-PROMPT · hash:asis009_almacenamiento_20260120 · 2026-01-20T00:00:00Z*
