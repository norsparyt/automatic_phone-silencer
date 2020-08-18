import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:native_test/models/task_model.dart';
import 'package:native_test/screens/Home.dart';
import 'package:native_test/screens/login_screens/intro_screen.dart';
import 'package:native_test/screens/login_screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sign_up_screen.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ));
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "lib/images/welcome_image.jpg",
                height: MediaQuery.of(context).size.height * 0.5,
                alignment: Alignment.topCenter,
              ),
              Container(
                  margin: EdgeInsets.only(
                      left: 30.0, right: 20.0, top: 20.0, bottom: 20.0),
                  child: Text(
                    "Hey, there",
                    style: Theme.of(context).textTheme.headline,
                  )),
              Container(
                  margin: EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 0.0, bottom: 20.0),
                  child: Text(
                    "Distracted by your phone during work?\nWe are here to help.",
                    style: Theme.of(context)
                        .textTheme
                        .display2
                        .copyWith(fontSize: 17),
                  )),
              Expanded(
                child: Container(child: signOptions(context)),
              ),
            ],
          ),
        ),
      ), onWillPop: ()=>SystemNavigator.pop(),
    );
  }

  Widget signOptions(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
          tag: "SignUp",
          child: Container(
            decoration: BoxDecoration(
                color: Colors.indigo.shade500,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0))),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              MaterialButton(
                color: Colors.amber.shade600,
                splashColor: Colors.white,
                onPressed: () {
                  signInWithGoogle(context).then((FirebaseUser user) async {
                    if (user != null) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setStringList(
                          'User', [user.displayName, user.photoUrl]);
                      await prefs.setBool("googleSignIn", true);
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                      Animation animation,
                                      Animation secondaryAnimation) =>
                                  IntroScreen()));
                    }
                  }).catchError((e) => print(e));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                height: MediaQuery.of(context).size.height * 0.07,
                minWidth: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Sign in",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                    Text(
                      "G",
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(_createRouteToSignUp());
                },
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(40.0)),
                height: MediaQuery.of(context).size.height * 0.07,
                minWidth: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Sign up ",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.27,
                    ),
                    Icon(
                      Icons.mail_outline,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              MaterialButton(
                child: Text(
                  "Login with Email and Password? Click here",
                  style: Theme.of(context)
                      .textTheme
                      .display2
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).push(_createRouteToLogin());
                },
              )
            ],
          ),
        )
      ],
    );
  }

  Route _createRouteToSignUp() {
    return PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => SignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }

  Route _createRouteToLogin() {
    return PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }

  Future<FirebaseUser> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}
