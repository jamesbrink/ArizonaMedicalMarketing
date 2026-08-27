# Repository instructions

## Project overview

Arizona Medical Marketing is a static website. The primary page is
`index.html`; `card.html` contains the printable business-card layout. Tailwind
CSS and Font Awesome load from CDNs, and the contact form posts to Formspree.
There is no application compilation or production bundle.

## Development environment

Use the Nix flake for repository commands:

```bash
nix develop
# or allow the automatic environment once with: direnv allow
```

The flake supports `aarch64-darwin`, `aarch64-linux`, and `x86_64-linux`.
Current Nixpkgs no longer supports `x86_64-darwin`.

Available helper commands:

- `serve` starts the local site at `http://localhost:3000`.
- `convert-svg <input.svg> [output.png] [dpi]` exports SVG artwork.
- `menu` lists the development-shell tools.

The `corefonts` dependency downloads self-extracting Microsoft font archives
with `.exe` names. Nix extracts their font files; they are not project build
outputs and must not be committed.

## Change guidelines

- Keep the site static unless a task explicitly requires a new build system.
- Do not add npm dependencies for tasks the Nix development shell already supports.
- Preserve the custom domain in `CNAME` and the GitHub Pages deployment path.
- Never expose or replace the Formspree endpoint without explicit approval.
- Keep generated dependencies, Nix store artifacts, and `.direnv` out of Git.
- Update `README.md` and this file when commands or project behavior change.

## Verification

For content-only documentation changes, inspect Markdown links and the Git diff.
For HTML, CSS, JavaScript, or asset changes, run `serve` and verify the rendered
desktop and mobile layouts in a browser. Confirm contact links, navigation, and
the Formspree form still point to their intended destinations.

## Git conventions

Use Conventional Commits, such as `feat:`, `fix:`, `docs:`, and `chore:`. Use
typed branch names such as `feat/<topic>`, `fix/<topic>`, or `chore/<topic>`.
Do not commit directly to `main` unless explicitly requested.

## Deployment

`.github/workflows/deploy.yml` publishes the repository root to GitHub Pages on
pushes to `main`. Deployment changes must preserve the permissions required by
GitHub Pages and the `www.arizonamedicalmarketing.com` custom domain.
