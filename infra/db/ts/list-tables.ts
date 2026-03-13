import dotenv from 'dotenv'
dotenv.config({ path: 'infra/env/.env.local' })
import { Client } from 'pg'

async function main() {
  const client = new Client({
    host: process.env.PGHOST,
    port: parseInt(process.env.PGPORT || '5432', 10),
    database: process.env.PGDATABASE,
    user: process.env.PGUSER,
    password: process.env.PGPASSWORD,
    ssl: process.env.PGSSLMODE === 'require' ? { rejectUnauthorized: false } : undefined,
  })

  try {
    await client.connect()
    const res = await client.query(`
      SELECT schemaname, tablename, tableowner
      FROM pg_catalog.pg_tables
      WHERE schemaname NOT LIKE 'pg_%'
        AND schemaname != 'information_schema'
      ORDER BY schemaname, tablename;
    `)

    if (res.rows.length === 0) {
      console.log('ℹ Conexión OK, pero no hay tablas en ningún esquema de usuario.')
    } else {
      console.log('📊 Tablas encontradas por esquema:')
      console.table(res.rows)

      // Conteo por esquema
      const schemaCount = res.rows.reduce((acc: any, row: any) => {
        acc[row.schemaname] = (acc[row.schemaname] || 0) + 1
        return acc
      }, {})

      console.log('\n📈 Resumen por esquema:')
      Object.entries(schemaCount).forEach(([schema, count]) => {
        console.log(`  ${schema}: ${count} tablas`)
      })
      console.log(`\n📊 Total: ${res.rows.length} tablas en ${Object.keys(schemaCount).length} esquemas`)
    }
  } catch (e) {
    console.error('❌ Error listando tablas:', e)
    process.exit(1)
  } finally {
    await client.end()
  }
}

main()
