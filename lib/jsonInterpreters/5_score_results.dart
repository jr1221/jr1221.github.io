import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ScoreResultsData> fetchAuto(String url) async {
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
    return ScoreResultsData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(
        'Please Enter or check your API Key or ensure the entered inputs are correct');
  }
}

class ScoreResultsData {
  List<MatchScores> matchScores;

  ScoreResultsData({this.matchScores});

  ScoreResultsData.fromJson(Map<String, dynamic> json) {
    if (json['MatchScores'] != null) {
      matchScores = <MatchScores>[];
      json['MatchScores'].forEach((v) {
        matchScores.add(new MatchScores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.matchScores != null) {
      data['MatchScores'] = this.matchScores.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MatchScores {
  String matchLevel;
  int matchNumber;
  List<Alliances> alliances;

  MatchScores({this.matchLevel, this.matchNumber, this.alliances});

  MatchScores.fromJson(Map<String, dynamic> json) {
    matchLevel = json['matchLevel'];
    matchNumber = json['matchNumber'];
    if (json['alliances'] != null) {
      alliances = <Alliances>[];
      json['alliances'].forEach((v) {
        alliances.add(new Alliances.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matchLevel'] = this.matchLevel;
    data['matchNumber'] = this.matchNumber;
    if (this.alliances != null) {
      data['alliances'] = this.alliances.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Alliances {
  String alliance;
  String preMatchLevelRobot1;
  String habLineRobot1;
  String endgameRobot1;
  String preMatchLevelRobot2;
  String habLineRobot2;
  String endgameRobot2;
  String preMatchLevelRobot3;
  String habLineRobot3;
  String endgameRobot3;
  String topLeftRocketNear;
  String topRightRocketNear;
  String midLeftRocketNear;
  String midRightRocketNear;
  String lowLeftRocketNear;
  String lowRightRocketNear;
  bool completedRocketNear;
  String topLeftRocketFar;
  String topRightRocketFar;
  String midLeftRocketFar;
  String midRightRocketFar;
  String lowLeftRocketFar;
  String lowRightRocketFar;
  bool completedRocketFar;
  String preMatchBay1;
  String preMatchBay2;
  String preMatchBay3;
  String preMatchBay6;
  String preMatchBay7;
  String preMatchBay8;
  String bay1;
  String bay2;
  String bay3;
  String bay4;
  String bay5;
  String bay6;
  String bay7;
  String bay8;
  int sandStormBonusPoints;
  int autoPoints;
  int hatchPanelPoints;
  int cargoPoints;
  int habClimbPoints;
  int teleopPoints;
  bool completeRocketRankingPoint;
  bool habDockingRankingPoint;
  int foulCount;
  int techFoulCount;
  int adjustPoints;
  int foulPoints;
  int rp;
  int totalPoints;

  Alliances(
      {this.alliance,
        this.preMatchLevelRobot1,
        this.habLineRobot1,
        this.endgameRobot1,
        this.preMatchLevelRobot2,
        this.habLineRobot2,
        this.endgameRobot2,
        this.preMatchLevelRobot3,
        this.habLineRobot3,
        this.endgameRobot3,
        this.topLeftRocketNear,
        this.topRightRocketNear,
        this.midLeftRocketNear,
        this.midRightRocketNear,
        this.lowLeftRocketNear,
        this.lowRightRocketNear,
        this.completedRocketNear,
        this.topLeftRocketFar,
        this.topRightRocketFar,
        this.midLeftRocketFar,
        this.midRightRocketFar,
        this.lowLeftRocketFar,
        this.lowRightRocketFar,
        this.completedRocketFar,
        this.preMatchBay1,
        this.preMatchBay2,
        this.preMatchBay3,
        this.preMatchBay6,
        this.preMatchBay7,
        this.preMatchBay8,
        this.bay1,
        this.bay2,
        this.bay3,
        this.bay4,
        this.bay5,
        this.bay6,
        this.bay7,
        this.bay8,
        this.sandStormBonusPoints,
        this.autoPoints,
        this.hatchPanelPoints,
        this.cargoPoints,
        this.habClimbPoints,
        this.teleopPoints,
        this.completeRocketRankingPoint,
        this.habDockingRankingPoint,
        this.foulCount,
        this.techFoulCount,
        this.adjustPoints,
        this.foulPoints,
        this.rp,
        this.totalPoints});

  Alliances.fromJson(Map<String, dynamic> json) {
    alliance = json['alliance'];
    preMatchLevelRobot1 = json['preMatchLevelRobot1'];
    habLineRobot1 = json['habLineRobot1'];
    endgameRobot1 = json['endgameRobot1'];
    preMatchLevelRobot2 = json['preMatchLevelRobot2'];
    habLineRobot2 = json['habLineRobot2'];
    endgameRobot2 = json['endgameRobot2'];
    preMatchLevelRobot3 = json['preMatchLevelRobot3'];
    habLineRobot3 = json['habLineRobot3'];
    endgameRobot3 = json['endgameRobot3'];
    topLeftRocketNear = json['topLeftRocketNear'];
    topRightRocketNear = json['topRightRocketNear'];
    midLeftRocketNear = json['midLeftRocketNear'];
    midRightRocketNear = json['midRightRocketNear'];
    lowLeftRocketNear = json['lowLeftRocketNear'];
    lowRightRocketNear = json['lowRightRocketNear'];
    completedRocketNear = json['completedRocketNear'];
    topLeftRocketFar = json['topLeftRocketFar'];
    topRightRocketFar = json['topRightRocketFar'];
    midLeftRocketFar = json['midLeftRocketFar'];
    midRightRocketFar = json['midRightRocketFar'];
    lowLeftRocketFar = json['lowLeftRocketFar'];
    lowRightRocketFar = json['lowRightRocketFar'];
    completedRocketFar = json['completedRocketFar'];
    preMatchBay1 = json['preMatchBay1'];
    preMatchBay2 = json['preMatchBay2'];
    preMatchBay3 = json['preMatchBay3'];
    preMatchBay6 = json['preMatchBay6'];
    preMatchBay7 = json['preMatchBay7'];
    preMatchBay8 = json['preMatchBay8'];
    bay1 = json['bay1'];
    bay2 = json['bay2'];
    bay3 = json['bay3'];
    bay4 = json['bay4'];
    bay5 = json['bay5'];
    bay6 = json['bay6'];
    bay7 = json['bay7'];
    bay8 = json['bay8'];
    sandStormBonusPoints = json['sandStormBonusPoints'];
    autoPoints = json['autoPoints'];
    hatchPanelPoints = json['hatchPanelPoints'];
    cargoPoints = json['cargoPoints'];
    habClimbPoints = json['habClimbPoints'];
    teleopPoints = json['teleopPoints'];
    completeRocketRankingPoint = json['completeRocketRankingPoint'];
    habDockingRankingPoint = json['habDockingRankingPoint'];
    foulCount = json['foulCount'];
    techFoulCount = json['techFoulCount'];
    adjustPoints = json['adjustPoints'];
    foulPoints = json['foulPoints'];
    rp = json['rp'];
    totalPoints = json['totalPoints'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alliance'] = this.alliance;
    data['preMatchLevelRobot1'] = this.preMatchLevelRobot1;
    data['habLineRobot1'] = this.habLineRobot1;
    data['endgameRobot1'] = this.endgameRobot1;
    data['preMatchLevelRobot2'] = this.preMatchLevelRobot2;
    data['habLineRobot2'] = this.habLineRobot2;
    data['endgameRobot2'] = this.endgameRobot2;
    data['preMatchLevelRobot3'] = this.preMatchLevelRobot3;
    data['habLineRobot3'] = this.habLineRobot3;
    data['endgameRobot3'] = this.endgameRobot3;
    data['topLeftRocketNear'] = this.topLeftRocketNear;
    data['topRightRocketNear'] = this.topRightRocketNear;
    data['midLeftRocketNear'] = this.midLeftRocketNear;
    data['midRightRocketNear'] = this.midRightRocketNear;
    data['lowLeftRocketNear'] = this.lowLeftRocketNear;
    data['lowRightRocketNear'] = this.lowRightRocketNear;
    data['completedRocketNear'] = this.completedRocketNear;
    data['topLeftRocketFar'] = this.topLeftRocketFar;
    data['topRightRocketFar'] = this.topRightRocketFar;
    data['midLeftRocketFar'] = this.midLeftRocketFar;
    data['midRightRocketFar'] = this.midRightRocketFar;
    data['lowLeftRocketFar'] = this.lowLeftRocketFar;
    data['lowRightRocketFar'] = this.lowRightRocketFar;
    data['completedRocketFar'] = this.completedRocketFar;
    data['preMatchBay1'] = this.preMatchBay1;
    data['preMatchBay2'] = this.preMatchBay2;
    data['preMatchBay3'] = this.preMatchBay3;
    data['preMatchBay6'] = this.preMatchBay6;
    data['preMatchBay7'] = this.preMatchBay7;
    data['preMatchBay8'] = this.preMatchBay8;
    data['bay1'] = this.bay1;
    data['bay2'] = this.bay2;
    data['bay3'] = this.bay3;
    data['bay4'] = this.bay4;
    data['bay5'] = this.bay5;
    data['bay6'] = this.bay6;
    data['bay7'] = this.bay7;
    data['bay8'] = this.bay8;
    data['sandStormBonusPoints'] = this.sandStormBonusPoints;
    data['autoPoints'] = this.autoPoints;
    data['hatchPanelPoints'] = this.hatchPanelPoints;
    data['cargoPoints'] = this.cargoPoints;
    data['habClimbPoints'] = this.habClimbPoints;
    data['teleopPoints'] = this.teleopPoints;
    data['completeRocketRankingPoint'] = this.completeRocketRankingPoint;
    data['habDockingRankingPoint'] = this.habDockingRankingPoint;
    data['foulCount'] = this.foulCount;
    data['techFoulCount'] = this.techFoulCount;
    data['adjustPoints'] = this.adjustPoints;
    data['foulPoints'] = this.foulPoints;
    data['rp'] = this.rp;
    data['totalPoints'] = this.totalPoints;
    return data;
  }
}


class ScoreResultsWidg extends StatefulWidget {
  final String url;
  ScoreResultsWidg({Key key, this.url}) : super(key: key);

  @override
  _ScoreResultsWidgState createState() => _ScoreResultsWidgState();
}

class _ScoreResultsWidgState extends State<ScoreResultsWidg> {
  Future<ScoreResultsData> futureAuto;

  @override
  void initState() {
    super.initState();
    futureAuto = fetchAuto(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder future = FutureBuilder<ScoreResultsData>(
      future: futureAuto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String text = "";
          snapshot.data.matchScores.forEach((element) {
            text += "\n\n${element.matchNumber}";
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
      title: Text('Score Results'),
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}
