class GrievanceDetailsResponse {
  ResponseInfo? responseInfo;
  List<ServiceWrapper>? serviceWrappers;
  int? complaintsResolved;
  int? averageResolutionTime;
  int? complaintTypes;

  GrievanceDetailsResponse({
    this.responseInfo,
    this.serviceWrappers,
    this.complaintsResolved,
    this.averageResolutionTime,
    this.complaintTypes,
  });

  factory GrievanceDetailsResponse.fromJson(Map<String, dynamic> json) {
    return GrievanceDetailsResponse(
      responseInfo: json['responseInfo'] != null
          ? ResponseInfo.fromJson(json['responseInfo'])
          : null,
      serviceWrappers: (json['ServiceWrappers'] as List?)
          ?.map((e) => ServiceWrapper.fromJson(e))
          .toList(),
      complaintsResolved: json['complaintsResolved'],
      averageResolutionTime: json['averageResolutionTime'],
      complaintTypes: json['complaintTypes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'responseInfo': responseInfo?.toJson(),
    'ServiceWrappers':
    serviceWrappers?.map((e) => e.toJson()).toList(),
    'complaintsResolved': complaintsResolved,
    'averageResolutionTime': averageResolutionTime,
    'complaintTypes': complaintTypes,
  };
}

class ResponseInfo {
  String? apiId;
  String? msgId;
  String? resMsgId;
  String? status;

  ResponseInfo({
    this.apiId,
    this.msgId,
    this.resMsgId,
    this.status,
  });

  factory ResponseInfo.fromJson(Map<String, dynamic> json) {
    return ResponseInfo(
      apiId: json['apiId'],
      msgId: json['msgId'],
      resMsgId: json['resMsgId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'apiId': apiId,
    'msgId': msgId,
    'resMsgId': resMsgId,
    'status': status,
  };
}

class ServiceWrapper {
  Service? service;
  Workflow? workflow;

  ServiceWrapper({
    this.service,
    this.workflow,
  });

  factory ServiceWrapper.fromJson(Map<String, dynamic> json) {
    return ServiceWrapper(
      service:
      json['service'] != null ? Service.fromJson(json['service']) : null,
      workflow: json['workflow'] != null
          ? Workflow.fromJson(json['workflow'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'service': service?.toJson(),
    'workflow': workflow?.toJson(),
  };
}

class Service {
  bool? active;
  String? id;
  String? tenantId;
  String? serviceCode;
  String? serviceRequestId;
  String? description;
  String? applicationStatus;
  String? priority;
  String? department;

  Citizen? citizen;
  Address? address;
  AuditDetails? auditDetails;

  Service({
    this.active,
    this.id,
    this.tenantId,
    this.serviceCode,
    this.serviceRequestId,
    this.description,
    this.applicationStatus,
    this.priority,
    this.department,
    this.citizen,
    this.address,
    this.auditDetails,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      active: json['active'],
      id: json['id'],
      tenantId: json['tenantId'],
      serviceCode: json['serviceCode'],
      serviceRequestId: json['serviceRequestId'],
      description: json['description'],
      applicationStatus: json['applicationStatus'],
      priority: json['priority'],
      department: json['department'],
      citizen:
      json['citizen'] != null ? Citizen.fromJson(json['citizen']) : null,
      address:
      json['address'] != null ? Address.fromJson(json['address']) : null,
      auditDetails: json['auditDetails'] != null
          ? AuditDetails.fromJson(json['auditDetails'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'active': active,
    'id': id,
    'tenantId': tenantId,
    'serviceCode': serviceCode,
    'serviceRequestId': serviceRequestId,
    'description': description,
    'applicationStatus': applicationStatus,
    'priority': priority,
    'department': department,
    'citizen': citizen?.toJson(),
    'address': address?.toJson(),
    'auditDetails': auditDetails?.toJson(),
  };
}

class Citizen {
  int? id;
  String? userName;
  String? name;
  String? mobileNumber;
  String? emailId;
  String? uuid;

  Citizen({
    this.id,
    this.userName,
    this.name,
    this.mobileNumber,
    this.emailId,
    this.uuid,
  });

  factory Citizen.fromJson(Map<String, dynamic> json) {
    return Citizen(
      id: json['id'],
      userName: json['userName'],
      name: json['name'],
      mobileNumber: json['mobileNumber'],
      emailId: json['emailId'],
      uuid: json['uuid'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'name': name,
    'mobileNumber': mobileNumber,
    'emailId': emailId,
    'uuid': uuid,
  };
}

class Address {
  String? city;
  String? district;
  String? region;
  String? street;
  String? state;
  String? landmark;
  String? pincode;

  Locality? locality;
  GeoLocation? geoLocation;

  Address({
    this.city,
    this.district,
    this.region,
    this.street,
    this.state,
    this.landmark,
    this.pincode,
    this.locality,
    this.geoLocation,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'],
      district: json['district'],
      region: json['region'],
      street: json['street'],
      state: json['state'],
      landmark: json['landmark'],
      pincode: json['pincode'],
      locality: json['locality'] != null
          ? Locality.fromJson(json['locality'])
          : null,
      geoLocation: json['geoLocation'] != null
          ? GeoLocation.fromJson(json['geoLocation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'district': district,
    'region': region,
    'street': street,
    'landmark': landmark,
    'state': state,
    'pincode': pincode,
    'locality': locality?.toJson(),
    'geoLocation': geoLocation?.toJson(),
  };
}

class Locality {
  String? code;

  Locality({this.code});

  factory Locality.fromJson(Map<String, dynamic> json) {
    return Locality(
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
  };
}

class GeoLocation {
  double? latitude;
  double? longitude;

  GeoLocation({
    this.latitude,
    this.longitude,
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}

class AuditDetails {
  String? createdBy;
  String? lastModifiedBy;
  int? createdTime;
  int? lastModifiedTime;

  AuditDetails({
    this.createdBy,
    this.lastModifiedBy,
    this.createdTime,
    this.lastModifiedTime,
  });

  factory AuditDetails.fromJson(Map<String, dynamic> json) {
    return AuditDetails(
      createdBy: json['createdBy'],
      lastModifiedBy: json['lastModifiedBy'],
      createdTime: json['createdTime'],
      lastModifiedTime: json['lastModifiedTime'],
    );
  }

  Map<String, dynamic> toJson() => {
    'createdBy': createdBy,
    'lastModifiedBy': lastModifiedBy,
    'createdTime': createdTime,
    'lastModifiedTime': lastModifiedTime,
  };
}

class Workflow {
  String? action;
  List<VerificationDocument>? verificationDocuments;

  Workflow({
    this.action,
    this.verificationDocuments,
  });

  factory Workflow.fromJson(Map<String, dynamic> json) {
    return Workflow(
      action: json['action'],
      verificationDocuments: (json['verificationDocuments'] as List?)
          ?.map((e) => VerificationDocument.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'action': action,
    'verificationDocuments':
    verificationDocuments?.map((e) => e.toJson()).toList(),
  };
}

class VerificationDocument {
  String? id;
  String? documentType;
  String? fileStoreId;

  VerificationDocument({
    this.id,
    this.documentType,
    this.fileStoreId,
  });

  factory VerificationDocument.fromJson(Map<String, dynamic> json) {
    return VerificationDocument(
      id: json['id'],
      documentType: json['documentType'],
      fileStoreId: json['fileStoreId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'documentType': documentType,
    'fileStoreId': fileStoreId,
  };
}