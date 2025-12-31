{
  latex,
  make,
  ...
}:
let
  sectionTemplate = section: {
    inherit (section) title;
    extraHeader = section.extraHeader or "";
    content = latex.section section.title section.content;
  };
  makeSection = path: sectionTemplate (make path { });
in
builtins.map makeSection [
  ./experience
  ./education
  ./research
  ./service
  ./languages
]
++ [
  {
    extraHeader = "";
    content = ''
      \newpage
    '';
  }
  (makeSection ./bibliography)
]
