{
  description = "Rellikeht's build of suckless st";

  inputs = {
    # {{{
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  }; # }}}

  outputs = {
    # {{{
    self,
    nixpkgs,
    flake-utils,
  }:
  # }}}
    flake-utils.lib.eachSystem
    flake-utils.lib.allSystems
    (system: let
      # {{{
      pkgs = nixpkgs.legacyPackages.${system};
      name = "st";
      src = self;
      # }}}
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        inherit name system src;
        # {{{
        PREFIX = "$(out)";
        CC = pkgs.stdenv.cc;
        PKG_CONFIG = pkgs.pkg-config;
        impureUseNativeOptimizations = true;
        # dontStrip = true;
        # }}}

        nativeBuildInputs = with pkgs; [
          # {{{
          pkg-config
        ]; # }}}

        buildInputs = with pkgs; [
          # {{{
          xorg.libX11
          xorg.libXft
          xorg.libXinerama
          ncurses

          # this seems to not be necessary ???
          freetype
        ]; # }}}

        buildPhase =
          # {{{
          ''
            sh patch.sh
            cd patched
            make clean
            make
          '';
        # }}}

        installPhase =
          # {{{
          ''
            # this is weird hack, no idea why this variable can't simply 
            # be outside this block
            export TERMINFO="$out/share/terminfo"
            make install
          ''; # }}}

        meta = with pkgs.lib; {
          # {{{
          homepage = "https://st.suckless.org/";
          description = "Suckless (simple) terminal, Rellikeht's build";
          license = licenses.mit;
          mainProgram = "st";
          maintainers = ["Rellikeht"];
          platforms = platforms.unix;
        }; # }}}
      };
    });
}
