{
  description = "Quentin Aristote's CV.";

  inputs = {
    data.url = "github:qaristote/info";
    devenv.url = "github:cachix/devenv";
    my-nixpkgs.url = "github:qaristote/my-nixpkgs";
    nixpkgs = {};
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-trusted-substituters = "https://devenv.cachix.org";
  };

  outputs = {
    flake-parts,
    my-nixpkgs,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      self,
      lib,
      ...
    }: {
      imports = builtins.attrValues {inherit (my-nixpkgs.flakeModules) personal devenv;};

      flake.lib = import ./lib {inherit lib;};

      perSystem = {pkgs, ...}: let
        latex = self.lib.pp.latex;
        cv = import ./default.nix {
          inherit pkgs latex;
          data = inputs.data.lib.formatWith {
            inherit pkgs;
            markup = latex;
          };
        };
      in {
        packages = {
          default = cv.pdf;
          cv = cv.pdf;
          cv_src = cv.src;
        };
        devenv.shells.default = {
          languages = {
            nix.enable = true;
            texlive = {
              enable = true;
              packages = cv.latexDeps;
              latexmk = {
                enable = true;
                output.pdf.enable = true;
              };
            };
          };
        };
      };
    });
}
