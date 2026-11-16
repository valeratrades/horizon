# docs/nix.md. Other arguments go to the game.
{
  writeShellApplication,
  horizon-prepare,
  horizon-client,
}:
writeShellApplication {
  name = "horizon-play";
  runtimeInputs = [
    horizon-prepare
    horizon-client
  ];
  text = ''
    data_home="''${XDG_DATA_HOME:-$HOME/.local/share}"
    data="$data_home/horizon-nix"
    resources="$data/resources"
    prism="''${HORIZON_PRISM_DIR:-$data_home/PrismLauncher}"
    if ! horizon-prepare --check --output "$resources" >/dev/null; then
      source=()
      [ -d "$prism" ] && source=(--prism-dir "$prism")
      horizon-prepare --prepare --complete --output "$resources" "''${source[@]}"
    fi
    mkdir -p "$data/game"
    exec horizon-client --resources "$resources" --game-dir "$data/game" "$@"
  '';
}
