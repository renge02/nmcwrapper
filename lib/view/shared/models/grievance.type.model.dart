class MasterDataResponse {
  final dynamic responseInfo;
  final MdmsRes? mdmsRes;

  MasterDataResponse({
    this.responseInfo,
    this.mdmsRes,
  });

  factory MasterDataResponse.fromJson(Map<String, dynamic> json) {
    return MasterDataResponse(
      responseInfo: json['ResponseInfo'],
      mdmsRes: json['MdmsRes'] != null
          ? MdmsRes.fromJson(json['MdmsRes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ResponseInfo': responseInfo,
      'MdmsRes': mdmsRes?.toJson(),
    };
  }
}

class MdmsRes {
  final RainmakerPgr? rainmakerPgr;

  MdmsRes({
    this.rainmakerPgr,
  });

  factory MdmsRes.fromJson(Map<String, dynamic> json) {
    return MdmsRes(
      rainmakerPgr: json['RAINMAKER-PGR'] != null
          ? RainmakerPgr.fromJson(json['RAINMAKER-PGR'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RAINMAKER-PGR': rainmakerPgr?.toJson(),
    };
  }
}

class RainmakerPgr {
  final List<ServiceDef> serviceDefs;

  RainmakerPgr({
    required this.serviceDefs,
  });

  factory RainmakerPgr.fromJson(Map<String, dynamic> json) {
    return RainmakerPgr(
      serviceDefs: (json['ServiceDefs'] as List<dynamic>? ?? [])
          .map((e) => ServiceDef.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ServiceDefs': serviceDefs.map((e) => e.toJson()).toList(),
    };
  }
}

class ServiceDef {
  final String? name;
  final int? order;
  final bool? active;
  final String? keywords;
  final String? menuPath;
  final int? slaHours;
  final String? department;
  final String? serviceCode;

  ServiceDef({
    this.name,
    this.order,
    this.active,
    this.keywords,
    this.menuPath,
    this.slaHours,
    this.department,
    this.serviceCode,
  });

  factory ServiceDef.fromJson(Map<String, dynamic> json) {
    return ServiceDef(
      name: json['name'],
      order: json['order'],
      active: json['active'],
      keywords: json['keywords'],
      menuPath: json['menuPath'],
      slaHours: json['slaHours'],
      department: json['department'],
      serviceCode: json['serviceCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'order': order,
      'active': active,
      'keywords': keywords,
      'menuPath': menuPath,
      'slaHours': slaHours,
      'department': department,
      'serviceCode': serviceCode,
    };
  }
}


