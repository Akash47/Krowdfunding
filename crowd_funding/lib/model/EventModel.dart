class EventModel {
  String ownerName;
  String projectName;
  String city;
  String campaginDiscription;
  int campaginDays;
  int eventNo;
  int goalAmount;
  int collectedAmount;
  String category;
  String createdDate;
  String pictureLocation;
  List<String> multiplePictureLocation;
  String userId;

  EventModel() {
    ownerName = "";
    projectName = "";
    city="";
    campaginDiscription = "";
    campaginDays = 0;
    eventNo=0;
    goalAmount = 0;
    collectedAmount=0;
    category = '';
    createdDate = '';
    pictureLocation = "";
    multiplePictureLocation=[];
    userId = "";
  }
  EventModel.fromJson(Map<String, dynamic> json)
      : ownerName = json['ownerName'],
        projectName = json['projectName'],
        city = json['city'],
        campaginDiscription = json['campaginDiscription'],
        campaginDays = json['campaginDays'],
        goalAmount = json['goalAmount'],
        eventNo=json['eventNo'],
        collectedAmount = json['collectedAmount'],
        category = json['category'],
        createdDate = json['createdDate'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
        'ownerName': this.ownerName,
        'projectName': this.projectName,
        'campaginDiscription': this.campaginDiscription,
        'city':this.city,
        'createdDate': this.createdDate,
        'eventNo':this.eventNo,
        'goalAmount': this.goalAmount,
        'collectedAmount': this.collectedAmount,
        'category': this.category,
        'campaginDays': this.campaginDays,
        'userId': this.userId,
      };
}
