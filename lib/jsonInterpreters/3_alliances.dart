import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AlliancesCode> fetchAuto(String url) async {
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
    return AlliancesCode.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Please Enter or check your API Key or ensure the entered inputs are correct');
  }
}

class AlliancesCode {
  List<Alliances> alliances;
  int count;

  AlliancesCode({this.alliances, this.count});

  AlliancesCode.fromJson(Map<String, dynamic> json) {
    if (json['Alliances'] != null) {
      alliances =  <Alliances>[];
      json['Alliances'].forEach((v) {
        alliances.add(new Alliances.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.alliances != null) {
      data['Alliances'] = this.alliances.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class Alliances {
  String name;
  int number;
  int captain;
  int round1;
  int round2;
  int round3;
  int backup;
  int backupReplaced;

  Alliances(
      {this.name,
        this.number,
        this.captain,
        this.round1,
        this.round2,
        this.round3,
        this.backup,
        this.backupReplaced});

  Alliances.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number = json['number'];
    captain = json['captain'];
    round1 = json['round1'];
    round2 = json['round2'];
    round3 = json['round3'];
    backup = json['backup'];
    backupReplaced = json['backupReplaced'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['name'] = this.name;
    data['number'] = this.number;
    data['captain'] = this.captain;
    data['round1'] = this.round1;
    data['round2'] = this.round2;
    data['round3'] = this.round3;
    data['backup'] = this.backup;
    data['backupReplaced'] = this.backupReplaced;
    return data;
  }
}

class AlliancesWidg extends StatefulWidget {
  final String url;
  AlliancesWidg({Key key, this.url}) : super(key: key);

  @override
  _AlliancesWidgState createState() => _AlliancesWidgState();
}

class _AlliancesWidgState extends State<AlliancesWidg> {
  Future<AlliancesCode> futureAuto;

  @override
  void initState() {
    super.initState();
    futureAuto = fetchAuto(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder future = FutureBuilder<AlliancesCode>(
      future: futureAuto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String text = "";
          text += "${snapshot.data.count.toString()} Alliances";
          snapshot.data.alliances.forEach((element) {
            text += "\n\nAlliance Number: ${element.number}";
         //   text += element.name; Alliance X
            text += "\nCaptain: ${element.captain}";
            text += "\nRound 1 Selection: ${element.round1}";
            text += "\nRound 2 Selection: ${element.round2}";
            if (element.round3 != null)
            text += "\nRound 3 Selection: ${element.round3}";
            if (element.backup != null)
            text += "\nBackup Team: ${element.backup}";
            if (element.backupReplaced != null)
              text += "\nBackup Replaced: ${element.backupReplaced}";
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
      title: Text('Alliance Info'),
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}
