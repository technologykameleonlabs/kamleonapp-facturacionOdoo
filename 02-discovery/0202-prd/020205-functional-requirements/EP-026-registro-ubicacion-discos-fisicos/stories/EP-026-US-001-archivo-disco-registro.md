# EP-026-US-001 — Archivo en disco físico y registro de ubicación

### Epic padre
EP-026 — Registro de ubicación en discos físicos

### Contexto/Descripción y valor
**Como** administración o equipo, **quiero** archivar el proyecto/boda en disco físico (TABLERO, ALFIL, etc.) y registrar la ubicación en el sistema (proyecto + disco), **para** tener trazabilidad de dónde está cada archivo.

### Alcance
**Incluye:** Selección de disco físico; archivo del proyecto en disco; registro en sistema (proyecto + disco). **Excluye:** Trazabilidad en BD (EP-026-US-002); búsqueda (EP-026-US-003).

### Precondiciones
- Archivos en nube (EP-025); disco físico disponible; usuario es administración o equipo.

### Postcondiciones
- Proyecto archivado en disco; ubicación registrada en sistema (EP-026-US-002).

### Flujo principal
1. Usuario selecciona disco físico (TABLERO, ALFIL, etc.).
2. Usuario archiva proyecto/boda en disco con organización por carpetas.
3. Usuario registra en sistema: proyecto + disco físico seleccionado.
4. Sistema registra trazabilidad (EP-026-US-002).

### Criterios BDD
- *Dado* que los archivos están en nube y tengo disco físico  
- *Cuando* archivo el proyecto y registro la ubicación  
- *Entonces* la ubicación queda registrada en el sistema

### Trazabilidad
- TO-BE-026.
