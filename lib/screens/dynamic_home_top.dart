import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_test/data/get_date_formatted.dart';
import 'package:native_test/models/task_model.dart';
import 'package:native_test/widgets/calendar_text.dart';
import 'package:native_test/widgets/calendar_widget.dart';
import 'package:provider/provider.dart';

class DynamicHomeTop extends StatefulWidget {
  Color primColor;

  DynamicHomeTop(Color primColor) {
    this.primColor = primColor;
  }

  @override
  _DynamicHomeTopState createState() => _DynamicHomeTopState();
}

class _DynamicHomeTopState extends State<DynamicHomeTop> {
  String _greeting;
  bool calenderMode;

  double opacity1, opacity2;

  @override
  void initState() {
    super.initState();
    setGreeting();
    setCalenderMode();
    opacity1 = 1.0;
    opacity2 = 0.0;
  }

  void setCalenderMode() {
    setState(() {
      if (Provider.of<TaskModel>(context, listen: false).initialDateField.day ==
          DateTime.now().day)
        calenderMode = false;
      else
        calenderMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      calenderMode ? Icons.arrow_back_ios : Icons.menu,
                      color: widget.primColor,
                    ),
                    onPressed: () {
                      if (calenderMode == true) {
                        Provider.of<TaskModel>(context, listen: false)
                            .setCurrentListFromAllTaskList(DateTime.now());
                        setState(() {
                          calenderMode = false;
                          opacity2 = 0.0;
                        });
                        Timer(Duration(milliseconds: 200), () {
                          setState(() {
                            opacity1 = 1.0;
                          });
                        });
                      } else
                        Scaffold.of(context).openDrawer();
                    }),
                IconButton(
                    icon: Icon(Icons.calendar_today,
                        color: widget.primColor.withOpacity(opacity1)),
                    onPressed: () {
                      setState(() {
                        calenderMode = true;
                        opacity1 = 0.0;
                        Timer(Duration(milliseconds: 200), () {
                          setState(() {
                            opacity2 = 1.0;
                          });
                        });
                      });
                    }),
              ],
            ),
          ),
        ),
        //AppBar
        Container(
//          alignment: Alignment.bottomLeft,
          color: Colors.transparent,
          margin: EdgeInsets.only(
              right: deviceWidth * 0.11,
              left: deviceWidth * 0.1,
              top: deviceWidth * 0.2),
          child: calenderMode
              ? CalendarText(widget.primColor)
              : greetText(),
        ),
        //Time+Name
        AnimatedAlign(
          curve: Curves.easeIn,
          alignment: calenderMode ? Alignment.topRight : Alignment(0.8, -0.35),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: CircleAvatar(
              backgroundImage:
                  Image.asset("lib/images/Chris-user-profile.jpg").image,
              radius: calenderMode ? 20 : 35,
            ),
          ),
          duration: Duration(milliseconds: 500),
        ),
        //ProfilePic
        Container(
          alignment: Alignment(0, 0.4),
          margin: EdgeInsets.only(
            left: deviceWidth * 0.13,
          ),
          child:
              calenderMode ? CalendarWidget(widget.primColor) : getInfoWidget(),
        ),
        //details
        Container(
          alignment: Alignment.bottomLeft,
          margin: EdgeInsets.only(left: deviceWidth * 0.14, bottom: 20.0),
          child: Text(
            GetDateFormatted()
                .getDateFormat(Provider.of<TaskModel>(context).initialDateField)
                .toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Quicksand',
                color: widget.primColor,
                fontSize: 15),
          ),
        ), //today
      ],
    );
  }

  void setGreeting() {
    int now = DateTime.now().hour;
    print(now);
    if (now >= 0 && now <= 3)
      _greeting = "Hello";
    else if (now < 12)
      _greeting = "Morning";
    else if (now <= 16)
      _greeting = "Afternoon";
    else if (now < 20)
      _greeting = "Evening";
    else if (now <= 24) _greeting = "Hello";
  }

  Widget getInfoWidget() {
    return AnimatedOpacity(
      child: Container(
        alignment: Alignment(-0.9, 0.4),
        child: Text(
          Provider.of<TaskModel>(context, listen: true).introLine,
          style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 17,
              height: 1.5,
              fontWeight: FontWeight.w400,
              color: widget.primColor),
        ),
      ),
      duration: Duration(milliseconds: 500),
      opacity: opacity1,
    );
  }


  Widget greetText() {
    return AnimatedOpacity(
      opacity: opacity1,
      duration: Duration(milliseconds: 300),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(" $_greeting\n Dave",
              style: Theme.of(context).textTheme.headline.copyWith(
                color: widget.primColor,
              )),
        ],
      ),
    );
  }
}
