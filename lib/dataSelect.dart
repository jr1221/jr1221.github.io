import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'urlGenerator.dart';
import 'jsonInterpreters/14_avatar.dart';
import 'jsonInterpreters/13_districts.dart';
import 'package:handy_tools/jsonInterpreters/12_district_rankings.dart';
import 'jsonInterpreters/11_awardsList.dart';
import 'jsonInterpreters/11_awardsTeamEvent.dart';
import 'jsonInterpreters/10_yearInfo.dart';
import 'jsonInterpreters/9_teams.dart';
import 'package:handy_tools/jsonInterpreters/8_events.dart';
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
        String url =
            UrlGenerator(_year, _event, _team).fromSelection(selection: 3);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlliancesWidg(url: url)),
        );
      },
    );
    FlatButton eventListing = FlatButton(
      child: Text('Event Listings'),
      onPressed: () async {
        int selection;
        int selection2;
        String goValue = "";
        if (_event == null && _team == null) {
          selection = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => OptsWidg(
                  "Filter by District Code?",
                  "Yes",
                  "No"));
          if (selection == 1) {
            goValue = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) =>
                    TextWidg("Enter District Code", "District Code"));
          } else {
            selection2 = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => OptsWidg(
                    "Exclude District and Championship events?",
                    "Yes",
                    "No"));
          }
        }
        String url =
        UrlGenerator(_year, _event, _team).fromSelection(selection: 8, extraNamed: goValue, extraNamedMode: selection, extraNamedMode2: selection2);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventsWidg(url: url)),
        );
      },
    );
    FlatButton teamListing = FlatButton(
      child: Text('Team Listings'),
      onPressed: () async {
        int selection = 0;
        String goValue = "";
        if (_team == null && _event == null) {
          selection = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => OptsWidg(
                  "Filter by district or state?", "State", "District"));
          if (selection == 1) {
            goValue = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) =>
                    TextWidg("Enter State", "State"));
          } else if (selection == 2) {
            goValue = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) =>
                    TextWidg("Enter District", "District"));
          }
        }
        String url = UrlGenerator(_year, _event, _team).fromSelection(
            selection: 9, extraNamed: goValue, extraNamedMode: selection);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TeamsWidg(url: url)),
        );
      },
    );
    FlatButton yearInfo = FlatButton(
      child: Text('Year Info'),
      onPressed: () {
        String url =
            UrlGenerator(_year, _event, _team).fromSelection(selection: 10);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => YearWidg(url: url)),
        );
      },
    );
    FlatButton awards = FlatButton(
      child: Text('Awards'),
      onPressed: () {
        String url =
            UrlGenerator(_year, _event, _team).fromSelection(selection: 11);
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
    FlatButton districtRankings = FlatButton(
      child: Text('District Rankings'),
      onPressed: () async {
        String goValue;
        String goValue2;
        int selection;
        if (_team == null) {
          goValue = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) =>
                  TextWidg("Enter District Code", "District Code"));
          selection = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => Opts2Widg(
                  "Please choose return filter.",
                  "None",
                  "Page #",
                  "Top X Rankings"));
          if (selection == 2) {
            goValue2 = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) =>
                    TextWidg("Enter Page Number", "Page Number"));
          }
          else if (selection == 3) {
            goValue2 = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) =>
                    TextWidg("Enter Top X Rankings", "Top X Rankings"));
          }
          try {
            int.parse(goValue2);
          } catch (Exception) {
            await showDialog(
                context: context,
              builder: (BuildContext context) => AlertWidg("Page Number and Top Rankings must be whole numbers"));
            return;
          }
        }
        String url = UrlGenerator(_year, _event, _team).fromSelection(
            selection: 12,
            extraNamed: goValue,
            extraNamed2: goValue2,
            extraNamedMode: selection);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DistrictRankWidg(url: url)),
        );
      },
    );
    FlatButton districts = FlatButton(
      child: Text('Districts'),
      onPressed: () {
        String url =
            UrlGenerator(_year, _event, _team).fromSelection(selection: 13);
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
        String url =
            UrlGenerator(_year, _event, _team).fromSelection(selection: 14);
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
          eventListing,
          teamListing,
          yearInfo,
          awards,
          districtRankings,
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

class OptsWidg extends StatelessWidget {
  final String askEnt;
  final String askOpt1;
  final String askOpt2;

  OptsWidg(this.askEnt, this.askOpt1, this.askOpt2);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        askEnt,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, 1);
            },
            child: Text(askOpt1)),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, 2);
          },
          child: Text(askOpt2),
        ),
      ],
    );
  }
}

class Opts2Widg extends StatelessWidget {
  final String askEnt;
  final String askOpt1;
  final String askOpt2;
  final String askOpt3;

  Opts2Widg(this.askEnt, this.askOpt1, this.askOpt2, this.askOpt3);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        askEnt,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, 1);
            },
            child: Text(askOpt1)),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, 2);
          },
          child: Text(askOpt2),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, 3);
          },
          child: Text(askOpt3),
        ),
      ],
    );
  }
}

class TextWidg extends StatelessWidget {
  final String title;
  final String label;
  TextWidg(this.title, this.label);

  @override
  Widget build(BuildContext context) {
    String responseStr;
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
      content: TextField(
        decoration: InputDecoration(labelText: label),
        onChanged: (String newValue) {
          responseStr = newValue;
        },
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, responseStr);
            },
            child: Text("Enter"))
      ],
    );
  }
}

class AlertWidg extends StatelessWidget {
  final String title;
  AlertWidg(this.title);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

