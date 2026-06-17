class ZoneModel {
  ZoneModel({
    required this.code,
    required this.name,
    required this.zoneChildren,
  });
  late final String code;
  late final String name;
  late final List<ZoneChildren> zoneChildren;

  ZoneModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    zoneChildren = List.from(json['children'])
        .map((e) => ZoneChildren.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['children'] = zoneChildren.map((e) => e.toJson()).toList();
    return data;
  }
}

class ZoneChildren {
  ZoneChildren({
    required this.code,
    required this.name,
    required this.boundaryNum,
  });
  late final String code;
  late final String name;
  late final int boundaryNum;

  ZoneChildren.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    boundaryNum = json['boundaryNum'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['boundaryNum'] = boundaryNum;
    return data;
  }
}
