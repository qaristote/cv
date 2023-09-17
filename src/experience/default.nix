{
  latex,
  data,
  lib,
  ...
}: let
  experience = data.experience;
in {
  title = "Experience";
  priority = 0;
  content = with latex;
    for
    (sort.reverse.byFun (x: with x.date.start; day + 100 * month + 10000 * year)
      experience) (item:
      with item;
        moderncv.cventry (latex.timerange date.start date.end)
        institution.position (with institution; href url name)
        institution.location (
          if item ? supervisors
          then
            "supervised by "
            + lib.concatStringsSep " \\& "
            (for supervisors (supervisor: with supervisor; href url name))
          else ""
        ) (description
          + lib.optionalString (item ? assets) (" "
            + cite
            (lib.concatStringsSep ","
              (for (lib.filter (asset: asset.type == "Publications") assets)
                (lib.getAttr "id"))))));
}
