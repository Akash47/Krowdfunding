import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_funding/app_screens/MyFundraise.dart';
import 'package:crowd_funding/common/FileStorage.dart';
import 'package:crowd_funding/model/EventModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'MyFundraiseDetailView.dart';
import 'Dashboard.dart';
class MyDonation extends StatelessWidget {
  String text, uid;
  MyDonation(  this.text, this.uid);
  // final CollectionReference firebaseEvents =
  //     FirebaseFirestore.instance.collection('Event');
  FileStorage aFileStorage = new FileStorage();
  List<EventModel> aEventModel=new List<EventModel>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text(
        this.text,
        style: new TextStyle(color: Colors.white),
      ),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white70,
          onPressed: () {
             Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new Dashboard(uid:this.uid),
            ),
          );
          },
        )
      ),
      body: FutureBuilder(
        future: retrieveEvent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            this.aEventModel = snapshot.data;
            return ListView.separated(
              shrinkWrap: true,
              itemCount: aEventModel.length,
              separatorBuilder: (context, index) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height / 25);
              },
              itemBuilder: (context, index) {
                return new InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => new MyFundraiseDetailView(uid:this.uid,currentProjectUid:this.aEventModel.elementAt(index).userId,currentProjectName:this.aEventModel.elementAt(index).projectName),
                      ),
                    );
                  },
                  child: new Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 6,
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          new Align(
                            alignment: Alignment.centerLeft,
                            child: new Container(
                                child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 8,
                              child: ClipOval(
                                child: new SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                    child: Image.network(this
                                          .aEventModel
                                          .elementAt(index)
                                          .pictureLocation,
                                      fit: BoxFit.fill,
                                    )),
                              ),
                            )),
                          ),
                          new Align(
                              alignment: Alignment.topCenter,
                              child: new Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  new Align(
                                    alignment: Alignment.topLeft,
                                    child: new Text(
                                      this
                                          .aEventModel
                                          .elementAt(index)
                                          .projectName,
                                      style: new TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Column(children: [
                                    new Align(
                                    alignment: Alignment.topLeft,
                                    child: new Text(
                                      this.aEventModel
                                          .elementAt(index)
                                          .goalAmount.toString(),
                                      style: new TextStyle(
                                          fontSize: 18,
                                          ),
                                    ),
                                  ),
                                  new Align(
                                    alignment: Alignment.topLeft,
                                    child: new Text(
                                      " pledged of",
                                      style: new TextStyle(
                                          fontSize: 18,
                                          ),
                                    ),
                                  ),
                                  new Align(
                                    alignment: Alignment.topLeft,
                                    child: new Text(
                                      this.aEventModel
                                          .elementAt(index)
                                          .collectedAmount.toString(),
                                      style: new TextStyle(
                                          fontSize: 18,
                                           ),
                                    ),
                                  ),
                                  ],),
                                   new Align(
                                      alignment: Alignment.bottomLeft,
                                      child: new Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        child:Center(child:noOfLeftDays((DateTime.parse(
                                                        this
                                                            .aEventModel
                                                            .elementAt(index)
                                                            .createdDate)),this
                                                            .aEventModel
                                                            .elementAt(index)
                                                            .campaginDays)),
                                        decoration: new BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6)),
                                      ))
                                  ],),
                                 ),
                                
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 16,
                            height: MediaQuery.of(context).size.height / 28,
                          ),
                          new Align(
                            alignment: Alignment.bottomRight,
                            heightFactor: 5.4,
                            child: new Container(
                              height: MediaQuery.of(context).size.height / 30,
                              width: MediaQuery.of(context).size.width / 3,
                              // ignore: unrelated_type_equality_checks
                              child: Center(child:currentStatus((DateTime.parse(
                                                        this
                                                            .aEventModel
                                                            .elementAt(index)
                                                            .createdDate)),this
                                                            .aEventModel
                                                            .elementAt(index)
                                                            .campaginDays)),
                              // ignore: unrelated_type_equality_checks
                              decoration: (new DateTime.now().difference(
                                          DateTime.parse(this
                                              .aEventModel
                                              .elementAt(index)
                                              .createdDate)) ==
                                      0)
                                  ? new BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width /
                                              6))
                                  : new BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width /
                                              6)),
                            ),
                          )
                        ]),
                    decoration: new BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width / 8),
                    ),
                  ),
                );
              },
            );
          }
          return new CircularProgressIndicator(strokeWidth:10.0);
        },
      ),
      // floatingActionButton: new FloatingActionButton(
      //   child: new Icon(Icons.add),
      //   backgroundColor: Theme.of(context).buttonColor,
      //   onPressed: () {
      //     print(uid);
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => new MyFundraise("My Fundraise",uid),
      //       ),
      //     );
      //   },
      // ),
    );
  }
  Widget noOfLeftDays(DateTime aDate ,int campaginDays){
    var leftDays= DateTime.now().difference(aDate).inDays;
          if(leftDays<campaginDays){
          return  new  Text((campaginDays-leftDays).toString()+" Days Remain",textAlign: TextAlign.center,);
          }
          else if(leftDays==campaginDays){
           return new Text("Today",);
          }
          else{
            return new Text("Time Over");
          }
  }
  Widget currentStatus(DateTime aDate ,int campaginDays){
    var leftDays= DateTime.now().difference(aDate).inDays;
          if(leftDays<=campaginDays){
          return  new  Text("In Progress");
          }
          else{
            return new Text("Finished");
          }
  }
  Future<List<EventModel>> retrieveEvent() {
    var completer = new Completer<List<EventModel>>();
    List<EventModel> aEventModelList = new List<EventModel>();
    FirebaseFirestore.instance.collection("Transactions").where('donorUserId',isEqualTo: uid).get().then((transactionValue) async{
      for (var itemss in transactionValue.docs) { 
       var uidPath=itemss.data().values.elementAt(2).toString();
        await FirebaseFirestore.instance.collection("Events").where('userId',isEqualTo:uidPath).where('projectName',isEqualTo:itemss.data().values.elementAt(3).toString()).get().then((value) async {
        for (var item in value.docs) {
         await aFileStorage
            .downloadFile(firebase_storage.FirebaseStorage.instance
                .ref()
                .child(uidPath)
                .child("Documents").child("event"+item.data().values.last.toString()))
            .then((value1) {
          EventModel aEventModel = new EventModel();
          aEventModel = EventModel.fromJson(item.data());
          aEventModel.pictureLocation = value1.first;
          aEventModelList.add(aEventModel);
        });
      }
      });
      }
       completer.complete(aEventModelList); 
    });
     return completer.future;
  }
}