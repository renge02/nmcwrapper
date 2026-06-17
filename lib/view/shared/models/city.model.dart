class CityModuleResponse {
  final dynamic responseInfo;
  final MdmsRes? mdmsRes;

  CityModuleResponse({
    this.responseInfo,
    this.mdmsRes,
  });

  factory CityModuleResponse.fromJson(Map<String, dynamic> json) {
    return CityModuleResponse(
      responseInfo: json['ResponseInfo'],
      mdmsRes:
      json['MdmsRes'] != null ? MdmsRes.fromJson(json['MdmsRes']) : null,
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
  final TenantModule? tenant;

  MdmsRes({this.tenant});

  factory MdmsRes.fromJson(Map<String, dynamic> json) {
    return MdmsRes(
      tenant:
      json['tenant'] != null
          ? TenantModule.fromJson(json['tenant'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenant': tenant?.toJson(),
    };
  }
}

class TenantModule {
  final List<CityModule> citymodule;

  TenantModule({required this.citymodule});

  factory TenantModule.fromJson(Map<String, dynamic> json) {
    return TenantModule(
      citymodule:
      (json['citymodule'] as List?)
          ?.map((e) => CityModule.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'citymodule': citymodule.map((e) => e.toJson()).toList(),
    };
  }
}

class CityModule {
  final String? module;
  final String? code;
  final String? bannerImage;
  final bool? active;
  final int? order;
  final String? helpLineNumber;
  final String? helplineForSmartStreetLightComplaint;
  final String? additionalComponent;
  final List<TenantCode> tenants;

  CityModule({
    this.module,
    this.code,
    this.bannerImage,
    this.active,
    this.order,
    this.helpLineNumber,
    this.helplineForSmartStreetLightComplaint,
    this.additionalComponent,
    required this.tenants,
  });

  factory CityModule.fromJson(Map<String, dynamic> json) {
    return CityModule(
      module: json['module'],
      code: json['code'],
      bannerImage: json['bannerImage'],
      active: json['active'],
      order: json['order'],
      helpLineNumber: json['helpLineNumber'],
      helplineForSmartStreetLightComplaint:
      json['HelplineForSmartStreetLightComplaint'],
      additionalComponent: json['additionalComponent'],
      tenants:
      (json['tenants'] as List?)
          ?.map((e) => TenantCode.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'module': module,
      'code': code,
      'bannerImage': bannerImage,
      'active': active,
      'order': order,
      'helpLineNumber': helpLineNumber,
      'HelplineForSmartStreetLightComplaint':
      helplineForSmartStreetLightComplaint,
      'additionalComponent': additionalComponent,
      'tenants': tenants.map((e) => e.toJson()).toList(),
    };
  }
}

class TenantCode {
  final String? code;

  TenantCode({this.code});

  factory TenantCode.fromJson(Map<String, dynamic> json) {
    return TenantCode(
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
    };
  }
}