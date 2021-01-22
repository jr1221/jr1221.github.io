import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' as math;
import 'package:photo_view/photo_view.dart';

class DistCalc extends StatefulWidget {
  @override
  _DistCalcState createState() => _DistCalcState();
}

class _DistCalcState extends State<DistCalc> {
  var _enableList = [false, true, true, true, true];
  final List<String> _nameInfo = [
    'Distance from target       (d)',
    'Height of limelight        (h1)',
    'Height of target           (h2)',
    'Limelight angle from level (a1)',
    'Limelight (y angle)        (a2)',
  ];
  String _dropVal = 'Distance from target       (d)';

  double d = -1.76;

  double h1 = -1.76;

  double h2 = -1.76;

  double a1 = -1.76;

  double a2 = -1.76;

  List _histResults = [];
  void _dropDownState(String newValue) {
    _enableList = [true, true, true, true, true];
    _enableList[_nameInfo.indexOf(newValue)] = false;
  }

  void _calcDo() {
    int whatMode = _enableList.indexOf(false);
    double ansDouble = 0.0;
    bool notAll = false;
    switch (whatMode) {
      case 0:
        if ((h2 == -1.76) || (h1 == -1.76) || (a2 == -1.76) || (a1 == -1.76)) {
          notAll = true;
        } else
          ansDouble = ((h2 - h1) / tan(math.radians(a1 + a2)));
        break;
      case 1:
        if ((d == -1.76) || (h2 == -1.76) || (a2 == -1.76) || (a1 == -1.76)) {
          notAll = true;
        } else
          ansDouble = (-1 * d * (tan(math.radians(a1 + a2))) + h2);
        break;
      case 2:
        if ((h1 == -1.76) || (d == -1.76) || (a2 == -1.76) || (a1 == -1.76)) {
          notAll = true;
        } else
          ansDouble = (h1 + d * tan(math.radians(a1 + a2)));
        break;
      case 3:
        if ((h2 == -1.76) || (h1 == -1.76) || (a2 == -1.76) || (d == -1.76)) {
          notAll = true;
          print(d);
        } else
          ansDouble = (math.degrees(atan((h2 - h1) / d))) - a2;
        break;
      case 4:
        if ((h2 == -1.76) || (h1 == -1.76) || (d == -1.76) || (a1 == -1.76)) {
          notAll = true;
        } else
          ansDouble = (math.degrees(atan((h2 - h1) / d)) - a1);
        break;
    }

    String ansStr;
    if (notAll)
      ansStr = "All fields that are not greyed out are required!";
    else {
      ansStr = "The answer is: $ansDouble";
      _histResults.add(whatMode);
      _histResults.add(ansDouble);
    }
    AlertDialog ans = AlertDialog(
      content: Text(ansStr),
    );
    showDialog(context: context, builder: (BuildContext context) => ans);
  }

  void _showHistory() {
    String historyGetter = "";
    for (var a in _histResults) {
      if (a is int) {
        switch (a) {
          case 0:
            historyGetter += '\nDistance: ';
            break;
          case 1:
            historyGetter += '\nHeight of limelight: ';
            break;
          case 2:
            historyGetter += '\nHeight of target: ';
            break;
          case 3:
            historyGetter += '\nLimelight angle from level: ';
            break;
          case 4:
            historyGetter += '\nLimelight y angle: ';
            break;
        }
      } else if (a is double) historyGetter += a.toStringAsFixed(3);
    }
    String histTitle = "Previous results below;";
    if (historyGetter == "") {
      histTitle = "";
      historyGetter = "No earlier calculations";
    }

    AlertDialog hist = AlertDialog(
      title: Text(
        histTitle,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
      content: Text(
        historyGetter,
        textAlign: TextAlign.center,
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => hist);
  }

  @override
  Widget build(BuildContext context) {
    TextField dist = TextField(
        enabled: _enableList[0],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: _nameInfo[0],
        ),
        onChanged: (String value) {
          d = double.tryParse(value);
          if (d == null) {
            d = -1.76;
          }
        });
    TextField height1 = TextField(
        enabled: _enableList[1],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: _nameInfo[1]),
        onChanged: (String value) {
          h1 = double.tryParse(value);
          if (h1 == null) {
            h1 = -1.76;
          }
        });
    TextField height2 = TextField(
        enabled: _enableList[2],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: _nameInfo[2]),
        onChanged: (String value) {
          h2 = double.tryParse(value);
          if (h2 == null) {
            h2 = -1.76;
          }
        });
    TextField angle1 = TextField(
        enabled: _enableList[3],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: _nameInfo[3]),
        onChanged: (String value) {
          a1 = double.tryParse(value);
          if (a1 == null) {
            a1 = -1.76;
          }
        });
    TextField angle2 = TextField(
        enabled: _enableList[4],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: _nameInfo[4]),
        onChanged: (String value) {
          a2 = double.tryParse(value);
          if (a2 == null) {
            a2 = -1.76;
          }
        });
    DropdownButton chooseAns = DropdownButton<String>(
      value: _dropVal,
      icon: Icon(Icons.arrow_downward),
      iconSize: 28,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          _dropVal = newValue;
          _dropDownState(newValue);
        });
      },
      items: _nameInfo.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 22),
          ),
        );
      }).toList(),
    );
    RaisedButton calcButton = RaisedButton(
        child: Text(
          "Calculate",
          style: TextStyle(fontSize: 26),
        ),
        onPressed: () {
          _calcDo();
        });
    FlatButton imgShow = FlatButton(
      child: Text(
        "Show Diagram",
        style: TextStyle(fontSize: 22),
      ),
      onPressed: () async {
        await showDialog(context: context, builder: (_) => ViewImg());
      },
    );
    FlatButton historyButton = FlatButton(
      child: Text("Previous Results", style: TextStyle(fontSize: 20)),
      onPressed: () {
        _showHistory();
      },
    );
    Container container = Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: <Widget>[
          dist,
          height1,
          height2,
          angle1,
          angle2,
          SizedBox(
            height: 30,
          ),
          chooseAns,
          calcButton,
          SizedBox(
            height: 30,
          ),
          imgShow,
          SizedBox(
            height: 50,
          ),
          historyButton,
        ]));
    AppBar appBar = AppBar(
      title: Text("Distance Calculator for FIRST"),
    );
    Scaffold scaffold = Scaffold(appBar: appBar, body: container);
    return scaffold;
  }
}

class ViewImg extends StatefulWidget {
  @override
  _ViewImgState createState() => _ViewImgState();
}

class _ViewImgState extends State<ViewImg> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: AssetImage("assets/DistanceEstimation.jpg"),
        minScale: 0.9,
        maxScale: 1.7,
      ),
    );
  }
}
