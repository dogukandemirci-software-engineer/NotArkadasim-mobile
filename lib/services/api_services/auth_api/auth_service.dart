
class ApiService {
  static late final ApiService _instance = ApiService._internal();

  ApiService._internal();

  static ApiService get instance => _instance;

  Future<bool> fakeLogin() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<bool> fakeRegister() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}