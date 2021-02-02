import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<MatchSchedData> fetchAuto(String url) async {
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
    return MatchSchedData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(
        'Please Enter or check your API Key or ensure the entered inputs are correct');
  }
}

class MatchSchedData {
  List<Schedule> schedule;

  MatchSchedData({this.schedule});

  MatchSchedData.fromJson(Map<String, dynamic> json) {
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
  String field;
  String tournamentLevel;
  String description;
  String startTime;
  int matchNumber;
  List<Teams> teams;

  Schedule(
      {this.field,
        this.tournamentLevel,
        this.description,
        this.startTime,
        this.matchNumber,
        this.teams});

  Schedule.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    tournamentLevel = json['tournamentLevel'];
    description = json['description'];
    startTime = json['startTime'];
    matchNumber = json['matchNumber'];
    if (json['teams'] != null) {
      teams = <Teams>[];
      json['teams'].forEach((v) {
        teams.add(new Teams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['field'] = this.field;
    data['tournamentLevel'] = this.tournamentLevel;
    data['description'] = this.description;
    data['startTime'] = this.startTime;
    data['matchNumber'] = this.matchNumber;
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

  Teams({this.teamNumber, this.station, this.surrogate});

  Teams.fromJson(Map<String, dynamic> json) {
    teamNumber = json['teamNumber'];
    station = json['station'];
    surrogate = json['surrogate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamNumber'] = this.teamNumber;
    data['station'] = this.station;
    data['surrogate'] = this.surrogate;
    return data;
  }
}


class MatchSchedWidg extends StatefulWidget {
  final String url;
  MatchSchedWidg({Key key, this.url}) : super(key: key);

  @override
  _MatchSchedWidgState createState() => _MatchSchedWidgState();
}

class _MatchSchedWidgState extends State<MatchSchedWidg> {
  Future<MatchSchedData> futureAuto;

  @override
  void initState() {
    super.initState();
    futureAuto = fetchAuto(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder future = FutureBuilder<MatchSchedData>(
      future: futureAuto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String text = "";
          snapshot.data.schedule.forEach((element) {
            text += "\n\n\n${element.description} -- (No. ${element.matchNumber}) (${element.tournamentLevel})";
            text += "\nScheduled for ${element.startTime}";
            if (element.field != "Primary") text += "\nMatch played on secondary field.";
            element.teams.forEach((element2) {
              text += "\n\nTeam ${element2.teamNumber}";
              text += "\nStationed at ${element2.station}";
              if (element2.surrogate) text += "\nThey were a surrogate team";
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
      title: Text('Match Schedule'),
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}
