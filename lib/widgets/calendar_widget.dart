import 'dart:async';
import 'package:flutter/material.dart';
import 'package:horizontal_calendar_widget/horizontal_calendar.dart';
import 'package:native_test/models/task_model.dart';
import 'package:provider/provider.dart';

class CalendarWidget extends StatefulWidget {
  Color primColor;
  CalendarWidget(Color primColor){this.primColor=primColor;}

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  double opacity=0.0;
  bool tasksPresent=false;
  TextStyle textStyle;
  @override
  void initState() {
    super.initState();
    print("from init state of calender widget");
    fadeIn();
  }
  fadeIn()=>Timer(Duration(milliseconds: 200), (){setState(() {opacity=1.0;});});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedOpacity(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Consumer<TaskModel>(
              builder: (BuildContext context, task, Widget child) {
              if(task.currentList.length>0) tasksPresent=true; else tasksPresent=false;
              textStyle=Theme.of(context).textTheme.button.copyWith(color: tasksPresent?Colors.grey.shade50:Theme.of(context).secondaryHeaderColor);
              return HorizontalCalendar(
                spacingBetweenDates: 12.0,
                padding: EdgeInsets.all(18.0),
                monthTextStyle: textStyle.copyWith(fontSize: 13.0),
                selectedMonthTextStyle: textStyle.copyWith(fontSize:13.0,color: tasksPresent?Theme.of(context).secondaryHeaderColor:Theme.of(context).primaryColorLight),
                dateTextStyle: textStyle,
                selectedDateTextStyle: textStyle.copyWith(color: tasksPresent?Theme.of(context).secondaryHeaderColor:Theme.of(context).primaryColorLight),
                weekDayTextStyle: textStyle.copyWith(fontSize: 15.0),
                selectedWeekDayTextStyle: textStyle.copyWith(fontSize: 15.0,color: tasksPresent?Theme.of(context).secondaryHeaderColor:Theme.of(context).primaryColorLight),
                initialSelectedDates: [task.initialDateField],
                defaultDecoration: BoxDecoration(
                    color: tasksPresent?task.colors[0]:Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15.0)
                ),
                selectedDecoration: BoxDecoration(
                    color: widget.primColor,
                    borderRadius: BorderRadius.circular(15.0)
                ),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 60)),
                onDateSelected: (selectedDate){
                  task.setCurrentListFromAllTaskList(selectedDate);
                },
              );
            },
            ),
          ), duration: Duration(milliseconds: 700), opacity: opacity,
        ),
      ],
    );
  }

}
