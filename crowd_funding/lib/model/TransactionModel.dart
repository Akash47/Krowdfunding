class TransactionModel{
  String creatorUserId;
  String donorUserId;
  String projectName;
  int donateAmount;
  int eventNo;

  TransactionModel() {
    creatorUserId = "";
    projectName = "";
    donorUserId = "";
    donateAmount=0;
    eventNo=0;
  }
  TransactionModel.fromJson(Map<String, dynamic> json)
      : creatorUserId = json['creatorUserId'],
        projectName = json['projectName'],
        donorUserId = json['donorUserId'],
        donateAmount=json['donateAmount'],
        eventNo=json['eventNo'];
  Map<String, dynamic> toJson() => {
        'donateAmount': this.donateAmount,
        'projectName': this.projectName,
        'donorUserId': this.donorUserId,
        'creatorUserId': this.creatorUserId,
        'eventNo':this.eventNo,
      };
}