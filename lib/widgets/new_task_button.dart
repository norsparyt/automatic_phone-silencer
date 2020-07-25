import 'package:flutter/material.dart';

class NewTaskButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width),
        gradient: LinearGradient(colors: [
          Colors.grey.shade200,
          Colors.white,
        ],
            stops: [0.1, 0.8],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight),
        boxShadow: [BoxShadow(
          color: Colors.grey.shade800.withOpacity(0.4),
          spreadRadius: 3,
          blurRadius: 7,
          offset: Offset(0, 5),
        ),
        ],
        color: Theme.of(context).primaryColorLight,),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Icon(
          Icons.add,
          color: Colors.teal,
          size: 30,
        ),
      ),
    );
  }
}

