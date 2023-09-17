{
  latex,
  data,
  lib,
  ...
}: let
  education = data.education;
  sortByStartDate =
    latex.sort.reverse.byFun
    (x: with x.date.start; day + 100 * month + 10000 * year);
in {
  title = "Education";
  priority = 10;
  content = with latex;
    for (sortByStartDate education) (item:
      with item;
        [
          (moderncv.cventry (latex.timerange date.start date.end) studyType
            (with institution; href url name)
            institution.location ""
            description)
        ]
        ++ lib.optional (item ? "years") (for (sortByStartDate years) (year:
          with year;
            moderncv.cvlistitem "${with program; bold (href url acronym)} (${
              timerange date.start date.end
            }). ${program.studyType}. {\\small ${description}}")));
}
