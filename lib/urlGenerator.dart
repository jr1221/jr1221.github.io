class UrlGenerator {
  final int year;
  final String event;
  final int team;

  final String base = "https://frc-api.firstinspires.org/v2.0/";
  UrlGenerator(this.year, this.event, this.team);

  String fromSelection(int selection) {
    String url;
    bool eventB = true;
    bool teamB = true;
    if (event == null) eventB = false;
    if (team == null) teamB = false;
    switch (selection) {
      case 3:
        url = "$base$year/alliances/$event";
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
        if (teamB) url += "/$team";
        else if (!eventB && !teamB)url = "$base$year/awards/list";
        break;
      case 14:
        url = "$base$year/avatars?teamNumber=$team";
        break;
    }
    print(url);
    return url;
  }
}