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
  List<ContactModel>? contacts;

  ContactCategory({this.name, this.contacts});

  factory ContactCategory.fromJson(Map<String, dynamic> json) {
    return ContactCategory(
      name: json['name'],

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
  List<String>? phoneNumbers;

  ContactModel({this.name, this.phoneNumbers});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      name: json['name'],

      phoneNumbers:
          (json['phoneNumbers'] as List?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }
}
