class EmergencyContactsResponse {
  List<ContactCategory>? categories;

  EmergencyContactsResponse({this.categories});

  factory EmergencyContactsResponse.fromJson(Map<String, dynamic> json) {
    return EmergencyContactsResponse(
      categories:
          (json['categories'] as List?)
              ?.map((e) => ContactCategory.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ContactCategory {
  String? name;
  String? nameMr;
  List<ContactModel>? contacts;

  ContactCategory({this.name,this.nameMr, this.contacts});

  factory ContactCategory.fromJson(Map<String, dynamic> json) {
    return ContactCategory(
      name: json['name'],
      nameMr: json['nameMr'],

      contacts:
          (json['contacts'] as List?)
              ?.map((e) => ContactModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ContactModel {
  String? name;
  String? nameMr;
  List<String>? phoneNumbers;

  ContactModel({this.name,this.nameMr, this.phoneNumbers});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      name: json['name'],
      nameMr: json['nameMr'],

      phoneNumbers:
          (json['phoneNumbers'] as List?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }
}
