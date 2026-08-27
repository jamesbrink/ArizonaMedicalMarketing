{
  description = "Arizona Medical Marketing development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Helper scripts
        serve = pkgs.writeShellScriptBin "serve" ''
          echo "Serving Arizona Medical Marketing at http://localhost:3000"
          exec ${pkgs.miniserve}/bin/miniserve \
            --interfaces 127.0.0.1 \
            --disable-indexing \
            --index index.html \
            --port 3000 \
            .
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
          echo "    serve        - Start local dev server (port 3000)"
          echo "    convert-svg  - Convert SVG to PNG with DPI settings"
          echo "    menu         - Show this menu"
          echo ""
          echo "  Tools available:"
          echo ""
          echo "    inkscape     - Vector graphics editor"
          echo "    convert      - ImageMagick convert tool"
          echo "    rsvg-convert - SVG to raster converter"
          echo ""
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            imagemagick
            inkscape
            corefonts
            fontconfig
            librsvg
            # Custom scripts
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
