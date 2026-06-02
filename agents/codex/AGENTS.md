# Development Standards — Stanley Mairon (Codex)

> Applies to every project in every Codex session.
> Mirrors agents/claude/CLAUDE.md — keep in sync when updating standards.

## Philosophy

Human decides WHAT and WHY. AI decides HOW.
Human navigates: direction, architecture, domain knowledge, stopping over-engineering.
AI pilots: code, tests, mechanical refactoring.

- Small releases: every commit is production-ready. Never commit something broken.
- Continuous refactoring: small, immediate surgery. Never accumulate technical debt.
- Atomic commits: one concern per commit, never mix unrelated changes.

## Code Style

- Functions: 4–20 lines. Split if longer.
- Files: under 500 lines. Split by responsibility.
- One thing per function, one responsibility per module (SRP).
- Names: specific and unique. Avoid `data`, `handler`, `Manager`. Prefer names that return <5 grep hits.
- Types: explicit. No `any` in TypeScript, no `Dict` without type in Python, no untyped functions.
- No code duplication. Extract shared logic into a function or module.
- Early returns over nested ifs. Max 2 levels of indentation.
- Exception messages must include the offending value and the expected shape.

## Comments

- Write WHY, not WHAT.
- Keep existing comments on refactor — they carry intent and provenance.
- Docstrings on public functions: intent + one usage example.

## Tests

- Every new function gets a test. Bug fixes get a regression test.
- Mock external I/O with named fake classes, not inline stubs.
- Tests must be F.I.R.S.T: fast, independent, repeatable, self-validating, timely.

## Dependencies

- Inject dependencies via constructor/parameter, not global/direct import.
- Wrap third-party libs behind a thin interface owned by this project.
- Never install, add, upgrade, or remove packages without explicit confirmation.

## Formatting

- TypeScript/JS: `prettier`
- Python: `ruff format`
- Go: `gofmt`
- Ruby: `rubocop -A`

## Commits

Conventional commits in English:

```
type(scope): short description (#issue)

- What changed and why

Closes #XX
```

Types: `fix`, `feat`, `docs`, `refactor`, `style`, `test`, `chore`

## What I Never Do

- Commit directly to main/master
- Skip type checks or linters before PR
- Use `any` in TypeScript or untyped functions in Python
- Write inline test stubs (use named fake classes instead)
- Nest more than 2 levels of indentation
- Add features or abstractions beyond what the task requires
- Design for hypothetical future requirements
- Force push or skip hooks
- Install, add, or remove packages without explicit confirmation
- Run tests autonomously — always prepare the command for the developer to run
