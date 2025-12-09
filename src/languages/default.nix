{
  latex,
  data,
  lib,
  ...
}:
let
  languages = data.languages;
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
  '';
  content =
    with latex;
    for (sortByProficiency languages) (
      lang: with lang; moderncv.cvline "${name} \\emoji{${icon.shortcode}}" proficiency
    );
}
