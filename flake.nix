{
  description = "Quentin Aristote's CV.";

  inputs = {
    data.url = "github:qaristote/info";
    my-nixpkgs.url = "github:qaristote/my-nixpkgs";
    nixpkgs = { };
  };

  outputs =
    {
      flake-parts,
      my-nixpkgs,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        self,
        lib,
        ...
      }:
      {
        imports = builtins.attrValues { inherit (my-nixpkgs.flakeModules) personal; };

        flake.lib = import ./lib { inherit lib; };

        perSystem =
          { pkgs, ... }:
          let
            latex = self.lib.pp.latex;
            cv = import ./default.nix {
              inherit pkgs latex;
              data = inputs.data.lib.formatWith {
                inherit pkgs;
                markup = latex;
              };
            };
          in
          {
            packages = {
              default = cv.pdf;
              cv = cv.pdf;
              cv_src = cv.src;
            };
          };
      }
    );
}
