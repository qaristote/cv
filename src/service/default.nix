{
  latex,
  data,
  lib,
  ...
}:
let
  service = data.experience.service;
in
{
  title = "Academic service";
  priority = 15;
  content = [
    (
      with service.reviews;
      let
        conferenceList = lib.concatMapAttrsStringSep "; " (
          name: years: "${name} ${lib.concatMapStringsSep ", " builtins.toString years}"
        ) conferences.names;
      in
      "I have reviewed ${builtins.toString conferences.number} conference papers (${conferenceList})."
    )
    (
      with latex;
      [ "I was a teaching assistant for the following lectures:\\\\" ]
      ++ for (sort.reverse.byFun (x: x.year) service.teaching) (
        item:
        with item;
        moderncv.cventry (builtins.toString year) name level institution (builtins.toString hours + "h") ""
      )
    )
  ];
}
