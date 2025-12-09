{
  pkgs,
  latex,
  data,
}:
let
  commonArgs = {
    inherit data latex make;
    inherit (pkgs) lib;
  };
  make =
    path: overrides:
    let
      f = import path;
    in
    f ((builtins.intersectAttrs (builtins.functionArgs f) commonArgs) // overrides);

  cvTEX = builtins.toFile "cv.tex" (make ./src { });
  source = pkgs.callPackage (
    {
      noto-fonts-color-emoji,
      # Source files
      cv-tex ? cvTEX,
      files ? data.files,
    }:
    pkgs.runCommand "cv-src" { } ''
      mkdir -p "$out" && cd $_
      ln -sT ${cv-tex} cv.tex
      ln -sT ${files} files
      ln -sT ${noto-fonts-color-emoji}/share/fonts/noto fonts
    ''
  ) { };

  latexDeps = tl: {
    inherit (tl)
      scheme-basic
      citation-style-language
      latexmk
      luatex
      luatexbase
      moderncv
      fontspec
      fontawesome5
      academicons
      pgf
      multirow
      arydshln
      emoji
      ;
  };
in
{
  inherit latexDeps;

  src = source;
  pdf = pkgs.callPackage (
    {
      cv-src ? source,
      texlive,
    }:
    pkgs.runCommand "cv.pdf"
      {
        buildInputs = [ (texlive.combine (latexDeps texlive)) ];
      }
      ''
        export HOME=$(pwd)
        latexmk -pdflua -cd "${cv-src}"/cv.tex --output-directory=$(pwd)
        mv cv.pdf "$out"
      ''
  ) { };
}
