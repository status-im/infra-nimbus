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
              ipython ansible ansible-core pyyaml jinja2 pygithub
              pyopenssl cryptography hvac pysocks
            ]
          );

          ansibleCollections = pkgs.linkFarm "ansible-collections" [
            {
              name = "ansible_collections/community/hashi_vault";
              # Not yet supported upstream in ansible-collections:
              # https://github.com/ansible-collections/community.hashi_vault/pull/504
              path = pkgs.fetchFromGitHub {
                owner = "status-im";
                repo = "community.hashi_vault";
                rev = "add-mtls";
                hash = "sha256-hjaLq2VHV1SJcVrf1qNIbpKFqG7TnGMg9a6tup1ytYQ=";
              };
            }
          ];
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
            terraform pythonPkgs
            # security
            gopass vault yubikey-manager pwgen
            # cloud
            aliyun-cli awscli doctl google-cloud-sdk
            hcloud s3cmd scaleway-cli
          ] ++ extraPkgs;

          ANSIBLE_COLLECTIONS_PATH = "${ansibleCollections}";

          shellHook = ''
            make checks
          '';
        };
      });
    };
}
