import 'package:flutter/material.dart';
import '../data.dart';

class Toggle extends StatefulWidget {
  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  bool alarmSwitchState = false;
  bool mediaSwitchState = false;
  bool vibrationSwitchState = false;
  @override
  Widget build(BuildContext context) {
    TextStyle sty = TextStyle(
        fontSize: 14,
        color: darkColor,
        letterSpacing: 2,
        fontWeight: FontWeight.w400,
        wordSpacing: 2);
    return Column(
      children: <Widget>[
        Expanded(
          flex: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Allow Alarms",
                style: sty,
              ),
              Switch(
                  activeColor: Colors.white,
                  activeThumbImage: AssetImage('lib/images/alarm-on.png'),
                  inactiveThumbImage: AssetImage('lib/images/alarm-off.png'),
                  activeTrackColor: dynamicTypeColor,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: secColor,
                  value: alarmSwitchState,
                  onChanged: (v) {
                    setState(() {
                      alarmSwitchState = v;
                      print("Alarm Switch:$alarmSwitchState");
                    });
                  })
            ],
          ),
        ), //ALARM TOGGLE
        Expanded(
          flex: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Vibration Enabled", style: sty),
              Switch(
                  activeColor: Colors.white,
                  activeThumbImage: AssetImage('lib/images/vibrate-on.png'),
                  inactiveThumbImage: AssetImage('lib/images/vibrate-off.png'),
                  activeTrackColor: dynamicTypeColor,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: secColor,
                  value: vibrationSwitchState,
                  onChanged: (v) {
                    setState(() {
                      vibrationSwitchState = v;
                      print("Vibration Switch:$vibrationSwitchState");
                    });
                  })
            ],
          ),
        ), //VIBRATION TOGGLE
        Expanded(
          flex: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Allow Other Media", style: sty),
              Switch(
                  activeColor: Colors.white,
                  activeThumbImage: AssetImage('lib/images/media-on.png'),
                  inactiveThumbImage: AssetImage('lib/images/media-off.png'),
                  activeTrackColor: dynamicTypeColor,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: secColor,
                  value: mediaSwitchState,
                  onChanged: (v) {
                    setState(() {
                      mediaSwitchState = v;
                      print("Media Switch:$mediaSwitchState");
                    });
                  })
            ],
          ),
        ), //MEDIA TOGGLE
      ],
    );
  }
}
