import dotenv from "dotenv";
dotenv.config({ path: "infra/env/.env.local" });
import { Client } from "pg";
import fs from "node:fs/promises";
import path from "node:path";

async function main() {
  const client = new Client({
    host: process.env.PGHOST,
    port: parseInt(process.env.PGPORT || "5432", 10),
    database: process.env.PGDATABASE,
    user: process.env.PGUSER,
    password: process.env.PGPASSWORD,
    ssl: process.env.PGSSLMODE === "require" ? { rejectUnauthorized: false } : undefined,
  });
  await client.connect();

  const dir = "03-poc/0301-database/seeds/seeds_sql";
  const files = (await fs.readdir(dir))
    .filter(f => f.toLowerCase().endsWith(".sql"))
    .sort(); // por prefijo 010_, 020_, ...

  if (files.length === 0) {
    console.log("?? No hay ficheros SQL en seeds_sql/. Genera los archivos SQL manualmente antes de aplicar.");
    await client.end();
    return;
  }

  for (const f of files) {
    const full = path.join(dir, f);
    const sql = await fs.readFile(full, "utf8");
    console.log(`?? applying ${f}`);
    try {
      await client.query("BEGIN");
      await client.query(sql);
      await client.query("COMMIT");
      console.log(`? applied ${f}`);
    } catch (e:any) {
      await client.query("ROLLBACK");
      console.error(`? error en ${f}:`, e?.message || e);
      await client.end();
      process.exit(1);
    }
  }

  await client.end();
}
main().catch(e => { console.error("? apply-seeds:", e); process.exit(1); });
