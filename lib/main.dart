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
import 'package:native_test/models/task_model.dart';
import 'package:provider/provider.dart';
import 'data/theme_data.dart';
import 'screens/Home.dart';

void main() {
  AppTheme appTheme = AppTheme();
  runApp(
      ChangeNotifierProvider(
        create: (BuildContext context) => TaskModel(),
        child: MaterialApp(
          theme: appTheme.themeData,
          title: "Psa",
          builder: (context,child){
            return ScrollConfiguration(behavior: MyBehavior(), child: child);
          },
          home: Home(),
          locale: Locale('en', 'US'),
          supportedLocales: [
            const Locale('en', 'US'), // English
          ],
          debugShowCheckedModeBanner: false,
        ),
      ));
  // ToDo:
//  when db has two tasks of the same name, all get removed at once
//on hitting back button at home screen app should close
//view all tasks?
//clear all tasks
//change time picker to avoid validation for before time case
}
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}