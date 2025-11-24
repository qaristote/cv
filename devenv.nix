{ inputs, ... }:
{
  imports = [ inputs.my-nixpkgs.devenvModules.personal ];
  languages = {
    nix.enable = true;
    texlive = {
      enable = true;
      latexmk.enable = true;
      packages = tl: { inherit (tl) scheme-full; };
    };
  };
}
