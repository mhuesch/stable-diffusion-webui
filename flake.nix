{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      supported-systems = [ "x86_64-linux" "aarch64-linux" ];
    in
    flake-utils.lib.eachSystem supported-systems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShell =
          pkgs.mkShell {
            buildInputs = with pkgs; [
              (python310.withPackages (ps: with ps; [
              ]))
            ];
            shellHook = ''
              addToSearchPath "LD_LIBRARY_PATH" "${pkgs.lib.getLib pkgs.stdenv.cc.cc}/lib"
              addToSearchPath "LD_LIBRARY_PATH" "/run/opengl-driver/lib"
            '';
          };
      });

}
