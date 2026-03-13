import dotenv from "dotenv";
dotenv.config({ path: "infra/env/.env.local" });
import { Client } from "pg";
import fs from "node:fs/promises";
import path from "node:path";

async function main() {
  const file = process.argv[2];
  if (!file) {
    console.error(" Uso: npm run db:sql <archivo.sql>");
    process.exit(1);
  }
  const resolvedPath = path.resolve(file);
  console.log(`Ejecutando archivo: ${resolvedPath}`);
  const sql = await fs.readFile(resolvedPath, "utf8");

  // Dividir el SQL en instrucciones separadas de manera más robusta
  const statements: string[] = [];
  let currentStatement = '';
  let inString = false;
  let stringChar = '';
  let inBlockComment = false;
  let inLineComment = false;
  let inDollarQuote = false;
  let dollarQuoteTag = '';
  let parenthesesDepth = 0;

  for (let i = 0; i < sql.length; i++) {
    const char = sql[i];
    const nextChar = sql[i + 1] || '';

    // Manejar comentarios
    if (!inString && !inBlockComment && char === '-' && nextChar === '-') {
      inLineComment = true;
      currentStatement += char;
      continue;
    }
    if (inLineComment && char === '\n') {
      inLineComment = false;
      currentStatement += char;
      continue;
    }
    if (inLineComment) {
      currentStatement += char;
      continue;
    }

    if (!inString && char === '/' && nextChar === '*') {
      inBlockComment = true;
      currentStatement += char;
      continue;
    }
    if (inBlockComment && char === '*' && nextChar === '/') {
      inBlockComment = false;
      currentStatement += char + nextChar;
      i++; // Saltar el siguiente carácter
      continue;
    }
    if (inBlockComment) {
      currentStatement += char;
      continue;
    }

    // Manejar strings
    if (!inString && (char === '"' || char === "'")) {
      inString = true;
      stringChar = char;
    } else if (inString && char === stringChar) {
      // Verificar si es un escape
      if (stringChar === "'" && nextChar === "'") {
        // Comilla escapada en PostgreSQL (doble comilla simple)
        currentStatement += char + nextChar;
        i++; // Saltar la siguiente comilla
        continue;
      } else {
        inString = false;
        stringChar = '';
      }
    }

    // Manejar paréntesis
    if (!inString && !inDollarQuote) {
      if (char === '(') {
        parenthesesDepth++;
      } else if (char === ')') {
        parenthesesDepth--;
      }
    }

    // Manejar delimitadores $$ de PostgreSQL
    if (!inString && !inBlockComment && !inLineComment && char === '$' && nextChar === '$') {
      if (!inDollarQuote) {
        // Entrando en un bloque $$
        inDollarQuote = true;
        dollarQuoteTag = '$$';
        currentStatement += '$$';
        i++; // Saltar el siguiente $
        continue;
      } else if (dollarQuoteTag === '$$') {
        // Saliendo de un bloque $$
        inDollarQuote = false;
        dollarQuoteTag = '';
        currentStatement += '$$';
        i++; // Saltar el siguiente $
        continue;
      }
    }

    // Manejar punto y coma
    if (!inString && !inBlockComment && !inLineComment && !inDollarQuote && parenthesesDepth === 0 && char === ';') {
      if (currentStatement.trim()) {
        statements.push(currentStatement.trim());
      }
      currentStatement = '';
      continue;
    }

    currentStatement += char;
  }

  // Agregar la última instrucción si existe
  if (currentStatement.trim()) {
    statements.push(currentStatement.trim());
  }

  console.log(`Encontradas ${statements.length} instrucciones SQL`);

  const client = new Client({
    host: process.env.PGHOST,
    port: parseInt(process.env.PGPORT || "5432", 10),
    database: process.env.PGDATABASE,
    user: process.env.PGUSER,
    password: process.env.PGPASSWORD,
    ssl: process.env.PGSSLMODE === "require" ? { rejectUnauthorized: false } : undefined,
  });

  try {
    await client.connect();
    await client.query("BEGIN");

    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i];
      console.log(`Ejecutando instrucción ${i + 1}/${statements.length}`);
      if (statement.trim()) {
        // Agregar punto y coma si no está presente
        const statementWithSemicolon = statement.trim().endsWith(';') ? statement : statement + ';';

        // Verificar si es una consulta SELECT para mostrar resultados
        const isSelectQuery = /^\s*SELECT/i.test(statementWithSemicolon.trim());

        const result = await client.query(statementWithSemicolon);

        // Mostrar resultados de consultas SELECT
        if (isSelectQuery && result.rows && result.rows.length > 0) {
          console.log(`Resultado (${result.rows.length} filas):`);
          console.log('─'.repeat(50));
          console.table(result.rows);
          console.log('─'.repeat(50));
        } else if (isSelectQuery) {
          console.log('Resultado: 0 filas');
        }
      }
    }

    await client.query("COMMIT");
    console.log(` Ejecutado ${file} exitosamente`);
  } catch (e:any) {
    await client.query("ROLLBACK");
    console.error(` Error ejecutando ${file}:`, e.message);
    console.error(`Instrucción problemática:`, e.query || 'N/A');
    process.exit(1);
  } finally {
    await client.end();
  }
}
main();