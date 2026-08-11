import { readdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const scriptDirectory = path.dirname(fileURLToPath(import.meta.url));
const outputRoot = path.resolve(scriptDirectory, "..", "dist");
const siteOrigin = (process.env.NIMBUS_SITE_ORIGIN || "")
  .trim()
  .replace(/\/+$/u, "");
const rawBasePath = (process.env.NIMBUS_BASE_PATH || "/").trim() || "/";

if (!siteOrigin) throw new Error("NIMBUS_SITE_ORIGIN is required.");
if (!rawBasePath.startsWith("/")) {
  throw new Error("NIMBUS_BASE_PATH must start with '/'.");
}

const basePath = rawBasePath === "/" ? "" : rawBasePath.replace(/\/+$/u, "");
if (!basePath) {
  process.stdout.write(
    "Publication uses the origin root. No URL rewrite is required.\n",
  );
  process.exit(0);
}

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/gu, "\\$&");
}

async function listFiles(directory) {
  const entries = await readdir(directory, { withFileTypes: true });
  const files = await Promise.all(
    entries.map((entry) => {
      const entryPath = path.join(directory, entry.name);
      return entry.isDirectory() ? listFiles(entryPath) : [entryPath];
    }),
  );
  return files.flat();
}

const baseSegment = basePath.slice(1);
const absoluteRoot = new RegExp(
  `${escapeRegExp(siteOrigin)}/(?!${escapeRegExp(baseSegment)}(?:/|$))`,
  "gu",
);
const rootAttribute = new RegExp(
  `(\\b(?:href|src|action)=["'])/(?!/|${escapeRegExp(baseSegment)}(?:/|["']))`,
  "gu",
);
const textExtensions = new Set([".html", ".md", ".mdx", ".txt", ".xml"]);
let changedFiles = 0;

for (const file of await listFiles(outputRoot)) {
  if (!textExtensions.has(path.extname(file))) continue;
  const source = await readFile(file, "utf8");
  const rewritten = source
    .replace(absoluteRoot, `${siteOrigin}${basePath}/`)
    .replace(rootAttribute, `$1${basePath}/`);
  if (rewritten === source) continue;
  await writeFile(file, rewritten, "utf8");
  changedFiles += 1;
}

process.stdout.write(
  `Publication base path ${basePath}/ applied to ${changedFiles} files.\n`,
);
