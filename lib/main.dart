import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:day_night_time_picker/day_night_time_picker.dart';

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
  var sendMap = <String, dynamic>{"from": 10};
  String text = "Set a timer";

  Future<String> _getMessage() async {
    String value;
    try {
      value = await platform.invokeMethod('getMessage', sendMap);
    } catch (e) {
      print(e);
    }
    return value;
  }

  TimeOfDay _time = TimeOfDay.now();
  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
    int t= DateTime.now().millisecondsSinceEpoch;
    print(t);
    print(_time.hour);
    print(_time.minute);
    print(_time.hourOfPeriod);
    print((_time.hour*60*60+_time.minute*60)*1000);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            Text(text),
            MaterialButton(
              color: Colors.black,
              onPressed: () {
              Navigator.of(context).push(
                showPicker(
                  context: context,
                  value: _time,
                  onChange: onTimeChanged,
                ),
              );
            },
            ),
            RaisedButton(
                child: Text("Set for "+_time.toString()),
                onPressed: () {
              _getMessage().then((String message) {
                print(message);
                setState(() {
                  text = message;
                });
              });
            })
          ],
        ),
      ),
    ));
  }
}
