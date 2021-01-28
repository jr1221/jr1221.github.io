import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<EventsData> fetchAuto(String url) async {
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
    return EventsData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(
        'Please Enter or check your API Key or ensure the entered inputs are correct');
  }
}
class EventsData {
  List<Events> events;
  int eventCount;

  EventsData({this.events, this.eventCount});

  EventsData.fromJson(Map<String, dynamic> json) {
    if (json['Events'] != null) {
      events = <Events>[];
      json['Events'].forEach((v) {
        events.add(new Events.fromJson(v));
      });
    }
    eventCount = json['eventCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.events != null) {
      data['Events'] = this.events.map((v) => v.toJson()).toList();
    }
    data['eventCount'] = this.eventCount;
    return data;
  }
}

class Events {
  String address;
  String website;
  List<String> webcasts;
  String timezone;
  String code;
  String divisionCode;
  String name;
  String type;
  String districtCode;
  String venue;
  String city;
  String stateprov;
  String country;
  String dateStart;
  String dateEnd;

  Events(
      {this.address,
        this.website,
        this.webcasts,
        this.timezone,
        this.code,
        this.divisionCode,
        this.name,
        this.type,
        this.districtCode,
        this.venue,
        this.city,
        this.stateprov,
        this.country,
        this.dateStart,
        this.dateEnd});

  Events.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    website = json['website'];
    webcasts = json['webcasts'].cast<String>();
    timezone = json['timezone'];
    code = json['code'];
    divisionCode = json['divisionCode'];
    name = json['name'];
    type = json['type'];
    districtCode = json['districtCode'];
    venue = json['venue'];
    city = json['city'];
    stateprov = json['stateprov'];
    country = json['country'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['address'] = this.address;
    data['website'] = this.website;
    data['webcasts'] = this.webcasts;
    data['timezone'] = this.timezone;
    data['code'] = this.code;
    data['divisionCode'] = this.divisionCode;
    data['name'] = this.name;
    data['type'] = this.type;
    data['districtCode'] = this.districtCode;
    data['venue'] = this.venue;
    data['city'] = this.city;
    data['stateprov'] = this.stateprov;
    data['country'] = this.country;
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    return data;
  }
}

class EventsWidg extends StatefulWidget {
  final String url;
  EventsWidg({Key key, this.url}) : super(key: key);

  @override
  _EventsWidgState createState() => _EventsWidgState();
}

class _EventsWidgState extends State<EventsWidg> {
  Future<EventsData> futureAuto;

  @override
  void initState() {
    super.initState();
    futureAuto = fetchAuto(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder future = FutureBuilder<EventsData>(
      future: futureAuto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String text = "";
          text += "\n${snapshot.data.eventCount} Events found.";
          snapshot.data.events.forEach((element) {
            text += "\n\n ${element.code} -- ${element.name}";
            text += "\nThis is a ${element.type} event.";
            if (element.districtCode != null) text += "\nThis district code is ${element.districtCode}";
            text += "\nThe event started at ${element.dateStart} and ended at ${element.dateEnd}, ${element.timezone}.";
            text += "\n${element.venue}";
            text += "\n${element.address}";
            text += "\n${element.city}, ${element.stateprov}, ${element.country}";
            text += "\nWebsite: ${element.website}";
            element.webcasts.forEach((element2) {
              text += "\nWebcast: $element";
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
      title: Text('Team Listings'),
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}
