/**
 * DATABASE-SNAPSHOT-MANAGER.TS
 * Gestor de snapshots de base de datos para PostgreSQL
 *
 * FUNCIONALIDAD:
 * - Crear snapshots completos de la estructura de BD
 * - Comparar snapshots para identificar cambios
 * - Generar scripts de rollback
 * - Gestionar versiones de esquemas
 *
 * USO:
 * ```bash
 * # Crear snapshot
 * npx ts-node infra/db/ts/database-snapshot-manager.ts create
 *
 * # Comparar snapshots
 * npx ts-node infra/db/ts/database-snapshot-manager.ts compare snapshot1.json snapshot2.json
 *
 * # Generar script de rollback
 * npx ts-node infra/db/ts/database-snapshot-manager.ts rollback snapshot.json
 * ```
 *
 * @author AI Assistant
 * @version 1.0
 * @date 2025-09-16
 */

import { Client } from 'pg';
import * as fs from 'fs';
import * as path from 'path';

interface DatabaseSnapshot {
  timestamp: string;
  version: string;
  schemas: SchemaSnapshot[];
  metadata: {
    database: string;
    host: string;
    totalTables: number;
    totalSchemas: number;
  };
}

interface SchemaSnapshot {
  name: string;
  tables: TableSnapshot[];
  functions: FunctionSnapshot[];
  types: TypeSnapshot[];
}

interface TableSnapshot {
  name: string;
  columns: ColumnSnapshot[];
  constraints: ConstraintSnapshot[];
  indexes: IndexSnapshot[];
  triggers: TriggerSnapshot[];
}

interface ColumnSnapshot {
  name: string;
  type: string;
  nullable: boolean;
  default: string | null;
  comment: string | null;
}

interface ConstraintSnapshot {
  name: string;
  type: string;
  definition: string;
}

interface IndexSnapshot {
  name: string;
  definition: string;
  isUnique: boolean;
}

interface TriggerSnapshot {
  name: string;
  function: string;
  events: string[];
}

interface FunctionSnapshot {
  name: string;
  signature: string;
  definition: string;
}

interface TypeSnapshot {
  name: string;
  type: string;
  definition: string;
}

class DatabaseSnapshotManager {
  private client: Client;
  private config = {
    host: process.env.PGHOST || 'localhost',
    port: parseInt(process.env.PGPORT || '5432'),
    database: process.env.PGDATABASE || 'postgres',
    user: process.env.PGUSER || 'postgres',
    password: process.env.PGPASSWORD || '',
    ssl: process.env.PGSSLMODE === 'require' ? { rejectUnauthorized: false } : undefined,
  };

  constructor() {
    this.client = new Client(this.config);
  }

  /**
   * Crea un snapshot completo de la base de datos
   */
  async createSnapshot(outputPath?: string): Promise<DatabaseSnapshot> {
    console.log('📸 Creando snapshot de base de datos...');

    await this.client.connect();

    const timestamp = new Date().toISOString();
    const snapshot: DatabaseSnapshot = {
      timestamp,
      version: '1.0',
      schemas: [],
      metadata: {
        database: this.config.database,
        host: this.config.host,
        totalTables: 0,
        totalSchemas: 0
      }
    };

    try {
      // Obtener lista de esquemas
      const schemasResult = await this.client.query(`
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name NOT LIKE 'pg_%'
          AND schema_name != 'information_schema'
        ORDER BY schema_name
      `);

      for (const schemaRow of schemasResult.rows) {
        const schemaName = schemaRow.schema_name;
        console.log(`  📁 Procesando esquema: ${schemaName}`);

        const schemaSnapshot = await this.createSchemaSnapshot(schemaName);
        snapshot.schemas.push(schemaSnapshot);
      }

      snapshot.metadata.totalSchemas = snapshot.schemas.length;
      snapshot.metadata.totalTables = snapshot.schemas.reduce(
        (total, schema) => total + schema.tables.length,
        0
      );

      // Guardar snapshot si se especifica ruta
      if (outputPath) {
        this.saveSnapshot(snapshot, outputPath);
      }

      console.log(`✅ Snapshot creado: ${snapshot.metadata.totalSchemas} esquemas, ${snapshot.metadata.totalTables} tablas`);

    } finally {
      await this.client.end();
    }

    return snapshot;
  }

  /**
   * Crea snapshot de un esquema específico
   */
  private async createSchemaSnapshot(schemaName: string): Promise<SchemaSnapshot> {
    const schema: SchemaSnapshot = {
      name: schemaName,
      tables: [],
      functions: [],
      types: []
    };

    // Obtener tablas del esquema
    const tablesResult = await this.client.query(`
      SELECT table_name
      FROM information_schema.tables
      WHERE table_schema = $1 AND table_type = 'BASE TABLE'
      ORDER BY table_name
    `, [schemaName]);

    for (const tableRow of tablesResult.rows) {
      const tableName = tableRow.table_name;
      const tableSnapshot = await this.createTableSnapshot(schemaName, tableName);
      schema.tables.push(tableSnapshot);
    }

    // Obtener funciones del esquema
    const functionsResult = await this.client.query(`
      SELECT proname, pg_get_function_identity_arguments(oid) as signature
      FROM pg_proc p
      JOIN pg_namespace n ON p.pronamespace = n.oid
      WHERE n.nspname = $1
      ORDER BY proname
    `, [schemaName]);

    for (const funcRow of functionsResult.rows) {
      schema.functions.push({
        name: funcRow.proname,
        signature: funcRow.signature,
        definition: '' // Se puede obtener con pg_get_functiondef si es necesario
      });
    }

    return schema;
  }

  /**
   * Crea snapshot de una tabla específica
   */
  private async createTableSnapshot(schemaName: string, tableName: string): Promise<TableSnapshot> {
    const table: TableSnapshot = {
      name: tableName,
      columns: [],
      constraints: [],
      indexes: [],
      triggers: []
    };

    // Obtener columnas
    const columnsResult = await this.client.query(`
      SELECT
        column_name,
        data_type,
        is_nullable = 'YES' as nullable,
        column_default,
        col_description(c.oid, c.attnum) as comment
      FROM information_schema.columns c
      JOIN pg_class cls ON cls.relname = c.table_name
      JOIN pg_namespace n ON n.oid = cls.relnamespace AND n.nspname = c.table_schema
      WHERE c.table_schema = $1 AND c.table_name = $2
      ORDER BY ordinal_position
    `, [schemaName, tableName]);

    table.columns = columnsResult.rows.map(row => ({
      name: row.column_name,
      type: row.data_type,
      nullable: row.nullable,
      default: row.column_default,
      comment: row.comment
    }));

    // Obtener constraints
    const constraintsResult = await this.client.query(`
      SELECT
        conname as name,
        contype as type,
        pg_get_constraintdef(c.oid) as definition
      FROM pg_constraint c
      JOIN pg_class cls ON cls.oid = c.conrelid
      JOIN pg_namespace n ON n.oid = cls.relnamespace
      WHERE n.nspname = $1 AND cls.relname = $2
    `, [schemaName, tableName]);

    table.constraints = constraintsResult.rows.map(row => ({
      name: row.name,
      type: row.type,
      definition: row.definition
    }));

    // Obtener índices
    const indexesResult = await this.client.query(`
      SELECT
        indexname,
        indexdef,
        indisunique as is_unique
      FROM pg_indexes
      WHERE schemaname = $1 AND tablename = $2
    `, [schemaName, tableName]);

    table.indexes = indexesResult.rows.map(row => ({
      name: row.indexname,
      definition: row.indexdef,
      isUnique: row.is_unique
    }));

    return table;
  }

  /**
   * Compara dos snapshots y genera un diff
   */
  compareSnapshots(snapshot1: DatabaseSnapshot, snapshot2: DatabaseSnapshot): any {
    const diff = {
      added: { schemas: [], tables: [], columns: [] },
      removed: { schemas: [], tables: [], columns: [] },
      modified: { tables: [], columns: [] }
    };

    // Comparar esquemas
    const schemaNames1 = snapshot1.schemas.map(s => s.name);
    const schemaNames2 = snapshot2.schemas.map(s => s.name);

    diff.added.schemas = schemaNames2.filter(name => !schemaNames1.includes(name));
    diff.removed.schemas = schemaNames1.filter(name => !schemaNames2.includes(name));

    // Comparar tablas por esquema común
    const commonSchemas = schemaNames1.filter(name => schemaNames2.includes(name));

    for (const schemaName of commonSchemas) {
      const schema1 = snapshot1.schemas.find(s => s.name === schemaName)!;
      const schema2 = snapshot2.schemas.find(s => s.name === schemaName)!;

      const tableNames1 = schema1.tables.map(t => t.name);
      const tableNames2 = schema2.tables.map(t => t.name);

      diff.added.tables.push(...tableNames2
        .filter(name => !tableNames1.includes(name))
        .map(name => `${schemaName}.${name}`));

      diff.removed.tables.push(...tableNames1
        .filter(name => !tableNames2.includes(name))
        .map(name => `${schemaName}.${name}`));
    }

    return diff;
  }

  /**
   * Genera script SQL de rollback basado en un snapshot
   */
  generateRollbackScript(snapshot: DatabaseSnapshot): string {
    let sql = `-- Rollback script generado automáticamente\n`;
    sql += `-- Timestamp: ${snapshot.timestamp}\n\n`;

    // Generar DROP TABLES en orden inverso
    for (const schema of snapshot.schemas.reverse()) {
      sql += `-- Schema: ${schema.name}\n`;

      for (const table of schema.tables.reverse()) {
        sql += `DROP TABLE IF EXISTS ${schema.name}.${table.name} CASCADE;\n`;
      }

      sql += '\n';
    }

    return sql;
  }

  /**
   * Guarda snapshot en archivo JSON
   */
  private saveSnapshot(snapshot: DatabaseSnapshot, filePath: string): void {
    const fullPath = path.isAbsolute(filePath) ? filePath : path.join(process.cwd(), filePath);
    fs.writeFileSync(fullPath, JSON.stringify(snapshot, null, 2));
    console.log(`💾 Snapshot guardado en: ${fullPath}`);
  }

  /**
   * Carga snapshot desde archivo JSON
   */
  loadSnapshot(filePath: string): DatabaseSnapshot {
    const fullPath = path.isAbsolute(filePath) ? filePath : path.join(process.cwd(), filePath);
    const data = fs.readFileSync(fullPath, 'utf8');
    return JSON.parse(data);
  }
}

// Función principal para CLI
async function main() {
  const args = process.argv.slice(2);
  const command = args[0];

  if (!command) {
    console.log('Uso: npx ts-node database-snapshot-manager.ts <comando>');
    console.log('Comandos disponibles:');
    console.log('  create [output.json]    - Crear snapshot');
    console.log('  compare <file1> <file2>  - Comparar snapshots');
    console.log('  rollback <file>         - Generar script de rollback');
    process.exit(1);
  }

  const manager = new DatabaseSnapshotManager();

  try {
    switch (command) {
      case 'create': {
        const outputPath = args[1] || `snapshot-${new Date().toISOString().slice(0, 10)}.json`;
        await manager.createSnapshot(outputPath);
        break;
      }

      case 'compare': {
        if (args.length < 3) {
          console.error('Error: Se requieren dos archivos para comparar');
          process.exit(1);
        }

        const snapshot1 = manager.loadSnapshot(args[1]);
        const snapshot2 = manager.loadSnapshot(args[2]);
        const diff = manager.compareSnapshots(snapshot1, snapshot2);

        console.log('📊 DIFERENCIAS ENTRE SNAPSHOTS:');
        console.log('Agregado:', diff.added);
        console.log('Eliminado:', diff.removed);
        console.log('Modificado:', diff.modified);
        break;
      }

      case 'rollback': {
        if (!args[1]) {
          console.error('Error: Se requiere archivo de snapshot');
          process.exit(1);
        }

        const snapshot = manager.loadSnapshot(args[1]);
        const rollbackScript = manager.generateRollbackScript(snapshot);

        const outputPath = `rollback-${new Date().toISOString().slice(0, 10)}.sql`;
        fs.writeFileSync(outputPath, rollbackScript);
        console.log(`📄 Script de rollback generado: ${outputPath}`);
        break;
      }

      default:
        console.error(`Comando desconocido: ${command}`);
        process.exit(1);
    }

  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

// Ejecutar si se llama directamente
if (require.main === module) {
  main().catch(console.error);
}

export { DatabaseSnapshotManager, DatabaseSnapshot };
