import 'package:crowd_funding/app_screens/Dashboard.dart';
import 'package:crowd_funding/app_screens/My_Donation.dart';
import 'package:crowd_funding/app_screens/downloadImage.dart';
import 'package:flutter/material.dart';
import 'TextFField.dart';
import 'cameraImageUpload.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crowd_funding/common/successTick.dart';
import 'package:crowd_funding/model/User.dart';
class EditProfile extends StatefulWidget {
  
  @override
  _EditProfile createState() {
    return _EditProfile();
  }
}
class _EditProfile extends State<EditProfile> {
  File _image;
  Image imagePath;
  String nameEdit;
  String emailEdit;
  String mobileNoEdit;
  final editFormKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;
  cameraImageUpload cameraa= new cameraImageUpload();
  downloadImage download = new downloadImage();
  final picker = ImagePicker();

  

  User aUser = new User();
  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  
  @override
  void initState() {
    super.initState();
    retrieveProfilePhoto() ;
  }
  @override
  Widget build(BuildContext context) {
  
    return new FutureBuilder(
      future: firestoreInstance.collection('UserProfile').doc("1nucdckUSJvLLa93pSZ4").get(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        print("fhhjg");
        print(snapshot.data["emailId"]);
         name=TextEditingController(text:snapshot.data["firstName"]+snapshot.data["lastName"]);
      email=TextEditingController(text:snapshot.data["emailId"]);
      mobileNo=TextEditingController(text:snapshot.data["mobileNumber"]);
      
     return Scaffold(
      appBar: new AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        iconTheme: Theme.of(context).iconTheme,
        title: new Text("Edit Profile",
                  style: TextStyle(
                    color:Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body:  new Form(
            key: editFormKey,
            child: new Center(
              child:ListView(children: [
            SizedBox(height: MediaQuery.of(context).size.height/30),
            Center(
            child: Stack(
              children: [
                 Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius:MediaQuery.of(context).size.width/5,   
                      child: ClipOval(
                        child: new SizedBox(
                           width: MediaQuery.of(context).size.width,           
                           height: MediaQuery.of(context).size.height/5,
                           child: (_image!=null)?Image.file(
                            _image,
                            fit: BoxFit.fill,
                          ):imagePath
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: MediaQuery.of(context).size.width / 3.5,
                  child: Container(
                    width:MediaQuery.of(context).size.width / 8,
                      height: MediaQuery.of(context).size.height / 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width:2,
                    color:Colors.black12
                    ),
                    color: Colors.grey[700] ),
                    child:IconButton(
                  icon:Icon(Icons.add_a_photo,
                  color: Colors.black,),
                  onPressed: () {
                    getImageFromCamera();
                                   
                  } ,
                  )
                ))
              ],)),
             Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height / 40),
                    Container(
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width / 8,
                      height: MediaQuery.of(context).size.height / 8,
                      child: TextFField(
                        suffixIcons: IconButton(
                               icon: Icon(
                                 Icons.edit,
                                 color: Theme.of(context).iconTheme.color,
                                 size: 30,
                             ),
                             onPressed: null,
                             ),
                            // initvalue: name,
                          obscureTexts: false,
                          aTextInputType: TextInputType.name,
                          maxLenthOfTextField: null,
                         // validInput: RegExp(r'[a-zA-Z]'),
                          lableTextField: "Full Name",
                          hintTextField: "Enter Full Name",
                          myController:this.name,
                          validInput:(value){
                               if (value.isEmpty) {
                                  return "Please Enter Full Name";
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
                         suffixIcons: IconButton(
                               icon: Icon(
                                 Icons.edit,
                                 color: Theme.of(context).iconTheme.color,
                                 size: 30,
                             ),
                             onPressed: null,
                             ),
                            //initvalue: emailEdit,
                             myController:this.email,
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
                    
                          ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 40),
                    Container(
                        width: MediaQuery.of(context).size.width -
                            MediaQuery.of(context).size.width / 8,
                        height: MediaQuery.of(context).size.height /8,
                        child: TextFField(
                          suffixIcons: IconButton(
                               icon: Icon(
                                 Icons.edit,
                                 color: Theme.of(context).iconTheme.color,
                                 size: 30,
                             ),
                             onPressed: null,
                                ),
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
                           myController:this.mobileNo,
                        //initvalue: mobileNoEdit,
                        )),
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
                              'SAVE',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            onPressed: () {
                               cameraa.uploadPic(context,_image,"ProfilePhotos","1nucdckUSJvLLa93pSZ4");
                              if (editFormKey.currentState.validate()) {
                                this.setUserDetail();
                                this.firestoreInstance.collection("UserProfile").doc("1nucdckUSJvLLa93pSZ4")
                                    .update(this.aUser.toJson())
                                    .then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => new My_Donation(),
                                    ),
                                  );
                                });
                              }}
                            ))
                              
                    ] )
      ])
            ))
    );}
    else
    return CircularProgressIndicator();
    });
  }
  void setUserDetail() {
    var names=this.name.toString().split(" ");
    this.aUser.firstName = names[0];
    this.aUser.lastName = names[1];
    this.aUser.mobileNumber = this.mobileNo.toString();
    this.aUser.emailId = this.email.toString();
   print(name);
   
  }

  @override
  void dispose() {
    this.name.dispose();
    this.mobileNo.dispose();
    this.email.dispose();
    super.dispose();
  }
 retrieveProfilePhoto()  {
   download.getProfileImage("ProfilePhotos","1nucdckUSJvLLa93pSZ4").then((value1) {
          if(value1 != null){
        imagePath=Image.network(value1,fit: BoxFit.fill,);
    }
    else{
      imagePath=Image(image:AssetImage('assets/Images/profile.png',),fit: BoxFit.fill,);
    }
      });
  }
}
