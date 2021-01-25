import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Avatars> fetchAuto(String url) async {
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
    return Avatars.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Please Enter or check your API Key or ensure the entered inputs are correct');
  }
}

class Avatars {
  List<Teams> teams;
  int teamCountTotal;
  int teamCountPage;
  int pageCurrent;
  int pageTotal;

  Avatars(
      {this.teams,
      this.teamCountTotal,
      this.teamCountPage,
      this.pageCurrent,
      this.pageTotal});

  Avatars.fromJson(Map<String, dynamic> json) {
    if (json['teams'] != null) {
      teams = <Teams>[];
      json['teams'].forEach((v) {
        teams.add(Teams.fromJson(v));
      });
    }
    teamCountTotal = json['teamCountTotal'];
    teamCountPage = json['teamCountPage'];
    pageCurrent = json['pageCurrent'];
    pageTotal = json['pageTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  int teamNumber;
  String encodedAvatar;

  Teams({this.teamNumber, this.encodedAvatar});

  Teams.fromJson(Map<String, dynamic> json) {
    teamNumber = json['teamNumber'];
    encodedAvatar = json['encodedAvatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['teamNumber'] = this.teamNumber;
    data['encodedAvatar'] = this.encodedAvatar;
    return data;
  }
}

class AvatarWidg extends StatefulWidget {
  final String url;
  AvatarWidg({Key key, this.url}) : super(key: key);

  @override
  _AvatarWidgState createState() => _AvatarWidgState();
}

class _AvatarWidgState extends State<AvatarWidg> {
  Future<Avatars> futureAuto;

  @override
  void initState() {
    super.initState();
    futureAuto = fetchAuto(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Avatars>(
        future: futureAuto,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Uint8List _bytesImage;
            String base6;
            snapshot.data.teams.forEach((element) {
              base6 = element.encodedAvatar;
            });
            _bytesImage = Base64Decoder().convert(base6);
              return PhotoView(
                imageProvider: MemoryImage(_bytesImage),
                minScale: 5.4,
                maxScale: 9.6,
              );
          } else if (snapshot.hasError) {}
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
