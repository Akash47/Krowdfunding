import 'package:crowd_funding/app_screens/Dashboard.dart';
import 'package:crowd_funding/app_screens/Logo.dart';
import 'package:crowd_funding/app_screens/MyFundraiseDetailView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

bool USE_FIRESTORE_EMULATOR = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(new CrowdfundApp());
}

class CrowdfundApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColorLight: Color(0xffCFD8DC),
          focusColor: Color(0xffCFD8DC),
          primaryColor: Color(0xffCFD8DC),
          disabledColor: Colors.white54,
          errorColor: Colors.red[600],
          appBarTheme: new AppBarTheme(
            color: new Color(0xff455A64),
          ),
          iconTheme: new IconThemeData(color: Colors.white),
          textTheme: TextTheme(bodyText1: TextStyle(color: Color(0xffFFFFFF))),
          buttonColor: Color(0xffEA8724),
          scaffoldBackgroundColor: Color(0xff607D8B)),
      title: "Crowd Funding",
      home: new Logo(),
    );
  }
}
