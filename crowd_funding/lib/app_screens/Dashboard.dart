import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_funding/common/FileStorage.dart';
import 'package:crowd_funding/model/EventModel.dart';
import 'package:flutter/material.dart';
import 'Menu.dart';
import 'MyFundraiseDetailView.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Dashboard extends StatefulWidget {
  final String uid;

  Dashboard({Key key, @required this.uid}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState(uid);
}

class _DashboardState extends State<Dashboard> {
  final String uid;
  _DashboardState(this.uid);
  GlobalKey<ScaffoldState> _dashboardKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _dashboardKey,
      appBar: AppBar(
        title: Text("DASHBOARD",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
        backgroundColor: Color(0xff455A64),
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white70,
          onPressed: () {
            _dashboardKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              print("notification");
            },
            color: Colors.white70,
          ),
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                print("share");
              },
              color: Colors.white70),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print("search");
              },
              color: Colors.white70)
        ],
        elevation: 15,
      ),
      drawer: Menu(this.uid),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: new CarouselWithIndicatorDemo('', this.uid),
    );
  }
}

class CarouselWithIndicatorDemo extends StatefulWidget {
  final String text, uid;
  CarouselWithIndicatorDemo(this.text, this.uid);
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState('', this.uid);
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  final String text, uid;
  _CarouselWithIndicatorState(this.text, this.uid);
  int _current = 0;
  final CollectionReference firebaseEvents =
      FirebaseFirestore.instance.collection('Event');
  FileStorage aFileStorage = new FileStorage();
  List<EventModel> aEventModel;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: retrieveEvent(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<EventModel> aEventModel = snapshot.data;
          return Column(children: [
            SizedBox(
              height: 20,
            ),
            CarouselSlider(
              items: aEventModel.map((item) {
                EventModel aEvent = item;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => new MyFundraiseDetailView(
                            uid: this.uid,
                            currentProjectUid: aEvent.userId,
                            currentProjectName: aEvent.projectName),
                      ),
                    );
                  },
                  child: Container(
                     height: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: new Container(
                        // height: MediaQuery.of(context).size.height,
                        child: new Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            //mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 95,
                              ),
                              new Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 20,
                                  ),
                                  new Align(
                                    alignment: Alignment.topLeft,
                                    child: new Container(
                                        child: CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width / 6,
                                      child: ClipOval(
                                        child: new SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                5,
                                            child: Image.network(
                                              aEvent.pictureLocation,
                                              fit: BoxFit.fill,
                                            )),
                                      ),
                                    )),
                                  ),
                                  // SizedBox(
                                  //   width:
                                  //       MediaQuery.of(context).size.width / ,
                                  // ),
                                  Column(
                                    children: [
                                      new Align(
                                        alignment: Alignment.topCenter,
                                        child: new Text(
                                          aEvent.projectName,
                                          style: new TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                45,
                                      ),
                                      new Align(
                                        alignment: Alignment.topCenter,
                                        child: new Text(
                                          aEvent.goalAmount.toString(),
                                          style: new TextStyle(
                                            fontSize: 18,
                                            // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      new Align(
                                        alignment: Alignment.topCenter,
                                        child: new Text(
                                          "pledged Of",
                                          style: new TextStyle(
                                            fontSize: 18,
                                            // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      new Align(
                                        alignment: Alignment.topCenter,
                                        child: new Text(
                                          aEvent.collectedAmount.toString(),
                                          style: new TextStyle(
                                            fontSize: 18,
                                            // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              
                              new Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 20,
                                  ),
                                  new Align(
                                      alignment: Alignment.centerLeft,
                                      child: new Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        child: Center(
                                            child: noOfLeftDays(
                                                (DateTime.parse(
                                                    aEvent.createdDate)),
                                                aEvent.campaginDays)),
                                        decoration: new BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6)),
                                      )),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 12,
                                  ),
                                  new Align(
                                    alignment: Alignment.centerRight,
                                    heightFactor: 5.4,
                                    child: new Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              35,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      // ignore: unrelated_type_equality_checks
                                      child: Center(
                                          child: currentStatus(
                                              (DateTime.parse(
                                                  aEvent.createdDate)),
                                              aEvent.campaginDays)),
                                      // ignore: unrelated_type_equality_checks
                                      decoration: (new DateTime.now()
                                                  .difference(DateTime.parse(
                                                      aEvent.createdDate)) ==
                                              0)
                                          ? new BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          6))
                                          : new BoxDecoration(
                                              color: Colors.yellow,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          6)),
                                    ),
                                  )
                                ],
                              )
                            ]),
                        decoration: new BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width / 8),
                        ),
                      ),
                    ),
                    //   ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                  height: MediaQuery.of(context).size.height / 2.4,
                  autoPlay: true,
                  enlargeCenterPage: true,
                   aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ]);
        } else
          return CircularProgressIndicator();
      },
    );
  }

  Widget noOfLeftDays(DateTime aDate, int campaginDays) {
    var leftDays = DateTime.now().difference(aDate).inDays;
    if (leftDays < campaginDays) {
      return new Text(
        (campaginDays - leftDays).toString() + " Days Remain",
        textAlign: TextAlign.center,
      );
    } else if (leftDays == campaginDays) {
      return new Text(
        "Today",
      );
    } else {
      return new Text("Time Over");
    }
  }

  Widget currentStatus(DateTime aDate, int campaginDays) {
    var leftDays = DateTime.now().difference(aDate).inDays;
    if (leftDays <= campaginDays) {
      return new Text("In Progress");
    } else {
      return new Text("Finished");
    }
  }

  Future<List<EventModel>> retrieveEvent() {
    var completer = new Completer<List<EventModel>>();
    FirebaseFirestore.instance
        .collection("Events")
        .where('userId', isNotEqualTo: uid)
        .get()
        .then((value) async {
      List<EventModel> aEventModelList = new List<EventModel>();
      print(value.docs);
      for (var item in value.docs) {
        EventModel aEventModel = EventModel.fromJson(item.data());
        var i = aEventModel.eventNo;
        var currentUid = aEventModel.userId;
        if (aEventModel.goalAmount > aEventModel.collectedAmount) {
          await aFileStorage
              .downloadFile(firebase_storage.FirebaseStorage.instance
                  .ref()
                  .child(currentUid.toString())
                  .child("Documents")
                  .child("event" + i.toString()))
              .then((docPics) {
            EventModel aEventModel = new EventModel();
            aEventModel = EventModel.fromJson(item.data());
            aEventModel.pictureLocation = docPics.first;
            aEventModelList.add(aEventModel);
          });
        }
      }
      completer.complete(aEventModelList);
    });
    return completer.future;
  }
}
