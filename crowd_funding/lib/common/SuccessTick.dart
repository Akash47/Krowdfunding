import 'package:crowd_funding/app_screens/Dashboard.dart';
import 'package:crowd_funding/app_screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class SuccessTick extends StatelessWidget {
  // This widget is the root of your application.
  String uid;
  SuccessTick(this.uid);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SplashScreen(this.uid)
    );
  }
}

class SplashScreen extends StatefulWidget {
  String uid;
  SplashScreen(this.uid);
  @override
  _SplashScreenState createState() => _SplashScreenState(this.uid);
}

class _SplashScreenState extends State<SplashScreen> {
  String uid;
  _SplashScreenState(this.uid);
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 8), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => new Dashboard(uid:this.uid),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlareActor("assets/riv/sucessCheck.flr2d",
          alignment: Alignment.center, fit: BoxFit.contain, animation: "Idle"),
    );
  }
}
