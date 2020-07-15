import 'package:flutter/material.dart';
Color primColor = Colors.grey.shade50;
Color secColor =Colors.blueGrey.shade700;
Color darkColor= Colors.grey.shade900;
Color dynamicTypeColor;
String toggles="";

String getDateFormat(DateTime dateTime) {
  String weekday = "";
  int day = dateTime.weekday;
  switch (day) {
    case 1:
      weekday = "Monday";
      break;
    case 2:
      weekday = "Tuesday";
      break;
    case 3:
      weekday = "Wednesday";
      break;
    case 4:
      weekday = "Thursday";
      break;
    case 5:
      weekday = "Friday";
      break;
    case 6:
      weekday = "Saturday";
      break;
    case 7:
      weekday = "Sunday";
      break;
  }
  String month = "";
  int monthInt = dateTime.month;
  switch (monthInt) {
    case 1:
      month = "January";
      break;
    case 2:
      month = "February";
      break;
    case 3:
      month = "March";
      break;
    case 4:
      month = "April";
      break;
    case 5:
      month = "May";
      break;
    case 6:
      month = "June";
      break;
    case 7:
      month = "July";
      break;
    case 8:
      month = "August";
      break;
    case 9:
      month = "September";
      break;
    case 10:
      month = "October";
      break;
    case 11:
      month = "November";
      break;
    case 12:
      month = "December";
      break;
  }
  String today = "$weekday, ${dateTime.day} $month";
  return today;
}