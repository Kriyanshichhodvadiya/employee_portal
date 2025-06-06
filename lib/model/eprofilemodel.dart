import 'dart:io';

import 'package:employeeform/model/task_model.dart';

import 'leaverequest_model.dart';

class UserProfile {
  String image;
  String firstName;
  String middleName;
  String lastName;
  String address;
  String? country;
  String? state;
  String? city;
  String? zipCode;
  String? password;
  String? confirmPass;
  String aadhar;
  String gender;
  String birthDate;
  String mobilenoone;
  String mobilentwo;
  String email;
  String bankName;
  String branchAddress;
  String accountNumber;
  String ifscCode;
  String reference;
  String employmentType;
  String dateFrom;
  String srNo;
  String adminsrNo;
  List<String> documents;
  List attachProof;
  bool attendance;
  List<LeaveRequest> leaveRequests;
  List<TaskModel> taskRequests;
  Map<String, File?> uploadedDocuments;
  UploadedDocumentsModel? attachedFiles;

  UserProfile({
    required this.image,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.address,
    this.country,
    this.state,
    this.city,
    this.password,
    this.confirmPass,
    this.zipCode,
    required this.aadhar,
    required this.gender,
    required this.birthDate,
    required this.mobilenoone,
    required this.mobilentwo,
    required this.email,
    required this.bankName,
    required this.branchAddress,
    required this.accountNumber,
    required this.ifscCode,
    required this.reference,
    required this.employmentType,
    this.dateFrom = '',
    this.adminsrNo = '',
    required this.srNo,
    required this.documents,
    required this.attachProof,
    this.attendance = false,
    this.leaveRequests = const [],
    this.taskRequests = const [],
    required this.uploadedDocuments,
    this.attachedFiles,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'address': address,
      'country': country,
      'state': state,
      'city': city,
      'password': password,
      'confirmPass': confirmPass,
      'zipCode': zipCode,
      'aadhar': aadhar,
      'gender': gender,
      'birthdate': birthDate,
      'mobileNumber': mobilenoone,
      'mobileNumberTwo': mobilentwo,
      'email': email,
      'bankname': bankName,
      'branchAddress': branchAddress,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'reference': reference,
      'employeetype': employmentType,
      'joindate': dateFrom,
      'srNo': srNo,
      'adminsrNo': adminsrNo,
      'proof': documents,
      'attachProof': attachProof,
      'attendance': attendance,
      'leaveRequests': leaveRequests.map((leave) => leave.toJson()).toList(),
      'taskRequests': taskRequests.map((task) => task.toJson()).toList(),
      'uploadedDocuments':
          uploadedDocuments.map((key, value) => MapEntry(key, value?.path)),
      'attachedFiles': attachedFiles!.toJson(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      image: map['image'] ?? '',
      firstName: map['firstName'] ?? '',
      middleName: map['middleName'] ?? '',
      lastName: map['lastName'] ?? '',
      address: map['address'] ?? '',
      country: map['country'],
      state: map['state'],
      city: map['city'],
      password: map['password'],
      confirmPass: map['confirmPass'],
      zipCode: map['zipCode'],
      aadhar: map['aadhar'] ?? '',
      gender: map['gender'] ?? '',
      birthDate: map['birthdate'] ?? '',
      mobilenoone: map['mobileNumber'] ?? '',
      mobilentwo: map['mobileNumberTwo'] ?? '',
      email: map['email'] ?? '',
      bankName: map['bankname'] ?? '',
      branchAddress: map['branchAddress'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      ifscCode: map['ifscCode'] ?? '',
      reference: map['reference'] ?? '',
      employmentType: map['employeetype'] ?? '',
      dateFrom: map['joindate'] ?? '',
      srNo: map['srNo'] ?? '',
      adminsrNo: map['adminsrNo'] ?? '',
      documents: List<String>.from(map['proof'] ?? []),
      attachProof: List.from(map['attachProof'] ?? []),
      attendance: map['attendance'] ?? false,
      leaveRequests: (map['leaveRequests'] as List?)
              ?.map((e) => LeaveRequest.fromJson(e))
              .toList() ??
          [],
      taskRequests: (map['taskRequests'] as List?)
              ?.map((e) => TaskModel.fromJson(e))
              .toList() ??
          [],
      uploadedDocuments: (map['uploadedDocuments'] as Map<String, dynamic>?)
              ?.map((key, value) =>
                  MapEntry(key, value != null ? File(value) : null)) ??
          {},
      attachedFiles: map['attachedFiles'] != null
          ? UploadedDocumentsModel.fromJson(
              Map<String, dynamic>.from(map['attachedFiles']))
          : UploadedDocumentsModel(),
    );
  }
}

class UploadedDocumentsModel {
  AadharCardModel? aadharCard;
  File? bankPassbookFile;
  List<OtherDocumentsModel> otherFiles;

  UploadedDocumentsModel({
    this.aadharCard,
    this.bankPassbookFile,
    this.otherFiles = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'aadharCard': aadharCard?.toMap(),
      'bankPassbookFile': bankPassbookFile?.path,
      'otherFiles': otherFiles.map((file) => file.toJson()).toList(),
    };
  }

  factory UploadedDocumentsModel.fromJson(Map<String, dynamic> json) {
    return UploadedDocumentsModel(
      aadharCard: json['aadharCard'] != null
          ? AadharCardModel.fromMap(
              json['aadharCard']) // Deserialize AadharCardModel
          : null,
      bankPassbookFile: json['bankPassbookFile'] != null
          ? File(json['bankPassbookFile'])
          : null,
      otherFiles: (json['otherFiles'] as List<dynamic>? ?? [])
          .map((item) => OtherDocumentsModel.fromJson(item))
          .toList(),
    );
  }
}

class AadharCardModel {
  String frontSidePath;
  String backSidePath;

  AadharCardModel({
    required this.frontSidePath,
    required this.backSidePath,
  });

  // Method to convert a map to an instance of AadharCardModel
  factory AadharCardModel.fromMap(Map<String, dynamic> map) {
    return AadharCardModel(
      frontSidePath: map['frontSidePath'] ?? '',
      backSidePath: map['backSidePath'] ?? '',
    );
  }

  // Method to convert an AadharCardModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'frontSidePath': frontSidePath,
      'backSidePath': backSidePath,
    };
  }
}

class OtherDocumentsModel {
  String? name;
  bool? check;
  File? otherFile;

  OtherDocumentsModel({
    this.name,
    this.check,
    this.otherFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'check': check,
      'otherFile': otherFile?.path,
    };
  }

  factory OtherDocumentsModel.fromJson(Map<String, dynamic> json) {
    return OtherDocumentsModel(
      name: json['name'],
      check: json['check'],
      otherFile: json['otherFile'] != null ? File(json['otherFile']) : null,
    );
  }
}

class AdminProfileModel {
  String image;
  String firstName;
  String middleName;
  String lastName;
  String address;
  String? country;
  String? state;
  String? city;
  String? zipCode;
  String? password;
  String? confirmPass;
  String aadhar;
  String gender;
  String birthDate;
  String mobilenoone;
  String mobilentwo;
  String email;
  String bankName;
  String branchAddress;
  String accountNumber;
  String ifscCode;
  String reference;
  String employmentType;
  String dateFrom;
  String srNo;
  String adminsrNo;
  List<String> documents;
  List attachProof;
  bool attendance;
  List<UserProfile> allUser;
  List<LeaveRequest> leaveRequests;
  List<TaskModel> taskRequests;
  UploadedDocumentsModel? attachedFiles;

  AdminProfileModel({
    required this.image,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.address,
    this.country,
    this.state,
    this.city,
    this.password,
    this.confirmPass,
    this.zipCode,
    required this.aadhar,
    required this.gender,
    required this.birthDate,
    required this.mobilenoone,
    required this.mobilentwo,
    required this.email,
    required this.bankName,
    required this.branchAddress,
    required this.accountNumber,
    required this.ifscCode,
    required this.reference,
    required this.employmentType,
    this.dateFrom = '',
    this.adminsrNo = '',
    required this.srNo,
    required this.documents,
    required this.attachProof,
    this.attendance = false,
    this.leaveRequests = const [],
    this.allUser = const [],
    this.taskRequests = const [],
    this.attachedFiles,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'address': address,
      'country': country,
      'state': state,
      'city': city,
      'password': password,
      'confirmPass': confirmPass,
      'zipCode': zipCode,
      'aadhar': aadhar,
      'gender': gender,
      'birthdate': birthDate,
      'mobileNumber': mobilenoone,
      'mobileNumberTwo': mobilentwo,
      'email': email,
      'bankname': bankName,
      'branchAddress': branchAddress,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'reference': reference,
      'employeetype': employmentType,
      'joindate': dateFrom,
      'srNo': srNo,
      'adminsrNo': adminsrNo,
      'proof': documents,
      'attachProof': attachProof,
      'attendance': attendance,
      'leaveRequests': leaveRequests.map((leave) => leave.toJson()).toList(),
      'allUser': allUser.map((user) => user.toMap()).toList(),
      'taskRequests': taskRequests.map((task) => task.toJson()).toList(),
      'attachedFiles': attachedFiles!.toJson(),
    };
  }

  factory AdminProfileModel.fromMap(Map<String, dynamic> map) {
    return AdminProfileModel(
      image: map['image'] ?? '',
      firstName: map['firstName'] ?? '',
      middleName: map['middleName'] ?? '',
      lastName: map['lastName'] ?? '',
      address: map['address'] ?? '',
      country: map['country'],
      state: map['state'],
      city: map['city'],
      password: map['password'],
      confirmPass: map['confirmPass'],
      zipCode: map['zipCode'],
      aadhar: map['aadhar'] ?? '',
      gender: map['gender'] ?? '',
      birthDate: map['birthdate'] ?? '',
      mobilenoone: map['mobileNumber'] ?? '',
      mobilentwo: map['mobileNumberTwo'] ?? '',
      email: map['email'] ?? '',
      bankName: map['bankname'] ?? '',
      branchAddress: map['branchAddress'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      ifscCode: map['ifscCode'] ?? '',
      reference: map['reference'] ?? '',
      employmentType: map['employeetype'] ?? '',
      dateFrom: map['joindate'] ?? '',
      srNo: map['srNo'] ?? '',
      adminsrNo: map['adminsrNo'] ?? '',
      documents: List<String>.from(map['proof'] ?? []),
      attachProof: List.from(map['attachProof'] ?? []),
      attendance: map['attendance'] ?? false,
      leaveRequests: (map['leaveRequests'] as List?)
              ?.map((e) => LeaveRequest.fromJson(e))
              .toList() ??
          [],
      allUser: (map['allUser'] as List?)
              ?.map((e) => UserProfile.fromMap(e))
              .toList() ??
          [],
      taskRequests: (map['taskRequests'] as List?)
              ?.map((e) => TaskModel.fromJson(e))
              .toList() ??
          [],
      attachedFiles: map['attachedFiles'] != null
          ? UploadedDocumentsModel.fromJson(
              Map<String, dynamic>.from(map['attachedFiles']))
          : UploadedDocumentsModel(),
    );
  }
}
