import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<YearData> fetchAuto(String url) async {
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
    return YearData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Please Enter or check your API Key or ensure the entered inputs are correct');
  }
}

class YearData {
  int eventCount;
  String gameName;
  String kickoff;
  int rookieStart;
  int teamCount;
  List<FrcChampionships> frcChampionships;

  YearData(
      {this.eventCount,
        this.gameName,
        this.kickoff,
        this.rookieStart,
        this.teamCount,
        this.frcChampionships});

  YearData.fromJson(Map<String, dynamic> json) {
    eventCount = json['eventCount'];
    gameName = json['gameName'];
    kickoff = json['kickoff'];
    rookieStart = json['rookieStart'];
    teamCount = json['teamCount'];
    if (json['frcChampionships'] != null) {
      frcChampionships =  <FrcChampionships>[];
      json['frcChampionships'].forEach((v) {
        frcChampionships.add(FrcChampionships.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventCount'] = this.eventCount;
    data['gameName'] = this.gameName;
    data['kickoff'] = this.kickoff;
    data['rookieStart'] = this.rookieStart;
    data['teamCount'] = this.teamCount;
    if (this.frcChampionships != null) {
      data['frcChampionships'] =
          this.frcChampionships.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FrcChampionships {
  String name;
  String startDate;
  String location;

  FrcChampionships({this.name, this.startDate, this.location});

  FrcChampionships.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    startDate = json['startDate'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['startDate'] = this.startDate;
    data['location'] = this.location;
    return data;
  }
}


class YearWidg extends StatefulWidget {
  final String url;
  YearWidg({Key key, this.url}) : super(key: key);

  @override
  _YearWidgState createState() => _YearWidgState();
}

class _YearWidgState extends State<YearWidg> {
  Future<YearData> futureAuto;

  @override
  void initState() {
    super.initState();
    futureAuto = fetchAuto(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder future = FutureBuilder<YearData>(
      future: futureAuto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String text = "";
          text += snapshot.data.gameName;
          text += "\nKickoff was on ${snapshot.data.kickoff}";
          text += "\nThere were ${snapshot.data.teamCount} teams";
          text += "\nThe lowest rookie team was ${snapshot.data.rookieStart}";
          text += "\nThere were ${snapshot.data.eventCount} events";
          text += "\n\nChampionships: ";
          snapshot.data.frcChampionships.forEach((element) {
            text += "\n\n${element.name}";
            text += "\nStart Date:  ${element.startDate}";
            text += "\nLocation: ${element.location}";
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
      title: Text('Year Info'),
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}

