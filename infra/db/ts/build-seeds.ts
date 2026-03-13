import fs from "node:fs/promises";
import path from "node:path";
import YAML from "yaml";
import { parse } from "csv-parse/sync";

type Batch = {
  name: string;
  source: string;
  table: string;
  key: string[];               // columnas destino que forman la clave natural
  mapping: Record<string,string>; // origen->destino
  order?: number;
};

function sqlEscape(v: any): string {
  if (v === null || v === undefined || v === "") return "NULL";
  if (typeof v === "boolean") return v ? "true" : "false";
  if (typeof v === "number") return Number.isFinite(v) ? String(v) : "NULL";
  // fechas ISO simples
  if (v instanceof Date) return `'${v.toISOString().replace(/'/g,"''")}'`;
  const s = String(v);
  // intenta number
  if (/^-?\d+(\.\d+)?$/.test(s)) return s;
  // true/false
  if (/^(true|false)$/i.test(s)) return s.toLowerCase();
  return `'${s.replace(/'/g, "''")}'`;
}

async function buildCsv(batch: Batch, baseDir: string, outDir: string) {
  const src = path.join(baseDir, batch.source);
  const csv = await fs.readFile(src, "utf8");
  const rows: any[] = parse(csv, { columns: true, skip_empty_lines: true, trim: true });

  const destCols = Object.values(batch.mapping);
  const srcCols  = Object.keys(batch.mapping);

  const valuesSql: string[] = [];
  for (const r of rows) {
    const vals = srcCols.map(sc => sqlEscape(r[sc]));
    valuesSql.push(`(${vals.join(", ")})`);
  }

  if (valuesSql.length === 0) return null;

  const colsList = destCols.map(c => `"${c}"`).join(", ");
  const order = String(batch.order ?? 999).padStart(3, "0");
  const fname = `${order}_${batch.name}.sql`;
  const fpath = path.join(outDir, fname);

  // ON CONFLICT
  const hasKey = Array.isArray(batch.key) && batch.key.length > 0;
  const conflict = hasKey
    ? `on conflict (${batch.key.map(k=>`"${k}"`).join(", ")}) do nothing`
    : "";

  const sql = [
    `insert into ${batch.table} (${colsList})`,
    `values`,
    valuesSql.join(",\n"),
    conflict,
    `;`
  ].join("\n");

  await fs.writeFile(fpath, sql);
  return fname;
}

async function main() {
  const base = "03-poc/0301-database/seeds";
  const manifestTxt = await fs.readFile(path.join(base, "manifest.yaml"), "utf8");
  const manifest = YAML.parse(manifestTxt) as { batches: Batch[] };

  const outDir = path.join(base, "build");
  await fs.mkdir(outDir, { recursive: true });

  const batches = (manifest.batches || []).slice().sort((a,b) => (a.order??999) - (b.order??999));

  const generated: string[] = [];
  for (const b of batches) {
    const produced = await buildCsv(b, base, outDir);
    if (produced) {
      generated.push(produced);
      console.log(`? build ${produced}`);
    } else {
      console.log(`(i) ${b.name}: sin filas`);
    }
  }

  if (generated.length === 0) {
    console.log("?? No se gener� ning�n SQL (�CSV vac�o?)");
  }
}
main().catch(e => { console.error("? build-seeds:", e); process.exit(1); });
