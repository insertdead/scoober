{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nmattia/naersk";
  };

  outputs = { self, nixpkgs, flake-utils, naersk }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages."${system}";
        naersk-lib = naersk.lib."${system}";
      in
        rec {
          # `nix build`
          packages.scoober = naersk-lib.buildPackage {
            pname = "scoober";
            buildInputs = [ pkgs.SDL2 ];
            root = ./.;
          };
          defaultPackage = packages.scoober;

          # `nix run`
          apps.scoober = flake-utils.lib.mkApp {
            drv = packages.scoober;
          };
          defaultApp = apps.scoober;

          # `nix develop`
          devShell = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [ rustc cargo SDL2 ];
          };
        }
    );
}
