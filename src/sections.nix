{
  latex,
  make,
  ...
}: let
  sectionTemplate = section: {
    inherit (section) title priority;
    extraHeader =
      if section ? extraHeader
      then section.extraHeader
      else "";
    content = latex.section section.title section.content;
  };
  makeSection = path: sectionTemplate (make path {});
in
  builtins.map makeSection [
    ./experience
    ./education
    ./languages
    ./research
  ]
