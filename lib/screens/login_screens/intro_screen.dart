import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../Home.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Home()),
    );
  }

  Widget _buildImage(String imageNumber) {
    return Align(
      child: Image.asset('lib/images/intro_image_$imageNumber.jpg',),
      alignment: Alignment.bottomCenter,
    );
  }
  @override
  Widget build(BuildContext context) {
  const pageDecoration = const PageDecoration(
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          titleWidget: title("Create tasks", context),
          bodyWidget: bodyText("App name automatically silences and restores your device as per your scheduled tasks.",context),
          image: _buildImage('1'),
          footer: Icon(Icons.add_circle,color: Colors.amber.shade500,size: 30,),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: title("Manage and tweak tasks", context),
          bodyWidget:bodyText("Choose your preferences and plan ahead using the quick calender.\nView all tasks from the 'All tasks' tab.", context),
          image: _buildImage('2'),
          decoration: pageDecoration,
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.calendar_today,color: Colors.amber.shade500,),
              Padding(padding: EdgeInsets.only(right: 30.0)),
              Icon(Icons.list,color: Colors.amber.shade500,),
            ],
          )
        ),
        PageViewModel(
          titleWidget: title("Work peacefully ", context),
          bodyWidget: bodyText("Now u can focus on the work at hand without being disturbed by your phone.", context),
          image: _buildImage('3'),
          footer: Icon(Icons.done,color: Colors.amber.shade500,),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Lets's go", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
  Widget title(String text,BuildContext context){
    TextStyle _titleStyle=Theme.of(context).textTheme.button.copyWith(fontSize: 30,fontWeight: FontWeight.bold);
    return Text(text,style: _titleStyle,textAlign: TextAlign.center,);
  }

  Widget bodyText(String text, BuildContext context) {
    TextStyle _bodyStyle=Theme.of(context).textTheme.button.copyWith(fontSize: 20,fontWeight: FontWeight.w400);
    return Text(text,style: _bodyStyle,textAlign: TextAlign.center,);
  }
}
