class LeaveRequest {
  String srNo;
  String name;
  String startDate;
  String endDate;
  String reason;
  String status; // Pending, Approved, Rejected
  String appliedDateTime; // Date and Time when leave was applied
  String? rejectionReason;

  LeaveRequest({
    required this.srNo,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.status = "Pending",
    required this.appliedDateTime, // New field
    this.rejectionReason,
  });

  // Convert a LeaveRequest object to a Map
  Map<String, dynamic> toJson() {
    return {
      "srNo": srNo,
      "name": name,
      "startDate": startDate,
      "endDate": endDate,
      "reason": reason,
      "status": status,
      "appliedDateTime": appliedDateTime, // Save applied time
      "rejectionReason": rejectionReason,
    };
  }

  // Convert a Map to a LeaveRequest object
  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      srNo: json["srNo"],
      name: json["name"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      reason: json["reason"],
      status: json["status"],
      appliedDateTime: json["appliedDateTime"], // Load applied time
      rejectionReason: json["rejectionReason"],
    );
  }
}
