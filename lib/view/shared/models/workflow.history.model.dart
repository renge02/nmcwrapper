class WorkflowHistoryResponse {
  dynamic responseInfo;
  List<ProcessInstance>? processInstances;
  int? totalCount;

  WorkflowHistoryResponse({
    this.responseInfo,
    this.processInstances,
    this.totalCount,
  });

  factory WorkflowHistoryResponse.fromJson(
      Map<String, dynamic> json) {
    return WorkflowHistoryResponse(
      responseInfo: json['ResponseInfo'],
      processInstances: (json['ProcessInstances'] as List?)
          ?.map((e) => ProcessInstance.fromJson(e))
          .toList(),
      totalCount: json['totalCount'],
    );
  }
}

class ProcessInstance {
  String? id;
  String? tenantId;
  String? businessService;
  String? businessId;
  String? action;
  String? moduleName;
  WorkflowState? state;
  String? comment;
  List<WorkflowDocument>? documents;
  WorkflowUser? assigner;
  List<WorkflowUser>? assignes;
  List<WorkflowAction>? nextActions;
  AuditDetails? auditDetails;
  int? rating;
  bool? escalated;

  ProcessInstance({
    this.id,
    this.tenantId,
    this.businessService,
    this.businessId,
    this.action,
    this.moduleName,
    this.state,
    this.comment,
    this.documents,
    this.assigner,
    this.assignes,
    this.nextActions,
    this.auditDetails,
    this.rating,
    this.escalated,
  });

  factory ProcessInstance.fromJson(
      Map<String, dynamic> json) {
    return ProcessInstance(
      id: json['id'],
      tenantId: json['tenantId'],
      businessService: json['businessService'],
      businessId: json['businessId'],
      action: json['action'],
      moduleName: json['moduleName'],
      comment: json['comment'],
      rating: json['rating'],
      escalated: json['escalated'],
      state: json['state'] != null
          ? WorkflowState.fromJson(json['state'])
          : null,
      assigner: json['assigner'] != null
          ? WorkflowUser.fromJson(json['assigner'])
          : null,
      auditDetails: json['auditDetails'] != null
          ? AuditDetails.fromJson(json['auditDetails'])
          : null,
      documents: (json['documents'] as List?)
          ?.map((e) => WorkflowDocument.fromJson(e))
          .toList(),
      assignes: (json['assignes'] as List?)
          ?.map((e) => WorkflowUser.fromJson(e))
          .toList(),
      nextActions: (json['nextActions'] as List?)
          ?.map((e) => WorkflowAction.fromJson(e))
          .toList(),
    );
  }
}

class WorkflowState {
  String? uuid;
  String? tenantId;
  String? state;
  String? applicationStatus;
  bool? docUploadRequired;
  bool? isStartState;
  bool? isTerminateState;
  List<WorkflowAction>? actions;

  WorkflowState({
    this.uuid,
    this.tenantId,
    this.state,
    this.applicationStatus,
    this.docUploadRequired,
    this.isStartState,
    this.isTerminateState,
    this.actions,
  });

  factory WorkflowState.fromJson(
      Map<String, dynamic> json) {
    return WorkflowState(
      uuid: json['uuid'],
      tenantId: json['tenantId'],
      state: json['state'],
      applicationStatus: json['applicationStatus'],
      docUploadRequired: json['docUploadRequired'],
      isStartState: json['isStartState'],
      isTerminateState: json['isTerminateState'],
      actions: (json['actions'] as List?)
          ?.map((e) => WorkflowAction.fromJson(e))
          .toList(),
    );
  }
}

class WorkflowAction {
  String? uuid;
  String? tenantId;
  String? currentState;
  String? action;
  String? nextState;
  List<String>? roles;

  WorkflowAction({
    this.uuid,
    this.tenantId,
    this.currentState,
    this.action,
    this.nextState,
    this.roles,
  });

  factory WorkflowAction.fromJson(
      Map<String, dynamic> json) {
    return WorkflowAction(
      uuid: json['uuid'],
      tenantId: json['tenantId'],
      currentState: json['currentState'],
      action: json['action'],
      nextState: json['nextState'],
      roles: (json['roles'] as List?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}

class WorkflowDocument {
  String? id;
  String? tenantId;
  String? documentType;
  String? fileStoreId;
  String? documentUid;
  AuditDetails? auditDetails;

  WorkflowDocument({
    this.id,
    this.tenantId,
    this.documentType,
    this.fileStoreId,
    this.documentUid,
    this.auditDetails,
  });

  factory WorkflowDocument.fromJson(
      Map<String, dynamic> json) {
    return WorkflowDocument(
      id: json['id'],
      tenantId: json['tenantId'],
      documentType: json['documentType'],
      fileStoreId: json['fileStoreId'],
      documentUid: json['documentUid'],
      auditDetails: json['auditDetails'] != null
          ? AuditDetails.fromJson(json['auditDetails'])
          : null,
    );
  }
}

class WorkflowUser {
  int? id;
  String? userName;
  String? name;
  String? type;
  String? mobileNumber;
  String? emailId;
  String? tenantId;
  String? uuid;
  List<UserRole>? roles;

  WorkflowUser({
    this.id,
    this.userName,
    this.name,
    this.type,
    this.mobileNumber,
    this.emailId,
    this.tenantId,
    this.uuid,
    this.roles,
  });

  factory WorkflowUser.fromJson(
      Map<String, dynamic> json) {
    return WorkflowUser(
      id: json['id'],
      userName: json['userName'],
      name: json['name'],
      type: json['type'],
      mobileNumber: json['mobileNumber'],
      emailId: json['emailId'],
      tenantId: json['tenantId'],
      uuid: json['uuid'],
      roles: (json['roles'] as List?)
          ?.map((e) => UserRole.fromJson(e))
          .toList(),
    );
  }
}

class UserRole {
  String? name;
  String? code;
  String? tenantId;

  UserRole({
    this.name,
    this.code,
    this.tenantId,
  });

  factory UserRole.fromJson(
      Map<String, dynamic> json) {
    return UserRole(
      name: json['name'],
      code: json['code'],
      tenantId: json['tenantId'],
    );
  }
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

  factory AuditDetails.fromJson(
      Map<String, dynamic> json) {
    return AuditDetails(
      createdBy: json['createdBy'],
      lastModifiedBy: json['lastModifiedBy'],
      createdTime: json['createdTime'],
      lastModifiedTime: json['lastModifiedTime'],
    );
  }
}