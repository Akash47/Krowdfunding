import 'package:flutter/material.dart';
import 'TextFField.dart';
import 'Registration.dart';
import 'Dashboard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  @override
  _LoginForm createState() {
    return _LoginForm();
  }
}

class _LoginForm extends State<Login> {
  final loginFormKey = GlobalKey<FormState>();
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        iconTheme: Theme.of(context).iconTheme,
        title: new Text(
          "Login",
          style: new TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: new Form(
        key: loginFormKey,
        child: new Center(
            child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 20),
            new Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width -
                              MediaQuery.of(context).size.width / 8,
                        height: MediaQuery.of(context).size.height / 8,
                        child: TextFField(
                          obscureTexts: false,
                          aTextInputType: TextInputType.emailAddress,
                          maxLenthOfTextField: null,
                          validInput:(value){
                               if (value.isEmpty) {
                                  return "Please Enter Email Id";
                                }
                            Pattern pattern=r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = new RegExp(pattern);
                              if (!regex.hasMatch(value))
                                {
                                  return "Enter Valid Email";
                                  }
                             
                                return null;
                          },
                          lableTextField: "Enter Email",
                          hintTextField: "Enter your email Id",
                          //errorText: "Please Enter Email Id",
                        )),
                    SizedBox(height: MediaQuery.of(context).size.height / 40),
                    Container(
                        width: MediaQuery.of(context).size.width -
                            MediaQuery.of(context).size.width / 8,
                        height: MediaQuery.of(context).size.height / 8,
                        child: TextFField(
                          obscureTexts: !_showPassword,
                          aTextInputType: TextInputType.visiblePassword,
                          maxLine: 1,
                          maxLenthOfTextField: 15,
                         // validInput: RegExp(r'[a-zA-Z0-9@#$%&*^]'),
                          lableTextField: "Enter Password",
                          hintTextField: "Enter your password",
                         suffixIcons: IconButton(
                               icon: Icon(
                             _showPassword? Icons.visibility: Icons.visibility_off,
                             color: this._showPassword ? Colors.grey : Theme.of(context).iconTheme.color,
                             ),
                              onPressed: (){
                               setState(() {
                                    _showPassword=!_showPassword;
                                  });
                             },
                             ),
                          validInput:(value){
                               if (value.isEmpty) {
                                  return "Please Enter Password";
                                }
                                 Pattern pattern =
                            r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                           RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value)){
                              return 'Invalid password';
                            }
                            return null;
                          })),
                    SizedBox(height: MediaQuery.of(context).size.height / 40),
                    Container(
                        width: MediaQuery.of(context).size.width -
                            MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.height / 15,
                        child: RaisedButton(
                            color: Theme.of(context).buttonColor,
                            textColor: Color.fromRGBO(0, 0, 0, 1),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            onPressed: () {
                              if (loginFormKey.currentState.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Dashboard(),
                                  ),
                                );
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Processing Data')));
                              }
                            })),
                  ]),
            ),
            new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                  Text(
                    "OR",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                  Container(
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 15,
                      child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () {},
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 18),
                                child: Icon(
                                  FontAwesomeIcons.google,
                                  color: Color(0xffFFFFFF),
                                  size: 25.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 40),
                                child: Text(
                                  'Sign In with Google',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                  Container(
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 15,
                      child: RaisedButton(
                          color: Colors.blue[800],
                          onPressed: () {},
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 18),
                                child: Icon(
                                  FontAwesomeIcons.facebookSquare,
                                  color: Color(0xffFFFFFF),
                                  size: 30.0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  'Sign In with Facebook',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                  Container(
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 15,
                      child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Color.fromRGBO(0, 0, 0, 1),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new Registration(),
                              ),
                            );
                          })),
                ]),
          ],
        )),
      ),
    );
  }
}
