import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_test/models/task_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Home.dart';
import 'welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _incorrectEmail = false, _incorrectPassword = false;
  final _formKey = GlobalKey<FormState>();
  double _opacity = 0.0;
  String _email, _password;

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
              color: Theme.of(context).primaryColorDark,
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
                  "Login",
                  style: Theme.of(context).textTheme.headline,
                )),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: "SignUp",
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: MediaQuery.of(context).size.width,
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
    TextStyle textStyle = Theme.of(context).textTheme.button.copyWith(
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
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                      onChanged: (email) {
                        _email = email;
                      },
                      validator: (email) {
                        if (email.length == 0)
                          return "This field can't be empty";
                        else if (_incorrectEmail)
                          return "No user with this email";
                        else
                          return null;
                      },
                      style: textStyle,
                      decoration: inputDecoration.copyWith(
                          labelText: 'Email',
                          hintText: "eg: myname123@xyz.com")),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30.0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                      onChanged: (password) {
                        _password = password;
                      },
                      validator: (password) {
                        if (password.length == 0)
                          return "This field can't be empty";
                        else if (_incorrectPassword)
                          return "Incorrect password ";
                        else
                          return null;
                      },
                      style: textStyle,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Password',
                      )),
                ),
                MaterialButton(
                  color: Colors.amber.shade600,
                  splashColor: Colors.white,
                  onPressed: _signInWithEmail,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  height: MediaQuery.of(context).size.height * 0.07,
                  minWidth: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    "Login",
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                MaterialButton(
                  child: Text(
                    "Facing a problem?\nSign in with google instead",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .display2
                        .copyWith(color: Colors.white),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
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

  _signInWithEmail() {
    if (_formKey.currentState.validate())
      auth
          .signInWithEmailAndPassword(
              email: _email.trim(), password: _password.trim())
          .catchError((onError) {
        print("Error occurred: ${onError.toString()}");
        setState(() {
          if (onError.toString().contains("ERROR_USER_NOT_FOUND")) {
            print('wrong email');
            _incorrectEmail = true;
          } else if (onError.toString().contains("ERROR_WRONG_PASSWORD")) {
            print("wrong password");
            _incorrectPassword = true;
            _incorrectEmail = false;
          }
          _formKey.currentState.validate();
          _incorrectPassword = false;
          _incorrectEmail = false;
        });
      }).then((user) async {
        if (user != null) {
          print("Signed in with email :${user.user.displayName}");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          await prefs.setStringList('User', ["${user.user.displayName} ", ""]);
          Provider.of<TaskModel>(context, listen: false).setGoogleSignIn(false);
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation animation,
                      Animation secondaryAnimation) =>
                  Home()));
        }
      });
  }
}
