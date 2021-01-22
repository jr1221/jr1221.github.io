import 'package:flutter/material.dart';
import 'distCalc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Handy Tools by Jack';

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
      child: Text("Distance Calculator Tool", style: TextStyle(fontSize: 28),),
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) =>  DistCalc()),
        );
      },
    );
    Container container = Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          distCalcPager,
        ]));
    AppBar appBar = AppBar(
      title: Text("Handy Tools by Jack"),
      centerTitle: true,
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;

  }
}
