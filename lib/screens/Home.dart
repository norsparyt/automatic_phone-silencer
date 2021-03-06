import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:native_test/models/task_model.dart';
import 'package:native_test/screens/newTask.dart';
import 'package:native_test/widgets/build_swiper.dart';
import 'package:native_test/widgets/drawer_widget.dart';
import 'package:native_test/widgets/new_task_button.dart';
import 'package:provider/provider.dart';

import 'dynamic_home_top.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var prov;
  Color _primColor;
  static const platform = const MethodChannel('com.audio');
  var sentData = [];

  Future<String> _getMessage() async {
    String value;
    try {
      value = await platform.invokeMethod('getMessage', sentData);
    } catch (e) {
      print(e);
    }
    return value;
  }

  void callNative() {
    print("Called native");
    _getMessage().then((String message) {
      print("NATIVE SAYS: $message");
    });
  }

  @override
  void initState() {
    super.initState();
    prov = Provider.of<TaskModel>(context, listen: false);
    if (prov.taskListInitialised == false) prov.initTaskList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Color c = Provider.of<TaskModel>(context, listen: true).homeColor;
    setState(() {
      _primColor = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
//      statusBarColor: Theme.of(context).primaryColorLight,
    ));
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: DrawerWidget(),
          body: SafeArea(
              child: Consumer<TaskModel>(
            builder: (BuildContext context, value, Widget child) {
              return AnimatedContainer(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: value.colors,
                        stops: [
                          0.3,
                          0.9,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                  ),
                  duration: Duration(milliseconds: 500),
                  child: child);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: Container(child: DynamicHomeTop(_primColor)),
                ),
                Expanded(
                    flex: 8,
                    child: Container(
//                        height: deviceHeight * 0.47,
                      child: BuildSwiper(),
                    )), //Cards
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, _createRouteToAdd());
                      },
                      child: Hero(
                        transitionOnUserGestures: true,
                        tag: 'addButton',
                        child: NewTaskButton(),
                      ),
                    ),
                  ),
                ), //add button
              ],
            ),
          ))),
    );
  }

  Future<bool> _onBackPressed() {
    List tempAllTasks =
        Provider.of<TaskModel>(context, listen: false).allTaskList;
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              tempAllTasks.length == 0 ? 'Exit' : 'Save Tasks and Exit?',
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 25),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Text(
              tempAllTasks.length == 0
                  ? '⦿ No tasks to be scheduled'
                  : '⦿ ${tempAllTasks.length} tasks to be scheduled',
              style: Theme.of(context).textTheme.display2.copyWith(),
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "CANCEL",
                  style:
                      Theme.of(context).textTheme.button.copyWith(fontSize: 15),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  if (tempAllTasks.length != 0) {
                    sentData = tempAllTasks;
                  }
                  callNative();
                  SystemNavigator.pop();
                },
                child: Text(
                  tempAllTasks.length == 0 ? 'EXIT' : 'SET AND EXIT',
                  style:
                      Theme.of(context).textTheme.button.copyWith(fontSize: 15),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Route _createRouteToAdd() {
    return PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => NewTask(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: Offset(0.0, -1.0), end: Offset.zero);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
          );
          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
//    return PageRouteBuilder(
//        transitionDuration: Duration(seconds: 1),
//        pageBuilder: (_, __, ___) => NewTask());
// PageRouteBuilder(
//  pageBuilder: (context,animation,secondaryAnimation)=>NewTask(),
//  transitionsBuilder: (context,animation,secondaryAnimation,child){
//    var tween = Tween(begin: 0.0, end: 1.0);
//    var opacityAnimation = animation.drive(tween);
//    return FadeTransition(
//    opacity: opacityAnimation,
//    child: child,
//  );}
//);
  }
}
