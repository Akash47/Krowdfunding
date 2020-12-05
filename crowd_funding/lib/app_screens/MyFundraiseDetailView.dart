import 'dart:ui';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crowd_funding/common/SuccessTick.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:crowd_funding/app_screens/FundraiseList.dart';
import 'package:crowd_funding/common/FileStorage.dart';
import 'package:crowd_funding/model/EventModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_funding/model/TransactionModel.dart';
import 'package:flutter/material.dart';

class MyFundraiseDetailView extends StatefulWidget {
  final String uid;
   String currentProjectName='';
  String currentProjectUid='';
  MyFundraiseDetailView({Key key, @required this.uid,this.currentProjectName,this.currentProjectUid}) : super(key: key);

  @override
  _myFundraiseDetailViewState createState() => _myFundraiseDetailViewState(uid,currentProjectName,currentProjectUid);
}

class _myFundraiseDetailViewState extends State<MyFundraiseDetailView> {
  final String uid;
  String currentProjectName='';
  String currentProjectUid='';
  final firestoreInstance = FirebaseFirestore.instance;
  final CollectionReference firebaseEvents =
      FirebaseFirestore.instance.collection('Event');
  FileStorage aFileStorage = new FileStorage();
  EventModel aEventModel;
  TransactionModel aTransactionModel=new TransactionModel();
  int _current = 0;
  int noOfDonor=0;
  _myFundraiseDetailViewState(this.uid,this.currentProjectName,this.currentProjectUid);

  @override
  void initState(){
     FirebaseFirestore.instance.collection("Transactions").where('projectName',isEqualTo:currentProjectName).get().then((value) async {
     for(var item in value.docs){
        //TransactionModel aTransactionModels=TransactionModel.fromJson(item.data());
        noOfDonor++;
     }
     }
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text(
            "Campaign ",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white70,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      new FundraiseList("My Fundraise", this.uid),
                ),
              );
            },
          )),
      body: FutureBuilder(
        future: retrieveEvent(currentProjectUid,currentProjectName),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            this.aEventModel = snapshot.data;
            print("indide snapsh,,ot");
            return ListView(children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  child:CarouselSlider(
                    items: imagePath( this.aEventModel.multiplePictureLocation  ),
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height / 2.8,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  )),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                color: Theme.of(context).focusColor,
                child: ListView(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height/60,),
                    Row(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 14,
                      ),
                      Text(this.aEventModel.projectName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20)),
                    ]),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 80,
                    ),
                    Row(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 14,
                      ),
                      Text(
                        "Created By",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ]),
                    Row(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 14,
                      ),
                      Text(
                        this.aEventModel.ownerName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ]),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Row(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 14,
                      ),
                      Expanded(child:Text(this.aEventModel.campaginDiscription,
                      //overflow: TextOverflow.ellipsis,
                      //maxLines: 4,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18))),
                             // SizedBox(width:MediaQuery.of(context).size.width / 10 ,)
                    ]),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 150,
                    ),
                    Row(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 14,
                      ),
                      Text(
                        this.aEventModel.city,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ]),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 100,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 130,
                      child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 80,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 14,
                        ),
                        Text(this.aEventModel.goalAmount.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 6,
                        ),
                        Text(noOfDonor.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 6,
                        ),
                        Text(
                            ((this.aEventModel.campaginDays) -
                                        DateTime.now()
                                            .difference((DateTime.parse(
                                                this.aEventModel.createdDate)))
                                            .inDays)
                                    .toString() +
                                " Days",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 14,
                        ),
                        Text("pledged of",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 9,
                        ),
                        Text("Donors",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 10,
                        ),
                        Text("Left",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 14,
                        ),
                        Text(this.aEventModel.collectedAmount.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 9),
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
                              'Donate',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            onPressed: () {
                              //calling Alert box to retreive donate amount
                              customsAlertbox(context).then((value){
                                //Getting document name of donated eventfrom firebase
                                this.firestoreInstance.collection("Events").where('userId',isEqualTo:aEventModel.userId).where('projectName',isEqualTo:this.aEventModel.projectName)
                                .get().then((docName){
                                  //update the donated amount in event document of firebase
                                  this.firestoreInstance.collection("Events")
                                .doc(docName.docs.first.id).
                                update({"collectedAmount":int.parse(value)+this.aEventModel.collectedAmount}).whenComplete(() {
                                 });} );
                                //calling setTransaction method to set data in TransactionModel
                                setTransactionDetail(this.aEventModel.userId,uid, this.aEventModel.projectName, int.parse(value),this.aEventModel.eventNo);
                                // set Trasaction details in firebase
                                this.firestoreInstance.collection("Transactions").
                                doc().set(this.aTransactionModel.toJson()).then((val) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => new SuccessTick(uid),
                                    ),
                                  );
                                });
                                
                                              
                              });
                            })),
                  ],
                ),
              ),
            ]);
          } else
            return CircularProgressIndicator();
        },
      ),
    );
  }
void setTransactionDetail(String creatorUserId,String donorUserId,String projectName,int donateAmount,int eventNo ) {
    this.aTransactionModel.creatorUserId = creatorUserId;
    this.aTransactionModel.donorUserId = donorUserId;
    this.aTransactionModel.projectName = projectName;
    this.aTransactionModel.donateAmount = donateAmount;
    this.aTransactionModel.eventNo = eventNo;
  }
Future<String> customsAlertbox(BuildContext context){
    TextEditingController mycontroller=new TextEditingController();
    return showDialog(
      context:context,
      builder:(context){
        return AlertDialog(
          title: Text("Enter The Amount You Want to Donate",
          style:TextStyle(fontSize: 16,
          fontWeight: FontWeight.w700)),
          backgroundColor: Theme.of(context).focusColor,
          shape: RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(30),
          ),
          content: TextField(
            controller:mycontroller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter Amount",
              hintStyle:TextStyle(fontSize: 16.0,
              fontFamily: "Roboto",)
            ),
          ),
          actions: [
            RaisedButton(
              child:Text("Submit",style: TextStyle(fontSize: 12.0,
              fontFamily: "Roboto",
              ),),
              onPressed: (){
                Navigator.of(context).pop(mycontroller.text);
            }),
            RaisedButton(
               child:Text("Cancel",style: TextStyle(fontSize: 12.0,
              fontFamily: "Roboto",),),
              onPressed: (){
                Navigator.of(context).pop("");
            }
            )
          ],
        );
      },
      barrierDismissible:false,
    );
  }
  List<Image> imagePath(List<String> aIMage)  {
   
    List<Image> img =new List<Image>();
    for (var item in aIMage) {
      img.add(Image.network(item,filterQuality:FilterQuality.medium,width: MediaQuery.of(context).size.width,fit:BoxFit.fill));
    }
    
    return img;
  }

  Future<EventModel> retrieveEvent(String currentProjectuid,String currentProjectName) {
    var completer = new Completer<EventModel>();
    EventModel aEventModel = new EventModel();
    FirebaseFirestore.instance
        .collection("Events")
        .where("userId", isEqualTo: currentProjectuid ).
        where('projectName',isEqualTo: currentProjectName)
        .get()
        .then((value) async {
      await aFileStorage
          .downloadFile(firebase_storage.FirebaseStorage.instance
              .ref()
              .child(currentProjectuid)
              .child("Documents")
              .child("event" + (value.docs.first.data().values.last).toString()))
          .then((value1) {
        aEventModel = EventModel.fromJson(value.docs.first.data());
        aEventModel.multiplePictureLocation = value1;
      });
      completer.complete(aEventModel);
    });
    return completer.future;
  }
}
