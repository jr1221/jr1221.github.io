import 'package:flutter/material.dart';
import 'statusGet.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChooseData extends StatefulWidget {
  @override
  _ChooseDataState createState() => _ChooseDataState();

}

class _ChooseDataState extends State<ChooseData> {
  String _userName;
  String _key;
  void _fillKey () async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString("username") ?? "Enter Username";
    _key = prefs.getString("key") ?? "Enter Key";
  }
  @override
  Widget build(BuildContext context) {
    _fillKey();
    TextField userField = TextField(
      decoration: InputDecoration(labelText: _userName),
      onChanged: (String newValue) {
        _userName = newValue;
      },
    );
    TextField keyField = TextField(
      decoration: InputDecoration(labelText: _key),
      onChanged: (String newValue) {
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
        child: Text("Save")
    );
    FlatButton testB = FlatButton(
      child: Text('Alliances'),
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) =>  StatusWidg()),
        );
      },
    );
    Container container = Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          SizedBox(width: 20,),
          userField,
          keyField,
          saveKey,
          testB,
        ]));
    AppBar appBar = AppBar(
      title: Text("FRC Data wizard"),
      centerTitle: true,
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}

