import 'package:flutter/material.dart';
import 'urlGenerator.dart';
import 'jsonInterpreters/14_avatar.dart';
import 'jsonInterpreters/13_districts.dart';
import 'package:handy_tools/jsonInterpreters/11_awardsList.dart';
import 'package:handy_tools/jsonInterpreters/11_awardsTeamEvent.dart';
import 'jsonInterpreters/10_yearInfo.dart';
import 'jsonInterpreters/3_alliances.dart';

class ChooseOpts extends StatefulWidget {
  final String event;
  final int year;
  final int team;
  ChooseOpts({Key key, this.year, this.event, this.team}) : super(key: key);

  @override
  _ChooseOptsState createState() => _ChooseOptsState();
}

class _ChooseOptsState extends State<ChooseOpts> {
  int _year;
  int _team;
  String _event;

  @override
  void initState() {
    super.initState();
    _year = widget.year;
    _team = widget.team;
    _event = widget.event;
  }
  bool _removeUnable(bool eventreq, bool teamreq) {
    if ((_event == null || _event.length < 2) && eventreq) {
      AlertDialog eventInvalid = AlertDialog(
        title: Text(
          "Event code is invalid or missing!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        content: Text(
          "Please enter a valid event to search, or choose a search option in which it is not required.",
          textAlign: TextAlign.center,
        ),
      );
      showDialog(
          context: context, builder: (BuildContext context) => eventInvalid);
      return true;
    }
    if ((_team == null || _team == 0) && teamreq) {
      AlertDialog teamInvalid = AlertDialog(
        title: Text(
          "Team number is invalid or missing!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        content: Text(
          "Please enter a valid team number to search, or choose a search option in which it is not required.",
          textAlign: TextAlign.center,
        ),
      );
      showDialog(
          context: context, builder: (BuildContext context) => teamInvalid);
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    FlatButton alliances = FlatButton(
      child: Text('Alliances'),
    onPressed: () {
      if (_removeUnable(true, false)) return;
        String url = UrlGenerator(_year, _event, _team).fromSelection(3);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlliancesWidg(url: url)),
        );
      },
    );
    FlatButton yearInfo = FlatButton(
      child: Text('Year Info'),
      onPressed: () {
        String url = UrlGenerator(_year, _event, _team).fromSelection(10);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => YearWidg(url: url)),
        );
      },
    );
     FlatButton awards = FlatButton(
       child: Text('Awards'),
       onPressed: () {
         String url = UrlGenerator(_year, _event, _team).fromSelection(11);
         if (_event == null && _team == null) {
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => AwardsListWidg(url: url)),
           );
         } else
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => AwardsWidg(url: url)),
           );
       },
     );
    FlatButton districts = FlatButton(
      child: Text('Districts'),
      onPressed: () {
        String url = UrlGenerator(_year, _event, _team).fromSelection(13);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DistrictWidg(url: url)),
        );
      },
    );
    FlatButton teamAvatar = FlatButton(
      child: Text('Avatar'),
      onPressed: () {
        if (_removeUnable(false, true)) return;
        String url = UrlGenerator(_year, _event, _team).fromSelection(14);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AvatarWidg(url: url)),
        );
      },
    );
    Container container = Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          SizedBox(
            width: 20,
          ),
          alliances,
          yearInfo,
          awards,
          districts,
          teamAvatar,
        ]));
    AppBar appBar = AppBar(
      title: Text("Select your request"),
      centerTitle: true,
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}
