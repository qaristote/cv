{ lib, ... }:
let
  lines =
    content:
    if lib.isList content then
      (
        if content == [ ] then "" else lines (builtins.head content) + "\n" + lines (builtins.tail content)
      )
    else
      content;
  sortByFun = cmp: f: lib.sort (x: y: cmp (f x) (f y));
  sortByPath = cmp: keys: sortByFun cmp (lib.getAttrFromPath keys);
  sortByKey = cmp: key: sortByPath cmp [ key ];
  for =
    iterable: f: if lib.isList iterable then builtins.map f iterable else lib.mapAttrsToList f iterable;

  setOptionalArg = name: value: "${name}=${value}";
  expandArgsPrefixed =
    numArgs: prefix:
    if numArgs <= 0 then
      prefix
    else
      arg:
      let
        appendToPrefix =
          if lib.isAttrs arg then
            "[" + lib.concatStringsSep "," (lib.mapAttrsToList setOptionalArg arg) + "]"
          else
            "{${arg}}";
        newNumArgs = if lib.isAttrs arg then numArgs else numArgs - 1;
      in
      expandArgsPrefixed newNumArgs (prefix + appendToPrefix);
  macroWithOpts = name: numArgs: expandArgsPrefixed numArgs "\\${name}";
  macro =
    name: content:
    let
      contentExpanded = if lib.isList content then lib.concatStringsSep "}{" content else content;
    in
    "\\${name}{${contentExpanded}}";
  sectionMacro = type: name: content: ''
    \${type}{${name}}

    ${lines content}
  '';
  environment = name: content: ''
    \begin{${name}}
    ${lines content}
    \end{${name}}
  '';

  latex = {
    inherit macro environment;

    comment = content: "% ${content}";
    document = environment "document";
    section = sectionMacro "section";

    title = macroWithOpts "title" 1;

    url = macroWithOpts "url" 1;
    href = macroWithOpts "href" 2;
    bold = macroWithOpts "textbf" 1;

    cite = macroWithOpts "cite" 1;
    moderncv = {
      name = macroWithOpts "name" 2;
      email = macroWithOpts "email" 1;
      extrainfo = macroWithOpts "extrainfo" 1;
      photo = macroWithOpts "photo" 1;
      makecvtitle = macro "makecvtitle" [ ];
      cventry = macroWithOpts "cventry" 6;
      cvlistitem = macroWithOpts "cvlistitem" 1;
      cvline = macroWithOpts "cvline" 2;
      cvitemwithcomment = macroWithOpts "cvitemwithcomment" 3;
      cvdoubleitem = macroWithOpts "cvdoubleitem" 4;
    };
  };

  file = path: "files/${path}";
  href = latex.href;
  timerange =
    startdate: enddate:
    let
      print = builtins.mapAttrs (_: x: builtins.toString x);
      # let str = builtins.toString x;
      # in if name == "year" then
      #   builtins.substring 2 4 str
      # else
      #   (if name == "month" && x < 10 then "0${str}" else str));
      start = print startdate;
      end = print enddate;
      months = {
        "1" = "jan";
        "2" = "feb";
        "3" = "mar";
        "4" = "apr";
        "5" = "may";
        "6" = "jun";
        "7" = "jul";
        "8" = "aug";
        "9" = "sep";
        "10" = "oct";
        "11" = "nov";
        "12" = "dec";
      };
    in
    "${months."${start.month}"}."
    + lib.optionalString (start.year != end.year) " ${start.year}"
    + " -- ${months."${end.month}"}. ${end.year}";
in
latex
// {
  inherit
    for
    file
    href
    lines
    timerange
    ;
  code = x: x;
  sort =
    let
      lt = x: y: x < y;
      gt = x: y: x > y;
    in
    {
      byKey = sortByKey lt;
      byPath = sortByPath lt;
      byFun = sortByFun lt;
      reverse = {
        byKey = sortByKey gt;
        byPath = sortByPath gt;
        byFun = sortByFun gt;
      };
    };
}
