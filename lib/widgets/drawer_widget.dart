import 'package:flutter/material.dart';
import 'package:native_test/widgets/tabs.dart';
class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            tab("Profile", Icon(Icons.person,)),
            Divider(
              color: Colors.grey.shade800,
            ),
            tab("Settings", Icon(Icons.settings)),
            Divider(
              color: Colors.grey.shade800,
            ),
            tab("About", Icon(Icons.info))
          ],
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width* 0.15,
      ),
    );
  }
}
