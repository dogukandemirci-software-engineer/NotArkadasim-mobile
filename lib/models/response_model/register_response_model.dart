
class RegisterResponse {
  bool isSuccess = false;
  String errorType = "";
  String errorMessage = "";

  RegisterResponse({
    required this.isSuccess,
    this.errorType = "",
    this.errorMessage = "",
  });
}
