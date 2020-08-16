import 'package:flutter/material.dart';
import 'package:native_test/models/task_model.dart';
import 'package:native_test/screens/all_task_screen.dart';
import 'package:native_test/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class tab extends StatefulWidget {
  String name;
  IconData icon;

  tab(String s, IconData icon) {
    name = s;
    this.icon = icon;
  }

  @override
  _tabState createState() => _tabState();
}

class _tabState extends State<tab> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        onPressed: (){
          switch(widget.name)
          {
            case 'All Tasks':goToAllTasksPage();break;
            case 'Settings': goToSettingsPage();break;
            case 'About': goToAboutPage();break;
          }
        },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RotatedBox(
                quarterTurns: 1,
                child: Text(widget.name,
                  style: Theme.of(context).textTheme.button.copyWith(letterSpacing: 2,fontSize: 17.0),
                ),
              ),
              Icon(widget.icon,color: Provider.of<TaskModel>(context).currentList.length == 0
                  ? Colors.teal
                  : Provider.of<TaskModel>(context).colors[0],
          ),
            ],
          ),
      ),
    );
  }
  void goToSettingsPage(){
    Navigator.push(context, PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => Settings(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: Offset(-1.0, 0.0), end: Offset.zero);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
          );
          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        }));
  }
  void goToAllTasksPage(){
    Navigator.push(context, PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => AllTasksScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: Offset(-1.0, 0.0), end: Offset.zero);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
          );
          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        }));
  }
  void goToAboutPage() {}
}
