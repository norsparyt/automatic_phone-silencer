import 'package:flutter/material.dart';
import 'package:native_test/models/task_model.dart';
import 'package:provider/provider.dart';
class AddButton extends StatefulWidget {
  String category;

  AddButton(String category){
    this.category=category;
  }

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      transitionOnUserGestures: true,
      tag: 'addButton',
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: MediaQuery.of(context).size.width*0.9,
        margin: EdgeInsets.only(top: 0.0, bottom: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width),
          gradient: LinearGradient(colors:
          widget.category==null?[Colors.indigo,Colors.lightBlue]:
          Provider.of<TaskModel>(context,listen: true).colors,
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
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColorLight,
            size: 30,
          ),
        ),
      ),
    );
  }
}
