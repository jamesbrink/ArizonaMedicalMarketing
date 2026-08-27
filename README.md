# Arizona Medical Marketing

Static marketing website for Arizona Medical Marketing, focused on connecting
medical professionals with referral networks in Arizona.

Live site: [www.arizonamedicalmarketing.com](https://www.arizonamedicalmarketing.com)

## What is in this repository

- `index.html` — primary responsive marketing page and Formspree contact form
- `card.html` — printable business-card layout with a generated QR code
- `rack_page1.svg` — editable rack-card source artwork
- `rack_page1.png` — exported rack-card artwork
- `logo.png`, `favicon.*`, `cactus*.png`, `AZMM.png` — site and print assets
- `.github/workflows/deploy.yml` — GitHub Pages deployment workflow

The site uses HTML5, Tailwind CSS via CDN, Font Awesome via CDN, and a small
Node.js HTTP server for local development. There is no JavaScript compilation
or production bundle.

## Development with Nix

The Nix flake is the supported development environment. It provides Node.js,
npm, Inkscape, ImageMagick, librsvg, Microsoft core fonts, and the repository
helper commands.

```bash
direnv allow
setup
serve
```

Alternatively, enter the environment manually:

```bash
nix develop
setup
serve
```

Open [http://localhost:3000](http://localhost:3000).

The first Nix environment load may download files named `*.exe`, such as
`times32.exe`. These are Microsoft core-font installer archives that Nix
extracts; they are not application executables built or shipped by this
project.

### Development commands

| Command | Purpose |
| --- | --- |
| `setup` | Install npm dependencies with `npm install` |
| `serve` | Install missing dependencies and serve the site on port 3000 |
| `convert-svg <input.svg> [output.png] [dpi]` | Export an SVG to PNG; DPI defaults to 600 |
| `menu` | Show the commands and tools provided by the Nix shell |

### Development without Nix

With Node.js and npm installed:

```bash
npm ci
npm start
```

Image conversion additionally requires librsvg and ImageMagick.

## Rack-card export

For the existing 3.86 by 8.39 inch, 600-DPI rack-card export, run:

```bash
./convert_svg.sh
```

For other SVG files, use the `convert-svg` helper supplied by the Nix shell.

## Deployment

Pushes to `main` automatically deploy the repository's static files to GitHub
Pages through `.github/workflows/deploy.yml`. The `CNAME` file configures the
custom `www.arizonamedicalmarketing.com` domain.

## Project conventions

Contributor and coding-agent instructions are maintained in [`AGENTS.md`](AGENTS.md).
`CLAUDE.md` is a symlink to that authoritative file so the instructions remain
identical across coding agents.

This project is proprietary and confidential. All rights reserved.
