import assert from "node:assert/strict";
import path from "node:path";
import test from "node:test";
import {
  convertSourceDocument,
  destinationFor,
} from "./sync-content.mjs";

test("converts a plain Markdown source into Nimbus content", () => {
  const sourcePaths = new Set(["README.md", "docs/decision.md"]);
  const result = convertSourceDocument(
    "# Project\n\nRead [the decision](docs/decision.md).\n",
    "README.md",
    "public",
    sourcePaths,
    "",
  );

  assert.match(result.content, /^---\ntitle: Project\n/);
  assert.match(result.content, /sourcePath: README.md/);
  assert.match(result.content, /visibility: public/);
  assert.match(result.content, /\[the decision\]\(\/docs\/decision\)/);
  assert.doesNotMatch(result.content, /^# Project$/m);
});

test("preserves useful source frontmatter and disables archive search", () => {
  const result = convertSourceDocument(
    "---\nlabel: Previous decision\norder: 4\n---\n\n# Decision\n\nHistory.\n",
    "archive/decision.md",
    "archive",
    new Set(["archive/decision.md"]),
    "/docs",
  );

  assert.match(result.content, /sidebar:\n  order: 4\n  label: Previous decision/);
  assert.match(result.content, /searchable: false/);
});

test("maps README files to directory indexes", () => {
  assert.equal(path.basename(destinationFor("README.md")), "overview.mdx");
  assert.match(
    destinationFor("guides/README.md"),
    /src\/content\/docs\/guides\/index\.mdx$/u,
  );
});

test("links the root README to Nimbus' overview route", () => {
  const result = convertSourceDocument(
    "# Catalog\n\nRead [the overview](README.md).\n",
    "DOCUMENTATION-CATALOG.md",
    "reference",
    new Set(["DOCUMENTATION-CATALOG.md", "README.md"]),
    "",
  );

  assert.match(result.content, /\[the overview\]\(\/overview\)/u);
});
