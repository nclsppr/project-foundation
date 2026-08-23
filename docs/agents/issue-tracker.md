# Issue tracker: GitHub

Issues and specifications for `nclsppr/project-foundation` live in GitHub
Issues. Run the `gh` CLI from this repository so it resolves the remote.

## Conventions

- Create an issue with `gh issue create --title "..." --body "..."`. Use a
  heredoc for a multi-line body.
- Read an issue with `gh issue view <number> --comments`. Fetch labels when the
  task depends on its triage state.
- List issues with
  `gh issue list --state open --json number,title,body,labels,comments` and use
  `--label`, `--state`, and `--jq` filters as needed.
- Comment with `gh issue comment <number> --body "..."`.
- Add or remove labels with `gh issue edit <number> --add-label "..."` and
  `gh issue edit <number> --remove-label "..."`.
- Close an issue with `gh issue close <number> --comment "..."`.

## Pull requests as a triage surface

**PRs as a request surface: no.** Set this value to `yes` only if external pull
requests must enter the issue triage queue.

If the value becomes `yes`, use the corresponding `gh pr` commands:

- Read a pull request with `gh pr view <number> --comments` and
  `gh pr diff <number>`.
- List external pull requests with
  `gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments`.
  Keep only `CONTRIBUTOR`, `FIRST_TIME_CONTRIBUTOR`, or `NONE` author
  associations.
- Comment, label, or close with `gh pr comment`, `gh pr edit`, and
  `gh pr close`.

GitHub shares one number space across issues and pull requests. For a bare
number such as `#42`, run `gh pr view 42` and fall back to
`gh issue view 42`.

## Skill operations

When a skill says to publish to the issue tracker, create a GitHub issue. When
it says to fetch the relevant ticket, run
`gh issue view <number> --comments`.

## Wayfinding operations

The map is one issue with child issues as tickets.

- Create the map with the `wayfinder:map` label. Its body contains Notes,
  Decisions-so-far, and Fog.
- Link each child through GitHub sub-issues. If sub-issues are unavailable, add
  the child to a task list in the map and put `Part of #<map>` at the start of
  the child body. Apply one `wayfinder:<type>` label: `research`, `prototype`,
  `grilling`, or `task`.
- Represent blocking with GitHub issue dependencies. Add an edge with
  `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-database-id>`.
  Obtain the database identifier with
  `gh api repos/<owner>/<repo>/issues/<number> --jq .id`. If dependencies are
  unavailable, put `Blocked by: #<number>` at the start of the child body.
- Build the frontier from the map's open children. Drop assigned children and
  children with an open blocker. Select the first remaining child in map order.
- Claim a child with `gh issue edit <number> --add-assignee @me`. This is the
  session's first write.
- Resolve a child by commenting with the answer, closing the issue, and adding
  its context pointer and link to the map's Decisions-so-far section.
