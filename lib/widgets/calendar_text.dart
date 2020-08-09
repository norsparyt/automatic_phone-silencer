import 'dart:async';

import 'package:flutter/material.dart';
class CalendarText extends StatefulWidget {
  final Color primColor;
  CalendarText(this.primColor);

  @override
  _CalendarTextState createState() => _CalendarTextState();
}

class _CalendarTextState extends State<CalendarText> {
  double opacity=0.0;
  @override
  void initState() {
    super.initState();
    fadeIn();
  }
  fadeIn()=>Timer(Duration(milliseconds: 200), (){setState(() {opacity=1.0;});});

  @override
  Widget build(BuildContext context) {
    return   AnimatedOpacity(
        opacity: opacity,
        duration: Duration(milliseconds: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(" Plan your week",
                style: Theme.of(context).textTheme.headline.copyWith(
                  color: widget.primColor,
                )),
          ],
        ),
      );
  }
}
