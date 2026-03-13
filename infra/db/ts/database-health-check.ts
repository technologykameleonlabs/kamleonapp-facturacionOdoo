/**
 * DATABASE-HEALTH-CHECK.TS
 * Script TypeScript reutilizable para verificar el estado de salud de la base de datos
 *
 * FUNCIONALIDAD:
 * - Verifica conectividad a la base de datos
 * - Valida estructura de tablas críticas
 * - Verifica integridad referencial
 * - Genera reportes de estado de la BD
 *
 * USO:
 * ```bash
 * npx ts-node infra/db/ts/database-health-check.ts
 * ```
 *
 * @author AI Assistant
 * @version 1.0
 * @date 2025-09-16
 */

import { Client } from 'pg';
import * as fs from 'fs';
import * as path from 'path';

// Configuración de conexión a la base de datos
const dbConfig = {
  host: process.env.PGHOST || 'localhost',
  port: parseInt(process.env.PGPORT || '5432'),
  database: process.env.PGDATABASE || 'postgres',
  user: process.env.PGUSER || 'postgres',
  password: process.env.PGPASSWORD || '',
  ssl: process.env.PGSSLMODE === 'require' ? { rejectUnauthorized: false } : undefined,
};

// Tablas críticas a verificar
const criticalTables = [
  'base.mst_users',
  'base.mst_entities',
  'base.mst_roles',
  'base.mst_permissions',
  'masterdata.mst_employees',
  'projects.mst_project_types',
  'tasks.mst_task_types'
];

// Esquemas a verificar
const schemasToCheck = [
  'base',
  'masterdata',
  'projects',
  'tasks',
  'time_tracking',
  'contacts'
];

interface HealthCheckResult {
  timestamp: string;
  connectivity: boolean;
  schemas: {
    name: string;
    exists: boolean;
    tablesCount: number;
  }[];
  criticalTables: {
    name: string;
    exists: boolean;
    recordCount: number;
  }[];
  referentialIntegrity: {
    orphanRecords: number;
    brokenConstraints: number;
  };
  recommendations: string[];
}

class DatabaseHealthChecker {
  private client: Client;
  private results: HealthCheckResult;

  constructor() {
    this.client = new Client(dbConfig);
    this.results = {
      timestamp: new Date().toISOString(),
      connectivity: false,
      schemas: [],
      criticalTables: [],
      referentialIntegrity: {
        orphanRecords: 0,
        brokenConstraints: 0
      },
      recommendations: []
    };
  }

  /**
   * Ejecuta todas las verificaciones de salud
   */
  async runHealthCheck(): Promise<HealthCheckResult> {
    console.log('🔍 Iniciando verificación de salud de la base de datos...\n');

    try {
      await this.client.connect();
      this.results.connectivity = true;
      console.log('✅ Conectado a la base de datos');

      await this.checkSchemas();
      await this.checkCriticalTables();
      await this.checkReferentialIntegrity();

      this.generateRecommendations();

    } catch (error) {
      console.error('❌ Error durante la verificación:', error);
      this.results.connectivity = false;
      this.results.recommendations.push('Verificar configuración de conexión a la base de datos');
    } finally {
      await this.client.end();
    }

    this.printReport();
    return this.results;
  }

  /**
   * Verifica la existencia de esquemas configurados
   */
  private async checkSchemas(): Promise<void> {
    console.log('\n📁 Verificando esquemas...');

    for (const schemaName of schemasToCheck) {
      try {
        const result = await this.client.query(`
          SELECT COUNT(*) as tables_count
          FROM information_schema.tables
          WHERE table_schema = $1
        `, [schemaName]);

        const exists = result.rows[0].tables_count > 0;
        const tablesCount = parseInt(result.rows[0].tables_count);

        this.results.schemas.push({
          name: schemaName,
          exists,
          tablesCount
        });

        console.log(`  ${exists ? '✅' : '❌'} ${schemaName}: ${tablesCount} tablas`);

      } catch (error) {
        this.results.schemas.push({
          name: schemaName,
          exists: false,
          tablesCount: 0
        });
        console.log(`  ❌ ${schemaName}: Error al verificar`);
      }
    }
  }

  /**
   * Verifica tablas críticas
   */
  private async checkCriticalTables(): Promise<void> {
    console.log('\n📋 Verificando tablas críticas...');

    for (const tableName of criticalTables) {
      try {
        const [schema, table] = tableName.split('.');

        // Verificar si la tabla existe
        const tableResult = await this.client.query(`
          SELECT EXISTS (
            SELECT 1
            FROM information_schema.tables
            WHERE table_schema = $1 AND table_name = $2
          ) as table_exists
        `, [schema, table]);

        const exists = tableResult.rows[0].table_exists;

        let recordCount = 0;
        if (exists) {
          const countResult = await this.client.query(
            `SELECT COUNT(*) as count FROM ${schema}.${table}`
          );
          recordCount = parseInt(countResult.rows[0].count);
        }

        this.results.criticalTables.push({
          name: tableName,
          exists,
          recordCount
        });

        console.log(`  ${exists ? '✅' : '❌'} ${tableName}: ${recordCount} registros`);

      } catch (error) {
        this.results.criticalTables.push({
          name: tableName,
          exists: false,
          recordCount: 0
        });
        console.log(`  ❌ ${tableName}: Error al verificar`);
      }
    }
  }

  /**
   * Verifica integridad referencial
   */
  private async checkReferentialIntegrity(): Promise<void> {
    console.log('\n🔗 Verificando integridad referencial...');

    try {
      // Contar registros huérfanos (usuarios sin entidad válida)
      const orphanResult = await this.client.query(`
        SELECT COUNT(*) as orphan_count
        FROM base.mst_users u
        LEFT JOIN base.mst_entities e ON u.entity_id = e.id
        WHERE u.entity_id IS NOT NULL AND e.id IS NULL
      `);

      this.results.referentialIntegrity.orphanRecords = parseInt(orphanResult.rows[0].orphan_count);

      // Contar constraints FK
      const fkResult = await this.client.query(`
        SELECT COUNT(*) as fk_count
        FROM information_schema.table_constraints
        WHERE constraint_type = 'FOREIGN KEY'
      `);

      this.results.referentialIntegrity.brokenConstraints = parseInt(fkResult.rows[0].fk_count);

      console.log(`  📊 Registros huérfanos: ${this.results.referentialIntegrity.orphanRecords}`);
      console.log(`  🔗 Constraints FK: ${this.results.referentialIntegrity.brokenConstraints}`);

    } catch (error) {
      console.log('  ❌ Error al verificar integridad referencial');
    }
  }

  /**
   * Genera recomendaciones basadas en los resultados
   */
  private generateRecommendations(): void {
    // Verificar esquemas faltantes
    const missingSchemas = this.results.schemas.filter(s => !s.exists);
    if (missingSchemas.length > 0) {
      this.results.recommendations.push(
        `Crear esquemas faltantes: ${missingSchemas.map(s => s.name).join(', ')}`
      );
    }

    // Verificar tablas críticas faltantes
    const missingTables = this.results.criticalTables.filter(t => !t.exists);
    if (missingTables.length > 0) {
      this.results.recommendations.push(
        `Crear tablas críticas faltantes: ${missingTables.map(t => t.name).join(', ')}`
      );
    }

    // Verificar tablas vacías
    const emptyTables = this.results.criticalTables.filter(t => t.exists && t.recordCount === 0);
    if (emptyTables.length > 0) {
      this.results.recommendations.push(
        `Poblar tablas vacías: ${emptyTables.map(t => t.name).join(', ')}`
      );
    }

    // Verificar integridad
    if (this.results.referentialIntegrity.orphanRecords > 0) {
      this.results.recommendations.push(
        `Corregir ${this.results.referentialIntegrity.orphanRecords} registros huérfanos`
      );
    }
  }

  /**
   * Imprime el reporte final
   */
  private printReport(): void {
    console.log('\n' + '='.repeat(60));
    console.log('📊 REPORTE DE SALUD DE LA BASE DE DATOS');
    console.log('='.repeat(60));

    console.log(`⏰ Timestamp: ${this.results.timestamp}`);
    console.log(`🔌 Conectividad: ${this.results.connectivity ? '✅ OK' : '❌ FALLANDO'}`);

    console.log('\n📁 ESQUEMAS:');
    this.results.schemas.forEach(schema => {
      console.log(`  ${schema.exists ? '✅' : '❌'} ${schema.name}: ${schema.tablesCount} tablas`);
    });

    console.log('\n📋 TABLAS CRÍTICAS:');
    this.results.criticalTables.forEach(table => {
      console.log(`  ${table.exists ? '✅' : '❌'} ${table.name}: ${table.recordCount} registros`);
    });

    console.log('\n🔗 INTEGRIDAD REFERENCIAL:');
    console.log(`  📊 Registros huérfanos: ${this.results.referentialIntegrity.orphanRecords}`);
    console.log(`  🔗 Constraints FK: ${this.results.referentialIntegrity.brokenConstraints}`);

    if (this.results.recommendations.length > 0) {
      console.log('\n💡 RECOMENDACIONES:');
      this.results.recommendations.forEach(rec => {
        console.log(`  • ${rec}`);
      });
    }

    console.log('\n' + '='.repeat(60));
  }

  /**
   * Guarda el reporte en un archivo JSON
   */
  async saveReport(filePath: string = 'database-health-report.json'): Promise<void> {
    try {
      const reportPath = path.join(process.cwd(), filePath);
      fs.writeFileSync(reportPath, JSON.stringify(this.results, null, 2));
      console.log(`📄 Reporte guardado en: ${reportPath}`);
    } catch (error) {
      console.error('❌ Error al guardar el reporte:', error);
    }
  }
}

// Función principal
async function main() {
  const checker = new DatabaseHealthChecker();

  try {
    const results = await checker.runHealthCheck();

    // Guardar reporte si se solicita
    if (process.argv.includes('--save')) {
      await checker.saveReport();
    }

  } catch (error) {
    console.error('❌ Error fatal:', error);
    process.exit(1);
  }
}

// Ejecutar si se llama directamente
if (require.main === module) {
  main().catch(console.error);
}

export { DatabaseHealthChecker, HealthCheckResult };
