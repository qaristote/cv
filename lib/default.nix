{ lib }:
{
  pp.latex = import ./latex.nix { inherit lib; };
}
