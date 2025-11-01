class RegisterModel {
  final String userName;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String collageId;
  final String departmentId;

  const RegisterModel({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.collageId,
    required this.departmentId,
  });

  /// JSON'dan oluşturma
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      userName: json['userName'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      collageId: json['collageId'] as String? ?? '',
      departmentId: json['departmentId'] as String? ?? '',
    );
  }

  /// JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'collageId': collageId,
      'departmentId': departmentId,
    };
  }

  /// Değiştirilmiş kopyasını almak için
  RegisterModel copyWith({
    String? userName,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? collageId,
    String? departmentId,
  }) {
    return RegisterModel(
      userName: userName ?? this.userName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      collageId: collageId ?? this.collageId,
      departmentId: departmentId ?? this.departmentId,
    );
  }

  @override
  String toString() {
    return 'RegisterModel(userName: $userName, firstName: $firstName, lastName: $lastName, email: $email, collageId: $collageId, departmentId: $departmentId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegisterModel &&
        other.userName == userName &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.password == password &&
        other.collageId == collageId &&
        other.departmentId == departmentId;
  }

  @override
  int get hashCode {
    return Object.hash(
      userName,
      firstName,
      lastName,
      email,
      password,
      collageId,
      departmentId,
    );
  }
}
