import 'package:flutter/material.dart';
import 'package:native_test/data/database_helper.dart';
import 'package:native_test/models/task.dart';

class TaskModel extends ChangeNotifier {
  var db = new DatabaseHelper();
  List<dynamic> allTaskList = [];

  //list of database stored tasks
  List<dynamic> currentList = [];

  //list of task to show on home screen for the current date
  bool taskListInitialised = false;

  //notifies if the tasks have retrieved from the database in to the allTaskList
  Color homeColor = Colors.grey.shade900;

  //color used for home screen widgets(dark grey by default assuming no tasks present
  //ToDo: make homeColors list with prim and sec colors for dynamic ui element colors

  List<Color> colors = [Colors.grey.shade200, Colors.grey.shade50];

  //primary list of dynamic colors for home screen background and/or other ui elements
  String toggles;

  //stores users preferences for alarm, media etc values

  String introLine = "You haven't set any tasks for today";

  //displays task's text

  DateTime inquiryDate = DateTime.now();

  DateTime initialDateField = DateTime.now();

  bool googleSignIn = false;

  setGoogleSignIn(bool value) => googleSignIn = value;

  //self-explanatory
  void initTaskList() {
    //called inside initState of Home screen
    toggles = "FFF";
    //default toggle settings
    db.getAllTasks().then((list) {
      allTaskList = list;
      //storing tasks
      for (int i = 0; i < allTaskList.length; i++)
        if ((DateTime.fromMillisecondsSinceEpoch(allTaskList[i]['startTime'])
                    .difference(DateTime.now())
                    .inMinutes <
                0) ||
            (DateTime.fromMillisecondsSinceEpoch(allTaskList[i]['startTime'])
                    .difference(DateTime.now())
                    .inDays <
                0)) {
          db.deleteTask(allTaskList[i]['title']);
          allTaskList.remove(allTaskList[i]);
        }
      //clearing all tasks from previous dates from both database and allTaskList
      taskListInitialised = true;
      print("Task list Initialised");
      //taskList is initialised
      setCurrentListFromAllTaskList(DateTime.now());
      //update the current list with today's tasks
      if (currentList.length > 0) {
        //if there are some tasks present set the intro line, home color, and dynamic color list accordingly
        print("greater than 0");
        setIntroLine(currentList.length);
        setHomeColor(Colors.grey.shade50);
        setDynamicColor(currentList[0]["category"]);
      }
      list.forEach((value) => print("$value \n"));
      //printing the value for reference
      notifyListeners();
    });
  }

  void setCurrentListFromAllTaskList(DateTime currentDate) {
    currentList = [];
    //sets a new list for the tasks of current data: current being the inquired date;default is today
    for (int i = 0; i < allTaskList.length; i++)
      if (DateTime.fromMillisecondsSinceEpoch(allTaskList[i]['date']).day ==
          currentDate.day) currentList.add(allTaskList[i]);
    print("CURRENT LIST$currentList");
    if (currentList.length == 0) {
      setDynamicColor("");
      setHomeColor(Colors.grey.shade900);
    } else {
      setHomeColor(Colors.grey.shade50);
      setDynamicColor(currentList[0]['category']);
    }
    //setting the initial field Date in case user taps the add button for that date
    initialDateField = currentDate;
    notifyListeners();
  }

  void addTaskToList(Task task) async {
    Task newTask = Task(task.title, task.startTime, task.endTime, task.date,
        task.category, task.toggle);
    //adding to all tasks list
    allTaskList.add(newTask.toMap());
    //checking if the task added is for today and then adding to current list
    setCurrentListFromAllTaskList(
        DateTime.fromMillisecondsSinceEpoch(task.date));
    print("CURRENT LIST$currentList");
    //changing dynamic ui
    currentList = List.from(currentList.reversed);
    //reversing current list so recently added task appears first
    await db.saveTask(task);
    //saving task to database
    print("task:${task.title} saved");
    db.getAllTasks().then((list) {
      list.forEach((value) => print("$value \n"));
    });

    notifyListeners();
    //Todo: we to rebuild the current task list every time by calling the set function
  }

  void deleteTask(String title) async {
    //method to remove tasks from all 3 lists: database, allTasksList and conditionally currentList
    allTaskList.removeWhere((item) => item["title"] == title);
    //removing from all tasks list
    await db.deleteTask(title);
    //removing from database
    currentList.removeWhere((item) => item["title"] == title);
    //removing from current task list
    print("removed $title");
    db.getAllTasks().then((list) {
      list.forEach((value) => print("$value \n"));
    });
    //printing
    if (currentList.length == 0) {
      introLine = "You haven't set any tasks for today";
      setDynamicColor("");
      setHomeColor(Colors.grey.shade900);
    } else
      setIntroLine(currentList.length);
    //changing dynamic ui for home screen elements
    notifyListeners();
  }

  void deleteAll() {
    allTaskList.forEach((f) {
      db.deleteTask(f['title']);
    });
    currentList.clear();
    allTaskList.clear();
  }

  void setDynamicColor(String category) {
    //adds colors to color list depending on the category of task demanded
    switch (category) {
      case "WORK":
        colors = [Colors.blue.shade800, Colors.lightBlue.shade400];
        break;
      case "MEETINGS":
        colors = [Colors.teal, Colors.tealAccent.shade700];
        break;
      case "CLASSES":
        colors = [Colors.cyan.shade800, Colors.cyanAccent.shade700];
        break;
      case "OTHER":
        colors = [Colors.deepPurple.shade800, Colors.deepPurpleAccent.shade700];
        break;
      case "DOZE":
        colors = [Colors.indigo.shade800, Colors.indigoAccent.shade700];
        break;
      case "SILENCE ZONE":
        colors = [Colors.green.shade800, Colors.green.shade400];
        break;
      default:
        colors = [Colors.grey.shade200, Colors.grey.shade50];
    }
    notifyListeners();
  }

  void setIntroLine(int taskLength) {
    switch (taskLength) {
      case 1:
        introLine = "Just one task scheduled for today";
        break;
      case 2:
        introLine = "You've got a couple of tasks lined up for today";
        break;
      default:
        introLine =
            "Looks pretty packed.\nYou've got $taskLength tasks scheduled for today";
    }
  }

//method to add tasks to all 3 lists: database, allTasksList and conditionally currentList
  void setHomeColor(Color color) {
    //sets home screen widget color: dark grey or white
    homeColor = color;
    notifyListeners();
  }

  void setToggle(String t) {
    //sets toggle to global toggle provider variable
    toggles = t;
    print(toggles);
    notifyListeners();
  }

  void reInitialise() {
    taskListInitialised = false;
  }
}
