import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_funding/app_screens/Dashboard.dart';
import 'package:crowd_funding/app_screens/FundraiseList.dart';
import 'package:crowd_funding/app_screens/TextFField.dart';
import 'package:crowd_funding/common/FileStorage.dart';
import 'package:crowd_funding/model/EventModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class MyFundraise extends StatefulWidget {
  final String text, uid;
  MyFundraise(this.text, this.uid);
  @override
  MyFundraiseState createState() => new MyFundraiseState(this.text, this.uid);
}

class MyFundraiseState extends State<MyFundraise> {
   String text, uid;
  MyFundraiseState(this.text, this.uid);
  int currentStep = 0;
  int eventCount=0;
  bool complete = false;
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController campaginDiscriptionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController campaginDaysController = TextEditingController();
  TextEditingController goalAmountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  EventModel event = new EventModel();
  final List<DropdownMenuItem> items = [];
  //final List<DropdownMenuItem> yearsOfExp = [];
  //String selectedValueCity;
  //String selectedValueResidence;
  CollectionReference firebaseUsers =
      FirebaseFirestore.instance.collection('Events');
  // DocumentReference docFirebaseUer = FirebaseFirestore.instance.doc("event");
  Set<String> path = new Set<String>();
  FileStorage aFileStorage = new FileStorage();
  int count=0;
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();
  int imageCount = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: MediaQuery.of(context).size.width -
            MediaQuery.of(context).size.width / 2,
        maxHeight: MediaQuery.of(context).size.height -
            MediaQuery.of(context).size.height / 2,
        imageQuality: 100,
      );
      setState(() {
        _imageFile = pickedFile;
        path.add(_imageFile.path);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }
  

  @override
  void initState() {
    FirebaseFirestore.instance.collection("Events").where('userId',isEqualTo:uid).get().then((value) {
      List <DocumentSnapshot> mydoc =value.docs;
      print("values in eventdocument");
      print(mydoc.length);
      eventCount=mydoc.length;
      print (value);
    }
    );
    items.add(DropdownMenuItem(
      child: Text("Bhopal"),
      value: "Bhopal",
    ));
  }

  next() {
    if (currentStep == 2) {
       FileStorage aFileStorage = new FileStorage();
       print(path.length);
       for(int i=0;i<path.length;i++){
         aFileStorage.uploadFile(new File(path.elementAt(i)), uid, "Documents",'event'+(eventCount+1).toString(),
            'document' + (i + 1).toString());
       }
        
      this.setEventDetails();
      firebaseUsers.doc().set(this.event.toJson()).then((value) {
        currentStep + 1 != steps.length
            ? goTo(currentStep + 1)
            : setState(() => complete = true);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(uid: uid),
          ),
        );
      });
    } else {
      currentStep + 1 != steps.length
          ? goTo(currentStep + 1)
          : setState(() {
              complete = true;
            });
    }
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  bool isActive(index) {
    if (currentStep == index) {
      return true;
    } else {
      return false;
    }
  }

  StepState isComplete(index) {
    if (currentStep > index) {
      return StepState.complete;
    } else if (currentStep == index) {
      return StepState.editing;
    } else {
      return StepState.disabled;
    }
  }

  createSteps(BuildContext context) {
    return this.steps = [
      Step(
          title: const Text(
            'Campaign info',
            style: TextStyle(color: Colors.white),
          ),
          isActive: isActive(0),
          state: isComplete(0),
          content: new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).size.height / 4,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Container(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 3,
                    child: new TextFField(
                      myController: ownerNameController,
                      lableTextField: "Owner Name",
                      hintTextField: "Enter The Owner Name",
                      suffixIcons: null,
                      obscureTexts: false,
                      aTextInputType: TextInputType.name,
                      validInput: (value) {
                        if (value.isEmpty) {
                          return "Please Enter Owner Name";
                        }
                        return null;
                      },
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 3,
                    child: new TextFField(
                      myController: projectNameController,
                      lableTextField: "Project Name",
                      hintTextField: "Enter The Project Name",
                      suffixIcons: null,
                      obscureTexts: false,
                      aTextInputType: TextInputType.name,
                      validInput: (value) {
                        if (value.isEmpty) {
                          return "Please Enter Project Name";
                        }
                        return null;
                      },
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 3,
                    child: new TextFField(
                      myController: campaginDiscriptionController,
                      lableTextField: "Campaign Discription",
                      hintTextField: "Enter The Campaign Discription",
                      suffixIcons: null,
                      maxLine: 8,
                      minLine: 100,
                      aTextInputType: TextInputType.multiline,
                      obscureTexts: false,
                      validInput: (value) {
                        if (value.isEmpty) {
                          return "Please Enter Campaign Discription";
                        }
                        return null;
                      },
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 3,
                    child: new TextFField(
                      myController: cityController,
                      lableTextField: "City",
                      hintTextField: "Enter The City",
                      suffixIcons: null,
                      obscureTexts: false,
                      validInput: (value) {
                        if (value.isEmpty) {
                          return "Please Enter City";
                        }
                        return null;
                      },
                    )),
              ],
            ),
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColorLight),
          )),
      Step(
          isActive: isActive(1),
          state: isComplete(1),
          title: const Text(
            'Goals',
            style: TextStyle(color: Colors.white),
          ),
          content: new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).size.height / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Container(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 3,
                    child: new TextFField(
                      myController: campaginDaysController,
                      lableTextField: "Campaign Days",
                      hintTextField: "Enter The Campaign Days",
                      suffixIcons: null,
                      obscureTexts: false,
                      aTextInputType: TextInputType.number,
                      validInput: (value) {
                        if (value.isEmpty) {
                          return "Please Enter Campaign Days";
                        }
                        return null;
                      },
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 3,
                    child: new TextFField(
                      myController: goalAmountController,
                      lableTextField: "Goal Amount",
                      hintTextField: "Enter The Goal Amount",
                      suffixIcons: null,
                      obscureTexts: false,
                      aTextInputType: TextInputType.number,
                      validInput: (value) {
                        if (value.isEmpty) {
                          return "Please Enter Goal Amount";
                        }
                        return null;
                      },
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 3,
                    child: new TextFField(
                      myController: categoryController,
                      lableTextField: "Sub Category",
                      hintTextField: "Enter The Sub Category",
                      suffixIcons: null,
                      obscureTexts: false,
                      aTextInputType: TextInputType.text,
                      validInput: (value) {
                        if (value.isEmpty) {
                          return "Please Enter Sub Category";
                        }
                        return null;
                      },
                    )),
              ],
            ),
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColorLight),
          )),
      Step(
          state: isComplete(2),
          isActive: isActive(2),
          title: const Text('Documents', style: TextStyle(color: Colors.white)),
          content:new Column(children: [
                new Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.width / 4,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColorLight),
                  alignment: Alignment.center,
                  child: new Scrollbar(
                      child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        child: new Text("Upload Photos",
                            style: new TextStyle(fontSize: 18)),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            3, // constrain height
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemCount: this.path.length,
                          itemBuilder: (context, index) {
                            return new InkWell(
                                onTap: () {
                                  setState(() {
                                    if (this.path.elementAt(index) != '') {
                                      print(index);
                                    } else {
                                      _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(content: Text('No Image')));
                                    }
                                  });
                                },
                                child:
                                    new RadioItem(this.path.elementAt(index)));
                          },
                        ),
                      ),
                      new Align(
                        alignment: Alignment.bottomRight,
                        child: ClipOval(
                          child: Material(
                            color:
                                Theme.of(context).buttonColor, // button color
                            child: InkWell(
                              splashColor: Colors.red, // inkwell color
                              child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: Icon(Icons.add)),
                              onTap: () {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    duration: new Duration(seconds: 10),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Semantics(
                                          label:
                                              'image_picker_example_from_gallery',
                                          child: new RaisedButton(
                                            onPressed: () {
                                              _onImageButtonPressed(
                                                  ImageSource.gallery,
                                                  context: context);
                                            },
                                            child:
                                                const Icon(Icons.photo_library),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16.0),
                                          child: new RaisedButton(
                                            onPressed: () {
                                              _onImageButtonPressed(
                                                  ImageSource.camera,
                                                  context: context);
                                            },
                                            child: const Icon(Icons.camera_alt),
                                          ),
                                        ),
                                      ],
                                    )));
                                    count++;
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
                ),
              ])
            
          )
    ];
  }

  List<Step> steps;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Fundraise",style: TextStyle(color: Colors.white),),
          leading:IconButton(icon: Icon(Icons.arrow_back), onPressed:(){
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new FundraiseList("My Fundraise",uid),
            ),
          );
          })
        ),
        body: Theme(
            data: ThemeData(
                canvasColor: Theme.of(context).scaffoldBackgroundColor),
            child: Column(children: <Widget>[
              Expanded(
                child: Stepper(
                  steps: createSteps(context),
                  type: StepperType.vertical,
                  currentStep: currentStep,
                  onStepContinue: next,
                  onStepCancel: cancel,
                ),
              ),
            ])));
  }

  void setEventDetails() {
    this.event.ownerName = this.ownerNameController.text;
    this.event.projectName = this.projectNameController.text;
    this.event.campaginDiscription = this.campaginDiscriptionController.text;
    this.event.campaginDays = int.parse(this.campaginDaysController.text);
    this.event.category = this.categoryController.text;
    this.event.city = this.cityController.text;
    this.event.createdDate = new DateTime.now().toString();
    this.event.goalAmount = int.parse(this.goalAmountController.text);
    this.event.userId = this.uid;
    this.event.collectedAmount=0;
    this.event.eventNo=eventCount+1;
  }
}

class RadioItem extends StatelessWidget {
  final String _item;

  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new SizedBox(
            height: 200,
          ),
          new Container(
            child: this._item != ''
                ? Image.file(
                    new File(this._item),
                    fit: BoxFit.fill,
                  )
                : new Icon(Icons.add),
            width: MediaQuery.of(context).size.width / 6,
            height: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
}
class RadioModel {
  bool isSelected;
  final String buttonText;
 RadioModel(this.isSelected, this.buttonText);
}

