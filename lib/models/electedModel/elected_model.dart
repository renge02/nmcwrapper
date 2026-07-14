class ElectedRepresentativeResponse {
  ModuleName? moduleName;
  List<Category>? categories;

  ElectedRepresentativeResponse({
    this.moduleName,
    this.categories,
  });

  factory ElectedRepresentativeResponse.fromJson(
      Map<String, dynamic> json) {
    return ElectedRepresentativeResponse(
      moduleName: json['moduleName'] != null
          ? ModuleName.fromJson(json['moduleName'])
          : null,
      categories: (json['categories'] as List?)
          ?.map((e) => Category.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "moduleName": moduleName?.toJson(),
      "categories": categories?.map((e) => e.toJson()).toList(),
    };
  }
}

class ModuleName {
  String? en;
  String? mr;

  ModuleName({
    this.en,
    this.mr,
  });

  factory ModuleName.fromJson(Map<String, dynamic> json) {
    return ModuleName(
      en: json['en'],
      mr: json['mr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "en": en,
      "mr": mr,
    };
  }
}

class Category {
  String? id;
  LocalizedText? title;
  RepresentativeDetails? details;

  Category({
    this.id,
    this.title,
    this.details,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'] != null
          ? LocalizedText.fromJson(json['title'])
          : null,
      details: json['details'] != null
          ? RepresentativeDetails.fromJson(json['details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title?.toJson(),
      "details": details?.toJson(),
    };
  }
}

class RepresentativeDetails {
  LocalizedText? name;
  LocalizedText? party;
  String? wardNumber;
  String? mobileNumber;
  LocalizedText? address;
  String? photoUrl;

  RepresentativeDetails({
    this.name,
    this.party,
    this.wardNumber,
    this.mobileNumber,
    this.address,
    this.photoUrl,
  });

  factory RepresentativeDetails.fromJson(
      Map<String, dynamic> json) {
    return RepresentativeDetails(
      name: json['name'] != null
          ? LocalizedText.fromJson(json['name'])
          : null,
      party: json['party'] != null
          ? LocalizedText.fromJson(json['party'])
          : null,
      wardNumber: json['wardNumber'],
      mobileNumber: json['mobileNumber'],
      address: json['address'] != null
          ? LocalizedText.fromJson(json['address'])
          : null,
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name?.toJson(),
      "party": party?.toJson(),
      "wardNumber": wardNumber,
      "mobileNumber": mobileNumber,
      "address": address?.toJson(),
      "photoUrl": photoUrl,
    };
  }
}

class LocalizedText {
  String? en;
  String? mr;

  LocalizedText({
    this.en,
    this.mr,
  });

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(
      en: json['en'],
      mr: json['mr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "en": en,
      "mr": mr,
    };
  }
}