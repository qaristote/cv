{
  latex,
  data,
  make,
  ...
}:
with latex;
let
  sections = make ./sections.nix { };
in
with data.basics;
lines [
  (builtins.readFile ./header.tex)
  (comment "-------------------- EXTRA --------------------")
  (for sections (section: section.extraHeader))
  (comment "-------------------- DATA --------------------")
  (moderncv.name name.first name.last)
  (moderncv.email email.personal)
  (moderncv.extrainfo (latex.url url))
  (moderncv.photo { "" = "128pt"; } avatar)
  ""
  (document [
    (title institution.position)
    moderncv.makecvtitle
    description
    (for sections (section: section.content))
  ])
]
