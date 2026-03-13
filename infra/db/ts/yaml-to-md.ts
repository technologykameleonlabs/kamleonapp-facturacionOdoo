import fs from "node:fs/promises";
import path from "node:path";
import YAML from "yaml";

async function main() {
  const base = "03-poc/0301-database";
  const ypath = path.join(base, "DATABASE.yaml");
  const mpath = path.join(base, "DATABASE.md");

  const ytxt = await fs.readFile(ypath, "utf8");
  const y = YAML.parse(ytxt);

  const out: string[] = ["# Database Snapshot", ""];
  out.push(`_Generated at: ${y.generated_at}_`, "");

  for (const s of (y.schemas ?? [])) {
    out.push(`## \`${s.name}\``, "");
    for (const t of (s.tables ?? [])) {
      out.push(`### \`${s.name}.${t.name}\``);
      if (t.purpose) out.push("", t.purpose);

      out.push(
        "",
        "| Column | Type | Req | Default | PK |",
        "|---|---|---|---|---|"
      );

      for (const c of (t.columns ?? [])) {
        out.push(
          `| \`${c.name}\` | ${c.type} | ${c.required ? "?" : "-"} | ${c.default ?? ""} | ${c.pk ? "?" : "-"} |`
        );
      }

      if ((t.relations ?? []).length) {
        out.push("", "**Relations**");
        for (const r of t.relations) {
          out.push(`- \`${r.from}\`  \`${r.to}\``);
        }
      }

      if ((t.indexes ?? []).length) {
        out.push("", "**Indexes**");
        for (const i of t.indexes) {
          const cols = Array.isArray(i.columns) ? i.columns : [i.columns].filter(Boolean);
          out.push(
            `- \`${i.name}\`${i.unique ? " _(unique)_" : ""}: (${cols.join(", ")})`
          );
        }        
      }

      if ((t.trace ?? []).length) {
        out.push("", "**Trace (EP/US)**");
        for (const tr of t.trace) {
          const usStr = Array.isArray(tr.user_stories) ? tr.user_stories.join(", ") : (tr.user_stories || "undefined");
          const desc = tr.description || "";
          out.push(`- \`${tr.epic}\`/\`${usStr}\`: ${desc}`);
        }
      }

      out.push(""); // spacer
    }
  }

  await fs.writeFile(mpath, out.join("\n"));
  console.log(" DATABASE.md actualizado");
}

main().catch((e) => {
  console.error("", e);
  process.exit(1);
});