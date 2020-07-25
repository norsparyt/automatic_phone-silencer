import 'package:flutter/material.dart';
import 'package:native_test/data/database_helper.dart';
import 'package:native_test/models/task.dart';

class TaskModel extends ChangeNotifier {
  var db = new DatabaseHelper();
  List<dynamic> taskList = [];
  bool taskListInitialised = false;
  Color homeColor = Colors.grey.shade900;
  //ToDo: make homeColors list with prim and sec colors for dynamic ui element colors
  List<Color> colors = [Colors.grey.shade200, Colors.grey.shade50];
  String toggles;
  String introLine = "You haven't set any tasks for today";

  void initTaskList() {
    toggles = "FFF";
    db.getAllTasks().then((list) {
      taskList = list;
      taskListInitialised = true;
      if (taskList.length > 0) {
        print("greater than 0");
        setIntroLine(taskList.length);
        setHomeColor(Colors.grey.shade50);
        setDynamicColor(taskList[0]["category"]);
      }
      print("Task list Initialised");
      list.forEach((value) => print("$value \n"));
      notifyListeners();
    });
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
        introLine="Looks pretty packed.\nYou've got $taskLength tasks scheduled for today";
    }
  }

  void addTaskToList(Task task) async {
    Task newTask = Task(task.title, task.startTime, task.endTime, task.date,
        task.category, task.toggle);
    taskList.add(newTask.toMap());

    if (taskList.length > 0){ setHomeColor(Colors.grey.shade50);setIntroLine(taskList.length);}

    taskList = List.from(taskList.reversed);
    await db.saveTask(task);
    print("task:${task.title} saved");
    db.getAllTasks().then((list) {
      list.forEach((value) => print("$value \n"));
    });

    notifyListeners();
  }

  void deleteTask(String title) async {
    taskList.removeWhere((item) => item["title"] == title);
    await db.deleteTask(title);
    print("removed $title");
    db.getAllTasks().then((list) {
      list.forEach((value) => print("$value \n"));
    });
    if (taskList.length == 0) {
      introLine = "¯\\_(ツ)_/¯\nYou haven't set any tasks for today";
      setDynamicColor("");
      setHomeColor(Colors.grey.shade900);
    } else setIntroLine(taskList.length);
    notifyListeners();
  }

  void setDynamicColor(String category) {
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

  void setHomeColor(Color color) {
    homeColor = color;
    notifyListeners();
  }

  void setToggle(String t) {
    toggles = t;
    print(toggles);
    notifyListeners();
  }
}
