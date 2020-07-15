import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:native_test/data/database_helper.dart';
import 'package:native_test/models/task.dart';
import 'package:native_test/widgets/toggle.dart';
import '../data.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> with SingleTickerProviderStateMixin {
  AnimationController _introController;
  Animation<Offset> _slide;
  Animation _radius, _fadeTop, _fadeBottom;
  TextEditingController _titleController,
      _fromController,
      _toController,
      _dateController;
  Widget dynamicIcon = Icon(
    Icons.create,
    color: primColor,
    size: 30,
  );
  DateTime _fromTime, _toTime, _inputDate;
  var db = new DatabaseHelper();
  String _title, _category, _error;
  Color _gradientDark, _gradientLight;

  @override
  void initState() {
    _gradientDark = Colors.blue.shade900;
    _gradientLight = Colors.blue.shade400;
    dynamicTypeColor = darkColor;
    super.initState();
    _titleController = TextEditingController();
    _fromController = TextEditingController();
    _toController = TextEditingController();
    _dateController = TextEditingController();
    _introController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(() {
            setState(() {});
          });
    _slide = Tween<Offset>(
      begin: Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _introController,
      curve: Interval(0.0,0.4,curve:Curves.easeIn),
    ));
    _radius = Tween(begin: 40.0, end: 0.0).animate(CurvedAnimation(
      parent: _introController,
      curve: Interval(0.4, 1.0, curve: Curves.easeIn),
    ));
    _fadeTop = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _introController,
      curve: Interval(0.5, 0.8, curve: Curves.easeIn),
    ));
    _fadeBottom = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _introController,
      curve: Interval(0.8, 1.0, curve: Curves.easeIn),
    ));

    _introController.forward();

  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: SlideTransition(
                    position: _slide,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                          color: dynamicTypeColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(_radius.value),
                              bottomLeft: Radius.circular(_radius.value))),
                      child: _fieldsTop(context),
                    ),
                  ),
                ), //TOP CONTAINER
                Expanded(
                  flex: 6,
                  child: Container(
                    color: primColor,
                    child: _fieldsBottom(context),
                  ),
                ), //BOTTOM CONTAINER
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      saveNewTask(context);
                    },
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: 'addButton',
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: deviceWidth,
                        margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            _gradientDark,
                            _gradientLight,
                          ],
                              stops: [
                                0.1,
                                0.8
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                            ),
                          ],
                          color: secColor,
                        ),
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
                ), //ADD BUTTON
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _fieldsTop(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left:30.0,right:30.0,bottom:30.0,top: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom:20.0),
              alignment: Alignment.centerLeft,
              child: IconButton(icon: Icon(Icons.arrow_back_ios,color: primColor,), onPressed: (){
                print("GO bACK");
                Navigator.of(context).pop();
              }),
            ),//BACK BUTTON
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
                            color: primColor.withOpacity(_fadeTop.value),
                            fontSize: 35.0,
                            fontWeight: FontWeight.w300),
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 10.0, top: 5.0),
                      child: dynamicIcon),
                ],
              ),
            ),//HEAD AND ICON
            Expanded(
              flex: 2,
              child: TextField(
                controller: _titleController,
                maxLength: 30,
                maxLengthEnforced: true,
                onChanged: (title) {
                  _title = title;
                },
                style: TextStyle(color: Colors.white),
                cursorColor: primColor,
                decoration: InputDecoration(
//                  errorText: _errorTitle,
                    labelText: "TITLE", hintText: "eg.Meeting with Dave"),
              ),//TITLE
            ),
            Expanded(flex: 2, child: _timePick(context)),//ROW OF TIME
          ],
        ),
      );
  }


  Widget _fieldsBottom(BuildContext context) {
    TextStyle labelStyle = TextStyle(
        color: Colors.grey.shade700,
        fontSize: 12.0,
        fontWeight: FontWeight.w300);
    return  Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Opacity(
            opacity: _fadeBottom.value,
            child: ListView(
              physics: BouncingScrollPhysics(),
            children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _dateController,
                          onTap: () async {
                            _inputDate=await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(Duration(days: 1)),
                              lastDate: DateTime.now().add(Duration(days: 90)),
                            );
                            _dateController.text="${getDateFormat(_inputDate)}";
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
                            labelStyle: labelStyle,
                            enabledBorder: UnderlineInputBorder(
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
                          style: labelStyle,
                        )),
                //PREFS LABEL
                Toggle(),
                Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Text("CATEGORY", style: labelStyle)),
                //CATEGORY LABEL
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        category(Colors.amberAccent.withOpacity(0.4),
                            Colors.amber.shade900, "WORK", context),
                        category(Colors.greenAccent.withOpacity(0.4),
                            Colors.green.shade800, "MEETINGS", context),
                        category(Colors.pinkAccent.withOpacity(0.4),
                            Colors.pink.shade900, "CLASSES", context),
                      ],
                    ),
                    Padding(padding: const EdgeInsets.all(10),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        category(Colors.deepPurpleAccent.withOpacity(0.4),
                            Colors.deepPurple.shade900, "OTHER", context),
                        category(Colors.lightBlueAccent.withOpacity(0.4),
                            Colors.lightBlue.shade900, "SLEEP", context),
                        category(Colors.indigoAccent.withOpacity(0.4),
                            Colors.indigo.shade900, "SILENCE ZONE", context),
                      ],
                    )
                  ],
                ),
                Container(height:20.0,)
              ],
            ),
          ),
        );
  }
Widget category(Color boxColor, Color textColor, String text, BuildContext context) {
  return GestureDetector(
    onTap: () {
      setDynamicIcon(text);
      setState(() {
        dynamicTypeColor = textColor;
        _gradientLight = boxColor;
        _gradientDark = textColor;
      });
      print("tapped:$text");
      _category = text;
    },
    child: Container(
      height: MediaQuery
          .of(context)
          .size
          .width * 0.08,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: boxColor,
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    ),
  );
  }

  void setDynamicIcon(String t){
    switch(t)
    {case 'WORK': dynamicIcon=Icon(Icons.work,color: primColor,size: 30,);break;
      case 'MEETINGS': dynamicIcon=Icon(Icons.group,color: primColor,size: 30,);break;
      case 'CLASSES': dynamicIcon=Icon(Icons.class_,color: primColor,size: 30,);break;
      case 'OTHER': dynamicIcon=Icon(Icons.content_paste,color: primColor,size: 30,);break;
      case 'SLEEP': dynamicIcon=Icon(Icons.airline_seat_individual_suite,color: primColor,size: 30,);break;
      case 'SILENCE ZONE': dynamicIcon=Icon(Icons.volume_off,color: primColor,size: 30,);break;
    }
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
              style: TextStyle(color: Colors.white),
              controller: _fromController,
              showCursor: true,
              readOnly: true,
              onTap: () => _showDialog(context, 1),
              cursorColor: primColor,
              decoration: InputDecoration(
//                  errorText:_errorFromTime,
                  labelText: "FROM"),
            ),
          ),
          Icon(
            Icons.alarm,
            color: primColor.withOpacity(_fadeTop.value),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: _toController,
              showCursor: true,
              onTap: () {
                _showDialog(context, 2);
              },
              readOnly: true,
              cursorColor: primColor,
              decoration: InputDecoration(
//                  errorText:_errorToTime,
                  labelText: "TO"),
            ),
          ),
        ],
      ),
    );
  }

  int _id = 1;
  bool checked = false;

  void _showDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            backgroundColor: primColor,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: TimePickerSpinner(
                      is24HourMode: false,
                      onTimeChange: (time) {
                        if (index == 1)
                          _fromTime = time;
                        if (index == 2)
                          _toTime = time;
                      },
                    ),
                  ),
                  Divider(
                    color: darkColor,
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
                        else if (index == 2) _toController.text =
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
    if (checked == true) {
      await db.saveTask(Task(
          _title,
          _fromTime.millisecondsSinceEpoch,
          _toTime.millisecondsSinceEpoch,
          _inputDate.millisecondsSinceEpoch,
          _category,
          toggles));
      print("saved");
      Navigator.of(context).pop();
    }
    int count = await db.getCount();
    print(count);
  }

  void validations(BuildContext context) {
    if (_titleController.text.length < 3) {
      _error = "Title too small";
      showSnackBar(context);
    }
    else if (_titleController.text.length > 30) {
      _error = "Title too large";
      showSnackBar(context);
    }
    else if (_fromTime == null) {
      _error = "Choose a start time";
      showSnackBar(context);
    }
    else if (_toTime == null) {
      _error = "Choose an end time";
      showSnackBar(context);
    }
    else if (_inputDate == null) {
      _error = "Select a date";
      showSnackBar(context);
    }
    else if (_category == null) {
      _error = "A Category must be selected";
      showSnackBar(context);
    }
    else {
//      print("title:$_title ,from: $_fromTime,to: $_toTime, date: $_inputDate ,state:$toggles,category:$_category}");
      _error = "Saved this task";
      showSnackBar(context);
      checked = true;
    }
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(content:
    Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(_error, style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w300, letterSpacing: 5.0),),
          Icon(Icons.announcement),
        ],
      ),
      height: 33,
    ),
      backgroundColor: darkColor,
      elevation: 2,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
