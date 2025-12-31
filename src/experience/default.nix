{
  latex,
  data,
  lib,
  ...
}:
let
  experience = data.experience.jobs;
in
{
  title = "Experience";
  content =
    with latex;
    for (sort.reverse.byFun (x: with x.date.start; day + 100 * month + 10000 * year) experience) (
      item:
      with item;
      moderncv.cventry (latex.timerange date.start date.end) institution.position
        (with institution; href url name)
        institution.location
        (
          if item ? supervisors then
            "with "
            + lib.concatStringsSep " \\& " (for supervisors (supervisor: with supervisor; href url name))
          else
            ""
        )
        (
          description
          + lib.optionalString (item ? assets) (
            " "
            + cite (
              lib.concatStringsSep "," (
                for (lib.filter (asset: asset.type == "Writings") assets) (lib.getAttr "id")
              )
            )
          )
        )
    );
}
