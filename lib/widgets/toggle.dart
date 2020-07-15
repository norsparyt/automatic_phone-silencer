import 'package:flutter/material.dart';
import '../data.dart';

class Toggle extends StatefulWidget {
  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  bool alarmSwitch,mediaSwitch,vibrationSwitch ;
  _ToggleState(){
    alarmSwitch=false;
    mediaSwitch=false;
    vibrationSwitch=false;
    toggles="FFF";
  }
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
                  activeTrackColor: dynamicTypeColor==darkColor?Colors.blue.shade700:dynamicTypeColor,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: secColor,
                  value: alarmSwitch,
                  onChanged: (v) {
                    setState(() {
                      alarmSwitch = v;
                      alarmSwitch==true?changeToggle(0,"T"):changeToggle(0,"F");
                      print("Alarm Switch:$alarmSwitch");
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
                  activeTrackColor: dynamicTypeColor==darkColor?Colors.blue.shade700:dynamicTypeColor,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: secColor,
                  value: vibrationSwitch,
                  onChanged: (v) {
                    setState(() {
                      vibrationSwitch = v;
                      vibrationSwitch==true?changeToggle(1,"T"):changeToggle(1,"F");
                      print("Vibration Switch:$vibrationSwitch");
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
                  activeTrackColor: dynamicTypeColor==darkColor?Colors.blue.shade700:dynamicTypeColor,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: secColor,
                  value: mediaSwitch,
                  onChanged: (v) {
                    setState(() {
                      mediaSwitch = v;
                      mediaSwitch==true?changeToggle(2,"T"):changeToggle(2,"F");
                      print("Media Switch:$mediaSwitch");
                    });
                  })
            ],
          ),
        ), //MEDIA TOGGLE
      ],
    );
  }
void changeToggle(int index,String char){
toggles=toggles.substring(0,index)+char+toggles.substring(index+1);
print(toggles);
}
}
