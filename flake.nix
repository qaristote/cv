{
  description = "Quentin Aristote's CV.";

  inputs = {
    data = {
      # url = "github:qaristote/info";
      url = "github:qaristote/info";
      inputs = {
        nixpkgs.follows = "/nixpkgs";
        flake-utils.follows = "/flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, data }:
    {
      lib = import ./lib { inherit (nixpkgs) lib; };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (self: super: {
              texlive = super.lib.recursiveUpdate super.texlive {
                combined.moderncv = super.texlive.combine {
                  inherit (super.texlive)
                    scheme-basic biber biblatex latexmk luatex luatexbase
                    moderncv fontspec fontawesome5 academicons pgf multirow
                    arydshln emoji;
                };
              };
            })
          ];
        };
      in {
        packages = {
          texlive.combined.moderncv = pkgs.texlive.combined.moderncv;
          cv = import ./default.nix {
            inherit pkgs;
            inherit (self.lib.pp) latex;
            data = data.formatWith."${system}" self.lib.pp.latex;
          };
        };
        defaultPackage = self.packages."${system}".cv.pdf;
        devShell = pkgs.mkShell {
          packages = with pkgs; [ nixfmt texlive.combined.moderncv ];
        };
      });
}
