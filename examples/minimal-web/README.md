# Narrative example: Trail Card Lab

This example is entirely fictional. The people, product, and data are fictional. They show how to complete the lightweight process. This directory contains no application, deployment, or product verification.

This composite README is not the file tree produced by the bootstrap process or evidence of actual adoption. It shows the expected content without copying all generated files.

The primary project-specific documents that an actual repository creates use these templates:

- [Minimal README](../../templates/README.md)
- [Exploration brief](../../templates/BRIEF.md)
- [Minimal agent adapter](../../templates/AGENTS-minimal.md)
- [Foundation adoption contract](../../templates/FOUNDATION.md)

The bootstrap process also adds the core snapshot, the two profiles, and the verification scripts.

## Fictional project README

**Trail Card Lab** explores whether a static route card can show five fictional steps on a 320 px screen, remain usable with a keyboard, and print without overflow.

> Status: Documented exploration. Implementation has not started. No result is proven.

### Start

| Action | Command | Expected result |
| --- | --- | --- |
| Install | Not applicable at this stage | No package |
| Start | Not available before the exploration increment | No announced URL |
| Verify | Not available before the exploration increment | No announced verification |
| Stop or clean up | Not applicable at this stage | No process or state to remove |

A future increment can adopt a static server and a verification script. These commands are not documented as existing before they are added.

### Planned documentation map

```text
README.md
BRIEF.md
FOUNDATION.md
AGENTS.md
docs/foundation/
  PRINCIPLES.md
  DEFAULTS.md
  DEFINITION-OF-DONE.md
  profiles/
    experiment.md
    web.md
scripts/
  check_markdown.py
  verify.sh
```

## Completed BRIEF

### Identity

| Field | Value |
| --- | --- |
| Name | Trail Card Lab |
| Owner | Camille Martin, fictional person |
| Class | Exploration |
| Status | Not started |
| Start | 2026-07-27 |
| Limit | One workday, without a paid service |

### Question

Can an HTML and CSS page without JavaScript show five fictional steps clearly at 320 px, support keyboard navigation, and print clearly without horizontal overflow?

### Context and user

The fictional scenario concerns a product designer who wants to test a composition before proposing a product. No user interview occurred. The user need is an assumption, not a verified fact.

### Expected evidence

One local prototype with five synthetic steps. The evidence includes documented controls at 320 px and 1280 px, with a keyboard, with reduced motion, and in print preview.

### Scope

Included:

- one static page;
- five fully synthetic steps and durations;
- one mobile composition and one desktop composition;
- visible focus states;
- print preview.

Excluded:

- actual geographical map;
- user account, backend, or storage;
- geolocation;
- public publication;
- conversion measurement or tests with actual people.

### Facts and assumptions

| Type | Statement | Source or next verification |
| --- | --- | --- |
| Fact | This directory contains no application code | Inspection of the example file tree |
| Fact | All steps and durations will be synthetic | Exploration contract |
| Assumption | HTML and CSS will be sufficient for the primary path | Test with the local prototype |
| Assumption | Five steps will remain clear at 320 px without hiding information | Verify visually and with a keyboard |

### Constraints

- Data and confidentiality: Synthetic data only. No personal data.
- Access and secrets: None.
- Maximum time and cost: One workday and no external cost.
- Activated profiles: See the completed `FOUNDATION` contract below.

### Conclusion conditions

- Success: The five steps remain clear without overflow at 320 px and 1280 px. Keyboard order is logical. Print output does not cut off a step.
- Failure: Essential information must be hidden, the keyboard cannot navigate planned actions, or the layout requires JavaScript only to fit.
- Stop: The workday ends, real data becomes necessary, or public publication is requested.

### Verified state and conclusion

- Verified on: 2026-07-26.
- Environment or artifact: Example documentation only.
- Observations: No HTML file, CSS file, script, or deployment exists.
- Conclusion: Not concluded because no prototype or measurement exists.
- Evidence limitations: The documentation shows the method. It does not prove interface feasibility.

### Next decision

Create no more than one local one-day increment, then record the observations. Stop if a stop criterion occurs. If the evidence is positive and a decision permits use by actual people, use the standard bootstrap process. Do not extend this brief.

## Completed FOUNDATION

| Field | Example value |
| --- | --- |
| Source | Fictional `project-foundation` repository |
| Readable version | `v0.1.0`, fictional compliant tag |
| Immutable commit | `1111111111111111111111111111111111111111`, fictional SHA |
| Adopted pack | `minimal` |
| Adopted on | 2026-07-26 |
| Adopted by | Camille Martin, fictional person |
| Snapshot | `PRINCIPLES.md`, `DEFAULTS.md`, `DEFINITION-OF-DONE.md` |
| Activated profiles | `experiment` and `web` |
| Exceptions | None |
| Additional local source | `BRIEF.md` for data and cost limits |

## Completed minimal AGENTS

The local adapter does not copy a core rule. It routes each question:

| Question | Source in the example |
| --- | --- |
| Work authority | Camille's current request, within the foundation limits |
| Intent | Question, scope, and criteria in `BRIEF.md` |
| Current state | Files and commands observed in the repository at work time |
| History | Git and dated decisions, without presenting them as the current state |

The agent stays within the one-day limit, uses only commands that exist, and then updates the brief conclusion. A request for publication or actual data stops the exploration and requires reclassification.
