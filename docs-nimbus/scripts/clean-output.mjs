import { rm } from "node:fs/promises";
import { fileURLToPath } from "node:url";

const outputDirectories = ["../dist/", "../.astro/", "../.nimbus/"].map(
  (directory) => fileURLToPath(new URL(directory, import.meta.url)),
);

for (const directory of outputDirectories) {
  await rm(directory, { recursive: true, force: true });
}
process.stdout.write("Nimbus output and build caches removed.\n");
