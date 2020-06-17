import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

void main() {
  runApp(new MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const platform = const MethodChannel('com.audio');
  static int triggerTime;
  var sendMap = <String, dynamic>{"from": "10"};
  String txt = "Set a timer";

  Future<String> _getMessage() async {
    String value;
    try {
      value = await platform.invokeMethod('getMessage', sendMap);
    } catch (e) {
      print(e);
    }
    return value;
  }

  int flag = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            Text("set alarm for"),
            TimePickerSpinner(
              is24HourMode: false,
              onTimeChange: (time) {
                print(time);
                print(time.millisecondsSinceEpoch);
                triggerTime = time.millisecondsSinceEpoch;
                sendMap.update("from", (value)=>triggerTime.toString());
                setState(() {
                  flag = 1;
                });
              },
            ),
            RaisedButton(
                child: flag == 1 ? Text("Schedule Task") : Text("Enter time"),
                onPressed: flag == 1 ? () => callNative() : null
            )
          ],
        ),
      ),
    ));
  }

  void callNative() {
    _getMessage().then((String message) {
      print(message);
      setState(() {
        txt = message;
      });
    });
  }
}
