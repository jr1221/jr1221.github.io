class UrlGenerator {
  final int year;
  final String event;
  final int team;

  final String base = "https://frc-api.firstinspires.org/v2.0/";
  UrlGenerator(this.year, this.event, this.team);

  String fromSelection({int selection, String extraNamed, int extraNamedMode}) {
    String url;
    bool eventB = true;
    bool teamB = true;
    if (event == null) eventB = false;
    if (team == null) teamB = false;
    switch (selection) {
      case 3:
        url = "$base$year/alliances/$event";
        break;
      case 9:
        url = "$base$year/teams/";
        if (teamB) url += "?teamNumber=$team";
        else if (eventB)
          url += "?eventCode=$event";
        else if (!eventB && !teamB) {
          if (extraNamedMode == 1)
            url += "?state=${extraNamed.trim().replaceFirst(" ", "%20")}";
          else if (extraNamedMode == 2)
            url += "?districtCode=${extraNamed.trim()}";
        }
        break;
      case 10:
        url = "$base$year";
        break;
      case 13:
        url = "$base$year/districts";
        break;
      case 11:
        url = "$base$year/awards";
        if (eventB) url += "/$event";
        if (teamB)
          url += "/$team";
        else if (!eventB && !teamB) url = "$base$year/awards/list";
        break;
      case 14:
        url = "$base$year/avatars?teamNumber=$team";
        break;
    }
    print(url);
    return url;
  }
}
