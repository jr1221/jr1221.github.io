import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<HybridSchedData> fetchAuto(String url) async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username') ?? "";
  final key = prefs.getString('key') ?? "";
  if (username == "" || key == "") throw Exception;
  var bytes = utf8.encode("$username:$key");
  String encoded = base64.encode(bytes);
  final Response response = await http.get(url, headers: {
    "Authorization": " Basic " + encoded,
    "Accept": "application/json"
  });
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return HybridSchedData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(
        'Please Enter or check your API Key or ensure the entered inputs are correct');
  }
}
class HybridSchedData {
  List<Schedule> schedule;

  HybridSchedData({this.schedule});

  HybridSchedData.fromJson(Map<String, dynamic> json) {
    if (json['Schedule'] != null) {
      schedule = <Schedule>[];
      json['Schedule'].forEach((v) {
        schedule.add(new Schedule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.schedule != null) {
      data['Schedule'] = this.schedule.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Schedule {
  String tournamentLevel;
  String actualStartTime;
  String postResultTime;
  String description;
  int matchNumber;
  String startTime;
  int scoreRedFinal;
  int scoreRedFoul;
  int scoreRedAuto;
  int scoreBlueFinal;
  int scoreBlueFoul;
  int scoreBlueAuto;
  List<Teams> teams;

  Schedule(
      {this.tournamentLevel,
        this.actualStartTime,
        this.postResultTime,
        this.description,
        this.matchNumber,
        this.startTime,
        this.scoreRedFinal,
        this.scoreRedFoul,
        this.scoreRedAuto,
        this.scoreBlueFinal,
        this.scoreBlueFoul,
        this.scoreBlueAuto,
        this.teams});

  Schedule.fromJson(Map<String, dynamic> json) {
    tournamentLevel = json['tournamentLevel'];
    actualStartTime = json['actualStartTime'];
    postResultTime = json['postResultTime'];
    description = json['description'];
    matchNumber = json['matchNumber'];
    startTime = json['startTime'];
    scoreRedFinal = json['scoreRedFinal'];
    scoreRedFoul = json['scoreRedFoul'];
    scoreRedAuto = json['scoreRedAuto'];
    scoreBlueFinal = json['scoreBlueFinal'];
    scoreBlueFoul = json['scoreBlueFoul'];
    scoreBlueAuto = json['scoreBlueAuto'];
    if (json['teams'] != null) {
      teams = <Teams>[];
      json['teams'].forEach((v) {
        teams.add(new Teams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['tournamentLevel'] = this.tournamentLevel;
    data['actualStartTime'] = this.actualStartTime;
    data['postResultTime'] = this.postResultTime;
    data['description'] = this.description;
    data['matchNumber'] = this.matchNumber;
    data['startTime'] = this.startTime;
    data['scoreRedFinal'] = this.scoreRedFinal;
    data['scoreRedFoul'] = this.scoreRedFoul;
    data['scoreRedAuto'] = this.scoreRedAuto;
    data['scoreBlueFinal'] = this.scoreBlueFinal;
    data['scoreBlueFoul'] = this.scoreBlueFoul;
    data['scoreBlueAuto'] = this.scoreBlueAuto;
    if (this.teams != null) {
      data['teams'] = this.teams.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Teams {
  int teamNumber;
  String station;
  bool surrogate;
  bool dq;

  Teams({this.teamNumber, this.station, this.surrogate, this.dq});

  Teams.fromJson(Map<String, dynamic> json) {
    teamNumber = json['teamNumber'];
    station = json['station'];
    surrogate = json['surrogate'];
    dq = json['dq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['teamNumber'] = this.teamNumber;
    data['station'] = this.station;
    data['surrogate'] = this.surrogate;
    data['dq'] = this.dq;
    return data;
  }
}


class HybridSchedWidg extends StatefulWidget {
  final String url;
  HybridSchedWidg({Key key, this.url}) : super(key: key);

  @override
  _HybridSchedWidgState createState() => _HybridSchedWidgState();
}

class _HybridSchedWidgState extends State<HybridSchedWidg> {
  Future<HybridSchedData> futureAuto;

  @override
  void initState() {
    super.initState();
    futureAuto = fetchAuto(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder future = FutureBuilder<HybridSchedData>(
      future: futureAuto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String text = "";
          snapshot.data.schedule.forEach((element) {
            text += "\n\n\n${element.description} -- (No. ${element.matchNumber}) (${element.tournamentLevel})";
            text += "\nScheduled for ${element.startTime}";
            text += "\nStarted at ${element.actualStartTime}";
            text += "\nResults announced at ${element.postResultTime}";
            text += "\n${element.scoreRedFinal} Red points";
            text += "\n  ${element.scoreRedAuto} autonomous points.";
            text += "\n  ${element.scoreRedFoul} foul points";
            text += "\n${element.scoreBlueFinal} Blue points";
            text += "\n  ${element.scoreBlueAuto} autonomous points.";
            text += "\n  ${element.scoreBlueFoul} foul points";
            element.teams.forEach((element2) {
              text += "\n\nTeam ${element2.teamNumber}";
              text += "\nStationed at ${element2.station}";
              if (element2.surrogate) text += "\nThey were a surrogate team";
              if (element2.dq) text += "\nThey were disqualified!";
            });
          });
          return Text(text);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
    Container container = Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          future,
        ],
      ),
    );
    AppBar appBar = AppBar(
      title: Text('District Rankings'),
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}
