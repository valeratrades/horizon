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
      if [ -n "''${HORIZON_MCP_REBORN:-}" ]; then
        mcp="$HORIZON_MCP_REBORN/projects/mcp/build/mcp"
        source=(--version-json "$mcp/downloadJson/version.json" --client-jar "$mcp/downloadClient/client.jar"
          --server-jar "$mcp/downloadServer/server.jar" --assets-dir "$HORIZON_MCP_REBORN/run/assets"
          --libraries-dir "$data/libraries") # MCP-Reborn never resolves the game's libraries
      elif [ -d "$prism" ]; then
        source=(--prism-dir "$prism")
      fi
      horizon-prepare --prepare --complete --output "$resources" "''${source[@]}"
    fi
    mkdir -p "$data/game"
    exec horizon-client --resources "$resources" --game-dir "$data/game" "$@"
  '';
}
