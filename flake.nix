{
  description = "Rellikeht's build of suckless st";

  inputs.nixpkgs.url = github:NixOS/nixpkgs;

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachSystem [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "armv7l-linux"
    ] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      name = "tabbed";
      src = self;
    in {
      packages.default = pkgs.stdenv.mkDerivation rec {
        inherit name system src;
        PREFIX = "$(out)";
        CC = pkgs.gcc;
        PKG_CONFIG = pkgs.pkg-config;
        # TERMINFO = "$out/share/terminfo";

        nativeBuildInputs = with pkgs; [
          pkg-config
        ];

        buildInputs = with pkgs; [
          xorg.libX11
          xorg.libXft
          xorg.libXinerama
          freetype
          ncurses
        ];

        buildPhase = "
            make clean
            make
            ";

        installPhase = "
          export TERMINFO=\"$out/share/terminfo\"
          mkdir -p $out/bin
          mkdir -p $TERMINFO
          make install
          ";
      };
    });
}
