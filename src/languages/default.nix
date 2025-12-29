{
  latex,
  data,
  lib,
  ...
}:
let
  sortByProficiency = lib.sort (
    lang1: lang2:
    let
      prof1 = lang1.proficiency;
      prof2 = lang2.proficiency;
    in
    (prof2 == "basic") || (prof1 == "native") || (prof2 == "intermediate" && prof1 == "fluent")
  );
in
{
  title = "Languages";
  priority = 20;
  extraHeader = ''
    \usepackage{emoji}
    \setemojifont{NotoColorEmoji.ttf}[Path=./fonts/]
    \usepackage{multicol}
  '';
  content =
    with latex;
    environmentWithOpts "multicols" [ "2" ] (
      for (sortByProficiency data.languages) (
        lang: with lang; moderncv.cvline "${name} \\emoji{${icon.shortcode}}" proficiency
      )
    );
}
