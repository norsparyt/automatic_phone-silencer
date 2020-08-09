import 'dart:ui';

import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double deviceHeight;
  double deviceWidth;
String notificationState="On";
String timeFormat="24-Hour";
String themeMode="Light";
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: Theme.of(context).primaryColorLight,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            right: deviceWidth * 0.05,
            left: deviceWidth * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Settings text
              Container(
                  margin: EdgeInsets.only(
                    left: deviceWidth * 0.06,
                    top: 10.0
                  ),
                  child: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headline.copyWith(
                          color: Colors.grey.shade900,
                        ),
                  )),
              //User Picture
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(deviceHeight * 0.05),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade700.withOpacity(0.4),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 4),
                          )
                        ],
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(0.2))),
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: deviceHeight * 0.11,
                      backgroundColor: Theme.of(context).primaryColorLight,
                      child: CircleAvatar(
                        radius: deviceHeight * 0.1,
                        backgroundImage: Image.asset(
                          "lib/images/Chris-user-profile.jpg",
                        ).image,
                      ),
                    ),
                  ),
                  //todo:change sign in icon accordingly
                  Container(
                      margin: EdgeInsets.only(top: deviceHeight * 0.24),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'lib/images/google_icon.png',
                        scale: 2,
                      ))
                ],
              ),
              //tiles
              SizedBox(
                height: deviceHeight * 0.02,
              ),
              Divider(height: 30,indent: 20,endIndent: 20,),
              ListTile(
                leading: Icon(Icons.notifications_none),
                title: Text(
                  "Notifications for task \nreminders",
                  style: Theme.of(context).textTheme.button.copyWith(fontSize: 17,),
                ),
                trailing: DropdownButton(
                  value: notificationState,
                    style: Theme.of(context).textTheme.display2,
                    items: <String>['On','Off'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,),
                  );
                }).toList(), onChanged: (String value){
                  setState(() {
                    notificationState=value;
                  });
                }),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text("Time format",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(fontSize: 17,)),
                trailing: DropdownButton(
                    value: timeFormat,
                    style: Theme.of(context).textTheme.display2,
                    items: <String>['24-Hour','12-Hour'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,),
                      );
                    }).toList(), onChanged: (String value){
                  setState(() {
                    timeFormat=value;
                  });
                }),
              ),
              ListTile(
                leading: Icon(Icons.invert_colors),
                title: Text("Theme",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(fontSize: 17,)),
                trailing: DropdownButton(
                    value: themeMode,
                    style: Theme.of(context).textTheme.display2,
                    items: <String>['Light','Dark'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,),
                      );
                    }).toList(), onChanged: (String value){
                  setState(() {
                    themeMode=value;
                  });
                }),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
//                  color: Colors.red,
                  child: RaisedButton(
                    child: Text('Logout',style: Theme.of(context).textTheme.button,),
                    onPressed: (){},
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    color: Theme.of(context).primaryColorLight.withOpacity(0.9),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}