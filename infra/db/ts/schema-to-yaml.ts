import dotenv from 'dotenv'
dotenv.config({ path: 'infra/env/.env.local' })
import { Client } from 'pg'
import fs from 'node:fs/promises'
import path from 'node:path'
import YAML from 'yaml'

async function main() {
  const must = (v?: string, name?: string) => { if (!v) throw new Error(`Falta ${name}`); return v }

  const client = new Client({
    host: must(process.env.PGHOST, 'PGHOST'),
    port: parseInt(process.env.PGPORT || '5432', 10),
    database: must(process.env.PGDATABASE, 'PGDATABASE'),
    user: must(process.env.PGUSER, 'PGUSER'),
    password: must(process.env.PGPASSWORD, 'PGPASSWORD'),
    ssl: process.env.PGSSLMODE === 'require' ? { rejectUnauthorized: false } : undefined,
  })
  await client.connect()

  // 1) Tablas de usuario
  const { rows: tables } = await client.query(`
    select table_schema, table_name
    from information_schema.tables
    where table_type='BASE TABLE'
      and table_schema not in ('pg_catalog','information_schema')
    order by table_schema, table_name
  `)

  const schemas = new Map<string, any>()

  for (const t of tables) {
    const s = t.table_schema as string
    const n = t.table_name  as string
    if (!schemas.has(s)) schemas.set(s, { name: s, tables: [] })

    // 2) Columnas
    const { rows: cols } = await client.query(`
      select column_name, data_type, is_nullable, column_default
      from information_schema.columns
      where table_schema=$1 and table_name=$2
      order by ordinal_position
    `, [s, n])

    // 3) PKs
    const { rows: pks } = await client.query(`
      select a.attname as col
      from pg_index i
      join pg_class c on c.oid = i.indrelid
      join pg_namespace ns on ns.oid = c.relnamespace
      join pg_attribute a on a.attrelid = c.oid and a.attnum = any(i.indkey)
      where i.indisprimary and ns.nspname = $1 and c.relname = $2
    `, [s, n])
    const pkSet = new Set(pks.map((r: any) => r.col))

    // 4) FKs
    const { rows: fks } = await client.query(`
      select kcu.column_name as col,
             ccu.table_schema as fk_schema,
             ccu.table_name as fk_table,
             ccu.column_name as fk_col
      from information_schema.table_constraints tc
      join information_schema.key_column_usage kcu
        on tc.constraint_name = kcu.constraint_name
        and tc.table_schema = kcu.table_schema
      join information_schema.constraint_column_usage ccu
        on ccu.constraint_name = tc.constraint_name
        and ccu.table_schema = tc.table_schema
      where tc.constraint_type = 'FOREIGN KEY'
        and tc.table_schema = $1 and tc.table_name = $2
    `, [s, n])

    // 5) Índices
    const { rows: idxs } = await client.query(`
      select i.relname as index_name,
             ix.indisunique as is_unique,
             array(
               select a.attname
               from pg_attribute a
               where a.attrelid = ix.indrelid and a.attnum = any(ix.indkey)
               order by array_position(ix.indkey, a.attnum)
             ) as columns
      from pg_class t
      join pg_namespace ns on ns.oid = t.relnamespace
      join pg_index ix on ix.indrelid = t.oid
      join pg_class i on i.oid = ix.indexrelid
      where ns.nspname=$1 and t.relname=$2
        and not ix.indisprimary
      order by i.relname
    `, [s, n])

    const columns = cols.map((c: any) => ({
      name: c.column_name,
      type: c.data_type,
      required: c.is_nullable === 'NO',
      default: c.column_default ?? undefined,
      pk: pkSet.has(c.column_name) || undefined,
    }))

    const relations = fks.map((f: any) => ({
      from: f.col,
      to: `${f.fk_schema}.${f.fk_table}.${f.fk_col}`,
    }))

    const indexes = idxs.map((i: any) => ({
      name: i.index_name,
      unique: i.is_unique,
      columns: i.columns,
    }))

    schemas.get(s).tables.push({
      name: n,
      purpose: "",    // lo rellenarás más tarde
      columns, relations, indexes,
      trace: [],      // para trazabilidad EP/US
    })
  }

  await client.end()

  const doc = {
    version: 1,
    generated_at: new Date().toISOString(),
    schemas: Array.from(schemas.values()),
  }

  const outDir = path.resolve('03-poc/0301-database')
  await fs.mkdir(outDir, { recursive: true })
  await fs.writeFile(path.join(outDir, 'DATABASE.yaml'), YAML.stringify(doc))
  console.log('✅ DATABASE.yaml actualizado')
}

main().catch(e => { console.error('❌', e); process.exit(1) })
