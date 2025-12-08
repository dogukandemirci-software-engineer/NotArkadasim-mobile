class UserModel {
  final String userId;
  final String accessToken;
  final String? accessTokenExpiration;
  final String? refreshToken;
  final String? refreshTokenExpiration;
  final String username;
  final String fullName;
  final String email;
  final String? profilePicture;
  final String? univerityId; // API'de küçük harfle tanımlanmış
  final String? departmentId;
  final String? roleId;

  UserModel({
    required this.userId,
    required this.accessToken,
    this.accessTokenExpiration,
    this.refreshToken,
    this.refreshTokenExpiration,
    required this.username,
    required this.fullName,
    required this.email,
    this.profilePicture,
    this.univerityId,
    this.departmentId,
    this.roleId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      accessToken: json['accessToken'] ?? '',
      accessTokenExpiration: json['accessTokenExpiration'],
      refreshToken: json['refreshToken'],
      refreshTokenExpiration: json['refreshTokenExpiration'],
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'],
      univerityId: json['univerityId'], // API'de küçük harfle tanımlanmış
      departmentId: json['departmentId'],
      roleId: json['roleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'accessToken': accessToken,
      'accessTokenExpiration': accessTokenExpiration,
      'refreshToken': refreshToken,
      'refreshTokenExpiration': refreshTokenExpiration,
      'username': username,
      'fullName': fullName,
      'email': email,
      'profilePicture': profilePicture,
      'univerityId': univerityId,
            'departmentId': departmentId,
            'roleId': roleId,
          };
        }
      
        UserModel copyWith({
          String? userId,
          String? accessToken,
          String? accessTokenExpiration,
          String? refreshToken,
          String? refreshTokenExpiration,
          String? username,
          String? fullName,
          String? email,
          String? profilePicture,
          String? univerityId,
          String? departmentId,
          String? roleId,
        }) {
          return UserModel(
            userId: userId ?? this.userId,
            accessToken: accessToken ?? this.accessToken,
            accessTokenExpiration: accessTokenExpiration ?? this.accessTokenExpiration,
            refreshToken: refreshToken ?? this.refreshToken,
            refreshTokenExpiration: refreshTokenExpiration ?? this.refreshTokenExpiration,
            username: username ?? this.username,
            fullName: fullName ?? this.fullName,
            email: email ?? this.email,
            profilePicture: profilePicture ?? this.profilePicture,
            univerityId: univerityId ?? this.univerityId,
            departmentId: departmentId ?? this.departmentId,
            roleId: roleId ?? this.roleId,
          );
        }
      }
      