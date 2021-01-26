import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<DistrictRankData> fetchAuto(String url) async {
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
    return DistrictRankData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(
        'Please Enter or check your API Key or ensure the entered inputs are correct');
  }
}

class DistrictRankData {
  List<DistrictRanks> districtRanks;
  int rankingCountTotal;
  int rankingCountPage;
  int pageCurrent;
  int pageTotal;

  DistrictRankData(
      {this.districtRanks,
      this.rankingCountTotal,
      this.rankingCountPage,
      this.pageCurrent,
      this.pageTotal});

  DistrictRankData.fromJson(Map<String, dynamic> json) {
    if (json['districtRanks'] != null) {
      districtRanks = <DistrictRanks>[];
      json['districtRanks'].forEach((v) {
        districtRanks.add(DistrictRanks.fromJson(v));
      });
    }
    rankingCountTotal = json['rankingCountTotal'];
    rankingCountPage = json['rankingCountPage'];
    pageCurrent = json['pageCurrent'];
    pageTotal = json['pageTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.districtRanks != null) {
      data['districtRanks'] =
          this.districtRanks.map((v) => v.toJson()).toList();
    }
    data['rankingCountTotal'] = this.rankingCountTotal;
    data['rankingCountPage'] = this.rankingCountPage;
    data['pageCurrent'] = this.pageCurrent;
    data['pageTotal'] = this.pageTotal;
    return data;
  }
}

class DistrictRanks {
  String districtCode;
  int teamNumber;
  int rank;
  int totalPoints;
  String event1Code;
  double event1Points;
  String event2Code;
  double event2Points;
  String districtCmpCode;
  double districtCmpPoints;
  int teamAgePoints;
  int adjustmentPoints;
  bool qualifiedDistrictCmp;
  bool qualifiedFirstCmp;

  DistrictRanks(
      {this.districtCode,
      this.teamNumber,
      this.rank,
      this.totalPoints,
      this.event1Code,
      this.event1Points,
      this.event2Code,
      this.event2Points,
      this.districtCmpCode,
      this.districtCmpPoints,
      this.teamAgePoints,
      this.adjustmentPoints,
      this.qualifiedDistrictCmp,
      this.qualifiedFirstCmp});

  DistrictRanks.fromJson(Map<String, dynamic> json) {
    districtCode = json['districtCode'];
    teamNumber = json['teamNumber'];
    rank = json['rank'];
    totalPoints = json['totalPoints'];
    event1Code = json['event1Code'];
    event1Points = json['event1Points'];
    event2Code = json['event2Code'];
    event2Points = json['event2Points'];
    districtCmpCode = json['districtCmpCode'];
    districtCmpPoints = json['districtCmpPoints'];
    teamAgePoints = json['teamAgePoints'];
    adjustmentPoints = json['adjustmentPoints'];
    qualifiedDistrictCmp = json['qualifiedDistrictCmp'];
    qualifiedFirstCmp = json['qualifiedFirstCmp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['districtCode'] = this.districtCode;
    data['teamNumber'] = this.teamNumber;
    data['rank'] = this.rank;
    data['totalPoints'] = this.totalPoints;
    data['event1Code'] = this.event1Code;
    data['event1Points'] = this.event1Points;
    data['event2Code'] = this.event2Code;
    data['event2Points'] = this.event2Points;
    data['districtCmpCode'] = this.districtCmpCode;
    data['districtCmpPoints'] = this.districtCmpPoints;
    data['teamAgePoints'] = this.teamAgePoints;
    data['adjustmentPoints'] = this.adjustmentPoints;
    data['qualifiedDistrictCmp'] = this.qualifiedDistrictCmp;
    data['qualifiedFirstCmp'] = this.qualifiedFirstCmp;
    return data;
  }
}

class DistrictRankWidg extends StatefulWidget {
  final String url;
  DistrictRankWidg({Key key, this.url}) : super(key: key);

  @override
  _DistrictRankWidgState createState() => _DistrictRankWidgState();
}

class _DistrictRankWidgState extends State<DistrictRankWidg> {
  Future<DistrictRankData> futureAuto;

  @override
  void initState() {
    super.initState();
    futureAuto = fetchAuto(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder future = FutureBuilder<DistrictRankData>(
      future: futureAuto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String text = "";
          text +=
              "\nThis is page ${snapshot.data.pageCurrent} of ${snapshot.data.pageTotal}.";
          text +=
              "\n${snapshot.data.rankingCountPage} teams are on this page, and there are ${snapshot.data.rankingCountTotal} in total.";
          text += "\n\nRankings:\n";
          snapshot.data.districtRanks.forEach((element) {
            text += "\n\nTeam ${element.teamNumber} -- RANK: ${element.rank}";
            if (element.qualifiedDistrictCmp) {
              text += "\nThis team HAS qualified for district championships.";
              text +=
                  "\nThey scored ${element.districtCmpPoints} at the ${element.districtCmpCode} district championship";
              if (element.qualifiedFirstCmp)
                text += "\nThis team HAS qualified for FIRST CHAMPIONSHPS";
              else
                text += '\nThis team has NOT qualified for FIRST CHAMPIONSHIPS';
            } else
              text +=
                  "\nThis team has NOT qualified for district championships.";
            text += "\nThe team scored ${element.totalPoints} points;";
            text +=
                "\n  ${element.event1Points} points at ${element.event1Code}";
            text +=
                "\n  ${element.event2Points} points at ${element.event2Code}";
            if (element.teamAgePoints != 0)
              text +=
                  "\nThey got ${element.teamAgePoints} extra points for team age.";
            if (element.adjustmentPoints != 0)
              text +=
                  "\nThey got ${element.adjustmentPoints} adjustment points.";
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
