import 'package:flutter/material.dart';

class AppTheme{

  ThemeData get themeData{
    ThemeData _theme=ThemeData(
      primaryColorLight: Colors.grey.shade50,
        primaryColorDark: Colors.grey.shade900,
        textTheme: TextTheme(
          display1: TextStyle(fontFamily: 'Quicksand',color: Colors.grey.shade50)
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