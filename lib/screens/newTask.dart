import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:native_test/data/database_helper.dart';
import 'package:native_test/data/get_date_formatted.dart';
import 'package:native_test/data/get_dynamic_icon.dart';
import 'package:native_test/models/task.dart';
import 'package:native_test/models/task_model.dart';
import 'package:native_test/screens/Home.dart';
import 'package:native_test/widgets/save_task_button.dart';
import 'package:native_test/widgets/toggle.dart';
import 'package:provider/provider.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> with SingleTickerProviderStateMixin {
  TextEditingController _titleController,
      _fromController,
      _toController,
      _dateController;
  Widget dynamicIcon = Icon(
    Icons.create,
    color: Colors.grey.shade50,
    size: 30,
  );
  DateTime _fromTime, _toTime, _inputDate;
  var db = new DatabaseHelper();
  String _title, _category, _error;
  bool fade = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _fromController = TextEditingController();
    _toController = TextEditingController();
    _dateController = TextEditingController();
    _inputDate = Provider.of<TaskModel>(context,listen: false).initialDateField;
    if(_inputDate.day==DateTime.now().day)
    _dateController.text = "Today: ${GetDateFormatted().getDateFormat(_inputDate)}";
    else
      _dateController.text = "${GetDateFormatted().getDateFormat(_inputDate)}";

    Timer(Duration(milliseconds: 700), () => fadeIn());
  }

  void fadeIn() {
    setState(() {
      fade = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handlePop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (BuildContext context) {
            return SafeArea(
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
//                      child: SlideTransition(
//                        position: _slide,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            decoration: BoxDecoration(
                                color: _category == null
                                    ? Theme.of(context).primaryColorDark
                                    : Provider.of<TaskModel>(context,
                                            listen: false)
                                        .colors[0],
                          ),
                            child: _fieldsTop(context),
                          ),
                      ), //TOP CONTAINER
                      Expanded(
                        flex: 6,
                        child: AnimatedOpacity(
                          curve: Curves.easeInQuad,
                          opacity: fade ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          child: Container(
                            color: Theme.of(context).primaryColorLight,
                            child: _fieldsBottom(context),
                          ),
                        ),
                      ), //BOTTOM CONTAINER
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        saveNewTask(context);
                      },
                      child: AddButton(_category),
                    ),
                  ), //ADD BUTTON
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _fieldsTop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 30.0, right: 30.0, bottom: 30.0, top: 20.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 20.0),
            alignment: Alignment.centerLeft,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).primaryColorLight,
                ),
                onPressed: () {
                  print("GO bACK");
                  if (Provider.of<TaskModel>(context, listen: false).currentList.length == 0)
                    Provider.of<TaskModel>(context, listen: false)
                        .setDynamicColor("");
                  Navigator.push(context, _createRoute());
                }),
          ), //BACK BUTTON
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Create New Task",
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 35.0,
                          fontWeight: FontWeight.w400),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 10.0, top: 5.0),
                    child: dynamicIcon),
              ],
            ),
          ), //HEAD AND ICON
          Expanded(
            flex: 2,
            child: TextField(
              controller: _titleController,
              maxLength: 30,
              maxLengthEnforced: true,
              onChanged: (title) {
                _title = title;
              },
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(fontSize: 20.0, color: Colors.white),
              cursorColor: Theme.of(context).primaryColorLight,
              decoration: InputDecoration(
//                  errorText: _errorTitle,
                  labelText: "TITLE",
                  hintText: "eg.Meeting with Dave"),
            ), //TITLE
          ),
          Expanded(flex: 2, child: _timePick(context)), //ROW OF TIME
        ],
      ),
    );
  }

  Widget _fieldsBottom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//          child: Opacity(
      //TODO: change to animated opacity
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: TextField(
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .copyWith(color: Colors.grey.shade900, fontSize: 17.0),
                  controller: _dateController,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: Provider.of<TaskModel>(context,listen: false).initialDateField,
                      firstDate: DateTime.now().subtract(Duration(days: 1)),
                      lastDate: DateTime.now().add(Duration(days: 90)),
                    ).then((value) {
                      if (value != null) _inputDate = value;
                      _dateController.text = "${GetDateFormatted().getDateFormat(_inputDate)}";
                      print("Selected date:$value");
                    });
                  },
                  readOnly: true,
                  showCursor: true,
                  decoration: InputDecoration(
//                            errorText: _errorDate,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                    labelText: "DATE",
                    alignLabelWithHint: true,
                    labelStyle: Theme.of(context)
                        .inputDecorationTheme
                        .labelStyle
                        .copyWith(
                          color: Colors.grey.shade700,
                        ),
                    enabledBorder: Theme.of(context)
                        .inputDecorationTheme
                        .enabledBorder
                        .copyWith(
                            borderSide:
                                BorderSide(color: Colors.grey.shade700)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
              ),
              Icon(Icons.date_range)
            ],
          ),
          //DATE FIELD
          Container(
              margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "PREFERENCES",
                style:
                    Theme.of(context).inputDecorationTheme.labelStyle.copyWith(
                          color: Colors.grey.shade700,
                        ),
              )),
          //PREFS LABEL
          Toggle(_category),
          Container(
              margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text(
                "CATEGORY",
                style:
                    Theme.of(context).inputDecorationTheme.labelStyle.copyWith(
                          color: Colors.grey.shade700,
                        ),
              )),
          //CATEGORY LABEL
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  category("WORK", Colors.blueAccent, context),
                  category("CLASSES", Colors.cyanAccent.shade700, context),
                  category("MEETINGS", Colors.tealAccent.shade700, context),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  category("OTHER", Colors.deepPurpleAccent.shade200, context),
                  category("SILENCE ZONE", Colors.green, context),
                  category("DOZE", Colors.indigo.shade600, context),
                ],
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ],
      ),
    );
  }

  Widget category(String text, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        dynamicIcon = GetDynamicIcon()
            .getIcon(text, Theme.of(context).primaryColorLight, 30.0);
        Provider.of<TaskModel>(context, listen: false).setDynamicColor(text);
        print("tapped:$text");
        setState(() {
          _category = text;
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.width * 0.08,
        width: MediaQuery.of(context).size.width * 0.25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          color: color.withOpacity(0.4),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.display1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ),
    );
  }

  Widget _timePick(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: TextField(
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(fontSize: 20.0, color: Colors.white),
              controller: _fromController,
              showCursor: true,
              readOnly: true,
              onTap: () => _showDialog(context, 1),
              cursorColor: Theme.of(context).primaryColorLight,
              decoration: InputDecoration(
//                  errorText:_errorFromTime,
                  labelText: "FROM"),
            ),
          ),
          Icon(
            Icons.alarm,
            color: Theme.of(context).primaryColorLight,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: TextField(
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(fontSize: 20.0, color: Colors.white),
              controller: _toController,
              showCursor: true,
              onTap: () {
                _showDialog(context, 2);
              },
              readOnly: true,
              cursorColor: Theme.of(context).primaryColorLight,
              decoration: InputDecoration(
//                  errorText:_errorToTime,
                  labelText: "TO"),
            ),
          ),
        ],
      ),
    );
  }

  bool checked = false;

  void _showDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            backgroundColor: Theme.of(context).primaryColorLight,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: TimePickerSpinner(
                      is24HourMode: false,
                      onTimeChange: (time) {
                        print(time);
                        if (index == 1) _fromTime = time;
                        if (index == 2) _toTime = time;
                      },
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).primaryColorDark,
                  ),
                  Expanded(
                    flex: 2,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0))),
                      minWidth: double.maxFinite,
                      child: Icon(Icons.check),
                      onPressed: () {
                        if (index == 1)
                          _fromController.text =
                              "${_fromTime.hour}: ${_fromTime.minute}";
                        else if (index == 2)
                          _toController.text =
                              "${_toTime.hour}: ${_toTime.minute}";
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }

  Future<void> saveNewTask(BuildContext context) async {
    validations(context);
    //validating
    if (checked == true) {
      //adding date to times: start and end if date is other than today
      if(_inputDate.day!=DateTime.now().day) {
        _fromTime = _inputDate.add(_fromTime.add(Duration(days: 1)).difference(_inputDate));
        _toTime = _inputDate.add(_toTime.add(Duration(days: 1)).difference(_inputDate));
      }
      print("$_fromTime and $_toTime");
      Provider.of<TaskModel>(context, listen: false).addTaskToList(Task(
          _title,
          _fromTime.millisecondsSinceEpoch,
          _toTime.millisecondsSinceEpoch,
          _inputDate.millisecondsSinceEpoch,
          _category,
          Provider.of<TaskModel>(context, listen: false).toggles));
      Navigator.push(context, _createRoute());
    }
  }

  Route _createRoute() {
    return PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 1000),
        pageBuilder: (context, animation, secondaryAnimation) => Home(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }

  void validations(BuildContext context) {
    if (_titleController.text.length < 3) {
      _error = "Title too small";
      showSnackBar(context);
    } else if (_titleController.text.length > 30) {
      _error = "Title too large";
      showSnackBar(context);
    } else if (_fromTime == null) {
      _error = "Choose a start time";
      showSnackBar(context);
    } else if (_toTime == null) {
      _error = "Choose an end time";
      showSnackBar(context);
    } else if (_inputDate == null) {
      _error = "Select a date";
      showSnackBar(context);
    } else if (_category == null) {
      _error = "A Category must be selected";
      showSnackBar(context);
    } else {
//      print("title:$_title ,from: $_fromTime,to: $_toTime, date: $_inputDate ,state:$toggles,category:$_category}");
      _error = "Saved this task";
      showSnackBar(context);
      checked = true;
    }
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                _error,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 5.0),
              ),
            ),
            Icon(Icons.announcement),
          ],
        ),
        height: 42,
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      elevation: 2,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<bool> _handlePop(){
    print("HANDLING POP");
    if (Provider.of<TaskModel>(context, listen: false).currentList.length == 0)
      Provider.of<TaskModel>(context, listen: false).setDynamicColor("");
    Navigator.of(context).pop();
    return Navigator.of(context).maybePop(true);
  }
}
