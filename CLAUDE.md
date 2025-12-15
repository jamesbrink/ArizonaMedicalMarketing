# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Arizona Medical Marketing is a static single-page website built with HTML5 and Tailwind CSS (via CDN). The site connects medical professionals with referral networks.

## Development Environment

This project uses Nix flakes for development. Enter the dev shell with:
```bash
nix develop
# or with direnv: direnv allow
```

### Dev Shell Commands

- `serve` - Start local dev server on port 3000 (auto-installs deps if needed)
- `install` - Install npm dependencies
- `convert-svg <input.svg> [output.png] [dpi]` - Convert SVG to PNG with DPI metadata (default 600dpi)
- `menu` - Show available commands

### Available Tools

- Node.js, npm
- ImageMagick (`convert`)
- Inkscape
- librsvg (`rsvg-convert`)

## Deployment

The site auto-deploys to GitHub Pages via `.github/workflows/deploy.yml` when pushing to main.

## Assets

- Marketing materials: SVG source files (e.g., `rack_page1.svg`) with PNG exports
- Images: logo.png, favicon.png, cactus graphics, business card designs
