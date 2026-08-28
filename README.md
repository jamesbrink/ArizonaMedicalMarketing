# Arizona Medical Marketing

Static marketing website for Arizona Medical Marketing, focused on connecting
medical professionals with referral networks in Arizona.

Live site: [arizonamedicalmarketing.com](https://arizonamedicalmarketing.com)

## What is in this repository

- `index.html`: primary responsive marketing page, FAQ, testimonials, and Formspree contact form
- `card.html`: printable business-card layout with a generated QR code
- `rack_page1.svg`: editable rack-card source artwork
- `rack_page1.png`: exported rack-card artwork
- `logo.png`, `favicon.*`, `cactus*.png`, `AZMM.png`: site and print assets
- `medical-office-lobby.webp`, `provider-networking-lunch.webp`: optimized homepage photography
- `robots.txt`, `sitemap.xml`: search-crawler policy and canonical URL discovery
- `.github/workflows/deploy.yml`: GitHub Pages deployment workflow

The homepage uses HTML5, custom CSS, and Font Awesome via CDN. The business-card
page uses Tailwind CSS via CDN and QRious for its QR code. There is no JavaScript
compilation, npm dependency tree, or production bundle.

## Development with Nix

The Nix flake is the supported development environment. It provides a static
web server, Inkscape, ImageMagick, librsvg, Microsoft core fonts, and the
repository helper commands.

Supported Nix platforms are Apple Silicon macOS and ARM or x86_64 Linux. Current
Nixpkgs no longer supports Intel macOS.

```bash
direnv allow
serve
```

Alternatively, enter the environment manually:

```bash
nix develop
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
| `serve` | Serve the static site on port 3000 |
| `convert-svg <input.svg> [output.png] [dpi]` | Export an SVG to PNG; DPI defaults to 600 |
| `menu` | Show the commands and tools provided by the Nix shell |

### Quick preview without Nix

With Python 3 installed:

```bash
python3 -m http.server 3000
```

This only serves the site. Image conversion additionally requires librsvg and
ImageMagick.

## Rack-card export

For the existing 3.86 by 8.39 inch, 600-DPI rack-card export, run:

```bash
./convert_svg.sh
```

For other SVG files, use the `convert-svg` helper supplied by the Nix shell.

## Deployment

Pull requests run `scripts/validate_site.py` to check the required deployment
files, canonical metadata, contact-form contract, structured data, and crawler
configuration. Pushes to `main` run the same validation before deploying the
repository's static files to GitHub Pages through
`.github/workflows/deploy.yml`. The `CNAME` file configures the custom
`www.arizonamedicalmarketing.com` domain.

The public canonical URL is `https://arizonamedicalmarketing.com/`; the `www`
hostname redirects there. The homepage includes matching canonical, Open Graph,
Twitter Card, and `ProfessionalService` structured metadata.

After a significant homepage deployment, submit
`https://arizonamedicalmarketing.com/sitemap.xml` in Google Search Console and
request indexing for the canonical homepage. Maintain the Google Business
Profile as a service-area business unless the published address is staffed and
open to customers.

## Project conventions

Contributor and coding-agent instructions are maintained in [`AGENTS.md`](AGENTS.md).
`CLAUDE.md` is a symlink to that authoritative file so the instructions remain
identical across coding agents.

This project is proprietary and confidential. All rights reserved.
