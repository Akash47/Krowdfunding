import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_funding/app_screens/Login.dart';
import 'package:crowd_funding/common/SuccessTick.dart';
import 'package:crowd_funding/model/User.dart';
import 'package:flutter/material.dart';
import 'TextFField.dart';
import 'authentication.dart';
class Registration extends StatefulWidget {
  @override
  _RegistrartionForm createState() {
    return _RegistrartionForm();
  }
}

class _RegistrartionForm extends State<Registration> {
  final registrationFormKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final mobileNumber = TextEditingController();
  final emailId = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  String userId;
  bool _showPassword=false;
  bool _showRePassword=false;
  CollectionReference firebaseUsers =
      FirebaseFirestore.instance.collection('UserProfile');

  User aUser = new User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Theme.of(context).appBarTheme.color,
          iconTheme: Theme.of(context).iconTheme,
          title: new Text(
            "Registration",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: new Form(
            key: registrationFormKey,
            child: new Center(
                child: new ListView(children: [
              SizedBox(height: MediaQuery.of(context).size.height / 20),
              new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width / 8,
                      height: MediaQuery.of(context).size.height / 8,
                      child: TextFField(
                           obscureTexts: false,
                          aTextInputType: TextInputType.name,
                          maxLenthOfTextField: null,
                          lableTextField: "First Name",
                          hintTextField: "Enter The First Name",
                          myController: this.firstName,
                          validInput:(value){
                               if (value.isEmpty) {
                                  return "Please Enter First Name";
                                }
                                return null;
                          }
                          ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 40),
                    Container(
                        width: MediaQuery.of(context).size.width -
                            MediaQuery.of(context).size.width / 8,
                        height: MediaQuery.of(context).size.height / 8,
                        child: TextFField(
                        obscureTexts: false,
                          aTextInputType: TextInputType.name,
                          maxLenthOfTextField: null,
                            lableTextField: "Last Name",
                            hintTextField: "Enter The Last Name",
                           validInput:(value){
                               if (value.isEmpty) {
                                  return "Please Enter Last Name";
                                }
                                return null;
                          },
                            myController: this.lastName)),
                    SizedBox(height: MediaQuery.of(context).size.height / 40),
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
                                {return 'Enter Valid Email';}
                                return null;
                          },
                          lableTextField: "Email Id",
                          hintTextField: "Enter The Email Id",
                          myController: this.emailId),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 40),
                    Container(
                        width: MediaQuery.of(context).size.width -
                            MediaQuery.of(context).size.width / 8,
                        height: MediaQuery.of(context).size.height /8,
                        child: TextFField(
                         obscureTexts: false,
                          aTextInputType: TextInputType.number,
                          maxLenthOfTextField: 10,
                         validInput:(value) {
                              if (value.isEmpty) {
                                  return "Please Enter Mobile Number";
                                }
                              if (value.length != 10)
                                 {return 'Mobile Number must be of 10 digit';}
                                return null;},
  
                            lableTextField: "Mobile Number",
                            hintTextField: "Enter Mobile Number",
                           
                        myController: this.mobileNumber)),
                    SizedBox(height: MediaQuery.of(context).size.height / 40),
                    Container(
                        width: MediaQuery.of(context).size.width -
                            MediaQuery.of(context).size.width / 8,
                        height: MediaQuery.of(context).size.height / 8,
                        child: TextFField(
                          maxLine: 1,
                          obscureTexts: !_showPassword,
                            aTextInputType: TextInputType.visiblePassword,
                            maxLenthOfTextField: 15,
                            lableTextField: "Enter Password",
                            hintTextField: "Enter your password",
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
                          },
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
                            myController: this.password)),
                    SizedBox(height: MediaQuery.of(context).size.height / 40),
                    Container(
                        width: MediaQuery.of(context).size.width -
                            MediaQuery.of(context).size.width / 8,
                        height: MediaQuery.of(context).size.height / 8,
                        child: TextFField(
                          obscureTexts:!_showRePassword,
                            maxLine: 1,
                            aTextInputType: TextInputType.visiblePassword,
                            maxLenthOfTextField: 15,
                            lableTextField: "Enter Re-Password",
                            hintTextField: "Enter your Re-Password",
                            validInput:(value){
                               if (value.isEmpty) {
                                  return "Please Enter Re-Password";
                                }
                                 Pattern pattern =
                            r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                           RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value)){
                              return 'Invalid Re-password';
                            }
                             if(this.confirmPassword.text != this.password.text)
                                   return 'Re-Password Not Match With Password';
                            return null;
                          },
                            suffixIcons: IconButton(
                               icon: Icon(
                                 _showRePassword? Icons.visibility: Icons.visibility_off,
                                 color: Theme.of(context).iconTheme.color,
                             ),
                             onPressed: (){
                               setState(() {
                                    _showRePassword=!_showRePassword;
                                  });
                             },
                             ),
                            myController: this.confirmPassword)),
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
                              'CREATE ACCOUNT',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            onPressed: () {
                              if (registrationFormKey.currentState.validate()) {
                                signUp(this.emailId.text, this.password.text,  context).then((value) {
                                   if(value != null){
                                     userId=value.uid;
                                     this.setUserDetail();
                                    this.firebaseUsers.doc(userId)
                                    .set(this.aUser.toJson())
                                    .then((value1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => new SuccessTick(value.uid),
                                    ),
                                  );
                                });
                                    }
                                   
                                });
                               
                                
                              }
                            })),
                  ])
            ]))));
  }

  void setUserDetail() {
    this.aUser.firstName = this.firstName.text;
    this.aUser.lastName = this.lastName.text;
    this.aUser.mobileNumber = this.mobileNumber.text;
    this.aUser.emailId = this.emailId.text;
    this.aUser.password = this.password.text;
  }

  @override
  void dispose() {
    this.firstName.dispose();
    this.lastName.dispose();
    this.mobileNumber.dispose();
    this.emailId.dispose();
    this.password.dispose();
    this.confirmPassword.dispose();
    super.dispose();
  }
}

