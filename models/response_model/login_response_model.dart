
class LoginResponse {
  bool isSuccess = false;
  String errorType = "";
  String errorMessage = "";

  LoginResponse({
    required this.isSuccess,
    this.errorType = "",
    this.errorMessage = "",
  });
}
