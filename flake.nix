{
  description = "Arizona Medical Marketing development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Helper scripts
        setup = pkgs.writeShellScriptBin "setup" ''
          echo "Installing npm dependencies..."
          npm install
        '';

        serve = pkgs.writeShellScriptBin "serve" ''
          if [ ! -d "node_modules" ]; then
            echo "node_modules not found. Running npm install first..."
            npm install
          fi
          npm start
        '';

        convert-svg = pkgs.writeShellScriptBin "convert-svg" ''
          if [ -z "$1" ]; then
            echo "Usage: convert-svg <input.svg> [output.png] [dpi]"
            echo "Example: convert-svg design.svg design.png 600"
            exit 1
          fi
          input="$1"
          output="''${2:-''${input%.svg}.png}"
          dpi="''${3:-600}"
          echo "Converting $input to $output at ''${dpi}dpi..."
          ${pkgs.librsvg}/bin/rsvg-convert "$input" -o "$output"
          ${pkgs.imagemagick}/bin/convert "$output" -units PixelsPerInch -density "$dpi" "$output"
          echo "Done!"
        '';

        menu = pkgs.writeShellScriptBin "menu" ''
          echo ""
          echo "  Arizona Medical Marketing - Development Shell"
          echo "  ============================================="
          echo ""
          echo "  Available commands:"
          echo ""
          echo "    setup        - Install npm dependencies"
          echo "    serve        - Start local dev server (port 3000)"
          echo "    convert-svg  - Convert SVG to PNG with DPI settings"
          echo "    menu         - Show this menu"
          echo ""
          echo "  Tools available:"
          echo ""
          echo "    node         - Node.js runtime"
          echo "    npm          - Node package manager"
          echo "    inkscape     - Vector graphics editor"
          echo "    convert      - ImageMagick convert tool"
          echo "    rsvg-convert - SVG to raster converter"
          echo ""
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            imagemagick
            inkscape
            corefonts
            fontconfig
            librsvg
            # Custom scripts
            setup
            serve
            convert-svg
            menu
          ];

          shellHook = ''
            export FONTCONFIG_PATH="${pkgs.fontconfig.out}/etc/fonts"
            menu
          '';
        };
      }
    );
}
