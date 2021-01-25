import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dataSelect.dart';

class ChooseData extends StatefulWidget {
  @override
  _ChooseDataState createState() => _ChooseDataState();
}

class _ChooseDataState extends State<ChooseData> {
  String _userName;
  String _key;
  var _yearDef;

  int _year;
  String _event;
  int _team;

  final controlUsername = TextEditingController();
  final controlKey = TextEditingController();
  final controlYear = TextEditingController();
  final controlYearDef = TextEditingController();

  @override
  void initState()  {
    super.initState();
    _fillKey();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    controlUsername.dispose();
    controlKey.dispose();
    controlYear.dispose();
    controlYearDef.dispose();

    super.dispose();
  }

  Future _fillKey() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString("username");
    if (_userName != null) {
        controlUsername.text = _userName;
    }
    _key = prefs.getString("key");
    if (_key != null) {
        controlKey.text = _key;
    }
    _yearDef = prefs.getString("default_year");
    if (_yearDef != null) {
        controlYearDef.text = _yearDef;
        controlYear.text = _yearDef;
      _year = int.parse(_yearDef);
    }
  }

  bool _checkYear() {
    if (_year == null || _year < 1996) {
      AlertDialog yearInvalid = AlertDialog(
        title: Text(
          "Year is invalid or missing!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        content: Text(
          "Please enter a valid year to search",
          textAlign: TextAlign.center,
        ),
      );
      showDialog(
          context: context, builder: (BuildContext context) => yearInvalid);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    TextField userField = TextField(
      controller: controlUsername,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(labelText: "API Key Username"),
      onChanged: (String newValue) {
        TextSelection previousSelection = controlUsername.selection;
        controlUsername.text = newValue;
        controlUsername.selection = previousSelection;
        _userName = newValue;
      },
    );
    TextField keyField = TextField(
      controller: controlKey,
      textAlign: TextAlign.center,
      decoration: InputDecoration(labelText: "API Key Value"),
      onChanged: (String newValue) {
        TextSelection previousSelection = controlKey.selection;
        controlKey.text = newValue;
        controlKey.selection = previousSelection;
        _key = newValue;
      },
    );
    ElevatedButton saveKey = ElevatedButton(
        onPressed: () async {
          if (_userName != "Enter Username" || _key != "Enter Key") {
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('username', _userName);
            prefs.setString('key', _key);
          }
        },
        child: Text("Save API Key"));
    TextField yearInput = TextField(
      controller: controlYear,
      textAlign: TextAlign.center,
      decoration: InputDecoration(labelText: "Input Year"),
      onChanged: (String newValue) {
        TextSelection previousSelection = controlYear.selection;
        controlYear.text = newValue;
        controlYear.selection = previousSelection;
        setState(() {
          try {
            _year = int.parse(newValue);
          } catch (Exception) {
            _year = null;
          }
        });
      },
    );
    TextField eventInput = TextField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(labelText: "Input Event"),
      onChanged: (String newValue) {
        setState(() {
          if (newValue == null) _event = null;
          else _event = newValue;
        });
      },
    );
    TextField teamInput = TextField(
      decoration: InputDecoration(labelText: "Input Team"),
      textAlign: TextAlign.center,
      onChanged: (String newValue) {
        setState(() {
          try {
            _team = int.parse(newValue);
          } catch (Exception) {
            _team = null;
          }
        });
      },
    );
    RaisedButton goButton = RaisedButton(
      child: Text("Go"),
      onPressed: () {
        if (_checkYear()) return;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChooseOpts(year: _year, event: _event, team: _team)),
        );
      },
    );
    TextField yearDefField = TextField(
      controller: controlYearDef,
      textAlign: TextAlign.center,
      decoration: InputDecoration(labelText: "Default Year"),
      onChanged: (String newValue) {
        TextSelection previousSelection = controlYearDef.selection;
        controlYearDef.text = newValue;
        controlYearDef.selection = previousSelection;
        _yearDef = newValue;
      },
    );
    ElevatedButton saveYear = ElevatedButton(
        onPressed: () async {
          if (_yearDef != "Enter Default Year") {
            try {
              int.parse(_yearDef);
              final prefs = await SharedPreferences.getInstance();
              prefs.setString("default_year", _yearDef);
            } catch (Exception) {}
          }
        },
        child: Text("Save Default Year"));
    Container container = Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          SizedBox(
            width: 20,
          ),
          userField,
          keyField,
          saveKey,
          yearInput,
          eventInput,
          teamInput,
          goButton,
          yearDefField,
          saveYear
        ]));
    AppBar appBar = AppBar(
      title: Text("FRC Datawizard"),
      centerTitle: true,
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}
