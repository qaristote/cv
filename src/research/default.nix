{
  latex,
  data,
  lib,
  ...
}: let
  addBibResource = name: ''
    \begin{filecontents*}{${name}.json}
    ${builtins.toJSON data.research."${name}"}
    \end{filecontents*}
    \addbibresource{${name}.json}
    '';
in {
  title = "Research";
  priority = 30;
  extraHeader = ''
    \usepackage[style=ieee]{citation-style-language}
    \cslsetup{bib-item-sep = 8 pt plus 4 pt minus 2 pt}
    '' + addBibResource "conferences" + addBibResource "journals" + addBibResource "misc" + addBibResource "reports";
  content = ''
    \nocite{*}

    \textbf{Conference papers}

    \printbibliography[heading=none,type=paper-conference]

    \textbf{Journal papers}

    \printbibliography[heading=none,type=article-journal]

    \textbf{Not peer-reviewed}

    \printbibliography[heading=none,nottype=article-journal,nottype=paper-conference,nottype=report]

    \textbf{Reports}

    \printbibliography[heading=none,type=report]
  '';
}
