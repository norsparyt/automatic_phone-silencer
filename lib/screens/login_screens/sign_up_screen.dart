import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_test/models/task_model.dart';
import 'package:native_test/screens/Home.dart';
import 'package:native_test/screens/login_screens/intro_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'welcome_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  double _opacity = 0.0;
  String _username, _email, _password;

  @override
  void initState() {
    setOpacity();
  }

  void setOpacity() {
    Timer(Duration(milliseconds: 700), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Theme
                  .of(context)
                  .primaryColorDark,
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                    left: 30.0, right: 20.0, top: 10.0, bottom: 20.0),
                child: Text(
                  "Sign Up",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline,
                )),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: "SignUp",
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                          color: Colors.indigo.shade500,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0))),
                    ),
                  ),
                  buildForm(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .button
        .copyWith(
      color: Colors.white,
    );
    InputDecoration inputDecoration = InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(40.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(40.0),
        ));

    return AnimatedOpacity(
      child: Container(
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.7,
                  child: TextFormField(
                      onChanged: (username) => _username = username,
                      style: textStyle,
                      validator: (username) {
                        RegExp exp = RegExp(r"[aA-zZ]$");
                        if ((exp.hasMatch(username)) &&
                            (username.length > 3) &&
                            (username.length < 15))
                          return null;
                        else
                          return "Only letters between 3 to 16 characters required";
                      },
                      decoration: inputDecoration.copyWith(
                          labelText: "Name", hintText: "eg: James Muller")),
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.7,
                  child: TextFormField(
                      onChanged: (email) => _email = email,
                      style: textStyle,
                      validator: (email) {
                        RegExp exp = RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                        if (exp.hasMatch(email))
                          return null;
                        else
                          return "Something wrong with the email address";
                      },
                      decoration: inputDecoration.copyWith(
                          labelText: 'Email',
                          hintText: "eg: myname123@xyz.com")),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30.0),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.7,
                  child: TextFormField(
                      onChanged: (password) => _password = password,
                      style: textStyle,
                      validator: (password) {
                        RegExp exp = RegExp(r'(?=.*?[0-9])');
                        if (!exp.hasMatch(password))
                          return "Must have at least one numeric value";
                        else if ((password.length < 5) ||
                            (password.length > 30))
                          return "Password length should be between 5 to 30 characters";
                        else
                          return null;
                      },
                      decoration: inputDecoration.copyWith(
                        labelText: 'Password',
                      )),
                ),
                MaterialButton(
                  color: Colors.amber.shade600,
                  splashColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) _createUser();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.07,
                  minWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 0.7,
                  child: Text(
                    "Sign Up",
                    style: Theme
                        .of(context)
                        .textTheme
                        .button
                        .copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Image.asset(
                  "lib/images/sign_up.png",
                  scale: 20,
                  color: Colors.indigo,
                  colorBlendMode: BlendMode.saturation,
                ),
              ],
            ),
          ),
        ),
      ),
      opacity: _opacity,
      duration: Duration(milliseconds: 300),
    );
  }

  Future _createUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool('googleSignIn', false);
    await prefs.setStringList(
        'User', ["${_username.trim()} ", ""]);
    await auth.createUserWithEmailAndPassword(
      email: _email.trim(),
      password: _password.trim(),
    ).then((user) {
      UserUpdateInfo userUpdateInfo=UserUpdateInfo();
      userUpdateInfo.displayName="${_username.trim()} ";
      userUpdateInfo.photoUrl="";
      user.user.updateProfile(userUpdateInfo);
      print("${user.user.displayName} created");
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) => IntroScreen()));
    });
  }
}