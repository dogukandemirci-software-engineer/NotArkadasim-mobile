class Meta {
  final bool isSuccess;
  final String? message;
  final List<String>? errorMessages;
  final int statusCode;

  Meta({
    required this.isSuccess,
    this.message,
    this.errorMessages,
    required this.statusCode,
  });

  factory Meta.success([String? message]) => Meta(
    isSuccess: true,
    message: message ?? MetaMessages.success,
    errorMessages: null,
    statusCode: 200,
  );

  factory Meta.error([String? message]) => Meta(
    isSuccess: false,
    message: null,
    errorMessages: [message ?? MetaMessages.error],
    statusCode: 424,
  );

  factory Meta.errorList(List<String> messages) => Meta(
    isSuccess: false,
    message: null,
    errorMessages: messages.isEmpty ? [MetaMessages.error] : messages,
    statusCode: 424,
  );

  factory Meta.notFound([String? message]) => Meta(
    isSuccess: false,
    message: null,
    errorMessages: [message ?? MetaMessages.notFound],
    statusCode: 404,
  );

  factory Meta.badRequest(List<String> messages) => Meta(
    isSuccess: false,
    message: null,
    errorMessages: messages.isEmpty ? [MetaMessages.badRequest] : messages,
    statusCode: 400,
  );

  factory Meta.unauthorized([String? message]) => Meta(
    isSuccess: false,
    message: null,
    errorMessages: [message ?? MetaMessages.unauthorized],
    statusCode: 401,
  );

  factory Meta.unprocessableEntity([String? message]) => Meta(
    isSuccess: false,
    message: null,
    errorMessages: [message ?? MetaMessages.unprocessableEntity],
    statusCode: 422,
  );

  factory Meta.validationError(List<String> messages) => Meta(
    isSuccess: false,
    message: null,
    errorMessages: messages.isEmpty ? [MetaMessages.validationError] : messages,
    statusCode: 422,
  );

  factory Meta.serverError([String? message]) => Meta(
    isSuccess: false,
    message: null,
    errorMessages: [message ?? MetaMessages.error],
    statusCode: 500,
  );

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    isSuccess: json['isSuccess'] ?? false,
    message: json['message'],
    errorMessages: json['errorMessages'] != null
        ? List<String>.from(json['errorMessages'])
        : null,
    statusCode: json['statusCode'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'isSuccess': isSuccess,
    'message': message,
    'errorMessages': errorMessages,
    'statusCode': statusCode,
  };
}

class MetaMessages {
  static const String success = 'İşlem Başarılı';
  static const String error = 'İşlem Başarısız';
  static const String notFound = 'Veri Bulunamadı';
  static const String badRequest = 'Geçersiz istek';
  static const String unauthorized = 'Yetkisiz';
  static const String validationError = 'Geçersiz model';
  static const String unprocessableEntity = 'Gerekli Alanları Giriniz';
}
