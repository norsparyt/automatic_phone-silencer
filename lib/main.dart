//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'dart:async';
//import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
//
//void main() {
//  runApp(new MaterialApp(
//    home: Home(),
//  ));
//}
//
//class Home extends StatefulWidget {
//  @override
//  _HomeState createState() => _HomeState();
//}
//
//class _HomeState extends State<Home> {
//  static const platform = const MethodChannel('com.audio');
//  static int triggerTime;
//  var sendMap = <String, dynamic>{"from": "10", "to": "20"};
//  String txt = "Set a timer";
//
//  Future<String> _getMessage() async {
//    String value;
//    try {
//      value = await platform.invokeMethod('getMessage', sendMap);
//    } catch (e) {
//      print(e);
//    }
//    return value;
//  }
//
//  int flag = 0;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        body: SafeArea(
//      child: Center(
//        child: Column(
//          children: <Widget>[
//            Text("set alarm for"),
//            TimePickerSpinner(
//              is24HourMode: false,
//              onTimeChange: (time) {
//                print(time);
//                print(time.millisecondsSinceEpoch);
//                triggerTime = time.millisecondsSinceEpoch;
//              },
//            ),
//            RaisedButton(
//                child: Text("Schedule Task"),
//                onPressed: () {
//                  if (flag == 0) {
//                    sendMap.update("from", (value) => triggerTime.toString());
//                    print("from: value updated");
//                  } else if (flag == 1) {
//                    sendMap.update("to", (value) => triggerTime.toString());
//                    print("to: value updated");
//                    callNative();
//                  }
//                  flag = 1;
//                })
//          ],
//        ),
//      ),
//    ));
//  }
//
//  void callNative() {
//    print("Called native");
//    _getMessage().then((String message) {
//      print(message);
//      setState(() {
//        txt = message;
//      });
//    });
//  }
//}
import 'package:flutter/material.dart';
import 'screens/Home.dart';

void main() {
  runApp(new MaterialApp(
    theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          alignLabelWithHint: true,
          labelStyle: TextStyle(color: Colors.grey.shade300,fontSize: 12.0,fontWeight: FontWeight.w300),
          hintStyle: TextStyle(color: Colors.grey.shade400,fontSize: 10.0),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        )
    ),
    title: "Psa",
    home: Home(),
    locale: Locale('en', 'US'),
    supportedLocales: [
      const Locale('en', 'US'), // English
    ],
    debugShowCheckedModeBanner: false,
  ));
}
