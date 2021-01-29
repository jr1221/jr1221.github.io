import 'package:flutter/foundation.dart' show kIsWeb;

class UrlGenerator {
  final int year;
  final String event;
  final int team;

  UrlGenerator(this.year, this.event, this.team);

  String fromSelection({int selection, String extraNamed, String extraNamed2, int extraNamedMode, int extraNamedMode2}) {
    String base;
    if (!kIsWeb) {
      base = "https://frc-api.firstinspires.org/v2.0/";
    } else
      base = "https://am.encrypt.se/zapiz/v2.0/";
    String url;
    bool eventB = true;
    bool teamB = true;
    if (event == null) eventB = false;
    if (team == null) teamB = false;
    switch (selection) {
      case 3:
        url = "$base$year/alliances/$event";
        break;
      case 8:
        url = "$base$year/events/";
        if (teamB) url += "?teamNumber=$team";
        else if (eventB) url += "$event";
        else if (!teamB && !eventB) {
            if (extraNamedMode == 1)
              url += "?districtCode=$extraNamed";
            else if (extraNamedMode2 == 1)
              url += "?excludeDistrict=true";
        }
        break;
      case 9:
        url = "$base$year/teams/";
        if (teamB)
          url += "?teamNumber=$team";
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
      case 11:
        url = "$base$year/awards";
        if (eventB) url += "/$event";
        if (teamB)
          url += "/$team";
        else if (!eventB && !teamB) url = "$base$year/awards/list";
        break;
      case 12:
        if (teamB)
          url = "$base$year/rankings/district/?teamNumber=$team";
        else {
          if (extraNamedMode == 1)
            url = "$base$year/rankings/district/$extraNamed";
          else if (extraNamedMode == 2)
            url = "$base$year/rankings/district/$extraNamed?page=$extraNamed2";
          else if (extraNamedMode == 3)
            url = "$base$year/rankings/district/$extraNamed?top=$extraNamed2";
        }
        break;
      case 13:
        url = "$base$year/districts";
        break;
      case 14:
        url = "$base$year/avatars?teamNumber=$team";
        break;
    }
    print(url);
    return url;
  }
}
