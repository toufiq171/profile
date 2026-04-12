# AGENTS.md
Guidance for agentic coding assistants operating in this repository.

## 1) Mission
- Static personal/brand site on GitHub Pages.
- Stack: plain HTML, CSS, small inline browser JS.
- Default branch: `main`.
- Goal: fast, safe, production-ready updates.

## 2) Rule Priority
Apply instructions in this order:
1. This repository-local `AGENTS.md`.
2. Cursor rules (`.cursor/rules/*` or `.cursorrules`) if present.
3. Copilot rules (`.github/copilot-instructions.md`) if present.
4. Generic assistant defaults.

## 3) Repository Map (Where to Put Things)
- `index.html`: all visible content, sections, nav links, forms, inline JS.
- `style.css`: all custom styles and responsive overrides.
- `assets/projects/`: downloadable artifacts (zip/rar/pdf/etc).
- `assets/`: mostly vendor-generated files; avoid editing unless asked.
- `gitserver`: canonical health/build/publish helper.
- `webmaster`: focused helper for verify/quick/ship workflows.
- `.build/`: generated output; never edit manually.

Section map in `index.html`:
- Hero copy: `#header05-1`
- Writing posts: `#features04-w`
- Projects list: `#projects-9`
- Contact and social: `#form02-6`

Placement rules:
- New writing: add `<article class="writing-item">` under `#features04-w`.
- Long writing: use `<details class="see-more"><summary>See more</summary>...</details>`.
- New project file: place in `assets/projects/` with lowercase-dash filename.
- New project entry: keep one-line format with download link first.
- Visual-only changes: edit `style.css`, not vendor CSS.
- Do not remove existing content unless explicitly requested.

## 4) Build / Lint / Test Commands
Run from `/home/seum/profile`.

Core commands:
- Health: `./gitserver health`
- Build: `./gitserver build`
- Publish: `./gitserver run "<commit message>"`

Fast webmaster commands:
- Verify by focus: `./webmaster verify all|writing|projects|contact`
- Quick local cycle (no push): `./webmaster quick all`
- Quick ship: `./webmaster ship "<commit message>"`

Recommended workflow:
1. `./gitserver health`
2. Make scoped edits in correct files/sections.
3. Run one focused single test.
4. `./gitserver build`
5. Publish only when user requests deploy/push.

## 5) Single-Test Commands (Important)
Single test: contact wiring
```bash
python3 - <<'PY'
from pathlib import Path
s = Path('index.html').read_text()
assert 'mailto:toufiqhamid171@gmail.com' in s
assert 'form action="mailto:toufiqhamid171@gmail.com"' in s
print('single test passed: contact wiring')
PY
```

Single test: projects section and download link
```bash
python3 - <<'PY'
from pathlib import Path
s = Path('index.html').read_text()
assert 'id="projects-9"' in s
assert 'assets/projects/prime-number-finder-v1-01.rar' in s
print('single test passed: projects link')
PY
```

Single test: writing section has expandable content
```bash
python3 - <<'PY'
from pathlib import Path
s = Path('index.html').read_text()
assert 'id="features04-w"' in s
assert 'class="see-more"' in s
print('single test passed: writing see-more')
PY
```

## 6) Code Style Guidelines
HTML: semantic tags, stable section IDs, concise brand-first copy, HTTPS external links.
CSS: all custom styling in `style.css`; small scoped overrides; kebab-case selectors/vars.
JavaScript: minimal vanilla JS, guarded DOM queries, progressive enhancement.
Imports/dependencies: no npm/pnpm/poetry unless requested; reuse assets first; document new deps in `README.md`.
Formatting: preserve file style; avoid mass format of vendor files; keep HTML readable.
Types/data: validate DOM input (`trim`, null checks, safe coercion); do not assume optional nodes exist.
Naming: HTML/CSS kebab-case, JS camelCase, new files lowercase-with-dashes.
Error handling: fail safely, keep messages actionable, never expose secrets/tokens.

## 7) Fast Sector Playbooks
- Writing: edit `#features04-w`; keep intro short; move long text into `See more`; add source/date line when given.
- Projects: copy artifact to `assets/projects/`; add one-line download-first row in `#projects-9`.
- Contact/social: edit only `#form02-6`; keep `mailto:` consistent across form and email link.
- Always run the matching single test after each sector change.

## 8) Webmaster Mode Guide (Faster Future Work)
- Use `./webmaster verify writing` when only writing copy changes.
- Use `./webmaster verify projects` after project file/link updates.
- Use `./webmaster verify contact` after social/email edits.
- Use `./webmaster quick all` for fast local confidence before showing results.
- Use `./webmaster ship "<message>"` only when user explicitly asks to publish.

Expected behavior by mode:
- `verify`: runs health + focused scripted checks, no build/publish.
- `quick`: runs verify + build, no commit/push.
- `ship`: runs quick + publish in one command.

When adding new sectors later:
1. Add a dedicated section ID in `index.html`.
2. Add minimal styles in `style.css`.
3. Add one focused `python3` single-test snippet in this file.
4. Add/extend `webmaster verify <sector>` checks if automation is needed.

## 9) Git / Safety Rules
- Do not revert unrelated user changes.
- Avoid destructive git commands unless explicitly requested.
- Keep commits small and scoped.
- Never commit secrets (`.env`, keys, credentials).
- Use `./webmaster ship` only when user asks to publish.

## 10) Cursor / Copilot Rules Status
- `.cursor/rules/`: not present currently.
- `.cursorrules`: not present currently.
- `.github/copilot-instructions.md`: not present currently.
If these files are added later, follow them as higher-priority local guidance.

## 11) Done Checklist
- Correct file/section placement used for every change.
- Matching single test executed for touched sector.
- `./gitserver build` completed successfully.
- No vendor/minified files edited unless requested.
- No secrets or credentials introduced.
- Publish step performed only when user requested deployment.
