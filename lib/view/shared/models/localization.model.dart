class LocalizationResponse {
  final List<LocalizationMessage> messages;

  LocalizationResponse({
    required this.messages,
  });

  factory LocalizationResponse.fromJson(Map<String, dynamic> json) {
    return LocalizationResponse(
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => LocalizationMessage.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }
}

class LocalizationMessage {
  final String code;
  final String message;
  final String module;
  final String locale;

  LocalizationMessage({
    required this.code,
    required this.message,
    required this.module,
    required this.locale,
  });

  factory LocalizationMessage.fromJson(Map<String, dynamic> json) {
    return LocalizationMessage(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      module: json['module'] ?? '',
      locale: json['locale'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'module': module,
      'locale': locale,
    };
  }
}