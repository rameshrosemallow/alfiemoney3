import 'dart:async';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'register/Register.dart';


const colorizeTextStyle = TextStyle(
  fontSize: 15.0,
  fontFamily: 'Horizon',

);
class SplashScreen extends StatefulWidget {

  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;
  List<Color> colorizeColors = [
    Rmblue,
    Colors.black38,
  ];
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegistrationPage()));
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Rmlightblue,
      child: SafeArea(child:Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                Constants.developerBy,
                style: TextStyle(

                    fontSize: 12,

                    color: Rmlightblue),
              ),
             SizedBox(height: 10,)


            ],),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                Constants.developerLogo,
                width: 250,
                height: 250,
              ),
              SizedBox(height: 10,),
               CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 5,
                valueColor: new AlwaysStoppedAnimation<Color>(Rmlightblue),
              ),

            ],
          ),

        ],
      ),
    )));
  }
}