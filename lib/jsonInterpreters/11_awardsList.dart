import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AwardsListData> fetchAuto(String url) async {
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
    return AwardsListData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(
        'Please Enter or check your API Key or ensure the entered inputs are correct');
  }
}

class AwardsListData {
  List<Awards> awards;

  AwardsListData({this.awards});

  AwardsListData.fromJson(Map<String, dynamic> json) {
    if (json['awards'] != null) {
      awards = <Awards>[];
      json['awards'].forEach((v) {
        awards.add(new Awards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.awards != null) {
      data['awards'] = this.awards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Awards {
  int awardId;
  String eventType;
  String description;
  bool forPerson;

  Awards({this.awardId, this.eventType, this.description, this.forPerson});

  Awards.fromJson(Map<String, dynamic> json) {
    awardId = json['awardId'];
    eventType = json['eventType'];
    description = json['description'];
    forPerson = json['forPerson'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['awardId'] = this.awardId;
    data['eventType'] = this.eventType;
    data['description'] = this.description;
    data['forPerson'] = this.forPerson;
    return data;
  }
}

class AwardsListWidg extends StatefulWidget {
  final String url;
  AwardsListWidg({Key key, this.url}) : super(key: key);

  @override
  _AwardsListWidgState createState() => _AwardsListWidgState();
}

class _AwardsListWidgState extends State<AwardsListWidg> {
  Future<AwardsListData> futureAuto;

  @override
  void initState() {
    super.initState();
    futureAuto = fetchAuto(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder future = FutureBuilder<AwardsListData>(
      future: futureAuto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String text = "";
          snapshot.data.awards.forEach((element) {
            text += "\n\n${element.description}";
            text += "\nThis award is given out at ${element.eventType}";
            if (element.forPerson) text += "\nThis award is for a person";
            text += "\nInternal Award ID: ${element.awardId}";
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
