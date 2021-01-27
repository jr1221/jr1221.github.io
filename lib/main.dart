import 'package:flutter/material.dart';
import 'distCalc.dart';
import 'dataWizard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Handy Tools by Jack';
  static String base = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Page1(),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RaisedButton distCalcPager = RaisedButton(
      child: Text(
        "Distance Calculator Tool",
        style: TextStyle(fontSize: 28),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DistCalc()),
        );
      },
    );
    Visibility visFRC = Visibility(
  //    visible: !kIsWeb,
      child: RaisedButton(
        child: Text(
          "FRC Datawizard",
          style: TextStyle(fontSize: 28),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChooseData()),
          );
        },
      ),
    );
    Container container = Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          SizedBox(
            height: 20,
          ),
          distCalcPager,
          SizedBox(
            height: 40,
          ),
          visFRC,
        ]));
    AppBar appBar = AppBar(
      title: Text("Handy Tools by Jack"),
      centerTitle: true,
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}
