import 'package:flutter/material.dart';
import 'package:native_test/models/task_model.dart';
import 'package:provider/provider.dart';

class Toggle extends StatefulWidget {
  String category;

  Toggle(this.category);

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  String toggles;
  bool alarmSwitch, mediaSwitch, vibrationSwitch;

  var prov;

  @override
  void initState() {
    super.initState();
    alarmSwitch = false;
    mediaSwitch = false;
    vibrationSwitch = false;
    prov = Provider.of<TaskModel>(context, listen: false);
    toggles = prov.toggles;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle sty = Theme.of(context).textTheme.display1.copyWith(
        fontSize: 14,
        color: Theme.of(context).primaryColorDark,
        letterSpacing: 2,
        fontWeight: FontWeight.w500,
        wordSpacing: 2);
    return Column(
      children: <Widget>[
        Container(
          height: 40,
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
                  activeTrackColor: widget.category == null ? Colors.lightBlue
                      .shade500 : Provider
                      .of<TaskModel>(context, listen: true)
                      .colors[0],
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Theme
                      .of(context)
                      .primaryColorDark,
                  value: alarmSwitch,
                  onChanged: (v) {
                    setState(() {
                      alarmSwitch = v;
                      alarmSwitch == true ? changeToggle(0, "T") : changeToggle(
                          0, "F");
                      print("Alarm Switch:$alarmSwitch");
                    });
                  })
            ],
          ),
        ), //ALARM TOGGLE

        Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Vibration Enabled", style: sty),
              Switch(
                  activeColor: Colors.white,
                  activeThumbImage: AssetImage('lib/images/vibrate-on.png'),
                  inactiveThumbImage: AssetImage('lib/images/vibrate-off.png'),
                  activeTrackColor: widget.category == null ? Colors.lightBlue
                      .shade500 : Provider
                      .of<TaskModel>(context, listen: true)
                      .colors[0],
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Theme
                      .of(context)
                      .primaryColorDark,
                  value: vibrationSwitch,
                  onChanged: (v) {
                    setState(() {
                      vibrationSwitch = v;
                      vibrationSwitch == true
                          ? changeToggle(1, "T")
                          : changeToggle(1, "F");
                      print("Vibration Switch:$vibrationSwitch");
                    });
                  })
            ],
          ),
        ), //VIBRATION TOGGLE

        Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Allow Other Media", style: sty),
              Switch(
                  activeColor: Colors.white,
                  activeThumbImage: AssetImage('lib/images/media-on.png'),
                  inactiveThumbImage: AssetImage('lib/images/media-off.png'),
                  activeTrackColor: widget.category == null ? Colors.lightBlue
                      .shade500 : Provider
                      .of<TaskModel>(context, listen: true)
                      .colors[0],
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Theme
                      .of(context)
                      .primaryColorDark,
                  value: mediaSwitch,
                  onChanged: (v) {
                    setState(() {
                      mediaSwitch = v;
                      mediaSwitch == true ? changeToggle(2, "T") : changeToggle(
                          2, "F");
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
  toggles = toggles.substring(0, index) + char + toggles.substring(index + 1);
  prov.setToggle(toggles);
}
}
