
class PinCheckService {
  static late final PinCheckService _instance = PinCheckService._internal();

  PinCheckService._internal();

  static PinCheckService get instance => _instance;

  Future<bool> checkPin() async {
    return await fakeCheckPin();
  }

  Future<bool> fakeCheckPin() async {
    return true;
  }


}