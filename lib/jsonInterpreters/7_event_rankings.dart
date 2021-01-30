import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<EventRankingsData> fetchAuto(String url) async {
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
    return EventRankingsData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(
        'Please Enter or check your API Key or ensure the entered inputs are correct');
  }
}

class EventRankingsData {
  List<Rankings> rankings;

  EventRankingsData({this.rankings});

  EventRankingsData.fromJson(Map<String, dynamic> json) {
    if (json['Rankings'] != null) {
      rankings =  <Rankings>[];
      json['Rankings'].forEach((v) {
        rankings.add(new Rankings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.rankings != null) {
      data['Rankings'] = this.rankings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rankings {
  int rank;
  int teamNumber;
  double sortOrder1;
  double sortOrder2;
  double sortOrder3;
  double sortOrder4;
  double sortOrder5;
  double sortOrder6;
  int wins;
  int losses;
  int ties;
  double qualAverage;
  int dq;
  int matchesPlayed;

  Rankings(
      {this.rank,
        this.teamNumber,
        this.sortOrder1,
        this.sortOrder2,
        this.sortOrder3,
        this.sortOrder4,
        this.sortOrder5,
        this.sortOrder6,
        this.wins,
        this.losses,
        this.ties,
        this.qualAverage,
        this.dq,
        this.matchesPlayed});

  Rankings.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    teamNumber = json['teamNumber'];
    sortOrder1 = json['sortOrder1'];
    sortOrder2 = json['sortOrder2'];
    sortOrder3 = json['sortOrder3'];
    sortOrder4 = json['sortOrder4'];
    sortOrder5 = json['sortOrder5'];
    sortOrder6 = json['sortOrder6'];
    wins = json['wins'];
    losses = json['losses'];
    ties = json['ties'];
    qualAverage = json['qualAverage'];
    dq = json['dq'];
    matchesPlayed = json['matchesPlayed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['rank'] = this.rank;
    data['teamNumber'] = this.teamNumber;
    data['sortOrder1'] = this.sortOrder1;
    data['sortOrder2'] = this.sortOrder2;
    data['sortOrder3'] = this.sortOrder3;
    data['sortOrder4'] = this.sortOrder4;
    data['sortOrder5'] = this.sortOrder5;
    data['sortOrder6'] = this.sortOrder6;
    data['wins'] = this.wins;
    data['losses'] = this.losses;
    data['ties'] = this.ties;
    data['qualAverage'] = this.qualAverage;
    data['dq'] = this.dq;
    data['matchesPlayed'] = this.matchesPlayed;
    return data;
  }
}

class EventRankWidg extends StatefulWidget {
  final String url;
  EventRankWidg({Key key, this.url}) : super(key: key);

  @override
  _EventRankWidgState createState() => _EventRankWidgState();
}

class _EventRankWidgState extends State<EventRankWidg> {
  Future<EventRankingsData> futureAuto;

  @override
  void initState() {
    super.initState();
    futureAuto = fetchAuto(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder future = FutureBuilder<EventRankingsData>(
      future: futureAuto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String text = "";
          snapshot.data.rankings.forEach((element) {
            text += "\n\nTeam ${element.teamNumber} -- Ranked ${element.rank}";
            text += "\nPlayed ${element.matchesPlayed} matches";
            text += "\nWins ${element.wins} -- Losses ${element.losses} -- Ties ${element.ties}";
            text += "\nDQed ${element.dq} times";
            text += "\nQualification average points is ${element.qualAverage}";
            //sortOrder not included, for manual scoring
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
