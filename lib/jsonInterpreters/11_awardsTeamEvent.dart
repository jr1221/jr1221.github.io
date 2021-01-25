import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AwardsTBData> fetchAuto(String url) async {
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
    return AwardsTBData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Please Enter or check your API Key or ensure the entered inputs are correct');
  }
}
class AwardsTBData {
  List<Awards> awards;

  AwardsTBData({this.awards});

  AwardsTBData.fromJson(Map<String, dynamic> json) {
    if (json['Awards'] != null) {
      awards =  <Awards>[];
      json['Awards'].forEach((v) {
        awards.add(new Awards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.awards != null) {
      data['Awards'] = this.awards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Awards {
  int awardId;
  int teamId;
  int eventId;
  int eventDivisionId;
  String eventCode;
  String name;
  int series;
  int teamNumber;
  String schoolName;
  String fullTeamName;
  String person;

  Awards(
      {this.awardId,
        this.teamId,
        this.eventId,
        this.eventDivisionId,
        this.eventCode,
        this.name,
        this.series,
        this.teamNumber,
        this.schoolName,
        this.fullTeamName,
        this.person});

  Awards.fromJson(Map<String, dynamic> json) {
    awardId = json['awardId'];
    teamId = json['teamId'];
    eventId = json['eventId'];
    eventDivisionId = json['eventDivisionId'];
    eventCode = json['eventCode'];
    name = json['name'];
    series = json['series'];
    teamNumber = json['teamNumber'];
    schoolName = json['schoolName'];
    fullTeamName = json['fullTeamName'];
    person = json['person'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['awardId'] = this.awardId;
    data['teamId'] = this.teamId;
    data['eventId'] = this.eventId;
    data['eventDivisionId'] = this.eventDivisionId;
    data['eventCode'] = this.eventCode;
    data['name'] = this.name;
    data['series'] = this.series;
    data['teamNumber'] = this.teamNumber;
    data['schoolName'] = this.schoolName;
    data['fullTeamName'] = this.fullTeamName;
    data['person'] = this.person;
    return data;
  }
}



class AwardsWidg extends StatefulWidget {
  final String url;
  AwardsWidg({Key key, this.url}) : super(key: key);

  @override
  _AwardsWidgState createState() => _AwardsWidgState();
}

class _AwardsWidgState extends State<AwardsWidg> {
  Future<AwardsTBData> futureAuto;

  @override
  void initState() {
    super.initState();
    futureAuto = fetchAuto(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder future = FutureBuilder<AwardsTBData>(
      future: futureAuto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String text = "";
          snapshot.data.awards.forEach((element) {
            text += "\n\n${element.name}";
       //     teamId, eventId, eventDivisionId  endpoints not really useful
            if (element.teamNumber != null) {
              text += "\nAwarded to team ${element.teamNumber} -\n- ${element.fullTeamName}";
            }
            text += "\nNumber ${element.series} in event that received award.";
            text +="\nInternal Award ID: ${element.awardId}";

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
      title: Text('Awards'),
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}

