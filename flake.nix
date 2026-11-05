{
  description = "Project template with the impeccable Claude Code skill";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    impeccable = {
      url = "github:pbakaus/impeccable";
      flake = false;
    };
  };

  outputs = { nixpkgs, impeccable, ... }:
    let
      lib = nixpkgs.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});


      skill = "${impeccable}/plugin/skills/impeccable";
    in
    {
      devShells = forAllSystems (pkgs:
        let
          # The skill's launcher downloads its engine (a static binary) to
          # ~/.impeccable on first run. Fetch the same release here instead,
          # with the version and checksum the skill ships, and hand it
          # to the launcher through IMPECCABLE_BIN.
          version = lib.fileContents "${skill}/scripts/VERSION";
          asset = {
            x86_64-linux = "impeccable-linux-x64";
            aarch64-linux = "impeccable-linux-arm64";
          }.${pkgs.stdenv.hostPlatform.system};
          checksum = lib.findFirst (line: lib.hasPrefix "${version} ${asset} " line)
            (throw "impeccable: no checksum for ${asset} ${version}")
            (lib.splitString "\n" (builtins.readFile "${skill}/scripts/engine-checksums.txt"));
          engine = pkgs.runCommand "impeccable-engine-${version}" { } ''
            install -Dm755 ${pkgs.fetchurl {
              url = "https://github.com/pbakaus/impeccable/releases/download/engine-v${version}/${asset}";
              sha256 = lib.last (lib.splitString " " checksum);
            }} $out/bin/impeccable
          '';
        in
        {
          default = pkgs.mkShell {
            packages = [ engine ];
            IMPECCABLE_BIN = "${engine}/bin/impeccable";

            # Link the skill into the project's .claude/skills (gitignored).
            shellHook = ''
              root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
              mkdir -p "$root/.claude/skills"
              ln -sfn ${skill} "$root/.claude/skills/impeccable"
            '';
          };
        });
    };
}
