# -*- coding: utf-8 -*-
"""Regenera REQUISITOS-FUNCIONALES-DETALLE.html desde el .md (markdown-it-cli + ensamblado)."""
import re
import subprocess
import sys
from pathlib import Path

DIR = Path(__file__).resolve().parent
MD = DIR / "REQUISITOS-FUNCIONALES-DETALLE.md"
BODY_TMP = DIR / "REQUISITOS-FUNCIONALES-DETALLE-body.html"
OUT = DIR / "REQUISITOS-FUNCIONALES-DETALLE.html"


def run_markdown_converter():
    """Usa marked-cli (tablas GFM). Alternativa: markdown-it-cli con .markdownitrc válido."""
    cmd = f'npx --yes marked-cli "{MD.name}" -o "{BODY_TMP.name}"'
    r = subprocess.run(cmd, cwd=str(DIR), shell=True)
    if r.returncode != 0:
        raise subprocess.CalledProcessError(r.returncode, cmd)


def postprocess_body(html: str) -> str:
    # Quitar H1 duplicado (el título va en doc-header)
    html = re.sub(r"^<h1>.*?</h1>\s*", "", html, count=1, flags=re.DOTALL)

    # Quitar párrafo "Documento para desarrolladores" duplicado con doc-header
    html = re.sub(
        r"^<p><strong>Documento para desarrolladores</strong>.*?</p>\s*",
        "",
        html,
        count=1,
        flags=re.DOTALL,
    )

    # Índice rápido del .md usa anclas largas; la barra lateral usa #mf-001 … #mf-014
    html = re.sub(r'href="#(mf-\d{3})--[^"]+"', r'href="#\1"', html)

    # IDs en H2 para la barra lateral
    html = html.replace(
        "<h2>Cómo usar este documento</h2>",
        '<h2 id="como-usar">Cómo usar este documento</h2>',
    )
    for n in range(1, 15):
        mid = f"{n:03d}"
        html = re.sub(
            rf"<h2>MF-{mid} —",
            rf'<h2 id="mf-{mid}">MF-{mid} —',
            html,
            count=1,
        )

    # Pie del .md: se usa el footer fijo del template
    html = re.sub(
        r"<hr>\s*<p><em>Documento de requisitos funcionales detallados.*?</em></p>\s*\Z",
        "",
        html,
        flags=re.DOTALL,
    )

    # Primera columna tipo "ID" en tablas de historias (MF-xxx-US-xxx)
    def mark_epic_ids(m):
        block = m.group(0)
        return re.sub(
            r"<tr>\s*\n<td>(MF-\d{3}-US-\d{3})</td>",
            r'<tr>\n<td class="epic-id">\1</td>',
            block,
        )

    html = re.sub(
        r"(<h3>Historias de usuario</h3>\s*<table>.*?</table>)",
        mark_epic_ids,
        html,
        flags=re.DOTALL,
    )

    return html.strip()


def main():
    print("Ejecutando marked-cli (npx)...")
    try:
        run_markdown_converter()
    except (subprocess.CalledProcessError, FileNotFoundError) as e:
        print("npx/marked-cli falló:", e, file=sys.stderr)
        if not BODY_TMP.exists():
            sys.exit(1)
        print("Usando body existente:", BODY_TMP)

    body = BODY_TMP.read_text(encoding="utf-8")
    body = postprocess_body(body)

    shell = r"""<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Requisitos funcionales detallados — Módulo de facturación Kameleon App</title>
  <style>
    :root {
      --color-primary: #1a365d;
      --color-primary-light: #2c5282;
      --color-accent: #2b6cb0;
      --color-text: #2d3748;
      --color-text-muted: #4a5568;
      --color-border: #e2e8f0;
      --color-bg: #f7fafc;
      --color-bg-card: #fff;
      --font-sans: 'Segoe UI', system-ui, -apple-system, sans-serif;
      --font-mono: 'Consolas', 'Monaco', monospace;
      --shadow: 0 1px 3px rgba(0,0,0,.08);
      --radius: 6px;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      font-family: var(--font-sans);
      font-size: 15px;
      line-height: 1.6;
      color: var(--color-text);
      background: var(--color-bg);
    }
    .page-header {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      z-index: 100;
      background: #1a365d;
      color: #fff;
      padding: 1rem 2rem;
      min-height: 72px;
      box-shadow: 0 2px 8px rgba(0,0,0,.15);
    }
    .page-header h1 {
      font-size: 1.5rem;
      font-weight: 700;
      color: #fff;
      margin: 0 0 .35rem 0;
    }
    .page-header .subtitle {
      font-size: 0.9rem;
      color: rgba(255,255,255,.85);
      margin: 0;
    }
    .sidebar {
      position: fixed;
      top: 72px;
      left: 0;
      width: 220px;
      bottom: 0;
      z-index: 50;
      background: var(--color-bg-card);
      border-right: 1px solid var(--color-border);
      overflow-y: auto;
      padding: 1rem 0;
    }
    .sidebar nav { padding: 0 .75rem; }
    .sidebar .nav-title {
      font-size: 0.75rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: .05em;
      color: var(--color-text-muted);
      margin: 0 0 .5rem 0;
      padding: 0 .5rem;
    }
    .sidebar ul { list-style: none; padding: 0; margin: 0; }
    .sidebar li { margin: 0; }
    .sidebar a {
      display: block;
      padding: .4rem .5rem;
      font-size: 0.875rem;
      color: var(--color-accent);
      text-decoration: none;
      border-radius: 4px;
    }
    .sidebar a:hover {
      background: var(--color-bg);
      color: var(--color-primary);
    }
    .main-with-sidebar {
      margin-left: 220px;
      margin-top: 72px;
      min-height: calc(100vh - 72px);
    }
    .doc {
      max-width: 900px;
      margin: 0 auto;
      padding: 2rem;
      background: var(--color-bg-card);
      box-shadow: var(--shadow);
    }
    header.doc-header {
      border-bottom: 3px solid var(--color-primary);
      padding-bottom: 1.5rem;
      margin-bottom: 2rem;
    }
    header.doc-header h1 {
      font-size: 1.75rem;
      font-weight: 700;
      color: var(--color-primary);
      margin: 0 0 .5rem 0;
    }
    .doc .subtitle {
      font-size: 0.95rem;
      color: var(--color-text-muted);
      margin: 0;
    }
    h2 {
      font-size: 1.35rem;
      color: var(--color-primary);
      margin: 2.5rem 0 1rem 0;
      padding-bottom: .35rem;
      border-bottom: 1px solid var(--color-border);
    }
    h2:first-of-type { margin-top: 0; }
    h2[id] { scroll-margin-top: 130px; }
    h3 {
      font-size: 1.1rem;
      color: var(--color-primary-light);
      margin: 1.25rem 0 .5rem 0;
    }
    p { margin: .5rem 0 1rem 0; }
    ul, ol { margin: .5rem 0 1rem 0; padding-left: 1.5rem; }
    li { margin: .25rem 0; }
    li ul, li ol { margin: .25rem 0; }
    strong { color: var(--color-primary); font-weight: 600; }
    hr {
      border: none;
      border-top: 1px solid var(--color-border);
      margin: 2rem 0;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      font-size: 0.9rem;
      margin: 1rem 0;
      box-shadow: var(--shadow);
      border-radius: var(--radius);
      overflow: hidden;
    }
    th, td {
      padding: .6rem .85rem;
      text-align: left;
      border-bottom: 1px solid var(--color-border);
    }
    th {
      background: var(--color-primary);
      color: #fff;
      font-weight: 600;
    }
    tr:nth-child(even) { background: var(--color-bg); }
    tr:hover { background: #edf2f7; }
    .epic-id { font-weight: 600; color: var(--color-accent); }
    footer.doc-footer {
      margin-top: 3rem;
      padding-top: 1rem;
      border-top: 1px solid var(--color-border);
      font-size: 0.85rem;
      color: var(--color-text-muted);
      font-style: italic;
    }
    code { font-family: var(--font-mono); font-size: 0.88em; background: var(--color-bg); padding: .1rem .35rem; border-radius: 4px; }
    @media print {
      body { background: #fff; }
      .page-header { position: static; background: #1a365d; color: #fff; }
      .sidebar { display: none; }
      .main-with-sidebar { margin-left: 0; margin-top: 0; }
      .doc { box-shadow: none; max-width: none; }
      h2 { break-after: avoid; }
    }
  </style>
</head>
<body>
  <header class="page-header">
    <h1>Definición de Requisitos: Módulo de Finanzas</h1>
    <p class="subtitle">Sistema: Kameleon App</p>
  </header>

  <aside class="sidebar" aria-label="Índice del documento">
    <nav>
      <p class="nav-title">Navegación</p>
      <ul>
        <li><a href="#como-usar">Cómo usar</a></li>
        <li><a href="#mf-001">MF-001 Activación</a></li>
        <li><a href="#mf-002">MF-002 Factura cierre</a></li>
        <li><a href="#mf-003">MF-003 Facturación núcleo</a></li>
        <li><a href="#mf-004">MF-004 Cobros</a></li>
        <li><a href="#mf-005">MF-005 Notas de crédito</a></li>
        <li><a href="#mf-006">MF-006 PDF y email</a></li>
        <li><a href="#mf-007">MF-007 Facturación proyecto</a></li>
        <li><a href="#mf-008">MF-008 Anticipos</a></li>
        <li><a href="#mf-009">MF-009 Portal cliente</a></li>
        <li><a href="#mf-010">MF-010 Dashboard</a></li>
        <li><a href="#mf-011">MF-011 Maestros</a></li>
        <li><a href="#mf-012">MF-012 Moneda</a></li>
        <li><a href="#mf-013">MF-013 Roles</a></li>
        <li><a href="#mf-014">MF-014 Auditoría</a></li>
      </ul>
    </nav>
  </aside>

  <div class="main-with-sidebar">
    <div class="doc">
      <header class="doc-header">
        <h1>Requisitos funcionales detallados — Módulo de facturación Kameleon App</h1>
        <p class="subtitle">Documento para desarrolladores: especificación en profundidad de cada funcionalidad del módulo de facturación, con procesos, reglas de negocio, validaciones y criterios de aceptación.</p>
      </header>

    <main>
__BODY__
      <footer class="doc-footer">
        Generado desde <code>REQUISITOS-FUNCIONALES-DETALLE.md</code> · Módulo de facturación Kameleon App · Equipo de desarrollo.
      </footer>
    </main>
    </div>
  </div>
</body>
</html>
"""

    final = shell.replace("__BODY__", body + "\n")
    OUT.write_text(final, encoding="utf-8")
    print("Escrito:", OUT)


if __name__ == "__main__":
    main()
