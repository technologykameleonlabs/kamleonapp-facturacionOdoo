# 🗂️ Gestión de Base de Datos - Guía Completa

Este directorio documenta **cómo gestionamos la base de datos con Supabase como única fuente de verdad**, manteniendo en el repo **artefactos sincronizados** para contexto y revisión, y un **pipeline de seeds** para cargar datos de ejemplo.

---

## 🔑 Principios Fundamentales

- **🏆 Supabase = Verdad Absoluta**: Todas las tablas y cambios se aplican directamente en Supabase
- **📊 Artefactos Sincronizados**: El repo mantiene snapshots legibles para IA y equipo humano
- **🌱 Seeds Idempotentes**: Datos de ejemplo generados automáticamente con `ON CONFLICT DO NOTHING`
- **🔄 Flujo Disciplinado**: Cambios → Aplicar → Snapshot → Verificar → Documentar
- **🧹 Limpieza Continua**: Archivos temporales se eliminan periódicamente

---

## 📁 Estructura de Archivos Completa

```
03-poc/0301-database/
├── DATABASE.yaml              # 📊 Schema canónico (actualizado automáticamente)
├── DATABASE.md               # 📖 Documentación legible (opcional)
├── PROMPT-database.md        # 🎯 Guía completa del flujo de trabajo
├── sql/                      # 🏗️ SQL específico por épica
│   ├── ep001_configuracion_maestros.sql
│   ├── ep002_creacion_configuracion_proyectos.sql
│   └── temp/                 # 🗑️ ARCHIVOS TEMPORALES DE SQL
│       ├── check_*.sql       # Verificaciones
│       ├── test_*.sql        # Testing
│       └── debug_*.sql       # Debugging
├── seeds/                    # 🌱 Datos maestros
│   ├── manifest.yaml         # ⚙️ Configuración de orden y mapping
│   ├── sources/              # 📁 Archivos fuente originales
│   │   ├── employees_kameleonlabs
│   │   ├── employees_mojito360
│   │   ├── contacts
│   │   └── projects
│   ├── seeds_sql/            # 🎯 SQL generado por tabla (principales)
│   │   ├── 001_entities.sql
│   │   ├── 002_roles.sql
│   │   └── 0XX_*.sql...
│   └── temp/                 # 🗑️ ARCHIVOS TEMPORALES DE SEEDS
└── temp/                     # 🗑️ ARCHIVOS TEMPORALES GENERALES

infra/db/                     # 🔧 INFRAESTRUCTURA REUTILIZABLE
├── sql/                      # Scripts SQL agnósticos
│   ├── extend_base_table.sql          # Extender tablas base
│   └── check_referential_integrity.sql # Verificar integridad
├── ts/                       # Scripts TypeScript reutilizables
│   ├── database-health-check.ts       # Verificación de salud BD
│   ├── database-snapshot-manager.ts   # Gestión de snapshots
│   ├── run-sql.ts            # Ejecutor robusto de SQL
│   └── apply-seeds.ts        # Aplicador de seeds
└── [otros scripts de infraestructura...]
```

---

## ⚙️ Configuración de Entorno

### Variables de Entorno (infra/env/.env.local)

Usamos conexión **Session/Direct** a Supabase. Variables requeridas:

```bash
# Conexión a PostgreSQL
PGHOST=your-project-ref.supabase.co
PGPORT=5432
PGDATABASE=postgres
PGUSER=postgres
PGPASSWORD=your-password
PGSSLMODE=require

# URLs de Supabase
NEXT_PUBLIC_SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_SERVICE_ROLE=your-service-role-key  # Para operaciones administrativas
```

> ⚠️ **Importante**: Si cambias credenciales o proyecto, regenera los snapshots con `npm run db:update`

---

## 🛠️ Scripts y Comandos Principales

### 📊 Gestión de Schema (Snapshots)

```bash
# Generar/actualizar snapshot YAML desde Supabase
npm run db:snapshot:yaml

# Generar documentación MD desde YAML (opcional)
npm run db:snapshot:md

# Comando combinado: push + snapshots
npm run db:update
```

### ⚡ Ejecución de SQL

```bash
# Ejecutar archivo SQL con transacciones
npm run db:sql ruta/al/archivo.sql

# Ejemplos comunes:
npm run db:sql sql/ep001_configuracion_maestros.sql
npm run db:sql infra/db/sql/extend_base_table.sql
npm run db:sql /temp/debug_users.sql
```

### 🌱 Gestión de Seeds (Datos Maestros)

```bash
# Aplicar seeds existentes (recomendado)
npm run seeds:apply

# Verificar estado de seeds
npm run db:sql infra/db/sql/check_seeds.sql
```

### 🔍 Verificación y Diagnóstico

```bash
# Listar todas las tablas
npx ts-node infra/db/ts/list-tables.ts

# Health check completo de BD
npx ts-node infra/db/ts/database-health-check.ts --save

# Verificar integridad referencial
npm run db:sql infra/db/sql/check_referential_integrity.sql

# Verificar tablas base
npm run db:sql infra/db/sql/check_base_tables.sql
```

### 📸 Gestión de Snapshots Avanzada

```bash
# Crear snapshot completo
npx ts-node infra/db/ts/database-snapshot-manager.ts create

# Comparar snapshots
npx ts-node infra/db/ts/database-snapshot-manager.ts compare snap1.json snap2.json

# Generar script de rollback
npx ts-node infra/db/ts/database-snapshot-manager.ts rollback snapshot.json
```

---

## 🔄 Flujo de Trabajo Disciplinado

### 🎯 **Ciclo Principal: Cambios → Aplicar → Verificar → Documentar**

#### **1. Desarrollo y Testing (Archivos Temporales)**
```bash
# Crear archivos temporales para desarrollo
echo "SELECT * FROM base.mst_users LIMIT 5;" > temp/debug_users.sql
npm run db:sql temp/debug_users.sql

# Si el script es reutilizable, moverlo a infra/db/
mv temp/extend_table.sql infra/db/sql/extend_base_table.sql
```

#### **2. Cambios de Modelo (DDL)**
```bash
# Aplicar cambios de estructura
npm run db:sql sql/ep001_configuracion_maestros.sql

# Regenerar documentación
npm run db:update
```

#### **3. Carga de Datos (Seeds)**
```bash
# Aplicar seeds existentes
npm run seeds:apply

# Verificar estado
npm run db:sql infra/db/sql/check_seeds.sql
```

#### **4. Verificación y Limpieza**
```bash
# Health check completo
npx ts-node infra/db/ts/database-health-check.ts --save

# Limpiar archivos temporales
rm -rf */temp/* temp/*
```

### 📋 **Política de Archivos por Ubicación**

#### **🗑️ Carpetas `/temp/` (Archivos Temporales)**
- **Ubicación**: `/temp/`
- **Propósito**: Desarrollo, debugging y testing
- **Contenido**:
  - `check_*.sql` - Verificaciones de integridad
  - `test_*.sql` - Scripts de testing
  - `debug_*.sql` - Debugging y troubleshooting
  - `verify_*.sql` - Validaciones
  - `simple_*.sql` - Consultas simples
- **Gestión**: Se pueden borrar en cualquier momento sin afectar el proyecto

#### **🔧 Scripts Reutilizables (infra/db/)**
- **SQL**: Scripts agnósticos parametrizables con `\set`
- **TypeScript**: Utilidades con logging robusto y manejo de errores
- **Propósito**: Reutilizables en otros proyectos similares

### 📚 **Scripts Reutilizables - Guía Rápida**

#### **🔧 SQL Reutilizables**

**`extend_base_table.sql`** - Extender tablas existentes
```bash
# Configurar variables
\set table_schema 'base'
\set table_name 'mst_users'
npm run db:sql infra/db/sql/extend_base_table.sql
```

**`check_referential_integrity.sql`** - Verificar integridad
```bash
# Configurar esquemas a verificar
npm run db:sql infra/db/sql/check_referential_integrity.sql
```

#### **⚙️ TypeScript Reutilizables**

**`database-health-check.ts`** - Diagnóstico completo
```bash
npx ts-node infra/db/ts/database-health-check.ts --save
```

**`database-snapshot-manager.ts`** - Gestión de snapshots
```bash
npx ts-node infra/db/ts/database-snapshot-manager.ts create
```

---

## 🌱 Sistema de Seeds (Datos Maestros)

### 📋 **Concepto y Arquitectura**

- **Sources**: Archivos fuente en formatos cómodos (`seeds/sources/*.csv|.json|.txt`)
- **Manifest**: Configuración central (`seeds/manifest.yaml`) que define:
  - Tabla destino y mapping de columnas
  - Clave natural para evitar duplicados
  - Orden de aplicación (dependencias)
- **SQL Generado**: Archivos en `seeds/seeds_sql/` con `ON CONFLICT DO NOTHING`
- **Aplicación**: Ejecución transaccional en orden definido

### 📄 **Ejemplo Práctico**

**Archivo fuente** (`seeds/sources/project_types.csv`):
```csv
code,name,description
PLAN,Planificación,Fase inicial de planificación
EXEC,Ejecución,Desarrollo del proyecto
CLOSE,Cierre,Finalización y entrega
```

**Configuración** (`seeds/manifest.yaml`):
```yaml
batches:
- name: project_types
  source: sources/project_types.csv
  table: projects.mst_project_types
  key: [code]                 # Clave natural para idempotencia
  mapping:
    code: code
    name: name
    description: description
  order: 10                   # Orden de aplicación
```

**SQL generado** (`seeds/seeds_sql/010_project_types.sql`):
```sql
INSERT INTO projects.mst_project_types (code, name, description)
VALUES
  ('PLAN', 'Planificación', 'Fase inicial de planificación'),
  ('EXEC', 'Ejecución', 'Desarrollo del proyecto'),
  ('CLOSE', 'Cierre', 'Finalización y entrega')
ON CONFLICT (code) DO NOTHING;
```

### ⚙️ **Aplicación de Seeds**

```bash
# Aplicar todos los seeds en orden
npm run seeds:apply

# Verificar estado después de aplicar
npm run db:sql infra/db/sql/check_seeds.sql
```

---

## 🧩 Convenciones y Mejores Prácticas

### 📏 **Nomenclatura y Estructura**

#### **Schemas y Tablas**
- **snake_case**: `user_permissions`, `project_stages`
- **Prefijos estándar**:
  - `mst_` - Maestras (entidades principales)
  - `trn_` - Transaccionales (operaciones)
  - `evt_` - Eventos (logs históricos)
  - `cfg_` - Configuración
  - `cat_` - Catálogos
  - `log_` - Auditoría y logs
  - `rel_` - Relaciones N:M

#### **Campos Especiales**
- **PK**: `id uuid DEFAULT gen_random_uuid() PRIMARY KEY`
- **Auditoría**: `created_at`, `updated_at`, `created_by`, `updated_by`
- **Soft Delete**: `deleted_at` (opcional)
- **Metadata**: `metadata jsonb` (flexible)

### 🔒 **Seguridad y Constraints**

#### **Foreign Keys**
- **Cascade**: `ON UPDATE CASCADE ON DELETE RESTRICT` (por defecto)
- **Nombres**: `fk_{tabla_padre}_{tabla_hija}_{campo}`
- **Validación**: Verificar referencias circulares

#### **Constraints de Negocio**
- **CHECK**: Para validaciones de dominio
- **UNIQUE**: Índices únicos en claves naturales
- **NOT NULL**: Campos obligatorios por defecto

### 🌱 **Seeds y Datos**

#### **Idempotencia**
- **ON CONFLICT DO NOTHING**: Evita duplicados
- **Claves naturales**: Define `key` en manifest.yaml
- **Orden de aplicación**: Respeta dependencias padre-hijo

#### **Fuentes de Datos**
- **Formatos soportados**: CSV, JSON, TXT
- **Encoding**: UTF-8 sin BOM
- **Validación**: Verificar integridad antes de aplicar

### 🔄 **Flujo de Desarrollo**

#### **Principio DRY (Don't Repeat Yourself)**
- Scripts reutilizables → `infra/db/`
- Archivos temporales → `/temp/` (se pueden borrar)
- Variables parametrizables → `\set` en SQL

#### **Control de Versiones**
- **DATABASE.yaml**: Snapshot canónico (machine-readable)
- **DATABASE.md**: Documentación legible (opcional)
- **No editar manualmente**: Se regeneran automáticamente

### 📊 **Performance**

#### **Índices Estratégicos**
- **Búsqueda**: WHERE, JOIN, ORDER BY frecuentes
- **Compuestos**: Múltiples campos cuando aplique
- **Parciales**: WHERE deleted_at IS NULL

#### **Tipos de Datos**
- **UUID**: Para IDs (gen_random_uuid())
- **TEXT**: Para strings variables
- **TIMESTAMPTZ**: Para fechas con zona horaria
- **JSONB**: Para datos semi-estructurados

---

## 🛠️ Troubleshooting Avanzado

### 🔍 **Errores Comunes de Conexión**

#### **"ENOTFOUND" / "Connection timeout"**
```bash
# Verificar variables de entorno
cat infra/env/.env.local

# Probar conexión básica
npx ts-node infra/db/ts/list-tables.ts

# Verificar configuración de red/firewall
ping your-project-ref.supabase.co
```

#### **"Authentication failed" / "password authentication failed"**
- Verificar credenciales en `.env.local`
- Confirmar que el usuario tiene permisos DDL
- Revisar expiración de tokens/password

#### **"SSL connection error"**
```bash
# Verificar configuración SSL
PGSSLMODE=require  # Para Supabase siempre es requerido
```

### 📊 **Errores de Schema y Tablas**

#### **"relation 'table_name' does not exist"**
```bash
# Verificar que la tabla existe
npm run db:sql infra/db/sql/check_base_tables.sql

# Si no existe, crear con DDL
npm run db:sql sql/ep001_configuracion_maestros.sql

# Regenerar snapshots
npm run db:update
```

#### **"column does not exist"**
- Verificar ortografía del nombre de columna
- Confirmar que la tabla tiene esa columna
- Recordar: PostgreSQL es case-sensitive

#### **"violates foreign key constraint"**
```bash
# Verificar integridad referencial
npm run db:sql infra/db/sql/check_referential_integrity.sql

# Corregir datos huérfanos antes de aplicar FK
UPDATE child_table SET parent_id = NULL WHERE parent_id NOT IN (SELECT id FROM parent_table);
```

### 🌱 **Errores de Seeds**

#### **"duplicate key value violates unique constraint"**
- Verificar que el seed usa `ON CONFLICT DO NOTHING`
- Revisar definición de clave natural en `manifest.yaml`
- Verificar orden de aplicación (padres antes que hijos)

#### **"invalid input syntax" en CSV**
- Verificar encoding UTF-8 sin BOM
- Revisar separadores y comillas en CSV
- Validar tipos de datos (números, fechas, etc.)

### 🔧 **Errores de Scripts**

#### **"Permission denied for schema"**
- Verificar permisos del usuario en esquemas específicos
- Otorgar permisos: `GRANT USAGE ON SCHEMA schema_name TO user_name;`

#### **"function does not exist"**
- Verificar que las funciones están creadas
- Revisar orden de ejecución de scripts
- Confirmar que las dependencias están resueltas

### 💻 **Problemas de Desarrollo**

#### **PowerShell rompe scripts al copiar/pegar**
```powershell
# Usar here-strings con comillas simples
$content = @'
CREATE TABLE example (...);
'@
$content | Out-File -FilePath "script.sql" -Encoding UTF8
```

#### **"join is not a function" al render MD**
- Algún índice en YAML tiene `columns` no array
- Regenerar YAML: `npm run db:snapshot:yaml`

#### **Scripts ejecutan como bloque único**
- El `run-sql.ts` está optimizado para procesar instrucciones individualmente
- Verificar que las instrucciones terminan con `;`

### 🚀 **Comandos de Recuperación**

```bash
# Verificar estado general
npx ts-node infra/db/ts/database-health-check.ts --save

# Backup de schema actual
npm run db:snapshot:yaml

# Limpiar archivos temporales problemáticos
rm -rf */temp/* temp/*

# Verificar conectividad
npm run db:sql infra/db/sql/test_connection.sql
```

---

## 📊 Scripts Principales por Categoría

### 🏗️ **Gestión de Schema**
- **`run-sql.ts`** - Ejecutor robusto de SQL con parsing inteligente
- **`schema-to-yaml.ts`** - Generador de DATABASE.yaml
- **`yaml-to-md.ts`** - Generador de DATABASE.md
- **`database-snapshot-manager.ts`** - Gestión avanzada de snapshots

### 🌱 **Seeds y Datos Maestros**
- **`apply-seeds.ts`** - Aplicador transaccional de seeds
- **`check_seeds.sql`** - Verificación de estado de seeds
- **`manifest.yaml`** - Configuración de orden y mapping

### 🔍 **Diagnóstico y Verificación**
- **`database-health-check.ts`** - Verificación completa de BD
- **`list-tables.ts`** - Listado de todas las tablas
- **`check_referential_integrity.sql`** - Integridad referencial
- **`check_base_tables.sql`** - Verificación de tablas base

### 🔧 **Utilidades Reutilizables**
- **`extend_base_table.sql`** - Extender tablas existentes
- Scripts en `/temp/` - Desarrollo y debugging (se pueden borrar)

### 📁 **Archivos por Ubicación**
- **`/sql/`** - DDL específico de épicas
- **`/seeds/seeds_sql/`** - SQL generado de seeds
- **`/seeds/sources/`** - Archivos fuente originales
- **`/*/`** - Archivos temporales (borrar sin afectar proyecto)

---

## ✅ Resumen Ejecutivo

### 🏆 **Principios Fundamentales**
- **Supabase = Fuente de Verdad Absoluta**: Todos los cambios se aplican directamente
- **Artefactos Sincronizados**: `DATABASE.yaml` y `DATABASE.md` reflejan el estado real
- **Seeds Idempotentes**: Datos maestros con `ON CONFLICT DO NOTHING`
- **Flujo Disciplinado**: Cambios → Aplicar → Verificar → Documentar

### 🔄 **Ciclo de Desarrollo**
```
📝 Desarrollo (temp/) → ⚡ Aplicar (npm run db:sql) → 📊 Snapshot (npm run db:update) → 🔍 Verificar → 🧹 Limpiar
```

### 📚 **Recursos Clave**
- **Scripts Reutilizables**: `infra/db/` para utilidades agnósticas
- **Archivos Temporales**: `/temp/` se pueden borrar sin afectar el proyecto
- **Seeds**: Sistema completo para datos maestros desde múltiples fuentes
- **Snapshots**: Control de versiones automático del schema

### 🚀 **Próximos Pasos**
Para nuevas funcionalidades, fuentes de datos (XLSX, APIs, etc.) o mejoras del sistema, crear issue/PR con la propuesta específica.

---

## 📖 Referencias y Documentación

### 📋 **Documentos del Proyecto**
- **[PROMPT-database.md](./PROMPT-database.md)** - Guía completa del flujo de trabajo y mejores prácticas
- **[DATABASE.yaml](./DATABASE.yaml)** - Schema canónico actual (machine-readable)
- **[DATABASE.md](./DATABASE.md)** - Documentación del schema (generada automáticamente)
- **[seeds/manifest.yaml](./seeds/manifest.yaml)** - Configuración de seeds y orden de aplicación

### 🔧 **Scripts de Infraestructura**
- **[infra/db/sql/extend_base_table.sql](../infra/db/sql/extend_base_table.sql)** - Extender tablas existentes
- **[infra/db/sql/check_referential_integrity.sql](../infra/db/sql/check_referential_integrity.sql)** - Verificar integridad referencial
- **[infra/db/ts/database-health-check.ts](../infra/db/ts/database-health-check.ts)** - Diagnóstico completo de BD
- **[infra/db/ts/database-snapshot-manager.ts](../infra/db/ts/database-snapshot-manager.ts)** - Gestión avanzada de snapshots

### 🌐 **Recursos Externos**
- **[PostgreSQL 15 Documentation](https://www.postgresql.org/docs/15/)** - Referencia oficial
- **[Supabase Docs](https://supabase.com/docs)** - Documentación específica de Supabase
- **[SQL Style Guide](https://www.sqlstyle.guide/)** - Convenciones de escritura SQL
- **[Database Design Patterns](https://database-patterns.com/)** - Patrones de diseño de BD

### 🏗️ **Arquitectura y Mejores Prácticas**
- **Schema Organization**: Separación por dominio funcional
- **Idempotent Scripts**: SQL que se puede ejecutar múltiples veces
- **Version Control**: Snapshots automáticos del schema
- **Data Integrity**: Constraints y validaciones en BD

---

*Última actualización: 2025-09-16*