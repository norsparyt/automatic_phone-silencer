import 'package:flutter/material.dart';

class AppTheme{

  ThemeData get themeData{
    ThemeData _theme=ThemeData(
      primaryColorLight: Colors.grey.shade50,
        primaryColorDark: Colors.grey.shade900,
        secondaryHeaderColor: Colors.grey.shade700,
        textTheme: TextTheme(
          headline: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 40,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2),
          display1: TextStyle(fontFamily: 'Quicksand',color: Colors.grey.shade50),
          button: TextStyle(fontFamily: 'Quicksand',fontSize: 20.0),
            display2: TextStyle(fontFamily: 'Quicksand',fontSize: 15.0,color: Colors.grey.shade800)
        ),
        inputDecorationTheme: InputDecorationTheme(
          alignLabelWithHint: true,
          labelStyle: TextStyle(
              fontFamily:'Quicksand',
              color: Colors.grey.shade50,
              fontSize: 12.0,
              fontWeight: FontWeight.w600),
          hintStyle: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w400,color: Colors.grey.shade300, fontSize: 15.0),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ));
    return _theme;
  }
}