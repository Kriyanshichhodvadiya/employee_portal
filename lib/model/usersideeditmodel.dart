class EmployeeModel {
  String srNo;
  String fname;
  String lname;
  String address;
  String email;
  String mobile1;
  String mobile2;
  String imagePath;

  EmployeeModel({
    required this.srNo,
    required this.fname,
    required this.lname,
    required this.address,
    required this.email,
    required this.mobile1,
    required this.mobile2,
    required this.imagePath,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      srNo: json['srNo'],
      fname: json['fname'],
      lname: json['lname'],
      address: json['address'],
      email: json['email'],
      mobile1: json['mobile1'],
      mobile2: json['mobile2'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'srNo': srNo,
      'fname': fname,
      'lname': lname,
      'address': address,
      'email': email,
      'mobile1': mobile1,
      'mobile2': mobile2,
      'imagePath': imagePath,
    };
  }
}
