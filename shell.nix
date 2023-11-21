{pkgs ? (import <nixpkgs> {})}:
with pkgs;
mkShell {
  buildInputs = [
     elixir
     nodejs_20
     inotify-tools
  ];
  HEX_HOME = ".cache/hex";
  MIX_HOME = ".cache/mix";
}
