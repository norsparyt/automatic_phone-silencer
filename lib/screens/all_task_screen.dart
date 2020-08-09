import 'package:flutter/material.dart';
import 'package:native_test/models/task_model.dart';
import 'package:provider/provider.dart';

class AllTasksScreen extends StatefulWidget {
  @override
  _AllTasksScreenState createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  List allTask = [];

  @override
  void initState() {
    super.initState();
    allTask = Provider.of<TaskModel>(context,listen:false).allTaskList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemCount: allTask.length,
            itemBuilder: (BuildContext context, int index) {
//              if(allTask.length!=0)
              return ListTile(
                  title: Text(allTask[index]['title']),
                  subtitle: Text(DateTime.fromMillisecondsSinceEpoch(
                          allTask[index]['date']).day
                      .toString())
              );
//              else
//                return Text("No tasks set");
            },
          ),
        ),
      ),
    );
  }
}
