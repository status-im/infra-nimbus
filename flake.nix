{
  description = "infra-shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

  outputs = { self, nixpkgs }:
    let
      stableSystems = ["x86_64-linux"  "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      forAllSystems = nixpkgs.lib.genAttrs stableSystems;
      pkgsFor = nixpkgs.lib.genAttrs stableSystems (
        system: import nixpkgs { inherit system; config.allowUnfree = true; }
      );
    in rec {
      devShells = forAllSystems (system: let
        pkgs = pkgsFor.${system};
      in {
        default = let
          pythonPkgs = pkgs.python313.withPackages (
            _: with (pkgs.python313Packages); [
              ipython pyyaml jinja2 pygithub
              pyopenssl cryptography hvac pysocks
            ]
          );
        in pkgs.mkShellNoCC {
          packages = with pkgs.buildPackages; let
            # Optional pkgs.nix for customizing repo dev shell.
            extraPkgs = pkgs.lib.optionals (builtins.pathExists ./pkgs.nix)
              (import ./pkgs.nix { inherit pkgs; });
          in [
            # misc
            git openssh jq silver-searcher direnv
            # networking
            curl nmap nettools dnsutils
            # infra
            terraform ansible_2_18 pythonPkgs
            # security
            gopass vault yubikey-manager pwgen
            # cloud
            aliyun-cli awscli doctl google-cloud-sdk
            hcloud s3cmd scaleway-cli
          ] ++ extraPkgs;

          shellHook = ''
            make checks
          '';
        };
      });
    };
}
