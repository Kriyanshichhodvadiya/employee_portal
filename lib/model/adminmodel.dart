class AdminModel {
  String companyName;
  String adminName;
  String address;
  String mobileNumber;
  String email;
  String password;
  int registrationNumber;
  String? profileImage; // Optional (file path)

  AdminModel({
    required this.companyName,
    required this.adminName,
    required this.address,
    required this.mobileNumber,
    required this.email,
    required this.password,
    required this.registrationNumber,
    this.profileImage,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "companyName": companyName,
      "adminName": adminName,
      "address": address,
      "mobileNumber": mobileNumber,
      "email": email,
      "password": password,
      "registrationNumber": registrationNumber,
      "profileImage": profileImage,
    };
  }

  // Convert from JSON
  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      companyName: json["companyName"],
      adminName: json["adminName"],
      address: json["address"],
      mobileNumber: json["mobileNumber"],
      email: json["email"],
      password: json["password"],
      registrationNumber: json["registrationNumber"],
      profileImage: json["profileImage"],
    );
  }
}
