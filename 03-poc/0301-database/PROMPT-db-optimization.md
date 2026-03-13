# Supabase/Postgres — Prompt de Optimización Tabla por Tabla

## 🎯 Objetivo

Auditar y optimizar, antes del cierre del diseño, cada esquema y cada tabla de la base de datos para aprovechar completamente las capacidades de Supabase/PostgreSQL: funciones, triggers, enumerated types, extensiones, nomenclatura, RLS, índices, constraints y lifecycle de datos.

**CRÍTICO: Todo debe consultarse directamente a Supabase**
- Cualquier duda sobre el estado actual de la base de datos debe resolverse consultando directamente a Supabase
- Antes de aplicar cualquier cambio, verificar el estado real de esquemas, tablas, índices, RLS, etc.
- Si algo no está claro o no coincide con las expectativas, consultar al usuario inmediatamente
- NO cambiar de estrategia sin aprobación explícita del usuario

Principios: sin duplicación, orden estricto, cobertura completa, cambios documentados y trazables.

---

## 🔍 Pre-ejecución: Validación de Conexión a Supabase

**OBLIGATORIO: Verificar conexión antes de cualquier operación**

### Checklist de Validación de Entorno
- ✅ **Scripts disponibles**: Verificar que `package.json` contiene los scripts requeridos
- ✅ **Conexión funcional**: Ejecutar `npm run db:snapshot:yaml` para probar conectividad
- ✅ **Scripts npm disponibles**:
  - `npm run db:snapshot:yaml` - Genera snapshot en YAML
  - `npm run db:snapshot:md` - Genera documentación en MD
  - `npm run db:sql <archivo>` - Ejecuta archivo SQL en Supabase
  - `npm run db:update` - Actualiza snapshots (ejecuta snapshot:yaml + snapshot:md)
- ✅ **Variables de entorno**: Verificar que están configuradas correctamente

### Comando de Verificación de Conexión
```bash
# Verificar conectividad con Supabase
npx ts-node infra/db/ts/list-tables.ts
```

### Comandos de Conexión Seguros
```bash
# ✅ RECOMENDADO: Ejecutar SQL en Supabase
npm run db:sql <archivo.sql>

# ✅ RECOMENDADO: Generar snapshots
npm run db:snapshot:yaml
npm run db:snapshot:md

# ✅ RECOMENDADO: Actualización completa
npm run db:update
```

---

## 🧭 Flujo de Trabajo (resumido)

**IMPORTANTE: Consultar Supabase directamente en cada paso**

1) **Snapshot inicial obligatorio**
```bash
npx ts-node infra/db/ts/schema-to-yaml.ts
```
*Verificar en Supabase que el snapshot refleja el estado real*

2) **Seleccionar esquema objetivo y listar sus tablas**
```sql
SELECT tablename
FROM pg_tables
WHERE schemaname = '<schema>'
ORDER BY tablename;
```
*Ejecutar directamente en Supabase y comparar con snapshot*

3) **Revisar tabla por tabla usando la Plantilla de Revisión por Tabla (sección siguiente)**
*Para cada tabla: consultar estructura, índices, RLS, triggers directamente en Supabase*

4) **Aplicar fixes idempotentes y revalidar**
*Antes de aplicar: verificar estado actual en Supabase*
*Después de aplicar: confirmar cambios en Supabase*

5) **Documentar, actualizar snapshot y cerrar esquema**
```bash
npx ts-node infra/db/ts/schema-to-yaml.ts
npx ts-node infra/db/ts/yaml-to-md.ts
```
*Verificar que la documentación refleja exactamente lo que está en Supabase*

---

## ✅ Plantilla de Revisión por Tabla

Usar esta plantilla para cada tabla de un esquema. Mantener el mismo orden y no omitir secciones.

### [schema].[table]

- Nombre lógico: [descripción corta]
- Tenancy: columna de tenant (p.ej. `org_id`) [sí/no]
- Exposición: user-facing [sí/no]

#### 1) Modeling & Naming
- [ ] Prefijo correcto según dominio: `mst_` | `trn_` | `rel_` | `cfg_` | `cat_` | `evt_` | `log_`
- [ ] Nombre en inglés, `snake_case`, singular
- [ ] Columnas en `snake_case` (excepto `id` y timestamps estándar)
- [ ] PK `uuid DEFAULT gen_random_uuid()` o equivalente aprobado
- [ ] Timestamps base presentes: `created_at`, `updated_at`
- [ ] Columna de tenant (si aplica al dominio)
- [ ] Comentarios/Descriptions en tabla y columnas clave

#### 2) Audit Fields & Soft Delete
- [ ] Campos: `created_at`, `updated_at`, `created_by`, `updated_by`
- [ ] Soft delete: `deleted_at`, `deleted_by`
- [ ] Trigger `base.util_set_updated_at()` BEFORE UPDATE
- [ ] Trigger `base.util_set_audit_fields()` BEFORE INSERT
- [ ] Índice parcial activo: `WHERE deleted_at IS NULL`

#### 3) Constraints & Data Integrity
- [ ] `NOT NULL` en campos requeridos
- [ ] Unique constraints en claves de negocio
- [ ] FKs con `ON UPDATE CASCADE ON DELETE RESTRICT`
- [ ] CHECK constraints para validaciones (montos > 0, fechas válidas, etc.)
- [ ] Sin orphans ni dependencias circulares

#### 4) Security & RLS (Supabase)
- [ ] RLS habilitado (si user-facing)
- [ ] Postura default-deny: `REVOKE ALL` a `anon, authenticated`
- [ ] Políticas por operación (SELECT/INSERT/UPDATE/DELETE)
- [ ] Aislamiento por tenant usando `base.rel_user_org` y `auth.uid()`
- [ ] Políticas filtran `deleted_at IS NULL`
- [ ] Funciones SECURITY DEFINER con `search_path` bloqueado

#### 5) Performance & Indexing
- [ ] Índices en columnas FK
- [ ] Índices en `created_at`, `updated_at` (tablas grandes)
- [ ] Índice parcial por soft delete
- [ ] Índices compuestos para queries frecuentes del dominio
- [ ] Índices de expresión (p.ej. `lower(email)`), GIN para JSONB, BRIN para time-series
- [ ] Sin índices duplicados/superpuestos/inútiles

#### 6) Functions & Triggers
- [ ] Volatility correcta (IMMUTABLE/STABLE/VOLATILE)
- [ ] Triggers no recursivos y con guards
- [ ] Manejo de errores/edge cases
- [ ] Evitar lógica pesada en triggers (preferir funciones puntuales)

#### 7) Enumerated Types
- [ ] Identificar campos con valores fijos (<15) → ENUM
- [ ] Alternativas según caso: CHECK o FK a catálogos
- [ ] Plan de conversión seguro (DDL y casting)

#### 8) Extensions (uso por tabla)
- [ ] `pgcrypto` (UUID/crypto), `pg_trgm` (ILIKE), `pg_stat_statements` (observabilidad)
- [ ] `uuid-ossp` (si aplica), `vector` (si aplica)
- [ ] Extensiones habilitadas y documentadas

#### 9) Data Lifecycle
- [ ] Estrategia de particionamiento (tablas voluminosas)
- [ ] Materialized Views para lecturas pesadas
- [ ] Retención y purga periódica (incluye soft-deleted)
- [ ] Autovacuum tuning si es crítico

#### 10) Supabase Features
- [ ] Realtime (publications) cuando aporta valor
- [ ] Storage + RLS si hay ficheros asociados
- [ ] GraphQL/Views seguras (respetar RLS)
- [ ] Edge Functions si reduce complejidad/app-costs

#### 11) Observabilidad
- [ ] Auditoría de cambios (log) cuando sea crítico
- [ ] Métricas/slow queries disponibles
- [ ] Health score de la tabla calculado

#### Acciones Acordadas (SQL breve)
```sql
-- Escribir solo cambios aprobados, idempotentes y con comentarios
-- Ejemplos:
-- ALTER TABLE {schema}.{table} ADD COLUMN IF NOT EXISTS deleted_at timestamptz;
-- CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_{table}_deleted_null ON {schema}.{table}(id) WHERE deleted_at IS NULL;
-- ALTER TABLE {schema}.{table} ENABLE ROW LEVEL SECURITY;
```

---

## 🧩 Guías de Implementación (reuso puntual)

Usar estos patrones únicamente cuando aplique a la tabla en revisión. No duplicar en el documento final; referenciar esta sección.

### a) RLS por tenant (patrón)
```sql
ALTER TABLE {schema}.{table} ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON {schema}.{table} FROM anon, authenticated;

CREATE POLICY "{table}_tenant_select" ON {schema}.{table}
FOR SELECT TO authenticated
USING (
  org_id = (SELECT org_id FROM base.rel_user_org WHERE user_id = auth.uid())
  AND deleted_at IS NULL
);

CREATE POLICY "{table}_tenant_insert" ON {schema}.{table}
FOR INSERT TO authenticated
WITH CHECK (
  org_id = (SELECT org_id FROM base.rel_user_org WHERE user_id = auth.uid())
);

CREATE POLICY "{table}_tenant_update" ON {schema}.{table}
FOR UPDATE TO authenticated
USING (
  org_id = (SELECT org_id FROM base.rel_user_org WHERE user_id = auth.uid())
)
WITH CHECK (
  org_id = (SELECT org_id FROM base.rel_user_org WHERE user_id = auth.uid())
);
```

### b) Campos de auditoría y triggers (patrón)
```sql
-- Campos
ALTER TABLE {schema}.{table}
  ADD COLUMN IF NOT EXISTS created_at timestamptz NOT NULL DEFAULT now(),
  ADD COLUMN IF NOT EXISTS updated_at timestamptz NOT NULL DEFAULT now(),
  ADD COLUMN IF NOT EXISTS created_by uuid,
  ADD COLUMN IF NOT EXISTS updated_by uuid,
  ADD COLUMN IF NOT EXISTS deleted_at timestamptz,
  ADD COLUMN IF NOT EXISTS deleted_by uuid;

-- Triggers
DROP TRIGGER IF EXISTS set_updated_at ON {schema}.{table};
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON {schema}.{table}
  FOR EACH ROW EXECUTE FUNCTION base.util_set_updated_at();

DROP TRIGGER IF EXISTS set_audit_fields ON {schema}.{table};
CREATE TRIGGER set_audit_fields
  BEFORE INSERT ON {schema}.{table}
  FOR EACH ROW EXECUTE FUNCTION base.util_set_audit_fields();
```

### c) Índices recomendados (patrón)
```sql
-- FK
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_{table}_{fkcol} ON {schema}.{table}({fkcol});
-- Auditoría
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_{table}_created_at ON {schema}.{table}(created_at);
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_{table}_updated_at ON {schema}.{table}(updated_at);
-- Soft delete
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_{table}_deleted_null ON {schema}.{table}(id) WHERE deleted_at IS NULL;
-- Compuestos (ejemplo)
-- CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_{table}_dashboard ON {schema}.{table}(org_id, status, due_date) WHERE deleted_at IS NULL;
```

### d) Enums (criterios rápidos)
- Usar ENUM si: valores fijos (<15), cambian raramente, impacto en performance/validación
- Alternativas: CHECK en TEXT o FK a catálogo para valores user-extensibles

---

## 🔧 Comandos de Conexión y Análisis (Supabase)

**CRÍTICO: Ejecutar y verificar TODO directamente en Supabase**
- NO asumir que los comandos del repo reflejan el estado real de Supabase
- Cada comando debe ejecutarse en Supabase y sus resultados verificados
- Si los resultados no coinciden con las expectativas, consultar al usuario inmediatamente
- Documentar cualquier discrepancia encontrada

### Comandos de Verificación de Conexión
```bash
# ✅ VERIFICACIÓN OBLIGATORIA: Probar conectividad antes de cualquier operación
npx ts-node infra/db/ts/list-tables.ts

# ✅ VERIFICACIÓN OBLIGATORIA: Generar snapshot actual de la BD
npm run db:snapshot:yaml
```

### Comandos de Ejecución SQL en Supabase
```bash
# ✅ EJECUTAR SQL: Ejecuta archivo SQL directamente en Supabase
npm run db:sql <ruta/al/archivo.sql>

# ✅ EJECUTAR SQL: Ejecutar SQL específico en Supabase
npm run db:sql infra/db/sql/project_config.sql
```

### Comandos de Análisis (usar selectivamente por esquema/tabla en curso)
```bash
# Análisis de estructura y convenciones
npm run db:sql infra/db/sql/analyze_naming_conventions.sql
npm run db:sql infra/db/sql/analyze_audit_fields.sql
npm run db:sql infra/db/sql/analyze_soft_delete.sql
npm run db:sql infra/db/sql/analyze_enum_candidates.sql

# Análisis de performance y seguridad
npm run db:sql infra/db/sql/analyze_index_comprehensive.sql
npm run db:sql infra/db/sql/analyze_security_rls.sql
```

### Comandos de Optimización (aplicar tras acordar cambios específicos)
```bash
# Patrones de optimización
npm run db:sql infra/db/sql/audit_patterns.sql
npm run db:sql infra/db/sql/rls_patterns.sql
npm run db:sql infra/db/sql/index_patterns.sql
npm run db:sql infra/db/sql/monitoring_patterns.sql
```

### Comandos de Documentación
```bash
# ✅ ACTUALIZACIÓN OBLIGATORIA: Después de cambios, actualizar documentación
npm run db:update                    # Ejecuta snapshot:yaml + snapshot:md
npm run db:snapshot:yaml            # Genera DATABASE.yaml
npm run db:snapshot:md              # Genera DATABASE.md
```

*Después de ejecutar cualquier comando: verificar manualmente en Supabase que los cambios se aplicaron correctamente*

---

## 📝 Registro por Esquema (mini)

Para cada esquema, mantener un bloque compacto:
```markdown
### Esquema: <schema>
- Tablas revisadas: N / N
- Issues críticos resueltos: X
- Acciones aplicadas (resumen):
  - [schema.table] Soft delete + índices parciales
  - [schema.table] RLS por tenant + políticas completas
  - [schema.table] Índices FK y compuestos
```

Al finalizar un esquema:
```bash
npx ts-node infra/db/ts/schema-to-yaml.ts
npx ts-node infra/db/ts/yaml-to-md.ts
```

---

## ✔️ Criterios de Cierre (por tabla)

- [ ] Checklist completo sin pendientes en secciones 1–11
- [ ] SQL aplicado y verificado (idempotente)
- [ ] RLS probado con `auth.uid()` (si user-facing)
- [ ] Índices sin duplicación y con uso esperado
- [ ] Snapshot/documentación actualizados

---

## 🔧 Troubleshooting de Conexión a Supabase

### Problemas Comunes de Conexión

**❌ "Connection timeout"**
- Verificar configuración de conexión a base de datos
- Confirmar que las variables de conexión son correctas
- Revisar firewall y conectividad de red

**❌ "Authentication failed"**
- Verificar credenciales de usuario en la base de datos
- Confirmar permisos del usuario
- Asegurarse de que las credenciales sean válidas

**❌ "Error en la query: Could not query the database for the schema cache. Retrying."**
- Verificar variables de entorno (DATABASE_URL, etc.)
- Confirmar que la base de datos está disponible
- Revisar configuración de conexión en Supabase

**❌ Scripts fallan silenciosamente**
- Usar flags verbose: `npm run --verbose`
- Verificar logs: `npm run db:snapshot:yaml; Write-Host "Snapshot completado"`
- Probar conectividad primero: `npx ts-node infra/db/ts/list-tables.ts`

### Secuencia de Diagnóstico
```bash
# 1. Verificar scripts disponibles
npm run

# 2. Probar conectividad básica
npx ts-node infra/db/ts/list-tables.ts

# 3. Verificar snapshot funciona
npm run db:snapshot:yaml

# 4. Si falla, verificar variables de entorno
# Verificar que .env.local contiene las variables correctas
```

### Comandos de Recuperación
```bash
# Si hay problemas con snapshots
npm run db:snapshot:yaml  # Regenerar YAML
npm run db:snapshot:md    # Regenerar documentación
npm run db:update         # Actualización completa
```

---

## 📌 Notas

- Priorizar en orden: 1) naming/convenciones, 2) FK sin índices, 3) auditoría, 4) RLS, 5) performance, 6) extensiones/otros.
- Mantener cambios mínimos, seguros y trazables; medir impacto cuando aplique.

**PROTOCOLO OBLIGATORIO PARA DUDAS**
- Si algo no está claro en Supabase: CONSULTAR AL USUARIO INMEDIATAMENTE
- Si los resultados no coinciden con lo esperado: CONSULTAR AL USUARIO
- Si hay discrepancias entre documentación y realidad en Supabase: CONSULTAR AL USUARIO
- Si no se sabe cómo proceder: CONSULTAR AL USUARIO
- NO improvisar estrategias ni asumir conocimientos
- La aprobación del usuario es REQUERIDA para cualquier cambio de rumbo

**PROTOCOLO OBLIGATORIO PARA CONEXIONES**
- SIEMPRE verificar conexión antes de cualquier operación: `npx ts-node infra/db/ts/list-tables.ts`
- SIEMPRE probar comandos en entorno seguro antes de producción
- SIEMPRE verificar que los cambios se aplicaron correctamente en Supabase
- SIEMPRE actualizar documentación después de cambios: `npm run db:update`


