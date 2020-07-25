import 'package:flutter/material.dart';
import 'package:native_test/models/task_model.dart';
import 'package:provider/provider.dart';

class tab extends StatelessWidget {
  String name;
  Icon icon;

  tab(String s, Icon icon) {
    name = s;
    this.icon = icon;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RotatedBox(
          quarterTurns: 1,
          child: Text(
            name,
            style: TextStyle(letterSpacing: 2),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(13),
        ),
        IconButton(
            icon: icon,
            color: Provider.of<TaskModel>(context).taskList.length == 0
                ? Colors.teal
                : Provider.of<TaskModel>(context).colors[0],
            onPressed: () {}),
      ],
    );
  }
}
