import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:native_test/data/get_dynamic_icon.dart';
import 'package:native_test/models/task_model.dart';
import 'package:provider/provider.dart';

class BuildSwiper extends StatefulWidget {
//builds swiper using Consumer
  @override
  _BuildSwiperState createState() => _BuildSwiperState();
}

class _BuildSwiperState extends State<BuildSwiper> {
  DateTime today=DateTime.now();
  final SwiperController _swipe = new SwiperController();
  List<bool> optionsTapped = List<bool>();


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    int length = Provider.of<TaskModel>(context).currentList.length;
    for (int i = 0; i < length; i++) optionsTapped.add(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
        builder: (BuildContext context, task, Widget child) {
      if (task.currentList.length != 0) {
        return Swiper(
          itemCount: task.currentList.length,
          onTap: (index) {},
          itemBuilder: (context, index) {
            return Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      optionsTapped[index] = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.all(10.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.grey.shade300)),
                                child: GetDynamicIcon().getIcon(
                                    task.currentList[index]["category"],
                                    task.colors[0],
                                    25.0)),
                            IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    optionsTapped[index] = true;
                                  });
                                }),
                          ],
                        ),
                        //ICON AND MORE
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              getTime(
                                  task.currentList[index]["startTime"], context),
                              Icon(
                                Icons.repeat,
                                size: 14,
                                color: task.colors[0],
                              ),
                              getTime(task.currentList[index]["endTime"], context),
                            ],
                          ),
                        ),
                        //TASK TIMINGS
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(left: 15.0, bottom: 10.0),
                          child: Text(
                            task.currentList[index]['category'],
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15.0,
                                    color: task.colors[0]),
                          ),
                        ),
                        //CATEGORY
                        Container(
                          margin: EdgeInsets.only(left: 15.0, bottom: 10.0),
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            task.currentList[index]["title"],
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(
                                    fontSize: 25.0,
                                    color: Colors.grey.shade800),
                          ),
                        ),
                        //TASK TITLE
                        Divider(
                          thickness: 1.0,
                          color: task.colors[0],
                          indent: 13.0,
                          endIndent: 13.0,
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(right: 35.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.shade50,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 8),
                          color: Colors.grey.shade900.withOpacity(0.5),
                          spreadRadius: 4,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                optionsTapped[index]
                    ? ClipRect(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(
                            sigmaX: 4.0,
                            sigmaY: 4.0,
                          ),
                          child: Container(
                            margin: EdgeInsets.only(right: 35.0, bottom: 20.0),
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                optionsTapped[index] = false;
                                task.deleteTask(task.currentList[index]['title']);
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.grey.shade300)),
                                child: Icon(Icons.delete,
                                    size: 40.0, color: Colors.grey.shade700),
                              ),
                            ), //
                          ),
                        ),
                      )
                    : Container(),
              ],
            );
          },
          loop: false,
          layout: SwiperLayout.DEFAULT,
          onIndexChanged: (index) {
            print(index);
            task.setDynamicColor(task.currentList[index]["category"]);
            if (index != 0) optionsTapped[index - 1] = false;
            if (index != task.currentList.length - 1)
              optionsTapped[index + 1] = false;
          },
          controller: _swipe,
          viewportFraction: 0.72,
        );
      } else {
        return noTasksFound();
      }
    });
  }

  Widget getTime(int timeInMilliseconds, BuildContext context) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeInMilliseconds);
    String formattedTime = " ${time.hour}:${time.minute} ";
    return Text(formattedTime,
        style: Theme.of(context).textTheme.display1.copyWith(
            letterSpacing: 2,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700));
  }

  Widget noTasksFound() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "lib/images/no_task.png",
            scale: 6,
          ),
          Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text(
                "Add a task, maybe?",
                style: TextStyle(
                    shadows: [
                      Shadow(
                        offset: Offset(-1.0, 0.0),
                        blurRadius: 1.0,
                        color: Colors.grey.shade700,
                      ),
                    ],
                    color: Colors.teal,
                    fontSize: 15,
                    letterSpacing: 2.0,
                    wordSpacing: 2),
              ))
        ],
      ),
    );
  }
}
