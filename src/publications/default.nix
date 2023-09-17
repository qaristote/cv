{
  latex,
  data,
  ...
}: let
  publications = data.publications;
  publicationsBIB = builtins.toFile "publications.bib" (latex.lines
    (builtins.map (entry: entry.cite.biblatex)
      (latex.sort.reverse.byPath ["issued" "date-parts"] publications)));
in {
  title = "Publications";
  priority = 30;
  extraHeader = ''
    \usepackage[sorting=ydnt]{biblatex}
    \addbibresource{${publicationsBIB}}
  '';
  content = ''
    \nocite{*}
    \printbibliography[heading=none]
  '';
}
