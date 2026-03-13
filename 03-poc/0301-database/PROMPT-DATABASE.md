# PROMPT MAESTRO · EP/US → Supabase → DATABASE.yaml

## Objetivo

A partir de las épicas y US, proponer y aplicar cambios de modelo directamente en Supabase y actualizar los artefactos del proyecto:

1. Ejecutar SQL idempotente en Supabase.
2. Regenerar `DATABASE.yaml` y `DATABASE.md`.
3. Inyectar trazabilidad EP y US en `DATABASE.yaml`.
4. Mantener el flujo continuo y auditable en PRs.

## Rol

Actúa como Arquitecto de Datos y DBA PostgreSQL en un entorno Supabase.

**🚨 ORDEN DE EJECUCIÓN OBLIGATORIO (NO MODIFICABLE):**
1. **PRIMERO Y ÚNICO**: Ejecutar `infra/db/sql/app-factory-dm.sql` para crear el esquema "base" completo
2. **DESPUÉS**: Ejecutar épicas en orden (EP-001, EP-002, etc.)
3. **NUNCA**: Recrear o modificar tablas base existentes en épicas posteriores

**⚠️ IMPORTANTE**: El esquema base `app-factory-dm.sql` contiene TODAS las tablas base necesarias. Este archivo debe ejecutarse UNA SOLA VEZ antes de cualquier desarrollo de épicas. Siempre contra un schemaname "base" en supabase, no "public"

## Suposiciones del proyecto

* **Entorno**: PostgreSQL con capacidad de ejecutar SQL directo
* **Raíz del repo**: {project_root} = la carpeta raíz del proyecto donde está el package.json
* **Estructura**: Proyecto con carpetas `03-poc/0301-database/`, `infra/db/`, etc.
* **Herramientas**: Node.js, ts-node, scripts npm configurados

## 🔍 Pre-ejecución: Validación de entorno

### Checklist obligatorio antes de comenzar:

**Dependencias de archivos:**
- ✅ `package.json` existe y contiene scripts requeridos
- ✅ `03-poc/0301-database/` existe con estructura de directorios
- ✅ `03-poc/0301-database/DATABASE.yaml` existe (generado previamente)
- ✅ Conexión a base de datos funcional (verificar con `npm run db:snapshot:yaml`)

**Scripts disponibles en package.json:**
- ✅ `npm run db:snapshot:yaml` disponible
- ✅ `npm run db:snapshot:md` disponible
- ✅ `npm run db:sql <archivo>` disponible
- ✅ Scripts de datos de prueba si son necesarios (ver @PROMPT-seeds.md)


**🚨 ESQUEMA BASE DEL PROYECTO (EJECUTAR PRIMERO):**
- ✅ `infra/db/sql/app-factory-dm.sql` existe (esquema base OBLIGATORIO)
- ✅ **DEBE EJECUTARSE ANTES DE CUALQUIER ÉPICA**
- ✅ Contiene TODAS las tablas base: usuarios, roles, permisos, perfiles, auditoría, configuración
- ✅ Una vez ejecutado, estas tablas NO deben recrearse en épicas posteriores

**Comando para ejecutar esquema base:**
```bash
# ⚠️ EJECUTAR ESTO PRIMERO Y SOLO UNA VEZ
npm run db:sql infra/db/sql/app-factory-dm.sql
```

**🛠️ USO DE POWERSHELL PARA OPERACIONES SEGURAS**
- **RECOMENDADO**: Usar PowerShell para crear archivos temporales y ejecutar comandos
- **Sintaxis**: `@'contenido'@ | Out-File -FilePath "ruta/archivo.ext" -Encoding UTF8`
- **Ventajas**:
  - Evita problemas de encoding con caracteres especiales
  - Manejo robusto de rutas de archivos
  - Mejor control de errores
- **Ejemplo**:
  ```powershell
  $content = @'
  -- SQL content here
  SELECT * FROM table;
  '@;
  $content | Out-File -FilePath "03-poc/0301-database/temp/check_table.sql" -Encoding UTF8;
  ```

**📋 SEEDS Y POBLACIÓN DE DATOS**
- **Prompt específico**: Ver `@PROMPT-seeds.md` para generación de datos de prueba
- **Ubicación**: Seeds en `seeds/seeds_sql/`, temporales en `temp/`
- **Idempotencia**: Todos los seeds deben ser ejecutables múltiples veces
- **Integridad**: Verificar FK antes de poblar datos

**🚨 SECUENCIA DE VALIDACIÓN Y EJECUCIÓN OBLIGATORIA:**
```bash
# PASO 1: Verificar estructura de proyecto
Get-ChildItem package.json, 03-poc/0301-database/

# PASO 2: Verificar scripts disponibles
npm run

# PASO 3: Verificar conexión a BD
npx ts-node infra/db/ts/list-tables.ts

# 🚨 PASO 4: EJECUTAR ESQUEMA BASE (OBLIGATORIO - PRIMERO Y ÚNICO)
# ⚠️  ESTE PASO DEBE EJECUTARSE SOLO UNA VEZ ANTES DE CUALQUIER ÉPICA
npm run db:sql infra/db/sql/app-factory-dm.sql

# PASO 5: ✅ VERIFICACIÓN MANUAL - Verificar ejecución satisfactoria
Write-Host "🚨 ¿Fue la ejecución del esquema base satisfactoria?"
Write-Host "   - Si: Aparecieron mensajes de creación de tablas exitosos"
Write-Host "   - No: Aparecieron errores SQL o de conexión"
$respuesta = Read-Host "Responde 'si' para continuar o 'no' para detener"
if ($respuesta -ne "si") {
    Write-Host "❌ Deteniendo proceso. Revisa los errores antes de continuar."
    exit 1
}

# PASO 6: Verificar que las tablas base se crearon correctamente
Write-Host "🔍 Verificando tablas base creadas..."
npx ts-node infra/db/ts/list-tables.ts

# PASO 7: ✅ VERIFICACIÓN MANUAL - Confirmar tablas base
Write-Host "🚨 ¿Se crearon correctamente TODAS las tablas del esquema base?"
Write-Host "   - Verifica que no haya mensajes de error en la ejecución"
Write-Host "   - Confirma que el número de tablas creadas coincide con lo esperado"
Write-Host "   - Revisa que no falten tablas críticas del sistema"
$tablas_ok = Read-Host "Responde 'si' si todas las tablas se crearon correctamente o 'no' para verificar"
if ($tablas_ok -ne "si") {
    Write-Host "❌ Verifica las tablas base antes de continuar con las épicas."
    exit 1
}

# PASO 8: ✅ PERMISO PARA CONTINUAR
Write-Host "🎉 Esquema base creado exitosamente. ¿Listo para proceder con las épicas?"
$continuar_epicas = Read-Host "Responde 'si' para continuar con EP-001 o 'no' para detener"
if ($continuar_epicas -ne "si") {
    Write-Host "ℹ️  Proceso detenido. Puedes continuar más tarde con las épicas."
    exit 0
}

# PASO 9: Ahora puedes proceder con las épicas (EP-001, EP-002, etc.)
```
### 📋 **🚨 TABLAS BASE DISPONIBLES DESPUÉS DE EJECUTAR app-factory-dm.sql**

**⚠️ CRÍTICO**: Las tablas definidas en `infra/db/sql/app-factory-dm.sql` se crean automáticamente al ejecutar ese archivo. **NO deben recrearse NUNCA en épicas posteriores**.

**Después de ejecutar el esquema base, tendrás disponibles:**

**📋 Lista dinámica de tablas:**
- Consulta `infra/db/sql/app-factory-dm.sql` para ver todas las tablas que se crearán
- Todas las tablas definidas en ese archivo estarán disponibles para su uso
- El esquema base proporciona la estructura fundamental del sistema

**🔍 Para ver qué tablas están disponibles:**
```bash
# Después de ejecutar el esquema base
npx ts-node infra/db/ts/list-tables.ts
```

**Nota importante:**
- Las tablas específicas pueden variar según la versión actual de `app-factory-dm.sql`
- Todas las tablas del esquema base son críticas para el funcionamiento del sistema
- Nunca modifiques o elimines estas tablas en épicas posteriores

**Estrategias para trabajar con tablas base:**

1. **🔗 Referenciar directamente**: Usar FKs a tablas base existentes
2. **➕ Extender campos**: Agregar columnas con `ALTER TABLE` si es necesario
3. **🔗 Crear relaciones**: Tablas relacionadas para datos específicos
4. **📊 Reutilizar**: Aprovechar roles/permisos existentes
5. **🚫 NO recrear**: Nunca crear `mst_users`, `mst_roles`, etc. en épicas

* Scripts disponibles en `package.json`:

  * `npm run db:link`
  * `npm run db:migration:new`
  * `npm run db:push`
  * `npm run db:update`  ← ejecuta `db:push` y después `db:snapshot:yaml` y `db:snapshot:md`
  * `npm run db:snapshot:yaml`
  * `npm run db:snapshot:md`
  * `npm run db:sql <archivo.sql>` ← ejecutar SQL suelto en Supabase
  * `npm run seeds:apply` ← aplicar archivos SQL de seeds (ver @PROMPT-seeds.md)
* `DATABASE.yaml` y `DATABASE.md` viven en `/03-poc/0301-database/`
* **Seeds**: Ver `@PROMPT-seeds.md` para generación de datos de prueba
* **SQL por épica**: Archivos SQL específicos van en `/03-poc/0301-database/sql/`
* **Archivos temporales**: Usar carpetas `/temp/` designadas (se pueden borrar periódicamente)

## 🗂️ **ORGANIZACIÓN DE ARCHIVOS**

### **Estructura de Carpetas**

```
03-poc/0301-database/
├── DATABASE.yaml              # Schema canónico (actualizado automáticamente)
├── DATABASE.md               # Documentación (actualizada automáticamente)
├── sql/                      # SQL específico por épica
│   ├── ep001_configuracion_maestros.sql
│   ├── ep002_creacion_configuracion_proyectos.sql
│   └── temp/                 # 🆕 ARCHIVOS TEMPORALES DE SQL
├── seeds/                    # Datos maestros
│   ├── sources/              # Archivos fuente originales
│   ├── seeds_sql/            # SQL generado por tabla
│   │   ├── 001_entities.sql
│   │   ├── 002_roles.sql
│   │   └── ...
│   └── temp/                 # 🆕 ARCHIVOS TEMPORALES DE SEEDS
└── temp/                     # 🆕 ARCHIVOS TEMPORALES GENERALES

infra/db/                     # 🆕 INFRAESTRUCTURA REUTILIZABLE
├── sql/                      # Scripts SQL reutilizables
│   ├── extend_base_table.sql          # Extender tablas base
│   └── check_referential_integrity.sql # Verificar integridad
├── ts/                       # Scripts TypeScript reutilizables
│   ├── database-health-check.ts       # Verificación de salud BD
│   └── database-snapshot-manager.ts   # Gestión de snapshots
├── run-sql.ts               # Ejecutor de SQL
├── schema-to-yaml.ts        # Generador de YAML
├── yaml-to-md.ts           # Generador de MD
├── apply-seeds.ts          # Aplicador de seeds
└── ...
```

### **Política de Archivos por Ubicación**

#### **📁 Archivos Temporales**
- **Ubicaciones permitidas**: `temp/`
- **Propósito**: Archivos de trabajo, debugging y testing
- **Gestión**: Se pueden borrar periódicamente sin afectar el proyecto
- **Regla crítica**: NUNCA crear archivos temporales fuera de carpetas `temp/`

#### **📁 Seeds**
- **Ubicación**: `seeds/seeds_sql/` para archivos finales
- **Prompt específico**: Ver `@PROMPT-seeds.md` para generación de datos
- **Idempotencia**: Seeds reutilizables con manejo de conflictos

#### **📁 `infra/db/sql/`**
- **Propósito**: Scripts SQL reutilizables y agnósticos
- **Características**:
  - Parametrizables con variables psql
  - Configurables con JSON
  - Documentación interna completa
  - Ejemplos de uso incluidos
- **Scripts disponibles**:
  - `extend_base_table.sql` - Extender tablas base con campos adicionales
  - `check_referential_integrity.sql` - Verificar integridad referencial

#### **📁 `infra/db/ts/`**
- **Propósito**: Utilidades TypeScript reutilizables
- **Características**:
  - Clases bien documentadas
  - Interfaces TypeScript
  - Manejo de errores robusto
  - Logging detallado
- **Scripts disponibles**:
  - `database-health-check.ts` - Verificación completa de salud BD
  - `database-snapshot-manager.ts` - Gestión avanzada de snapshots

### **Flujo de Trabajo Recomendado**

```bash
# 1. Crear archivos temporales en carpetas /temp/
# Ejemplo: /temp/debug_user_creation.sql

# 2. Si el archivo es reutilizable, moverlo a infra/db/
# mv /temp/extend_table.sql infra/db/sql/extend_base_table.sql

# 3. Limpiar archivos temporales periódicamente
# rm -rf 03-poc/0301-database/*/temp/*
```

### **Scripts Reutilizables - Guía de Uso**

#### **🔧 `extend_base_table.sql`**
```bash
# Configurar variables al inicio del script
\set table_schema 'base'
\set table_name 'mst_users'

# Ejecutar el script completo
npm run db:sql infra/db/sql/extend_base_table.sql
```

#### **🔍 `check_referential_integrity.sql`**
```bash
# Configurar esquemas y tablas al inicio
npm run db:sql infra/db/sql/check_referential_integrity.sql
```

#### **📊 `database-health-check.ts`**
```bash
# Verificar salud completa de la BD
npx ts-node infra/db/ts/database-health-check.ts

# Guardar reporte
npx ts-node infra/db/ts/database-health-check.ts --save
```

#### **📸 `database-snapshot-manager.ts`**
```bash
# Crear snapshot
npx ts-node infra/db/ts/database-snapshot-manager.ts create

# Comparar snapshots
npx ts-node infra/db/ts/database-snapshot-manager.ts compare snap1.json snap2.json

# Generar rollback
npx ts-node infra/db/ts/database-snapshot-manager.ts rollback snapshot.json
```

## Fuentes a leer

* Épicas e historias:

  * `/02-discovery/0202-prd/020205-functional-requirements/**/EP-*/`
  * `/02-discovery/0202-prd/020205-functional-requirements/**/stories/*`
* Glosario:

  * `/02-discovery/0202-prd/020210-glossary/**/*`
* Base técnica d00:

  * `infra/db/sql/app-factory-dm.sql` - **ESQUEMA BASE OBLIGATORIO** que debe ejecutarse primero

## Reglas clave del flujo

1. **Esquema base primero**: Ejecutar `infra/db/sql/app-factory-dm.sql` ANTES de cualquier épica.
2. **No recrear tablas base**: Las tablas de `app-factory-dm.sql` ya existen. Úsalas, extiéndelas, pero NO las recrees.
3. Supabase es la fuente de verdad. No escribas ficheros SQL de diseño fuera de Supabase. Si necesitas SQL, ejecútalo directamente.
4. Cada lote de cambios sigue el ciclo: Analizar → **Proponer con Validación** → Ejecutar en Supabase → `npm run db:update` → Verificar → Trazabilidad en YAML.
5. No crear vistas ni RLS en esta fase. Enfoque solo DDL y constraints.
6. Evita duplicar entidades. Extiende tablas existentes si aplica. Documenta qué EP y US justifican cada columna nueva.
7. Cohesión padre-hijo en el mismo dominio funcional.
8. **NOMENCLATURA OBLIGATORIA**: tablas y columnas en inglés con snake\_case.
   **PREFIJOS REQUERIDOS** (NO crear tablas sin prefijo):
   - `mst_` maestras (datos maestros, catálogos - approval.mst_workflows)
   - `trn_` transaccionales (operaciones de negocio - approval.trn_entity_workflows)
   - `evt_` eventos (logs de eventos del sistema)
   - `cat_` catálogos (listas controladas)
   - `cfg_` configuración (settings del sistema - approval.cfg_workflow_notifications)
   - `log_` logs/auditoría (approval.log_workflow_approvals)
   - `rel_` relaciones N:M (tablas de cruce)

   **⚠️ CRÍTICO**: El prefijo determina el propósito y comportamiento de la tabla. Todas las nuevas tablas DEBEN tener prefijo correcto.

## 🏗️ Mejores prácticas específicas

### Organización por esquemas funcionales
- **Principio**: No usar solo `public` - crear esquemas por dominio funcional
- **Ejemplos de esquemas**:
  - `projects` - Tablas relacionadas con gestión de proyectos
  - `tasks` - Tablas relacionadas con gestión de tareas
  - `users` - Tablas relacionadas con gestión de usuarios y roles
  - `masterdata` - Tablas maestras compartidas
  - `reporting` - Vistas y tablas para reportes
- **Beneficios**: Mejor organización, permisos granulares, reducción de conflictos
- **Sintaxis**: `CREATE SCHEMA IF NOT EXISTS {schema_name};`
- **Comentarios**: `COMMENT ON SCHEMA {schema_name} IS '{descripción funcional}';`
- **Grants**: `GRANT USAGE ON SCHEMA {schema_name} TO {role};`
- **Search path**: `SET search_path TO {schema_name}, public;` para queries simplificadas

### Diseño de tablas
- **Campos obligatorios**: `id` (UUID), `created_at`, `updated_at` en todas las tablas
- **Campos opcionales comunes**: `deleted_at` para soft deletes, `metadata jsonb` para datos flexibles
- **Constraints**: NOT NULL por defecto, usar CHECK constraints para validaciones de negocio
- **Enums**: Crear tipos personalizados con `CREATE TYPE` para valores controlados

### Estrategias para extender tablas base
- **Principio**: Las tablas base (`mst_users`, `mst_roles`, etc.) no se recrean, se extienden
- **Agregar campos**: `ALTER TABLE base.mst_users ADD COLUMN {campo} {tipo};`
- **Campos calculados**: Para datos derivados de tablas base
- **Tablas relacionadas**: Crear tablas específicas que referencien tablas base
- **Vistas**: Para combinar datos de múltiples tablas base
- **Triggers**: Para mantener consistencia entre extensiones y tablas base

**Ejemplos de extensiones permitidas:**
```sql
-- ✅ Agregar campos a tabla base existente
ALTER TABLE base.mst_users
ADD COLUMN IF NOT EXISTS last_login timestamptz,
ADD COLUMN IF NOT EXISTS account_locked boolean DEFAULT false;

-- ✅ Crear tabla relacionada con tabla base
CREATE TABLE project_user_settings (
    user_id uuid REFERENCES base.mst_users(id),
    project_id uuid REFERENCES base.trn_projects(id),
    settings jsonb DEFAULT '{}',
    PRIMARY KEY (user_id, project_id)
);

-- ✅ Extender con campos calculados
ALTER TABLE base.mst_users
ADD COLUMN IF NOT EXISTS full_name text GENERATED ALWAYS AS (
    COALESCE(name, '') || ' ' || COALESCE(surname, '')
) STORED;
```

**❌ NO PERMITIDO:**
```sql
-- ❌ Recrear tabla base
CREATE TABLE base.mst_users (...); -- ¡ERROR!

-- ❌ Modificar constraints existentes sin justificación
ALTER TABLE base.mst_users DROP CONSTRAINT ...; -- ¡PRECAUCIÓN!
```

### Índices estratégicos
- **Búsqueda**: Índices en campos de WHERE, JOIN y ORDER BY frecuentes
- **Unicidad**: Índices únicos para claves naturales (no solo PK)
- **Compuestos**: Índices multi-columna para consultas complejas
- **Parciales**: WHERE deleted_at IS NULL para tablas con soft delete

### Relaciones y FKs
- **Cascade**: UPDATE CASCADE, DELETE RESTRICT (evitar CASCADE automático)
- **Nombres**: `fk_{tabla_padre}_{tabla_hija}_{campo}` para claridad
- **Validación**: Verificar referencias circulares y dependencias

### Performance
- **Tipos de datos**: TEXT vs VARCHAR, INTEGER vs BIGINT según necesidades
- **JSONB**: Para datos semi-estructurados con índices GIN
- **Partitioning**: Considerar para tablas grandes (>1M registros)

### Consideraciones específicas de esquemas
- **Dependencias entre esquemas**: Documentar si un esquema depende de tipos/enums de otro
- **Migración de tablas existentes**: Estrategia para mover tablas de `public` a esquemas específicos
- **Backup por esquema**: `pg_dump --schema={schema_name}` para respaldos selectivos
- **Testing por esquema**: Ejecutar tests en esquemas específicos para aislamiento
- **Monitoreo por esquema**: Queries para analizar uso y performance por esquema

### Funciones SQL inteligentes como motor de negocio
- **Principio**: La lógica de negocio pertenece a la base de datos, no solo a la aplicación
- **Beneficios**: Cálculos automáticos, integridad de datos, performance mejorada
- **Patrones probados**:
  - Funciones de cálculo automático (progress, KPIs, riesgos)
  - Validadores de integridad (ciclos, dependencias)
  - Generadores de códigos únicos (secuencias, códigos de proyecto)
- **Ejemplos exitosos**: `calculate_project_progress()`, `assess_project_risks()`, `calculate_kpi_value()`

### Cross-schema relationships avanzadas
- **Patrón**: Esquemas funcionales con referencias entre sí
- **Beneficios**: Modularidad + Integridad referencial
- **FKs cross-schema**: `ON UPDATE CASCADE ON DELETE RESTRICT` por defecto
- **Nomenclatura**: `fk_{esquema_origen}_{esquema_destino}_{campo}`

### Sistemas RBAC (Role-Based Access Control)
- **Principio**: Control de acceso basado en roles con permisos granulares
- **Componentes clave**: Roles, permisos, asignaciones, overrides, auditoría
- **Patrones probados**:
  - Roles globales vs roles por contexto (proyecto, organización)
  - Herencia de permisos con jerarquía de roles
  - Overrides granulares por usuario/contexto
  - Auditoría completa de accesos y cambios
- **Estructura recomendada**: Esquema dedicado para seguridad con tablas de roles, permisos, asignaciones y auditoría

### Auditoría y compliance
- **Principio**: Todo acceso y cambio debe ser auditado para compliance y seguridad
- **Campos obligatorios**: usuario, acción, recurso, timestamp, resultado, metadatos
- **Patrones de auditoría**:
  - Logs inmutables (sin updates/deletes después de creación)
  - Campos JSON para metadatos flexibles y extensibles
  - Índices compuestos por (usuario, fecha, acción)
  - Retención configurable por tipo de evento y regulaciones
- **Monitoreo**: Queries automatizadas para detectar patrones sospechosos

### Validaciones de negocio en BD
- **Principio**: Las reglas de negocio críticas deben validarse en la base de datos
- **Patrones probados**:
  - Funciones de validación que retornan boolean/estado
  - Constraints CHECK con lógica compleja
  - Triggers para validaciones automáticas
  - Tablas de configuración para reglas parametrizables
- **Beneficios**: Consistencia, performance, seguridad contra manipulación

### Identificación y uso de tablas base
- **Prefijos de tablas base**: `mst_` (maestras), `dat_` (datos), `cfg_` (configuración), `log_` (logging), `rel_` (relaciones)
- **Antes de crear tabla**: Verificar si ya existe en `app-factory-dm.sql`
- **Si existe**: Referenciar con FKs, extender con campos adicionales, crear tablas relacionadas
- **Si no existe**: Crear nueva tabla siguiendo convenciones del proyecto
- **Query de verificación**:
  ```sql
  -- Verificar si tabla ya existe
  SELECT table_name FROM information_schema.tables
  WHERE table_schema = 'public' AND table_name = 'mst_users';
  ```

**Ejemplos de reutilización de tablas base:**

```sql
-- ✅ CORRECTO: Extender tabla base existente
ALTER TABLE base.mst_users
ADD COLUMN IF NOT EXISTS department varchar(100),
ADD COLUMN IF NOT EXISTS employee_id varchar(20) UNIQUE;

-- ✅ CORRECTO: Crear tabla relacionada
CREATE TABLE project_user_preferences (
    user_id uuid REFERENCES base.mst_users(id),
    project_id uuid REFERENCES base.trn_projects(id),
    preferences jsonb DEFAULT '{}',
    PRIMARY KEY (user_id, project_id)
);

-- ✅ CORRECTO: Usar roles existentes
INSERT INTO base.mst_roles (name, description)
VALUES ('project_manager', 'Gestor de proyectos')
ON CONFLICT (name) DO NOTHING;
```

**Análisis de impacto obligatorio:**
- **Antes de modificar tabla base**: Evaluar impacto en otras épicas
- **Documentar extensiones**: Registrar qué épica agregó qué campos
- **Mantener compatibilidad**: Las extensiones deben ser opcionales (IF NOT EXISTS)

## Estructura de trabajo en esta sesión

### Paso 1. Lectura exhaustiva por épica

* **OBLIGATORIO**: Lee TODAS las historias de usuario de la épica sin excepción (incluso las de baja prioridad).
* Lista todas las US con su código, título y prioridad.
* Identifica entidades, relaciones, claves naturales, catálogos, enumeraciones.
* Documenta todos los requerimientos, incluyendo los aparentemente menores.

Salida detallada de validación:

```
EP-{NN} leída completamente. Historias encontradas: [{códigos completos}] total {n}

📋 Resumen de historias por prioridad:
- 🔴 Alta: {lista de US alta prioridad}
- 🟡 Media: {lista de US media prioridad}
- 🟢 Baja: {lista de US baja prioridad}

📁 Archivos revisados:
{lista completa de archivos leídos con rutas}

🎯 Entidades identificadas:
- Tablas nuevas requeridas: {lista}
- Tablas a extender: {lista}
- Relaciones N:M necesarias: {lista}
- Enums requeridos: {lista}

🏗️ Esquemas funcionales propuestos:
- {schema_name}: {descripción} ({tablas principales})
- {schema_name}: {descripción} ({tablas principales})

⚠️ Pre-requisitos identificados:
{lista de dependencias o pre-condiciones}
📋 Dependencias entre esquemas: {si aplica}
```

### Paso 2. PROPUESTA DETALLADA DE CAMBIOS (VALIDACIÓN OBLIGATORIA)

**🚨 VALIDACIÓN PREVIA OBLIGATORIA: Antes de ejecutar cualquier cambio en Supabase, el sistema DEBE mostrar una propuesta completa por chat y esperar la aprobación explícita del usuario.**

#### **Formato de Propuesta Detallada:**

```markdown
# 📋 PROPUESTA DE CAMBIOS PARA EP-{XX}

## 🎯 Resumen Ejecutivo
- **Épica**: EP-{XX} - {Título de la épica}
- **Historias de usuario**: {lista completa de US}
- **Impacto estimado**: {tablas nuevas, extensiones, funciones}
- **Riesgo**: {Alto/Medio/Bajo}
- **Tiempo estimado de ejecución**: {X minutos}

## 🏗️ Cambios Técnicos Propuestos

### **Tablas Nuevas:**
1. **{schema}.{table_name}** - {descripción funcional}
   - Campos: {lista de campos con tipos}
   - Relaciones: {FKs con otras tablas}
   - Índices: {índices estratégicos}
   - Justificación: {razón de negocio}

2. **{schema}.{table_name}** - {descripción funcional}
   ...

### **Extensiones a Tablas Existentes:**
1. **{schema}.{existing_table}**
   - Campos nuevos: {campo1 tipo, campo2 tipo}
   - Justificación: {razón específica de negocio}
   - Impacto: {compatibilidad backward}

### **Funciones SQL Inteligentes:**
1. **{schema}.{function_name}()** - {descripción}
   - Propósito: {qué calcula/valida}
   - Parámetros: {tipos y descripciones}
   - Lógica: {algoritmo resumido}

### **Índices Estratégicos:**
- **{schema}.{table}**: {tipo de índice} en {campos}
- **{schema}.{table}**: {tipo de índice} en {campos}

## 🔗 Relaciones Cross-Schema
- **{schema1}.{table1}** → **{schema2}.{table2}**: {tipo de relación}
- **{schema1}.{table1}** → **{schema2}.{table2}**: {tipo de relación}

## 📊 Trazabilidad Completa
- **EP-{XX}-US-001** → {schema}.{table}.{campo}: {justificación}
- **EP-{XX}-US-002** → {schema}.{function}(): {justificación}

## ⚠️ Consideraciones de Riesgo
- **Datos existentes**: {impacto en datos existentes}
- **Performance**: {impacto en consultas existentes}
- **Rollback**: {plan de reversión si algo falla}

## ✅ Checklist de Validación
- [ ] Todas las US están mapeadas a cambios específicos
- [ ] No hay duplicación de entidades
- [ ] FKs tienen sentido y no crean ciclos
- [ ] Índices están optimizados para patrones de consulta
- [ ] Funciones SQL son idempotentes
- [ ] Constraints son apropiados y no restrictivos en exceso
- [ ] Nombres siguen convenciones del proyecto
- [ ] Comentarios están en inglés (evitar problemas de encoding)

## 🚀 Próximos Pasos (Después de Aprobación)
1. Generar SQL idempotente
2. Ejecutar cambios en Supabase
3. Actualizar snapshots (DATABASE.yaml, DATABASE.md)
4. Verificar integridad
5. Actualizar trazabilidad

---

**¿APROBAR esta propuesta?** Responda:
- ✅ **SÍ**: Proceder con la ejecución
- 🔄 **AJUSTAR**: Especificar qué cambiar
- ❌ **CANCELAR**: Detener el proceso
```

#### **Flujo de Validación Obligatorio:**

1. **Mostrar propuesta completa** por chat
2. **Esperar respuesta explícita** del usuario
3. **Si aprobado**: Continuar con ejecución
4. **Si ajustes**: Modificar propuesta y volver a mostrar
5. **Si cancelado**: Detener proceso completamente

#### **Ejemplo de Respuesta Esperada:**
```markdown
✅ APROBADO: La propuesta se ve bien, proceder con la ejecución.
```

O bien:
```markdown
🔄 AJUSTES REQUERIDOS:
- Cambiar nombre de tabla X por Y
- Agregar campo Z a tabla W
- Modificar función para incluir validación adicional
```

### Paso 3. Generación de SQL idempotente

* Escribe SQL compatible con PostgreSQL 15 y Supabase. Evita IF NOT EXISTS en funciones.
* Para enums usa bloque DO seguro.
* Asegura `on update cascade` y `on delete restrict` salvo justificación.

Plantillas rápidas:

```sql
-- Crear esquema funcional con configuración completa
CREATE SCHEMA IF NOT EXISTS {schema_name};
COMMENT ON SCHEMA {schema_name} IS '{descripción del dominio funcional}';

-- Configurar permisos del esquema
GRANT USAGE ON SCHEMA {schema_name} TO {role_name};
GRANT CREATE ON SCHEMA {schema_name} TO {admin_role};

-- Configurar search_path para el esquema (opcional)
-- ALTER ROLE {role_name} SET search_path TO {schema_name}, public;

-- Nueva tabla completa en esquema específico
create table if not exists {schema}.{table} (
  id uuid primary key default gen_random_uuid(),
  {cols...},
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Extensión de tabla existente
alter table base.{table}
  add column if not exists {col} {type} {nullability} {default};

-- Enum seguro
do $$ begin
  create type base.{table}_{field}_type as enum ('VALOR_A', 'VALOR_B', 'VALOR_C');
exception when duplicate_object then null; end $$;

-- Índices esenciales
create index if not exists idx_{table}_{col} on {schema}.{table}({col});
create unique index if not exists idx_{table}_{col}_unique on {schema}.{table}({col}) where deleted_at is null;

-- Foreign Key con nombre descriptivo (entre esquemas si es necesario)
alter table {schema}.{table}
  add constraint fk_{table}_{referenced_table}_{col}
  foreign key ({col}) references {referenced_schema}.{referenced_table}(id)
  on update cascade on delete restrict;

-- Constraint de validación
alter table {schema}.{table}
  add constraint chk_{table}_{col}_valid
  check ({col} in ('VALOR_A', 'VALOR_B', 'VALOR_C'));

-- Índice compuesto para consultas frecuentes
create index if not exists idx_{table}_{col1}_{col2} on {schema}.{table}({col1}, {col2});

-- Migrar tabla existente de public a esquema específico
-- ALTER TABLE base.{table} SET SCHEMA {new_schema};

-- Verificar esquemas disponibles
SELECT schema_name FROM information_schema.schemata
WHERE schema_name NOT LIKE 'pg_%' AND schema_name != 'information_schema'
ORDER BY schema_name;

-- Listar tablas por esquema
SELECT schemaname, tablename
FROM pg_tables
WHERE schemaname IN ('{schema1}', '{schema2}', '{schema3}')
ORDER BY schemaname, tablename;

-- Función de cálculo automático (patrón probado)
CREATE OR REPLACE FUNCTION {schema}.calculate_{entity}_{metric}({entity}_id uuid)
RETURNS numeric AS $$
DECLARE
    result_record record;
    calculated_value numeric;
BEGIN
    -- Obtener datos para cálculo
    SELECT * INTO result_record
    FROM {source_table}
    WHERE id = {entity}_id;

    IF NOT FOUND THEN
        RETURN 0;
    END IF;

    -- Lógica de cálculo específica
    -- SELECT {calculation_logic} INTO calculated_value;

    -- Insertar/actualizar resultado
    INSERT INTO {schema}.{result_table} ({entity}_id, calculated_value, calculated_at)
    VALUES ({entity}_id, calculated_value, now())
    ON CONFLICT ({entity}_id)
    DO UPDATE SET
        calculated_value = EXCLUDED.calculated_value,
        calculated_at = now();

    RETURN calculated_value;
END;
$$ LANGUAGE plpgsql;

-- Foreign Key cross-schema (patrón probado)
ALTER TABLE {schema}.{table}
ADD CONSTRAINT fk_{schema}_{referenced_schema}_{table}_{column}
FOREIGN KEY ({column}) REFERENCES {referenced_schema}.{referenced_table}(id)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Extensión de tabla existente con campo calculado
ALTER TABLE {existing_schema}.{existing_table}
ADD COLUMN IF NOT EXISTS {new_column} {type} DEFAULT {default_value},
ADD COLUMN IF NOT EXISTS {new_column}_updated_at timestamptz DEFAULT now();

-- Función de validación de acceso RBAC (patrón probado)
CREATE OR REPLACE FUNCTION {security_schema}.validate_user_access(p_user_id uuid, p_context_id uuid DEFAULT NULL, p_permission_name varchar DEFAULT NULL)
RETURNS boolean AS $$
DECLARE
    has_global_access boolean := false;
    has_context_access boolean := false;
    has_override boolean := false;
BEGIN
    -- Validar acceso global (sin contexto específico)
    IF p_context_id IS NULL THEN
        SELECT EXISTS(
            SELECT 1
            FROM {security_schema}.user_roles ur
            JOIN {security_schema}.role_permissions rp ON ur.role_id = rp.role_id
            JOIN {security_schema}.permissions p ON rp.permission_id = p.id
            WHERE ur.user_id = p_user_id
            AND p.name = COALESCE(p_permission_name, 'read')
            AND ur.is_active = true
            AND rp.is_active = true
            AND p.is_active = true
        ) INTO has_global_access;

        RETURN has_global_access;
    END IF;

    -- Validar acceso por contexto (proyecto, organización, etc.)
    SELECT EXISTS(
        SELECT 1
        FROM {security_schema}.context_members cm
        JOIN {security_schema}.role_permissions rp ON cm.role_id = rp.role_id
        JOIN {security_schema}.permissions p ON rp.permission_id = p.id
        WHERE cm.user_id = p_user_id
        AND cm.context_id = p_context_id
        AND cm.is_active = true
        AND p.name = COALESCE(p_permission_name, 'read')
        AND rp.is_active = true
        AND p.is_active = true
    ) INTO has_context_access;

    -- Verificar overrides específicos
    SELECT EXISTS(
        SELECT 1
        FROM {security_schema}.user_permission_overrides upo
        JOIN {security_schema}.permissions p ON upo.permission_id = p.id
        WHERE upo.user_id = p_user_id
        AND upo.context_id = p_context_id
        AND upo.is_active = true
        AND p.name = COALESCE(p_permission_name, 'read')
        AND (upo.expires_at IS NULL OR upo.expires_at > now())
        AND upo.override_type = 'grant'
    ) INTO has_override;

    RETURN has_context_access OR has_override;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Función de auditoría automática (patrón probado)
CREATE OR REPLACE FUNCTION {security_schema}.audit_action(
    p_user_id uuid,
    p_action varchar,
    p_resource_type varchar,
    p_resource_id uuid DEFAULT NULL,
    p_context_id uuid DEFAULT NULL,
    p_result varchar DEFAULT 'success',
    p_details jsonb DEFAULT NULL
)
RETURNS void AS $$
BEGIN
    INSERT INTO {security_schema}.audit_log (
        user_id,
        action,
        resource_type,
        resource_id,
        context_id,
        result,
        details,
        ip_address,
        user_agent
    ) VALUES (
        p_user_id,
        p_action,
        p_resource_type,
        p_resource_id,
        p_context_id,
        p_result,
        p_details,
        inet_client_addr(),
        current_setting('request.headers', true)::json->>'user-agent'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para auditoría automática (patrón probado)
CREATE OR REPLACE FUNCTION {security_schema}.audit_trigger_function()
RETURNS trigger AS $$
DECLARE
    action_type varchar;
    resource_id uuid;
BEGIN
    -- Determinar el tipo de acción
    IF TG_OP = 'INSERT' THEN
        action_type := 'create';
        resource_id := NEW.id;
    ELSIF TG_OP = 'UPDATE' THEN
        action_type := 'update';
        resource_id := NEW.id;
    ELSIF TG_OP = 'DELETE' THEN
        action_type := 'delete';
        resource_id := OLD.id;
    END IF;

    -- Registrar en auditoría (usando session variables para user_id)
    PERFORM {security_schema}.audit_action(
        current_setting('app.current_user_id', true)::uuid,
        action_type,
        TG_TABLE_NAME,
        resource_id,
        CASE WHEN TG_TABLE_NAME LIKE '%project%' THEN resource_id ELSE NULL END,
        'success',
        jsonb_build_object(
            'operation', TG_OP,
            'table', TG_TABLE_NAME,
            'timestamp', now()
        )
    );

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### Paso 4. Ejecución en Supabase

* Ejecuta los cambios de estructura mediante el mecanismo del proyecto.
* En este proyecto, tras escribir el SQL y aplicar cambios, se refresca el snapshot con un único comando.


### Paso 5. Verificación y trazabilidad en `DATABASE.yaml`

* Abre el `03-poc/0301-database/DATABASE.yaml` recién generado.
* Localiza las tablas y columnas afectadas y añade o actualiza el bloque de trazabilidad manteniendo el resto del YAML intacto.
* Usa esta forma de sección, ampliando registros existentes si ya hay uno similar:

```yaml
traceability:
  epics:
    - code: EP-01
      title: {título épica}
      stories:
        - code: EP-01-US-003
          title: {título}
          impacts:
            - table: base.trn_project
              columns: [code, name]
              rationale: Generar y consultar proyectos por código único
        - code: EP-01-US-005
          title: {título}
          impacts:
            - table: base.trn_project
              columns: [org_id]
              rationale: Vincular proyecto a organización
  last_update: "{fecha_iso}"
```

* Si tu generador `infra/db/ts/schema-to-yaml.ts` ya crea un contenedor para trazabilidad, actualiza dentro. Si no existe, crea el bloque `traceability` al final del archivo sin alterar los nodos generados automáticamente.

### Paso 6. Salidas de control y PR

* Presenta un resumen compacto con:

  * EP y US cubiertas
  * Tablas nuevas y tablas extendidas
  * Lista de índices y FKs creados
  * Secciones del YAML modificadas
* No subas ficheros fuera de:

  * `03-poc/0301-database/DATABASE.yaml`
  * `03-poc/0301-database/DATABASE.md`
  * `03-poc/0301-database/sql/ep{XX}_{descripcion}.sql` (UN SOLO archivo SQL por épica - los temporales se eliminan automáticamente)
  * Archivos de datos de prueba (ver @PROMPT-seeds.md)

### 📁 Estructura de archivos recomendada

```
03-poc/0301-database/
├── DATABASE.yaml              # Schema canónico (actualizado automáticamente)
├── DATABASE.md               # Documentación (actualizada automáticamente)
├── sql/                      # UN SOLO archivo SQL por épica (los temporales se eliminan)
│   ├── ep001_{domain}.sql    # DDL completo de EP-001
│   ├── ep002_{domain}.sql                  # DDL completo de EP-002 (cuando se implemente)
│   └── ep003_{domain}.sql                  # DDL completo de EP-003 (cuando se implemente)
├── temp/                     # Archivos temporales - SE BORRAN AUTOMÁTICAMENTE
│   └── (vacío - archivos temporales eliminados después de cada épica)
└── seeds/                    # Datos maestros (si aplica)
    ├── sources/              # Archivos fuente (opcional - para datos existentes)
    │   ├── *.txt
    │   └── *.md
    ├── manifest.yaml         # Configuración de orden de aplicación de seeds
    └── seeds_sql/            # SQL generado manualmente

infra/db/                     # Scripts generales de infraestructura
├── run-sql.ts               # Ejecutor de SQL
├── schema-to-yaml.ts        # Generador de YAML
├── yaml-to-md.ts           # Generador de MD
└── apply-seeds.ts          # Aplicador de seeds
```

## Checks obligatorios antes de cerrar el lote

* **🚨 Esquema base ejecutado**: Verificar que `infra/db/sql/app-factory-dm.sql` fue ejecutado previamente y que todas las tablas base existen (comando: `npx ts-node infra/db/ts/list-tables.ts`).
* **✅ Verificación manual del esquema base**: Confirmar que se realizó la verificación manual después de ejecutar el esquema base, incluyendo confirmación de que todas las tablas definidas en `app-factory-dm.sql` se crearon correctamente.
* **Lectura completa**: TODAS las historias de usuario de la épica han sido leídas y consideradas.
* Todas las US leídas de la épica están mapeadas a columnas específicas.
* No se han duplicado entidades ya existentes.
* **Validación previa obligatoria**: Se mostró propuesta completa por chat y fue aprobada explícitamente por el usuario.
* **Organización por esquemas**: Tablas agrupadas lógicamente por dominio funcional (no todo en `public`).
* PK, NK, FKs, índices y constraints coherentes (incluyendo referencias entre esquemas).
* SQL idempotente y válido, compatible con esquemas personalizados.
* `DATABASE.yaml` actualizado con trazabilidad completa y fecha (incluyendo esquemas).
* `DATABASE.md` regenerado con documentación de esquemas.
* Verificación de integridad: FKs válidas entre esquemas, índices no duplicados, constraints coherentes.
* Performance básica: índices en campos de búsqueda frecuentes, tipos de datos apropiados.
* **Verificación de archivos**: Antes de ejecutar SQL, confirmar que los archivos se crearon correctamente en las rutas esperadas.
* **Feedback de ejecución**: Scripts deben mostrar progreso claro y errores específicos, no fallar silenciosamente.
* **Encoding consistente**: Todos los archivos SQL deben crearse con UTF-8 sin BOM para evitar errores de caracteres especiales.

## 🧹 **REGLAS DE LIMPIEZA DE ARCHIVOS OBLIGATORIAS**

### **Política de archivos por épica:**
* **🚨 UN SOLO archivo SQL por épica**: Cada épica debe tener exactamente UN archivo SQL con el patrón `ep{XX}_{descripcion}.sql`
* **🗑️ Eliminación automática de temporales**: TODOS los archivos temporales en `/temp/` deben eliminarse después de completar cada épica
* **📁 Estructura limpia**: El directorio `/sql/` debe contener solo los archivos finales de cada épica implementada

### **Comandos de limpieza obligatorios:**
```bash
# Después de completar cada épica, ejecutar:
rm -rf 03-poc/0301-database/temp/*
# Verificar que solo queda el archivo final:
ls -la 03-poc/0301-database/sql/
```

### **Ejemplo de estructura final por épica:**
```
03-poc/0301-database/sql/
├── ep001_configuracion_maestros.sql    # ✅ Archivo final de ejemplo de EP-001
└── (vacío hasta EP-002)

03-poc/0301-database/temp/
└── (siempre vacío)
```

### **Razón de esta política:**
- **Mantenibilidad**: Evita confusión con múltiples versiones del mismo SQL
- **Limpieza**: Reduce el clutter del repositorio
- **Consistencia**: Patrón predecible para todas las épicas
- **Performance**: Menos archivos = mejor performance de git

## 🔧 Troubleshooting y resolución de problemas

### Lecciones aprendidas de implementaciones previas (v4.1)

**🆕 Errores identificados en EP-001:**

**❌ "File not found" en scripts run-sql.ts**
```bash
# Problema: Archivos creados en rutas incorrectas
npm run db:sql 03-poc/0301-database/sql/ep001_configuracion_maestros.sql
# Error: ENOENT: no such file or directory
```
**Solución preventiva:**
- ✅ Usar rutas absolutas cuando sea posible
- ✅ Verificar existencia de archivos antes de ejecutar: `Get-ChildItem 03-poc/0301-database/sql/`
- ✅ Crear archivos con PowerShell usando rutas completas
- ✅ Ejecutar `npm run db:snapshot:yaml` para verificar conectividad antes de cambios masivos

**❌ "syntax error at or near ''" en SQL complejo**
```sql
-- Problema: Encoding o caracteres especiales
COMMENT ON SCHEMA masterdata IS 'Datos maestros compartidos...';
-- Error: syntax error at or near ""
```
**Solución preventiva:**
- ✅ Evitar caracteres especiales (acentos, emojis) en comentarios SQL
- ✅ Crear archivos con encoding UTF-8 puro: `@'content'@ | Out-File -Encoding UTF8`
- ✅ Usar comentarios en inglés para evitar problemas de encoding
- ✅ Probar SQL en partes pequeñas antes de archivos complejos

**❌ Comandos fallan silenciosamente**
```bash
npm run db:update  # No muestra output ni errores
```
**Solución preventiva:**
- ✅ Verificar estado de procesos: `$LASTEXITCODE` después de comandos
- ✅ Usar flags verbose: `npm run --verbose`
- ✅ Verificar logs: `npm run db:snapshot:yaml; Write-Host "Snapshot completado"`
- ✅ Probar conectividad primero: `npx ts-node infra/db/ts/list-tables.ts`

**❌ Script run-sql.ts ejecuta SQL como bloque único**
```typescript
// Problema original: await client.query(sql); // Todo el archivo como una instrucción
// Solución implementada: Procesar línea por línea
```
**Solución aplicada:**
- ✅ Script modificado para dividir SQL en instrucciones separadas
- ✅ Mejor logging de progreso: "Ejecutando instrucción X/Y"
- ✅ Rollback automático en caso de error
- ✅ Mostrar instrucción problemática en errores

### Mejores prácticas actualizadas

#### 🧹 **Política de limpieza de archivos:**
- **✅ UN archivo SQL por épica**: Crear exactamente un archivo final por épica
- **✅ Eliminación inmediata de temporales**: `rm -rf 03-poc/0301-database/temp/*` después de cada épica
- **✅ Verificación de estructura**: Solo archivos finales en `/sql/`
- **✅ Patrón de nomenclatura consistente**: `ep{XX}_{descripcion}.sql`

#### 🌱 **Generación Directa de Seeds:**
- **✅ Un archivo por tabla**: Crear `seeds/seeds_sql/NNN_tabla.sql` manualmente
- **✅ Idempotencia**: Usar `ON CONFLICT DO NOTHING` en todos los INSERT
- **✅ Datos coherentes**: Crear ejemplos realistas del dominio
- **✅ Referencias seguras**: Usar `(SELECT id FROM tabla LIMIT 1)` para FK
- **✅ Testing**: Probar cada archivo SQL antes de aplicar todos

#### 📁 **Estructura simplificada:**
```bash
# Después de generación directa de seeds:
03-poc/0301-database/
├── sql/
│   └── ep001_configuracion_maestros.sql
├── seeds/
│   └── seeds_sql/
│       ├── 010_project_types.sql
│       ├── 020_task_types.sql
│       └── 030_contacts.sql
└── temp/
    # (vacío)
```

**🏗️ Creación de archivos SQL:**
```powershell
# ✅ RECOMENDADO: Usar rutas absolutas y encoding explícito
$content = @'
CREATE SCHEMA IF NOT EXISTS masterdata;
-- Comentarios en inglés para evitar encoding issues
'@;
$content | Out-File -FilePath "03-poc/0301-database/sql/ep001_schemas.sql" -Encoding UTF8;
```

**🔍 Verificación previa:**
```powershell
# ✅ Antes de ejecutar cambios masivos:
Get-ChildItem 03-poc/0301-database/sql/                    # Verificar archivos existen
npm run db:snapshot:yaml                           # Verificar conectividad
npx ts-node infra/db/ts/list-tables.ts               # Verificar estado actual
```

**⚡ Ejecución por fases:**
```powershell
# ✅ Fases de ejecución:
# 1. Esquemas básicos
npm run db:sql 03-poc/0301-database/sql/ep001_schemas.sql
# 2. Tablas principales
npm run db:sql 03-poc/0301-database/sql/ep001_tables.sql
# 3. Relaciones e índices
npm run db:sql 03-poc/0301-database/sql/ep001_relations.sql
# 4. Verificar y snapshots
npm run db:update
```

### Errores comunes durante la ejecución

**❌ "relation already exists"**
```sql
-- Solución: Verificar si la tabla existe antes de crearla
SELECT EXISTS (
  SELECT 1 FROM information_schema.tables
  WHERE table_schema = 'public' AND table_name = 'tu_tabla'
);
```
**Causa común:** SQL no idempotente, tabla ya creada en ejecución anterior

**❌ "column does not exist"**
- Verificar ortografía del nombre de columna
- Confirmar que la tabla existe y tiene esa columna
- Recordar: PostgreSQL es case-sensitive con comillas dobles
**Causa común:** Error tipográfico en nombre de columna o tabla padre no existe

**❌ "violates foreign key constraint"**
- Datos existentes violan la nueva FK
- Opción 1: Limpiar datos huérfanos antes de crear FK
- Opción 2: Usar `NOT VALID` inicialmente y validar después
**Causa común:** Datos existentes referencian registros que no existen

**❌ "permission denied for schema public"**
- Usuario de BD no tiene permisos suficientes
- Verificar rol de usuario en Supabase
**Solución:** Cambiar a usuario con permisos DDL

**❌ "syntax error at or near ..."**
- Error de sintaxis SQL
- Verificar paréntesis, comillas, punto y coma
- Usar herramientas de validación SQL
**Causa común:** Error al copiar/pegar o generación automática defectuosa

**❌ "schema does not exist"**
- Esquema no ha sido creado aún
- Verificar orden de ejecución (esquemas primero, luego tablas)
- Crear esquema con: `CREATE SCHEMA IF NOT EXISTS {schema_name};`
**Causa común:** Dependencias no respetadas en el orden de ejecución

### ✅ **Verificación manual después del esquema base**

**Si el esquema base falla o tienes dudas:**

```powershell
# 1. Verificar que el archivo existe y se ejecutó
Get-ChildItem infra/db/sql/app-factory-dm.sql

# 2. Verificar conexión a BD antes de ejecutar
npx ts-node infra/db/ts/list-tables.ts

# 3. Ejecutar y verificar cada tabla, creándola siempre con el schemaname "base"
npm run db:sql infra/db/sql/app-factory-dm.sql

# 4. Contar tablas creadas
Write-Host "Contando tablas creadas por el esquema base:"
(npx ts-node infra/db/ts/list-tables.ts | Measure-Object).Count

# 5. Listar todas las tablas para verificar
Write-Host "Tablas creadas:"
npx ts-node infra/db/ts/list-tables.ts
```

### ❌ **ERROR DE SINTAXIS CRÍTICO: "syntax error at or near "\"**

**Problema crítico identificado:**
```bash
Error ejecutando script.sql: syntax error at or near "\"
```

**Causa raíz:**
- Los caracteres `$$` para bloques PL/pgSQL se interpretan como variables de PowerShell
- PowerShell trata `$` como inicio de variable, causando conflictos de escape
- Scripts con funciones PL/pgSQL fallan sistemáticamente

**Solución preventiva:**
```powershell
# ❌ MAL: Usar $content con caracteres $$
$content = "DO $$ BEGIN ... END $$;"

# ✅ BIEN: Usar comillas simples para evitar expansión de variables
$content = 'DO $$ BEGIN ... END $$;'

# ✅ MEJOR: Crear archivos SQL sin bloques PL/pgSQL complejos
$content = "SELECT 'simple query' FROM table;"

# ✅ ÓPTIMO: Usar archivos SQL pre-creados en lugar de generación dinámica
# Crear el archivo manualmente y luego ejecutarlo
```

**Patrones a evitar:**
```sql
-- ❌ EVITAR: Bloques DO con $$
DO $$
DECLARE
    var_name TEXT;
BEGIN
    -- lógica compleja
END $$;

-- ✅ PREFERIR: SQL simple sin bloques PL/pgSQL
SELECT column FROM table WHERE condition;

-- ✅ O usar archivos separados para lógica compleja
```

**Lección aprendida:**
- **NUNCA** usar `$$` en scripts generados dinámicamente desde PowerShell
- **SIEMPRE** usar comillas simples para contenido SQL con caracteres especiales
- **PREFERIR** archivos SQL estáticos para lógica compleja
- **VALIDAR** scripts antes de ejecutar con sintaxis compleja

**Verificación general:**
- Compara el resultado de `npx ts-node infra/db/ts/list-tables.ts` con las tablas definidas en `infra/db/sql/app-factory-dm.sql`
- Todas las tablas definidas en el archivo SQL deben aparecer en la lista
- Si faltan tablas: Re-ejecutar `npm run db:sql infra/db/sql/app-factory-dm.sql`

**Nota:** Las tablas específicas dependen del contenido actual de `app-factory-dm.sql`. Consulta ese archivo para ver la lista completa de tablas que deben existir.

**❌ "cross-database references are not implemented"**
- Intentando referencias entre diferentes bases de datos
- En Supabase, todas las tablas deben estar en la misma BD
- Usar esquemas en lugar de bases de datos separadas
**Causa común:** Confusión entre esquemas y bases de datos

**❌ "schema does not exist"**
- Esquema no creado o eliminado accidentalmente
- Verificar orden de ejecución (esquemas antes que tablas)
- Recrear esquema: `CREATE SCHEMA IF NOT EXISTS {schema_name};`
**Causa común:** Dependencias no respetadas en el orden de ejecución

**❌ "permission denied for schema {schema_name}"**
- Usuario sin permisos en el esquema específico
- Otorgar permisos: `GRANT USAGE ON SCHEMA {schema_name} TO {user};`
- Verificar rol del usuario en esquemas específicos
**Causa común:** Permisos no configurados correctamente en esquemas personalizados

### Problemas de conexión

**"Connection timeout"**
- Verificar configuración de conexión a base de datos
- Confirmar que las variables de conexión son correctas
- Revisar firewall y conectividad de red

**"Authentication failed"**
- Verificar credenciales de usuario en la base de datos
- Confirmar permisos del usuario
- Asegurarse de que las credenciales sean válidas

### Issues con snapshots

**"schema-to-yaml.ts fails"**
- Verificar que todas las tablas tienen estructura válida
- Revisar tipos de datos no estándar
- Confirmar conectividad a Supabase

**"yaml-to-md.ts generates malformed output"**
- Verificar que DATABASE.yaml tenga estructura YAML válida
- Revisar caracteres especiales en nombres de tablas/columnas

### Rollback y recuperación

**Si un cambio SQL falla:**
1. Revisar el error específico en los logs
2. Si es transaccional, el rollback es automático
3. Para cambios no transaccionales: crear script de reversión
4. Revertir en orden inverso (FKs primero, luego tablas)

**Recuperación de estado anterior:**
```bash
# Si tienes backup del schema anterior
npm run db:snapshot:yaml  # para preservar el estado actual
# Luego revertir cambios manualmente o restaurar backup
```

### Validaciones preventivas

**Antes de ejecutar SQL:**
- ✅ Probar en entorno de desarrollo primero
- ✅ Verificar sintaxis con `EXPLAIN` o `ANALYZE`
- ✅ Confirmar impacto en datos existentes
- ✅ Revisar dependencias (vistas, funciones, triggers)
- ✅ Verificar permisos necesarios

## 📈 Lecciones aprendidas y mejores prácticas

### De implementaciones previas:

**🔧 Referencias de rutas actualizadas:**
- Mantener rutas consistentes en toda la documentación
- Verificar ubicación real de archivos antes de ejecutar
- Usar rutas relativas desde la raíz del proyecto

**🏗️ Organización por esquemas exitosa:**
- Los esquemas funcionales mejoran enormemente la organización
- Permiten permisos granulares por dominio funcional
- Facilitan el mantenimiento y evolución del schema
- Reducen conflictos de nombres entre módulos

**📁 Separación de responsabilidades en archivos:**
- Scripts generales de infraestructura → `infra/db/`
- SQL específico de épicas → `03-poc/0301-database/sql/`
- Archivos temporales → `03-poc/0301-database/temp/`
- Esta separación mejora mantenibilidad y claridad

**🎯 Funciones inteligentes como ventaja:**
- Funciones para generar códigos únicos automáticos
- Validadores de integridad de negocio
- Cálculos automáticos complejos
- Las funciones SQL pueden ser muy poderosas para lógica de negocio

**🏗️ Arquitectura multi-esquema probada:**
- Esquemas funcionales integrados perfectamente
- Separación clara de responsabilidades por dominio
- Permisos granulares por esquema mejoran seguridad
- Facilita evolución independiente de cada módulo

**🔧 Funciones SQL como motor de inteligencia:**
- Cálculos automáticos complejos en la base de datos
- Lógica de evaluación inteligente integrada
- Procesamiento de fórmulas dinámicas
- Funciones SQL = Lógica de negocio en la base de datos

**🔗 Cross-schema design patterns:**
- FKs entre esquemas funcionan perfectamente
- Referencias entre diferentes esquemas del dominio
- Importante: Mantener integridad referencial cross-schema
- Beneficio: Modularidad sin sacrificar consistencia

**🚨 TABLAS DUPLICADAS ENTRE ESQUEMAS (PROBLEMA CRÍTICO):**
- **RIESGO**: Evitar crear tablas con el mismo nombre en diferentes esquemas
- **EJEMPLO**: `base.mst_entities` vs `masterdata.mst_entities` (esta última no debería existir)
- **PROBLEMA**: FKs pueden apuntar erróneamente a la tabla duplicada en lugar de la correcta
- **SOLUCIÓN**: Mantener UNA SOLA tabla por entidad conceptual, preferiblemente en `base.*`
- **VERIFICACIÓN**: Antes de crear FKs, confirmar que apuntan al esquema correcto
- **LIMPIEZA**: Eliminar tablas duplicadas innecesarias que causen confusión

**🚨 ESQUEMAS DEDICADOS PARA UNA SOLA TABLA (ANTI-PATRÓN):**
- **RIESGO**: No crear esquemas dedicados solo para una tabla
- **EJEMPLO**: Esquema `contacts` eliminado - tabla movida a `masterdata.mst_contacts`
- **PROBLEMA**: Complejidad innecesaria y mantenimiento overhead
- **SOLUCIÓN**: Agrupar tablas relacionadas en esquemas funcionales
- **REGLA**: Esquemas deben contener múltiples tablas relacionadas o tener justificación específica preguntando antes al usuario

**📊 Índices estratégicos en esquemas funcionales:**
- Índices optimizados por esquema funcional
- Índices compuestos para consultas cross-schema
- Índices parciales para datos activos
- Optimización por patrón de consulta específico

**📋 Validación previa exhaustiva:**
- Ejecutar checklist de pre-ejecución antes de comenzar
- Verificar conectividad a BD antes de ejecutar cambios
- Confirmar que todos los scripts están disponibles

**🗂️ Organización de archivos:**
- Scripts de BD centralizados en `infra/db/`
- SQL generado en ubicaciones consistentes
- Backup de schema antes de cambios mayores

**🔍 Feedback detallado durante ejecución:**
- Reportar progreso paso a paso
- Mostrar qué tablas/índices se crearon
- Indicar métricas de éxito (conteos, tiempos)

**📊 Trazabilidad completa:**
- Documentar todas las US en YAML
- Incluir justificación de negocio para cada campo
- Mantener histórico de cambios

### Patrones probados:

**Para SQL idempotente:**
```sql
-- ✅ Bueno: Siempre usar IF NOT EXISTS
create table if not exists base.{table} (...);
create index if not exists idx_{table}_{col} on base.{table}({col});

-- ❌ Evitar: Puede fallar si ya existe
create table base.{table} (...);
```

**Para validaciones de FK:**
```sql
-- Verificar datos huérfanos antes de crear FK
SELECT COUNT(*) as orphaned_records
FROM child_table c
LEFT JOIN parent_table p ON c.parent_id = p.id
WHERE p.id IS NULL;
```

**Para manejo de errores en scripts:**
```powershell
# Verificar exit code y manejar errores
if ($LASTEXITCODE -ne 0) {
  Write-Host "❌ Error en la ejecución"
  exit 1
}
```

## Ejemplo de respuesta esperada por lote

#### Ejemplo de épica implementada (con validación previa):
Resumen técnico:

```
EP-XX Procesada. US: [EP-XX-US-001, EP-XX-US-002, EP-XX-US-003, ...] total N

📋 PROPUESTA VALIDADA ✅
- Mostrada propuesta completa por chat
- Aprobada explícitamente por usuario
- Checklist de validación completado

DDL aplicado:
- CREATE SCHEMA {schema_name};
- create table {schema}.{table1} (...campos)
- create table {schema}.{table2} (...campos)
- alter table {existing_table} add column {field} {type}
Funciones SQL inteligentes:
- {schema}.calculate_{entity}_{metric}()
- {schema}.{validator_function}()
- {schema}.{generator_function}()
Índices: {count} índices estratégicos creados
FKs: {count} referencias cross-schema configuradas
Enums: {count} enums personalizados

Trazabilidad añadida en DATABASE.yaml:
- EP-XX-US-001 → {schema}.{table}, {schema}.{function}()
- EP-XX-US-002 → {schema}.{table}, {existing_table}.{field}
- ...
```

#### Patrón estándar con validación:
```
EP-XX Procesada. US: [lista completa] total N
📋 PROPUESTA VALIDADA ✅
DDL aplicado:
- create schema {schema_name};
- create table {schema}.{table} (...campos)
- alter table {existing} add column {field}
Funciones: {lista de funciones SQL}
Índices: {conteo} índices estratégicos
FKs: {conteo} referencias cross-schema
```

Y termina siempre con un objeto JSON de control:

```json
{
  "OVERWRITE_FILES": false,
  "files": [
    { "path": "03-poc/0301-database/DATABASE.yaml", "action": "upsert" },
    { "path": "03-poc/0301-database/DATABASE.md", "action": "upsert" }
  ],
  "report": {
    "epic": "EP-01",
    "stories": ["EP-01-US-001","EP-01-US-002","EP-01-US-003"],
    "new_tables": ["base.trn_project"],
    "altered_tables": ["base.mst_employee +phone"],
    "indexes": ["idx_trn_project_code unique(code)"],
    "fks": ["trn_project.org_id → mst_org(id)"],
    "validation_approved": true,
    "traceability_updated": true
  }
}
```

## 🚨 **CHECKLIST DE INICIO OBLIGATORIO**

**Antes de comenzar con cualquier épica, ejecutar esta secuencia UNA SOLA VEZ:**

```powershell
# 1. Verificar conexión a base de datos
npx ts-node infra/db/ts/list-tables.ts

# 2. 🚨 EJECUTAR ESQUEMA BASE (UNA SOLA VEZ)
npm run db:sql infra/db/sql/app-factory-dm.sql

# 3. ✅ VERIFICACIÓN MANUAL: ¿Fue exitosa la ejecución?
Write-Host "🚨 ¿Fue la ejecución del esquema base satisfactoria?"
Write-Host "   - Si: Aparecieron mensajes de creación de tablas exitosos"
Write-Host "   - No: Aparecieron errores SQL o de conexión"
$respuesta = Read-Host "Responde 'si' para continuar o 'no' para detener"
if ($respuesta -ne "si") {
    Write-Host "❌ Deteniendo proceso. Revisa los errores antes de continuar."
    exit 1
}

# 4. Verificar que las tablas base se crearon correctamente
Write-Host "🔍 Verificando tablas base creadas..."
npx ts-node infra/db/ts/list-tables.ts | Select-String "base\."

# 5. ✅ VERIFICACIÓN MANUAL: ¿Se crearon todas las tablas base?
Write-Host "🚨 ¿Se crearon correctamente TODAS las tablas del esquema base?"
Write-Host "   - Verifica que no haya mensajes de error en la ejecución"
Write-Host "   - Confirma que el número de tablas creadas coincide con lo esperado"
Write-Host "   - Revisa que no falten tablas críticas del sistema"
$tablas_ok = Read-Host "Responde 'si' si todas las tablas se crearon correctamente o 'no' para verificar"
if ($tablas_ok -ne "si") {
    Write-Host "❌ Verifica las tablas base antes de continuar con las épicas."
    exit 1
}

# 6. ✅ PERMISO FINAL PARA CONTINUAR
Write-Host "🎉 Esquema base creado exitosamente. ¿Listo para proceder con las épicas?"
$continuar_epicas = Read-Host "Responde 'si' para continuar con EP-001 o 'no' para detener"
if ($continuar_epicas -ne "si") {
    Write-Host "ℹ️  Proceso detenido. Puedes continuar más tarde con las épicas."
    exit 0
}

# 7. Ahora puedes proceder con las épicas
```

## Notas

* **🚨 ESQUEMA BASE OBLIGATORIO**: El archivo `infra/db/sql/app-factory-dm.sql` debe ejecutarse UNA SOLA VEZ antes de cualquier épica. Contiene todas las tablas maestras necesarias.
* **✅ VERIFICACIÓN MANUAL REQUERIDA**: Después de ejecutar el esquema base, el usuario DEBE confirmar que la ejecución fue exitosa antes de proceder con las épicas. Se requieren verificaciones de mensajes de éxito, listado completo de tablas creadas, y confirmación manual.
* **LECTURA COMPLETA OBLIGATORIA**: Debes leer TODAS las historias de usuario de la épica sin excepción, incluyendo las de baja prioridad. Esto asegura que no se omitan requerimientos aparentemente menores pero importantes.
* **ORGANIZACIÓN POR ESQUEMAS**: No uses solo el esquema `public`. Crea esquemas funcionales (ej: `products`, `orders`, `users`, `analytics`) para mejor organización, permisos granulares y mantenibilidad.
* **ORGANIZACIÓN DE ARCHIVOS**: SQL específico de épicas → `03-poc/0301-database/sql/`, archivos temporales → `03-poc/0301-database/temp/`, scripts generales → `infra/db/`.
* **FUNCIONES SQL INTELIGENTES**: Implementa lógica de negocio en la base de datos mediante funciones que automaticen cálculos complejos, validaciones y generación de datos.
* **CROSS-SCHEMA RELATIONSHIPS**: Las referencias entre esquemas funcionan perfectamente y mantienen la integridad referencial mientras permiten modularidad.
* **EVOLUCIÓN PROBADA**: Este PROMPT-DATABASE ha sido mejorado iterativamente con lecciones de múltiples épicas implementadas, resultando en un proceso maduro y confiable.
* Para datos de prueba y seeds, ver `@PROMPT-seeds.md`
* No crear ni modificar archivos de migración en este flujo funcional. Si detectas drift o necesitas reproducibilidad adicional, se trata en el pipeline de CI, no aquí.

## 🔄 Estrategias de migración y evolución de esquemas

### Migración de tablas existentes
- **Evaluación previa**: `SELECT COUNT(*) FROM base.{table};` para verificar datos
- **Backup**: Crear respaldo antes de migrar
- **Migración**: `ALTER TABLE base.{table} SET SCHEMA {new_schema};`
- **Actualización de dependencias**: FKs, vistas, funciones que referencian la tabla
- **Testing**: Verificar que todas las referencias funcionan post-migración

### Evolución de esquemas
- **Versionado**: Mantener versiones de esquemas para rollback
- **Documentación**: Registrar cambios de esquema en DATABASE.yaml
- **Comunicación**: Notificar a equipos sobre cambios de esquema
- **Gradual**: Implementar cambios de esquema de forma incremental

### Monitoreo de esquemas
```sql
-- Uso por esquema
SELECT
  schemaname,
  COUNT(*) as tables_count,
  SUM(pg_total_relation_size(quote_ident(schemaname)||'.'||quote_ident(tablename))) as total_size
FROM pg_tables
WHERE schemaname NOT LIKE 'pg_%'
GROUP BY schemaname
ORDER BY total_size DESC;

-- FKs entre esquemas (cross-schema relationships)
SELECT
  tc.table_schema,
  tc.table_name,
  ccu.table_schema as referenced_schema,
  ccu.table_name as referenced_table
FROM information_schema.table_constraints tc
JOIN information_schema.constraint_column_usage ccu
  ON tc.constraint_name = ccu.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema != ccu.table_schema;

-- Funciones por esquema (inteligencia SQL)
SELECT
  n.nspname as schema_name,
  COUNT(*) as functions_count,
  string_agg(p.proname, ', ' ORDER BY p.proname) as function_names
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname NOT LIKE 'pg_%'
  AND n.nspname != 'information_schema'
GROUP BY n.nspname
ORDER BY functions_count DESC;

-- Índices por esquema (optimización)
SELECT
  schemaname,
  COUNT(*) as indexes_count,
  SUM(pg_relation_size(quote_ident(schemaname)||'.'||quote_ident(indexname))) as total_index_size
FROM pg_indexes
WHERE schemaname NOT LIKE 'pg_%'
GROUP BY schemaname
ORDER BY total_index_size DESC;

-- Monitoreo de accesos RBAC (seguridad)
SELECT
  schemaname,
  tablename,
  CASE
    WHEN tablename LIKE '%role%' THEN 'RBAC - Roles'
    WHEN tablename LIKE '%permission%' THEN 'RBAC - Permisos'
    WHEN tablename LIKE '%audit%' THEN 'Auditoría - Logs'
    WHEN tablename LIKE '%member%' THEN 'RBAC - Membresías'
    ELSE 'Otros'
  END as category
FROM pg_tables
WHERE schemaname NOT LIKE 'pg_%'
  AND (tablename LIKE '%role%' OR tablename LIKE '%permission%'
       OR tablename LIKE '%audit%' OR tablename LIKE '%member%')
ORDER BY schemaname, tablename;

-- Actividad de auditoría por día (últimos 7 días)
SELECT
  DATE(created_at) as audit_date,
  COUNT(*) as total_events,
  COUNT(*) FILTER (WHERE result = 'success') as successful_events,
  COUNT(*) FILTER (WHERE result = 'denied') as denied_events,
  COUNT(DISTINCT user_id) as unique_users
FROM {security_schema}.audit_log
WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY DATE(created_at)
ORDER BY audit_date DESC;

-- Usuarios con más actividad sospechosa (ejemplo)
SELECT
  user_id,
  COUNT(*) as total_actions,
  COUNT(*) FILTER (WHERE result = 'denied') as denied_actions,
  COUNT(*) FILTER (WHERE action = 'delete') as delete_actions,
  MAX(created_at) as last_activity
FROM {security_schema}.audit_log
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY user_id
HAVING COUNT(*) FILTER (WHERE result = 'denied') > 10
ORDER BY denied_actions DESC;

-- Permisos por rol (matriz RBAC)
SELECT
  r.name as role_name,
  p.name as permission_name,
  rp.is_active,
  rp.granted_at
FROM {security_schema}.global_roles r
CROSS JOIN {security_schema}.permissions p
LEFT JOIN {security_schema}.role_permissions rp ON r.id = rp.role_id AND p.id = rp.permission_id
WHERE r.is_active = true AND p.is_active = true
ORDER BY r.name, p.name;
```

## 📊 Métricas de éxito y KPIs

### Durante la ejecución:

**Cobertura de requerimientos:**
- ✅ US implementadas: {X}/{Y} ({Z}%)
- ✅ Campos mapeados: {X} campos de {Y} requeridos
- ✅ Relaciones implementadas: {X} FKs de {Y} identificadas

**Calidad del código:**
- ✅ SQL idempotente: {X} instrucciones con IF NOT EXISTS
- ✅ Índices estratégicos: {X} índices creados
- ✅ Constraints aplicadas: {X} validaciones implementadas

**Performance:**
- ⚡ Tiempo de ejecución: {X} segundos
- 📏 Tamaño del schema: {X} tablas, {Y} columnas
- 🔍 Cobertura de índices: {Z}% de campos de búsqueda indexados

### Post-implementación:

**Validaciones de integridad:**
```sql
-- Verificar FKs implementadas
SELECT
  tc.table_name,
  tc.constraint_name,
  tc.constraint_type
FROM information_schema.table_constraints tc
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name;

-- Verificar índices creados
SELECT
  schemaname,
  tablename,
  indexname,
  indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
```

**Métricas de adopción:**
- 📈 Uso de nuevas tablas: {X} registros en primeras semanas
- 🎯 Consultas optimizadas: {Y}% usan índices creados
- 🛡️ Constraints respetadas: {Z}% de inserciones válidas

**Métricas por esquema:**
- 📊 Tablas por esquema: {conteo} en cada esquema funcional
- 🔗 FKs entre esquemas: {conteo} referencias cross-schema
- 👥 Permisos por esquema: {conteo} roles con acceso por esquema
- 📈 Crecimiento por esquema: {tasa} de crecimiento semanal

### KPIs de calidad:

**Funcionalidad:** 100% de US implementadas correctamente
**Performance:** < 2 segundos tiempo de respuesta en consultas típicas
**Integridad:** 0% de violaciones de constraints en producción
**Mantenibilidad:** Schema claramente documentado y trazable
**Arquitectura:** Esquemas funcionales bien definidos y cross-schema funcionando
**Inteligencia:** Funciones SQL automatizando cálculos complejos
**Cobertura:** Todas las entidades mapeadas con trazabilidad completa
**Seguridad:** Control de acceso RBAC implementado correctamente
**Compliance:** Auditoría completa con 100% de cobertura de eventos
**Monitoreo:** Alertas automáticas para accesos sospechosos activas

## 📚 Referencias y documentación relacionada

### Documentos del proyecto
- **🚨 infra/db/sql/app-factory-dm.sql**: ESQUEMA BASE OBLIGATORIO - EJECUTAR PRIMERO (contiene todas las tablas base)
- **README-DATABASE.md**: Guía general de gestión de base de datos
- **DATABASE.yaml**: Esquema canónico actual (machine-readable)
- **DATABASE.md**: Documentación legible del esquema
- **seeds/manifest.yaml**: Configuración de datos maestros

### Scripts de infraestructura (infra/db/)

#### Scripts SQL reutilizables (infra/db/sql/)

##### **🔧 extend_base_table.sql**
Script agnóstico para extender tablas base con nuevos campos e índices.

**Uso típico:**
```bash
# Configurar variables en el script
# \set table_schema 'base'
# \set table_name 'mst_users'
# \set fields_config '{"username": {"type": "text", "nullable": true, "comment": "Nombre de usuario"}}'
# \set unique_indexes_config '["username"]'

# Ejecutar
npm run db:sql infra/db/sql/extend_base_table.sql
```

**Características:**
- ✅ Configurable mediante variables psql
- ✅ Agrega campos con validaciones IF NOT EXISTS
- ✅ Crea índices únicos automáticamente
- ✅ Verificación final de resultados

##### **🔍 check_referential_integrity.sql**
Script agnóstico para verificar integridad referencial en múltiples esquemas.

**Uso típico:**
```bash
# Configurar esquemas a verificar
# \set schemas_to_check '["base", "masterdata", "projects"]'
# \set critical_tables '["base.mst_users", "base.mst_entities"]'

# Ejecutar
npm run db:sql infra/db/sql/check_referential_integrity.sql
```

**Características:**
- ✅ Verificación automática de registros huérfanos
- ✅ Análisis de constraints FK por esquema
- ✅ Estadísticas generales de integridad
- ✅ Instrucciones de corrección incluidas

#### Scripts TypeScript reutilizables (infra/db/ts/)

##### **⚡ run-sql.ts**
Ejecutor robusto de archivos SQL con parsing inteligente y resultados de consultas.

**Uso típico:**
```bash
# Ejecutar cualquier archivo SQL
npm run db:sql infra/db/sql/extend_base_table.sql

# Ejecutar SQL de épicas
npm run db:sql 03-poc/0301-database/sql/ep001_configuracion_maestros.sql
```

**Características:**
- ✅ Parsing inteligente de SQL (maneja comentarios, strings, bloques $$)
- ✅ Transacciones con rollback automático
- ✅ Detección automática de consultas SELECT para mostrar resultados
- ✅ Logging detallado de progreso y errores
- ✅ Compatible con esquemas personalizados

##### **🏥 database-health-check.ts**
Verificador completo de salud de base de datos con reportes detallados.

**Uso típico:**
```bash
# Verificación completa
npx ts-node infra/db/ts/database-health-check.ts

# Guardar reporte en archivo
npx ts-node infra/db/ts/database-health-check.ts --save
```

**Características:**
- ✅ Verificación de conectividad
- ✅ Análisis de esquemas existentes
- ✅ Validación de tablas críticas
- ✅ Integridad referencial
- ✅ Recomendaciones automáticas
- ✅ Reportes JSON exportables

##### **📸 database-snapshot-manager.ts**
Gestor avanzado de snapshots para tracking de cambios en esquemas.

**Uso típico:**
```bash
# Crear snapshot
npx ts-node infra/db/ts/database-snapshot-manager.ts create

# Comparar snapshots
npx ts-node infra/db/ts/database-snapshot-manager.ts compare snapshot1.json snapshot2.json

# Generar rollback
npx ts-node infra/db/ts/database-snapshot-manager.ts rollback snapshot.json
```

**Características:**
- ✅ Snapshots completos de estructura BD
- ✅ Comparación automática de cambios
- ✅ Scripts de rollback generados
- ✅ Versionado de esquemas
- ✅ Compatible con esquemas múltiples

### Recursos externos
- **PostgreSQL 15 Documentation**: Referencia oficial de sintaxis SQL
- **Supabase Docs**: Características específicas de Supabase
- **SQL Style Guide**: Convenciones de escritura SQL
- **PostgreSQL Schema Best Practices**: Guías para organización por esquemas
- **Database Schema Design Patterns**: Patrones comunes de organización
- **PostgreSQL Advanced Functions**: Funciones SQL para lógica de negocio
- **Cross-Schema Database Design**: Arquitecturas multi-esquema
- **RBAC Database Design**: Patrones para sistemas de control de acceso
- **Database Auditing Patterns**: Mejores prácticas de auditoría en BD
- **Security in PostgreSQL**: Guías de seguridad y compliance

## 📈 **EVOLUCIÓN DEL PROMPT-DATABASE**

### **Versión 1.0 → 2.0 (Primera fase)**
- ✅ **Separación de archivos**: Scripts generales vs SQL específico
- ✅ **Lectura exhaustiva**: TODAS las US sin excepción
- ✅ **Trazabilidad completa**: EP/US → tablas/columnas
- ✅ **SQL idempotente**: Uso correcto de IF NOT EXISTS

### **Versión 2.0 → 3.0 (Segunda fase)**
- ✅ **Esquemas funcionales**: Organización por dominio funcional
- ✅ **Funciones SQL inteligentes**: Lógica de negocio en BD
- ✅ **Cross-schema relationships**: FKs entre esquemas
- ✅ **Estructura de archivos clara**: sql/, temp/, infra/db/

### **Versión 3.0 → 4.0 (Tercera fase)**
- ✅ **Arquitectura multi-esquema avanzada**: Esquemas completos de dominio
- ✅ **Funciones SQL avanzadas**: Cálculos automáticos complejos
- ✅ **Monitoreo inteligente**: Queries para analizar esquemas funcionales
- ✅ **Patrones probados**: Plantillas de funciones y cross-schema
- ✅ **Métricas de éxito**: KPIs específicos para esquemas funcionales
- ✅ **Sistemas RBAC completos**: Control de acceso basado en roles
- ✅ **Auditoría integral**: Logs inmutables con metadatos JSON
- ✅ **Validaciones de negocio**: Reglas críticas en la base de datos

### **Versión 4.0 → 4.1 (Corrección de EP-001)**
- ✅ **Script run-sql.ts mejorado**: Procesamiento de instrucciones SQL una por una
- ✅ **Verificación de archivos**: Checks obligatorios antes de ejecución
- ✅ **Encoding UTF-8 consistente**: Evita errores de caracteres especiales
- ✅ **Feedback de ejecución**: Logging detallado y errores específicos
- ✅ **Ejecución por fases**: Estrategia modular para cambios complejos
- ✅ **Manejo de rutas absolutas**: Evita problemas de resolución de archivos
- ✅ **Comentarios en inglés**: Previene issues de encoding internacional
- ✅ **Rollback automático**: Transacciones seguras con recuperación de errores

### **Estado Actual (v4.1)**
**Características principales:**
- 📊 **Múltiples épicas implementadas** con arquitectura probada
- 🏗️ **Arquitectura multi-esquema** madura y funcional
- 🔧 **Funciones SQL inteligentes** para lógica de negocio
- 📁 **Estructura de archivos** perfectamente organizada
- 📈 **Métricas de calidad** específicas por tipo de implementación
- 🎯 **Trazabilidad completa** en DATABASE.yaml
- ⚡ **Performance optimizada** con índices estratégicos
- 🔐 **Sistemas RBAC completos** con roles, permisos y auditoría
- 📋 **Auditoría integral** con logs inmutables y metadatos JSON
- ✅ **Validaciones de negocio** implementadas en la base de datos
- 🛡️ **Ejecución robusta** con verificación y recuperación de errores

**Patrones establecidos:**
- ✅ Esquemas funcionales por dominio
- ✅ Funciones SQL como motor de inteligencia
- ✅ Cross-schema relationships con integridad
- ✅ Índices estratégicos por patrón de consulta
- ✅ Extensiones compatibles a tablas existentes
- ✅ Enums personalizados para validación
- ✅ Monitoreo avanzado por esquema
- ✅ Sistemas RBAC con herencia y overrides
- ✅ Auditoría inmutable con metadatos JSON
- ✅ Validaciones de negocio en la base de datos
- ✅ **Ejecución segura**: Verificación previa y rollback automático
- ✅ **Encoding consistente**: UTF-8 sin problemas de caracteres
- ✅ **Feedback claro**: Logging detallado de todas las operaciones

**Problemas resueltos:**
- ❌ Scripts fallan silenciosamente → ✅ Feedback específico y validación
- ❌ Errores de encoding SQL → ✅ UTF-8 consistente y comentarios seguros
- ❌ Rutas de archivos incorrectas → ✅ Rutas absolutas y verificación previa
- ❌ SQL ejecutado como bloque único → ✅ Procesamiento instrucción por instrucción

**Próximas mejoras planificadas:**
- 🔄 Triggers automáticos para cálculos en tiempo real
- 📊 Vistas materializadas para dashboards de alto rendimiento
- 🔐 Políticas de seguridad por esquema (RLS)
- 📈 Métricas de adopción y uso por esquema
- 🔧 Optimización automática de índices
- 🚀 **CI/CD integration**: Automatización completa del flujo de BD

### Glosario del proyecto
- Revisar `/02-discovery/0202-prd/020210-glossary/**/*` para términos específicos del dominio

### Herramientas útiles para esquemas
- **pgAdmin**: Interfaz gráfica para gestión de esquemas
- **DBeaver**: Cliente universal con soporte completo de esquemas
- **SchemaCrawler**: Herramienta para documentar y analizar esquemas
- **Liquibase**: Para versionado y migraciones de esquemas