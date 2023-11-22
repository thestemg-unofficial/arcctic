{
  description = "watch party app";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      elixir = pkgs.beam.packages.erlang.elixir;
      elixir-ls = pkgs.beam.packages.erlang.elixir-ls;
      locales = pkgs.glibcLocales;
      inherit (pkgs.lib) optional optionals;
    in {
      packages.arcctic = pkgs.beam.packages.erlang.mixRelease rec {
        pname = "arcctic";
        version = "0.1.0";
        src = ./.;

        mixNixDeps = import ./mix.nix {
          lib = pkgs.lib;
          beamPackages = pkgs.beam.packages.erlang;
        };

        passthru = {
          inherit mixNixDeps;
        };

        #FIX: Fix cache_static_manifest not being found
        #     10:25:37.178 [info] Configuration :server was not enabled for ArccticWeb.Endpoint, http/https services won't start

        #HACK: This is a placeholder until the derivation can generate the cache_manifest
        postInstall = 
        ''
        cp ${./cache_manifest.json} "$out/lib/${pname}-${version}/priv/static/cache_manifest.json"
        '';

        removeCookie = false;
      };
      packages.default = self.packages.${system}.arcctic;

      devShell = pkgs.mkShell {
        buildInputs =
          [elixir elixir-ls locales pkgs.nodejs_20 pkgs.git pkgs.mix2nix]
          ++ optional pkgs.stdenv.isLinux pkgs.inotify-tools
          ++ optionals pkgs.stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [
            CoreFoundation
            CoreServices
          ]);
        HEX_HOME = ".cache/hex";
        MIX_HOME = ".cache/mix";
      };
    });
}
