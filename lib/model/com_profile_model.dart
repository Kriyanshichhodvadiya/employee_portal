class CompanyProfile {
  String companyName;
  String companySize;
  String industry;
  String description;
  String profileImage;
  String backgroundImage;
  String email;
  String phoneNumber;
  String website;
  String address;
  String country;
  String zipCode;
  String state;
  String city;
  String linkedIn;
  String instagram;
  String foundedYear;
  List<String> services;

  CompanyProfile({
    required this.companyName,
    required this.companySize,
    required this.industry,
    required this.description,
    required this.profileImage,
    required this.backgroundImage,
    required this.email,
    required this.phoneNumber,
    required this.website,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.zipCode,
    required this.linkedIn,
    required this.instagram,
    required this.foundedYear,
    required this.services,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'companySize': companySize,
      'industry': industry,
      'description': description,
      'profileImage': profileImage,
      'backgroundImage': backgroundImage,
      'email': email,
      'phoneNumber': phoneNumber,
      'website': website,
      'address': address,
      'country': country,
      'state': state,
      'city': city,
      'zipCode': zipCode,
      'linkedIn': linkedIn,
      'instagram': instagram,
      'foundedYear': foundedYear,
      'services': services,
    };
  }

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      companyName: json['companyName'] ?? '',
      companySize: json['companySize'] ?? '',
      industry: json['industry'] ?? '',
      description: json['description'] ?? '',
      profileImage: json['profileImage'] ?? '',
      backgroundImage: json['backgroundImage'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      website: json['website'] ?? '',
      address: json['address'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      zipCode: json['zipCode'] ?? '',
      linkedIn: json['linkedIn'] ?? '',
      instagram: json['instagram'] ?? '',
      foundedYear: json['foundedYear'] ?? '',
      services: List<String>.from(json['services'] ?? []),
    );
  }
}

class CountryModel {
  int id;
  String title;
  List<StateModel> states;

  CountryModel({required this.id, required this.title, required this.states});

  // Factory method to create an instance from a Map
  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      title: json['title'],
      states: (json['states'] as List)
          .map((state) => StateModel.fromJson(state))
          .toList(),
    );
  }
}

class StateModel {
  int id;
  String name;
  List<String> cities;

  StateModel({required this.id, required this.name, required this.cities});

  // Factory method to create an instance from a Map
  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      name: json['name'],
      cities: List<String>.from(json['cities']),
    );
  }
}

class IndustryModel {
  final String title;
  final List<String> services;

  IndustryModel({required this.title, required this.services});

  factory IndustryModel.fromMap(Map<String, dynamic> map) {
    return IndustryModel(
      title: map['title'],
      services: List<String>.from(map['service']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'service': services,
    };
  }
}
