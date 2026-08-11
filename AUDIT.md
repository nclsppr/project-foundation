# Foundation source audit

Snapshot created on 2026-07-26 from the local state of the `surplasse`, `personal`, `papersempire`, and `vps` projects. The `Developer/.claude` configuration provided supporting evidence.

This file explains the synthesis. It is not a normative source and does not replace a review of the repositories.

## Method

The audit compared:

- the `AGENTS.md`, `CLAUDE.md`, README, and design systems;
- the ADRs, roadmaps, and architecture, development, and operations documents;
- the scripts, hooks, package commands, and CI workflows;
- the Git state and the files that were present;
- the runbooks and production rules;
- the differences between the documented, automated, and currently executable behavior.

The audit used changelogs and dated audits only as historical records. It never used them as current requirements.

## Snapshot manifest

| Local area | Branch or status | Revision | State at the time of the audit | Primary sources |
| --- | --- | --- | --- | --- |
| `surplasse/` | `main` | `fab494ad2940f9ee46bf9a186ec7fb2735185367` | 6 worktree entries, mainly untracked, including the obsolete root `AGENTS.md` | `docs/AGENTS.md`, `CLAUDE.md`, README, ADRs, product, architecture, development, operations, scripts, and workflows |
| `personal/` | `codex/design-review-evolution` | `3a040e8c2a099e4a0647c7f27aeb8e080de09d97` | clean | `AGENTS.md`, `DESIGN.md`, README, information files, scripts, hooks, and changelog |
| `papersempire/` | `master` | `0591dea0ad7ec53c27eaa3965ccb8de642b6d16b` | clean | README, `docs/`, package, actual tree, and workflow |
| `vps/` | outside Git | SHA-256 `b641843c9ba39b4471dd5a35bcbc9dbc9194142e0149873610c6e405cfda7f97` | `VPS-SETUP.md`, mtime `2026-07-15T11:14:12+0200` | complete runbook |
| `Developer/.claude/` | outside Git, supporting evidence | `settings.json` SHA-256 `da59b3240683c662c57ab59717e0e6910810e7967053babb7c335d193acb9cfb`, `settings.local.json` SHA-256 `502ec9ca623a1bd044a97e842113f3f6da30c06ba693d055a2c61d270ccd5199` | mtimes `2026-07-18T05:28:20+0200` and `2026-07-16T00:19:16+0200` | Claude-specific hooks and permissions |

The Git states and dates are historical. Verify them again before you correct a source repository.

## Selected recurring rules

The four areas have these rules in common:

1. Understand the product and context before you examine the technology stack.
2. Do not invent information. Identify uncertainty.
3. Identify one source of truth for each concept.
4. Document structural decisions.
5. Preserve unrelated changes.
6. Verify a unit of work before delivery.
7. Make commands reproducible.
8. Keep secrets out of Git and output.
9. Plan rollback, backup, and restore procedures.
10. Validate the final surface, not only the code.
11. Treat accessibility, performance, and resilience as product constraints.
12. Isolate experiments and document their removal.
13. Commit sources and derived files atomically.
14. Keep the environment close to the production environment.

## Decisions that are not invariants

The following rules can be personal defaults or profiles, but they are not invariants:

- the `main` or `master` branch, direct push or pull request;
- the documentation language and commit convention;
- a prohibition on em dashes;
- static architecture, React, Quarkus, PostgreSQL, Docker, or Caddy;
- Retype, Nimbus, GitHub Pages, or Infomaniak;
- the number of languages and the i18n strategy;
- brand details, color palettes, fonts, and iconography;
- the absence or presence of a specific automated test suite;
- VPS paths, ports, domains, and networks;
- the automatic publication policy of a specific repository.

The foundation preserves the form of the decision, not its contextual value.

## Observed deviations

### Rule duplication

In `surplasse`, rules are repeated in `AGENTS.md`, `CLAUDE.md`, and `docs/AGENTS.md`. They diverged on the product phase, documentation engine, and commands.

In `personal`, content authority, parity, artifact generation, and publication are repeated in the README, `AGENTS.md`, `DESIGN.md`, and the article playbook.

**Lesson.** A rule must have one source. Tool-compatible files remain small pointers.

### Documentation differs from executable behavior

In `papersempire`, several documents state both that tests are present and that tests are absent. The current tree does not contain the documented test directory, and `package.json` no longer provides the documented commands. The name and version numbers also differ between several files.

In `surplasse`, a root document still describes a project without code and an old documentation engine. The repository and ADRs show a more recent state.

**Lesson.** Documented intent and operational state are different sources of truth. Audit and then correct a difference explicitly.

Therefore, the foundation template separates `PROJECT.md`, a relatively stable contract, from `STATUS.md`, a dated snapshot, and from `ROADMAP.md`, the sequencing authority.

### Agent-specific controls presented as general protections

In `personal`, the “Git hooks” are actually Claude `PreToolUse` hooks. They do not protect an external terminal, Codex, a Git GUI, or CI. Some controls also cover a smaller scope than the written rule.

The global configuration in `Developer/.claude` runs project-specific controls during actions on other projects.

**Lesson.** Critical rules belong in an agent-neutral command and in CI. Agent hooks remain local, scope-aware shortcuts.

### Copied procedures

In `personal`, the README describes the PDF procedure manually, although a canonical script already exists. The two procedures diverged.

**Lesson.** Documentation explains the intent and calls a command. The script contains the executable details.

### Historical runbook used as the current state

The `vps/VPS-SETUP.md` runbook describes a Papers Empire target that differs from the current repository and deployment. It also contains conflicts between the prohibition on displaying secrets and copying a private key, between backup protection and the retention policy, and between destructive-operation safeguards and `rsync --delete`.

**Lesson.** A runbook must contain a status, a last verification date, and checkpoints. Do not present a future target as the current system.

### Design plugins conflict with the project

UI skills installed in a repository can require visual terminology, an icon library, or motion that conflicts with its design system.

**Lesson.** Skills and plugins provide recommendations. The design system and local project constraints determine the decision.

## Targeted evidence index

Read the following lines in the snapshots that the manifest identifies:

| Finding | Evidence |
| --- | --- |
| Obsolete Surplasse root file | `surplasse/AGENTS.md:3,7,17-21`, untracked file; more recent state in `surplasse/CLAUDE.md:3` and documentation replacement in `surplasse/docs/decisions/adr-0038-nimbus-documentation-canonique.md:31-50` |
| Surplasse sources and derived files | `surplasse/docs/AGENTS.md:301-311` |
| Papers Empire contradictory test information | `papersempire/docs/AGENTS.md:32-33`, `papersempire/docs/DOCUMENTATION.md:29-39,75-78`, `papersempire/docs/accessibility.md:23-26`, `papersempire/package.json:5-10` |
| Papers Empire inconsistent versions | `papersempire/package.json:2-3`, `papersempire/retype.yml:10-12`, `papersempire/docs/RELEASE_NOTES.md:3-23`, `papersempire/docs/README.md:24-35` |
| Personal site, Claude-specific hooks | `personal/.claude/settings.json:2`, `personal/.claude/hooks/check-i18n-parity.py:12,49-56` |
| Personal site, different PDF rule and control | `personal/AGENTS.md:47`, `personal/scripts/generate-cv-pdf.sh:51`, `personal/.claude/hooks/check-cv-pdf.py:64` |
| VPS, secret displayed and then prohibited | `vps/VPS-SETUP.md:370-377,513-516` |
| VPS, conflict between retention and backup rule | `vps/VPS-SETUP.md:462-474,507-509` |
| VPS, destructive synchronization without an atomic release | `vps/VPS-SETUP.md:395-404,506-516` |
| Global agent configuration has excessive coupling | `Developer/.claude/settings.json:2-13`, `Developer/.claude/settings.local.json:14-33` |

## Location decision

The project did not select `vps/ai`:

- `vps` is not a Git repository;
- it contains an infrastructure-specific runbook;
- the runbook already identifies another repository as the canonical server source;
- multi-project rules must remain usable outside the VPS.

Therefore, the foundation is in `project-foundation`, an autonomous and agent-neutral repository. VPS rules are grouped in `profiles/infrastructure-production.md`.

## Limitations

This audit does not correct deviations in the source projects. Correct them one repository at a time. Use each repository's verification process and do not mix their worktrees.
