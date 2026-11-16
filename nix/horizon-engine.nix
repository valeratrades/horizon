# The server build of the game (`horizon-game --no-default-features`): the game without sound,
# controllers or Horizon's online extras, so it links neither ALSA nor udev. horizon-server runs it
# headless as `horizon-engine` (docs/hosting.md, packaging/server/Dockerfile).
{
  lib,
  rustPlatform,
  pkg-config,
  callPackage,
  version,
  gameBuildId,
}:
rustPlatform.buildRustPackage {
  pname = "horizon-engine";
  inherit version;
  src = callPackage ./source.nix { };
  cargoLock.lockFile = ../Cargo.lock;

  cargoBuildFlags = [
    "--package=horizon-game"
    "--bin=horizon-client"
  ];
  buildNoDefaultFeatures = true;

  nativeBuildInputs = [ pkg-config ];
  env.HORIZON_GAME_BUILD_ID = gameBuildId;

  # The game's tests read the prepared vanilla files in .local/, which a build never has.
  doCheck = false;

  postInstall = ''
    mv $out/bin/horizon-client $out/bin/horizon-engine
  '';

  meta = {
    description = "Horizon's headless game engine, run by horizon-server";
    homepage = "https://playhorizon.dev";
    license = lib.licenses.mit;
    mainProgram = "horizon-engine";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
