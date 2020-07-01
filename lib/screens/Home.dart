import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:native_test/widgets/task.dart';
import 'package:native_test/screens/newTask.dart';
import '../data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset:false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey.shade600),
          elevation: 0,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.calendar_today,
                  size: 20,
                ),
                onPressed: null)
          ],
          backgroundColor: primColor,
        ),
        drawer: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                color: primColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                tab("Profile", Icon(Icons.person)),
                Divider(
                  color: Colors.grey.shade800,
                ),
                tab("Settings", Icon(Icons.settings)),
                Divider(
                  color: Colors.grey.shade800,
                ),
                tab("About", Icon(Icons.info))
              ],
            ),
            height: deviceHeight,
            width: deviceWidth * 0.15,
          ),
        ),
        body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
               Expanded(
                 flex:3,
                 child: Container(
                   margin: EdgeInsets.only(right:deviceWidth*0.11,left: deviceWidth*0.07,top:deviceWidth*0.02 ),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        " Morning \n Dave",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2),
                      ),
                      CircleAvatar(
                        backgroundImage:
                            Image.asset("lib/images/Chris-user-profile.jpg").image,
                        radius: 35,
                      )
                    ],
              ),
                 ),
               ), //Time+Name
               Expanded(
                 flex:3,
                 child: Container(
                   margin: EdgeInsets.only(left: deviceWidth*0.1,top:deviceWidth*0.04 ),
                   child: Text(
                    "Looks pretty packed.\nYou have 3 tasks scheduled for today.",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: secColor),
              ),
                 ),
               ), //details
            Expanded(
              flex:1,
              child: Container(
                margin: EdgeInsets.only(left: deviceWidth*0.1),
                child: Text(
                  getDateFormat(DateTime.now()).toUpperCase(),
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ), //today
            Expanded(
              flex: 8,
              child: Container(
                height: deviceHeight * 0.47,
                child: Swiper(
                  onTap: (int index){},
                  loop: false,
                  itemCount: 3,
                  controller: SwiperController(),
                  viewportFraction: 0.8,
                  itemBuilder: (BuildContext context, int index) {
                    return Task();
                  },
                ),
              ),
            ), //Cards
            Expanded(
              flex: 2,
              child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,_createRoute());
                      },
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: 'addButton',
                      child: Container(
                        margin: EdgeInsets.only(bottom:5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(deviceWidth),
                          gradient: LinearGradient(colors: [Colors.blue.shade900,Colors.blue.shade400,],stops: [0.1,0.8],begin: Alignment.bottomLeft,end: Alignment.topRight),
                            boxShadow: [BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                          ),
                        ], color: secColor,),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.add,
                            color: primColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ),//add button
          ],
        )));
  }

//context,PageRouteBuilder(transitionDuration:Duration(seconds: 1),pageBuilder:(_,__,___) =>newTask())
  Widget tab(String name, Icon icon) {
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
        IconButton(icon: icon, onPressed: null),
      ],
    );
  }

  Route _createRoute(){
return PageRouteBuilder(transitionDuration:Duration(seconds: 1),pageBuilder:(_,__,___) =>NewTask());
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
