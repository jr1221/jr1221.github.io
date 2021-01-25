import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<TeamsData> fetchAuto(String url) async {
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
    return TeamsData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Please Enter or check your API Key or ensure the entered inputs are correct');
  }
}

class TeamsData {
  List<Teams> teams;
  int teamCountTotal;
  int teamCountPage;
  int pageCurrent;
  int pageTotal;

  TeamsData(
      {this.teams,
        this.teamCountTotal,
        this.teamCountPage,
        this.pageCurrent,
        this.pageTotal});

  TeamsData.fromJson(Map<String, dynamic> json) {
    if (json['teams'] != null) {
      teams =  <Teams>[];
      json['teams'].forEach((v) {
        teams.add(new Teams.fromJson(v));
      });
    }
    teamCountTotal = json['teamCountTotal'];
    teamCountPage = json['teamCountPage'];
    pageCurrent = json['pageCurrent'];
    pageTotal = json['pageTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teams != null) {
      data['teams'] = this.teams.map((v) => v.toJson()).toList();
    }
    data['teamCountTotal'] = this.teamCountTotal;
    data['teamCountPage'] = this.teamCountPage;
    data['pageCurrent'] = this.pageCurrent;
    data['pageTotal'] = this.pageTotal;
    return data;
  }
}

class Teams {
  String schoolName;
  String website;
  String homeCMP;
  int teamNumber;
  String nameFull;
  String nameShort;
  String city;
  String stateProv;
  String country;
  int rookieYear;
  String robotName;
  String districtCode;

  Teams(
      {this.schoolName,
        this.website,
        this.homeCMP,
        this.teamNumber,
        this.nameFull,
        this.nameShort,
        this.city,
        this.stateProv,
        this.country,
        this.rookieYear,
        this.robotName,
        this.districtCode});

  Teams.fromJson(Map<String, dynamic> json) {
    schoolName = json['schoolName'];
    website = json['website'];
    homeCMP = json['homeCMP'];
    teamNumber = json['teamNumber'];
    nameFull = json['nameFull'];
    nameShort = json['nameShort'];
    city = json['city'];
    stateProv = json['stateProv'];
    country = json['country'];
    rookieYear = json['rookieYear'];
    robotName = json['robotName'];
    districtCode = json['districtCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['schoolName'] = this.schoolName;
    data['website'] = this.website;
    data['homeCMP'] = this.homeCMP;
    data['teamNumber'] = this.teamNumber;
    data['nameFull'] = this.nameFull;
    data['nameShort'] = this.nameShort;
    data['city'] = this.city;
    data['stateProv'] = this.stateProv;
    data['country'] = this.country;
    data['rookieYear'] = this.rookieYear;
    data['robotName'] = this.robotName;
    data['districtCode'] = this.districtCode;
    return data;
  }
}



class TeamsWidg extends StatefulWidget {
  final String url;
  TeamsWidg({Key key, this.url}) : super(key: key);

  @override
  _TeamsWidgState createState() => _TeamsWidgState();
}

class _TeamsWidgState extends State<TeamsWidg> {
  Future<TeamsData> futureAuto;

  @override
  void initState() {
    super.initState();
    futureAuto = fetchAuto(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder future = FutureBuilder<TeamsData>(
      future: futureAuto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String text = "";
          text += "\nThis is page ${snapshot.data.pageCurrent} of ${snapshot.data.pageTotal}.";
          text += "\n${snapshot.data.teamCountPage} teams are on this page, and there are ${snapshot.data.teamCountTotal} in total.";
          text +="\nTeams:\n";
          snapshot.data.teams.forEach((element) {
            text += "\n\n${element.teamNumber} -- ${element.nameShort}";
            text += "\n${element.nameFull}";
            text += "\nRobot name: ${element.robotName}";
            text += "\n${element.districtCode} is their home district";
            text += "\nFrom ${element.schoolName}";
            text += "\nWebsite: ${element.website}";
            text += "\nLocated in ${element.city},${element.stateProv},${element.country}";
            text += "\nRookie year is ${element.rookieYear}";
            text += "\nChampionship event: ${element.homeCMP}";
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
      title: Text('Team Listings'),
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}

