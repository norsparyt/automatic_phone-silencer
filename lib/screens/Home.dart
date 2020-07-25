import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:native_test/data/get_date_formatted.dart';
import 'package:native_test/models/task_model.dart';
import 'package:native_test/widgets/build_swiper.dart';
import 'package:native_test/widgets/drawer_widget.dart';
import 'package:native_test/widgets/new_task_button.dart';
import 'package:native_test/screens/newTask.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var prov;
  Color _primColor;
  String _greeting;
bool change=false;
  @override
  void initState() {
    super.initState();
    prov = Provider.of<TaskModel>(context, listen: false);
    if (prov.taskListInitialised == false) prov.initTaskList();
    setGreeting();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Color c=Provider.of<TaskModel>(context,listen: true).homeColor;
    setState(() {
      _primColor=c;
    });
//    print("called");
  }

  @override
  Widget build(BuildContext context) {
//    ThemeData theme = Theme.of(context);
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: DrawerWidget(),
        body: Builder(builder: (BuildContext context) {

          return SafeArea(
            child: Consumer<TaskModel>(
              builder: (BuildContext context, value, Widget child) {
                return AnimatedContainer(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: value.colors, stops: [
                      0.3,
                      0.9,
                    ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                  ),
                  duration: Duration(milliseconds: 500),
                  child: child
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.menu,
                                color:_primColor
                                ,
                              ),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              }),
                          IconButton(
                              icon: Icon(Icons.calendar_today,
                                  color: _primColor
                              ),
                              onPressed: null),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.only(
                          right: deviceWidth * 0.11,
                          left: deviceWidth * 0.1,
                          top: deviceWidth * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              " $_greeting\n Dave",
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                  color: _primColor
                                  ,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2),
                            ),
                          ),
                          CircleAvatar(
                            backgroundImage:
                            Image.asset("lib/images/Chris-user-profile.jpg")
                                .image,
                            radius: 35,
                          )
                        ],
                      ),
                    ),
                  ), //Time+Name
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          left: deviceWidth * 0.13, top: 0.0),
                      child: Text(Provider.of<TaskModel>(context,listen: true).introLine,
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 17,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                            color: _primColor
                        ),
                      ),
                    ),
                  ), //details
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: deviceWidth * 0.14),
                      child: Text(
                        GetDateFormatted()
                            .getDateFormat(DateTime.now())
                            .toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                            fontFamily: 'Quicksand',
                            color:  _primColor,
                            fontSize: 15),
                      ),
                    ),
                  ), //today
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
                          Navigator.push(context, _createRoute());
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
            )
          );
        }));
//    )
  }
void setGreeting()
{
  int now= DateTime.now().hour;
  print(now);
  if(now>=0&&now<=3)
    _greeting="Night";
  else if(now<12)
    _greeting="Morning";
  else if(now<=16)
    _greeting="Afternoon";
  else if(now<=20)
    _greeting="Evening";
  else if(now<=24)
    _greeting="Night";
}
  Route _createRoute() {
    return PageRouteBuilder(
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (_, __, ___) => NewTask());
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
