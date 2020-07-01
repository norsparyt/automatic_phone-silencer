import 'package:flutter/material.dart';
import '../data.dart';

class Task extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double devH=MediaQuery.of(context).size.height;
    double devW=MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(right:devW*0.09,bottom: 20.0,top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: primColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 8),
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 7,
          ),
        ],
      ),
    );
  }
}

