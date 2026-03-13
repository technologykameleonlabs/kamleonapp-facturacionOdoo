import { sb } from './supabaseClient'

async function main() {
  try {
    const { data, error } = await sb
      .from('cfg_table_routes')  // cambia el nombre si tu tabla es otra
      .select('*')
      .limit(10)

    if (error) {
      console.error(' Error en la query:', error.message)
      process.exit(1)
    }

    if (!data || data.length === 0) {
      console.log('? Query ok, pero no hay filas en la tabla.')
      return
    }

    console.table(data)
  } catch (err) {
    console.error(' Excepción inesperada:', err)
    process.exit(1)
  }
}

main()