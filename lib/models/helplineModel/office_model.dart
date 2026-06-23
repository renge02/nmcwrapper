class OfficeModel {
  final String name;
  final String phone;
  final String email;
  final String address;
  final String otherInformation;

  OfficeModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.otherInformation,
  });

  factory OfficeModel.fromJson(Map<String, dynamic> json) {
    return OfficeModel(
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      address: json["address"] ?? "",
      otherInformation: json["otherInformation"] ?? "",
    );
  }
}