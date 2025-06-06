class TaskModel {
  String employeeName;
  String employeeLastName;

  String srNo;
  String task;
  String date;
  String appliedTime;
  String? startTime;
  String? finishTime;
  String? holdTime;
  String? reasonForHold;
  String? status;

  TaskModel(
      {required this.employeeName,
      required this.employeeLastName,
      required this.srNo,
      required this.task,
      required this.date,
      required this.appliedTime,
      this.startTime,
      this.finishTime,
      this.holdTime,
      this.reasonForHold,
      this.status});

  // Convert a TaskModel object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      "employeeName": employeeName,
      "employeeLastName": employeeLastName,
      "srNo": srNo,
      "task": task,
      "date": date,
      "appliedTime": appliedTime,
      "startTime": startTime,
      "finishTime": finishTime,
      "holdTime": holdTime,
      "reasonForHold": reasonForHold,
      "status": status,
    };
  }

  // Convert a Map (JSON) to a TaskModel object
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      employeeName: json["employeeName"],
      employeeLastName: json["employeeLastName"],
      srNo: json["srNo"],
      task: json["task"],
      date: json["date"],
      appliedTime: json["appliedTime"],
      startTime: json["startTime"],
      finishTime: json["finishTime"],
      holdTime: json["holdTime"],
      reasonForHold: json["reasonForHold"],
      status: json["status"],
    );
  }
}
