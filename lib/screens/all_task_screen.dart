import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_test/data/get_date_formatted.dart';
import 'package:native_test/data/get_dynamic_icon.dart';
import 'package:native_test/models/task_model.dart';
import 'package:provider/provider.dart';

import 'Home.dart';

class AllTasksScreen extends StatefulWidget {
  @override
  _AllTasksScreenState createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  List allTask = [];
  IconData fabIcon = Icons.clear_all;
  List<Color> colors = [
    Colors.teal,
    Colors.pinkAccent,
    Colors.lightBlue,
    Colors.amber,
    Colors.deepPurple
  ];

  @override
  void initState() {
    super.initState();
    allTask = Provider
        .of<TaskModel>(context, listen: false)
        .allTaskList;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme
                  .of(context)
                  .primaryColorDark,
            ),
            onPressed: (){goBackHome();},),
        backgroundColor: Theme
            .of(context)
            .primaryColorLight,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "All Tasks",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline
                        .copyWith(color: Theme
                        .of(context)
                        .primaryColorDark),
                  )),
              SizedBox(
                height: 30.0,
              ),
              Expanded(
                child: allTask.isEmpty?
                Center(child: Text('NO TASKS PRESENT',style: Theme.of(context).textTheme.display2.copyWith(color: Colors.teal),)):ListView.builder(
                  itemCount: allTask.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                            color: Colors.grey.shade500,
                          ),
                        ],
                        color: Colors
                            .primaries[
                        Random().nextInt(Colors.primaries.length)]
                            .shade600,
                      ),
                      height: height * 0.17,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: height * 0.17,
                            width: width * 0.15,
                            color: Colors.grey.shade100.withOpacity(0.3),
                            child: GetDynamicIcon().getIcon(
                                allTask[index]['category'],
                                Theme
                                    .of(context)
                                    .primaryColorLight,
                                30),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  allTask[index]['title'],
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                      color: Theme
                                          .of(context)
                                          .primaryColorLight),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  GetDateFormatted().getDateFormat(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          allTask[index]['date'])),
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .display2
                                      .copyWith(
                                      color: Theme
                                          .of(context)
                                          .primaryColorLight),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          'FROM : ${DateTime
                                              .fromMillisecondsSinceEpoch(
                                              allTask[index]['startTime'])
                                              .hour}:${DateTime
                                              .fromMillisecondsSinceEpoch(
                                              allTask[index]['startTime'])
                                              .minute}',
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .display2
                                              .copyWith(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColorLight,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          'TO      : ${DateTime
                                              .fromMillisecondsSinceEpoch(
                                              allTask[index]['endTime'])
                                              .hour}:${DateTime
                                              .fromMillisecondsSinceEpoch(
                                              allTask[index]['endTime'])
                                              .minute}',
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .display2
                                              .copyWith(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColorLight,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: width * 0.25,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          'ALARMS   ${allTask[index]['toggle'][0] ==
                                              'T' ? "✔" : "✘"}',
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .display2
                                              .copyWith(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColorLight,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Text(
                                          'MEDIA    ${allTask[index]['toggle'][2] ==
                                              'T' ? "✔" : "✘"}',
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .display2
                                              .copyWith(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColorLight,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          clearAll();
        },
        backgroundColor: Theme
            .of(context)
            .primaryColorLight,
        child: Icon(fabIcon, color: Colors.teal,),
        elevation: 20.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void clearAll() {
    print("pressed");
    setState(() {
      Provider.of<TaskModel>(context, listen: false).deleteAll();
      fabIcon = Icons.done;
      allTask.clear();
    });
  }
  void goBackHome(){
    Navigator.of(context).pop();
    Provider.of<TaskModel>(context,listen: false).reInitialise();
    Navigator.push(context, PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => Home(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: Offset(1.0, 0.0), end: Offset.zero);
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
}
