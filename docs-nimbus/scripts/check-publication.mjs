import { readdir, readFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import YAML from "yaml";
import { parseVisibilityFilter } from "./sync-content.mjs";

const scriptDirectory = path.dirname(fileURLToPath(import.meta.url));
const contentRoot = path.resolve(scriptDirectory, "..", "src", "content", "docs");
const allowedVisibilities = parseVisibilityFilter(
  process.env.NIMBUS_VISIBILITIES || "",
);
const siteOrigin = (process.env.NIMBUS_SITE_ORIGIN || "")
  .trim()
  .replace(/\/+$/u, "");
const rawBasePath = (process.env.NIMBUS_BASE_PATH || "/").trim() || "/";
const sourceUrl = (process.env.NIMBUS_SOURCE_URL || "").trim();

if (!allowedVisibilities) {
  throw new Error("NIMBUS_VISIBILITIES is required for a publication build.");
}
if (!sourceUrl) {
  throw new Error("NIMBUS_SOURCE_URL is required for a publication build.");
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

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/gu, "\\$&");
}

const files = (await listFiles(contentRoot)).filter((file) =>
  file.endsWith(".mdx"),
);
if (files.length === 0) {
  throw new Error("The publication contains no Nimbus pages.");
}

for (const file of files) {
  const source = await readFile(file, "utf8");
  const match = source.match(/^---\r?\n([\s\S]*?)\r?\n---/u);
  if (!match) throw new Error(`Missing frontmatter in ${file}`);
  const frontmatter = YAML.parse(match[1]);
  if (!allowedVisibilities.has(frontmatter.visibility)) {
    throw new Error(
      `Publication contains ${frontmatter.visibility} content: ${frontmatter.sourcePath}`,
    );
  }
}

if (rawBasePath !== "/") {
  const basePath = rawBasePath.replace(/\/+$/u, "");
  const baseSegment = basePath.slice(1);
  const rootAttribute = new RegExp(
    `\\b(?:href|src|action)=["']/(?!/|${escapeRegExp(baseSegment)}(?:/|["']))`,
    "u",
  );
  const rootAbsoluteUrl = new RegExp(
    `${escapeRegExp(siteOrigin)}/(?!${escapeRegExp(baseSegment)}(?:/|$))`,
    "u",
  );
  const outputRoot = path.resolve(contentRoot, "..", "..", "..", "dist");
  for (const file of await listFiles(outputRoot)) {
    if (
      ![".html", ".md", ".mdx", ".txt", ".xml"].includes(
        path.extname(file),
      )
    ) {
      continue;
    }
    const output = await readFile(file, "utf8");
    if (rootAttribute.test(output) || rootAbsoluteUrl.test(output)) {
      throw new Error(`Publication contains an origin-root URL: ${file}`);
    }
  }
}

process.stdout.write(
  `Publication audience: ${files.length} pages use only ` +
    `${[...allowedVisibilities].join(", ")} content.\n`,
);
