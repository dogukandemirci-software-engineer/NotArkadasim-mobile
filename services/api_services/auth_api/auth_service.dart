
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:http/http.dart' as http;
import 'package:note_arkadasim/models/login_model.dart';
import 'package:note_arkadasim/models/register_model.dart';
import 'package:note_arkadasim/models/response_model/login_response_model.dart';
import 'package:note_arkadasim/models/user_model.dart';
import 'package:note_arkadasim/services/api_services/baseapi/base_api.dart';
import 'package:note_arkadasim/services/user_service.dart';
import '../../../models/response_model/register_response_model.dart';
import '../../../models/result.dart';

class ApiService {
  static late final ApiService _instance = ApiService._internal();

  ApiService._internal();

  static ApiService get instance => _instance;

  final String registerUrl = "${BaseApi.ip}/auth/register";
  final String loginUrl = "${BaseApi.ip}/auth/login";

  Future<LoginResponse> login(LoginModel loginModel) async {
    try {
      // Debug için istek bilgilerini yazdıralım
      print('Login request to: $loginUrl');
      print('Login request body: ${jsonEncode(loginModel.toJson())}');
      print('Login request headers: {"Content-Type": "application/json; charset=UTF-8"}');

      http.Response response;
      try {
        response = await http.post(
          Uri.parse(loginUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
          },
          body: jsonEncode(loginModel.toJson()),
        );
      } catch (e) {
        // HTTPS yönlendirme durumunda sertifika hatasını ele al
        if (e.toString().contains('CERTIFICATE_VERIFY_FAILED') || e.toString().contains('HandshakeException')) {
          print('Certificate error detected, attempting HTTPS with certificate verification disabled');
          // HTTPS için güvenli olmayan sertifikaları kabul eden özel bir HttpClient oluştur
          final client = HttpClient()
            ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

          try {
            var uri = Uri.parse(loginUrl);
            if (loginUrl.startsWith('http://')) {
              uri = Uri.parse(loginUrl.replaceFirst('http://', 'https://'));
            }
            
            var request = await client.postUrl(uri);
            request.headers.set('Content-Type', 'application/json; charset=UTF-8');
            request.headers.set('Accept', 'application/json');
            request.write(jsonEncode(loginModel.toJson()));
            
            var resp = await request.close();
            var responseBody = await resp.transform(utf8.decoder).join();
            
            // HttpHeaders nesnesini Map'e dönüştür
            Map<String, String> responseHeaders = {};
            resp.headers.forEach((name, values) {
              responseHeaders[name] = values.join(', ');
            });
            response = http.Response(responseBody, resp.statusCode, headers: responseHeaders);
            
            client.close();
          } catch (sslError) {
            print('SSL error: $sslError');
            client.close();
            rethrow;
          }
        } else {
          rethrow;
        }
      }

      // 307 Temporary Redirect gibi yönlendirme durumlarını kontrol et
      if (response.statusCode == 307 || response.statusCode == 302 || response.statusCode == 301) {
        // Yeni konumu al
        var location = response.headers['location'];
        if (location != null) {
          print('Redirecting to: $location');
          // HTTPS yönlendirme durumunda özel istemci ile devam et
          if (location.startsWith('https://')) {
            // Güvenli olmayan sertifikaları kabul eden özel bir HttpClient oluştur
            final client = HttpClient()
              ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

            try {
              var uri = Uri.parse(location);
              var request = await client.postUrl(uri);
              request.headers.set('Content-Type', 'application/json; charset=UTF-8');
              request.headers.set('Accept', 'application/json');
              request.write(jsonEncode(loginModel.toJson()));
              
              var resp = await request.close();
              var responseBody = await resp.transform(utf8.decoder).join();
              
              // HttpHeaders nesnesini Map'e dönüştür
              Map<String, String> responseHeaders = {};
              resp.headers.forEach((name, values) {
                responseHeaders[name] = values.join(', ');
              });
              response = http.Response(responseBody, resp.statusCode, headers: responseHeaders);
              
              client.close();
            } catch (sslError) {
              print('SSL error during redirect: $sslError');
              client.close();
              return LoginResponse(
                isSuccess: false,
                errorType: "ssl_error",
                errorMessage: "SSL sertifika hatası: $sslError",
              );
            }
          } else {
            // HTTP yönlendirme
            response = await http.post(
              Uri.parse(location),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
              },
              body: jsonEncode(loginModel.toJson()),
            );
          }
        } else {
          return LoginResponse(
            isSuccess: false,
            errorType: "redirect_no_location",
            errorMessage: "Yönlendirme yapıldı ancak hedef belirtilmedi",
          );
        }
      }

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      // Yanıtın boş olup olmadığını kontrol et
      if (response.body.isEmpty) {
        return LoginResponse(
          isSuccess: false,
          errorType: "empty_response",
          errorMessage: "Sunucudan boş yanıt alındı",
        );
      }

      // JSON parse işlemini dene ve hata yakala
      Map<String, dynamic> json;
      try {
        json = jsonDecode(response.body);
      } on FormatException {
        return LoginResponse(
          isSuccess: false,
          errorType: "parse_error",
          errorMessage: "Sunucudan gelen yanıt JSON formatında değil: ${response.body}",
        );
      }

      // Status koduna göre kontrol et
      if (response.statusCode < 200 || response.statusCode >= 300) {
        // Sunucudan hata yanıtı geldiyse
        String errorMessage = "HTTP ${response.statusCode} hatası";
        if (json.containsKey('meta') && json['meta'] != null && json['meta'].containsKey('message')) {
          errorMessage = json['meta']['message']?.toString() ?? errorMessage;
        } else if (json.containsKey('message')) {
          errorMessage = json['message']?.toString() ?? errorMessage;
        }
        return LoginResponse(
          isSuccess: false,
          errorType: "status_code:${response.statusCode}",
          errorMessage: errorMessage,
        );
      }

      final result = Result<LoginModel?>.fromJson(
        json,
            (json) => json['entity'] != null ? LoginModel.fromJson(json['entity']) : null,
      );

      if (result.meta.isSuccess) {
        // Giriş başarılıysa kullanıcı bilgilerini sakla
        if (json['entity'] != null) {
          final user = UserModel.fromJson(json['entity']);
          await UserService().saveUser(user);
        }
        return LoginResponse(isSuccess: true);
      } else {
        String errorMessage = "";
        if (result.meta.errorMessages != null && result.meta.errorMessages!.isNotEmpty) {
          errorMessage = result.meta.errorMessages!.join(', ');
        } else if (result.meta.message != null) {
          errorMessage = result.meta.message!;
        }
        return LoginResponse(
          isSuccess: false,
          errorType: "status_code:${result.meta.statusCode}",
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      print('Login error: $e');
      return LoginResponse(
        isSuccess: false,
        errorType: "conn",
        errorMessage: "Connection error while logging in: $e",
      );
    }
  }


  Future<RegisterResponse> register(RegisterModel registerModel) async {
    try {
      // Debug için istek bilgilerini yazdıralım
      print('Register request to: $registerUrl');
      print('Register request body: ${jsonEncode(registerModel.toJson())}');
      print('Register request headers: {"Content-Type": "application/json; charset=UTF-8"}');

      http.Response response;
      try {
        response = await http.post(
          Uri.parse(registerUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
          },
          body: jsonEncode(registerModel.toJson()),
        );
      } catch (e) {
        // HTTPS yönlendirme durumunda sertifika hatasını ele al
        if (e.toString().contains('CERTIFICATE_VERIFY_FAILED') || e.toString().contains('HandshakeException')) {
          print('Certificate error detected, attempting HTTPS with certificate verification disabled');
          // HTTPS için güvenli olmayan sertifikaları kabul eden özel bir HttpClient oluştur
          final client = HttpClient()
            ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

          try {
            var uri = Uri.parse(registerUrl);
            if (registerUrl.startsWith('http://')) {
              uri = Uri.parse(registerUrl.replaceFirst('http://', 'https://'));
            }
            
            var request = await client.postUrl(uri);
            request.headers.set('Content-Type', 'application/json; charset=UTF-8');
            request.headers.set('Accept', 'application/json');
            request.write(jsonEncode(registerModel.toJson()));
            
            var resp = await request.close();
            var responseBody = await resp.transform(utf8.decoder).join();
            
            // HttpHeaders nesnesini Map'e dönüştür
            Map<String, String> responseHeaders = {};
            resp.headers.forEach((name, values) {
              responseHeaders[name] = values.join(', ');
            });
            response = http.Response(responseBody, resp.statusCode, headers: responseHeaders);
            
            client.close();
          } catch (sslError) {
            print('SSL error: $sslError');
            client.close();
            rethrow;
          }
        } else {
          rethrow;
        }
      }

      // 307 Temporary Redirect gibi yönlendirme durumlarını kontrol et
      if (response.statusCode == 307 || response.statusCode == 302 || response.statusCode == 301) {
        // Yeni konumu al
        var location = response.headers['location'];
        if (location != null) {
          print('Redirecting to: $location');
          // HTTPS yönlendirme durumunda özel istemci ile devam et
          if (location.startsWith('https://')) {
            // Güvenli olmayan sertifikaları kabul eden özel bir HttpClient oluştur
            final client = HttpClient()
              ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

            try {
              var uri = Uri.parse(location);
              var request = await client.postUrl(uri);
              request.headers.set('Content-Type', 'application/json; charset=UTF-8');
              request.headers.set('Accept', 'application/json');
              request.write(jsonEncode(registerModel.toJson()));
              
              var resp = await request.close();
              var responseBody = await resp.transform(utf8.decoder).join();
              
              // HttpHeaders nesnesini Map'e dönüştür
              Map<String, String> responseHeaders = {};
              resp.headers.forEach((name, values) {
                responseHeaders[name] = values.join(', ');
              });
              response = http.Response(responseBody, resp.statusCode, headers: responseHeaders);
              
              client.close();
            } catch (sslError) {
              print('SSL error during redirect: $sslError');
              client.close();
              return RegisterResponse(
                isSuccess: false,
                errorType: "ssl_error",
                errorMessage: "SSL sertifika hatası: $sslError",
              );
            }
          } else {
            // HTTP yönlendirme
            response = await http.post(
              Uri.parse(location),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
              },
              body: jsonEncode(registerModel.toJson()),
            );
          }
        } else {
          return RegisterResponse(
            isSuccess: false,
            errorType: "redirect_no_location",
            errorMessage: "Yönlendirme yapıldı ancak hedef belirtilmedi",
          );
        }
      }

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      // Yanıtın boş olup olmadığını kontrol et
      if (response.body.isEmpty) {
        return RegisterResponse(
          isSuccess: false,
          errorType: "empty_response",
          errorMessage: "Sunucudan boş yanıt alındı",
        );
      }

      // JSON parse işlemini dene ve hata yakala
      Map<String, dynamic> json;
      try {
        json = jsonDecode(response.body);
      } on FormatException {
        return RegisterResponse(
          isSuccess: false,
          errorType: "parse_error",
          errorMessage: "Sunucudan gelen yanıt JSON formatında değil: ${response.body}",
        );
      }

      // Status koduna göre kontrol et
      if (response.statusCode < 200 || response.statusCode >= 300) {
        // Sunucudan hata yanıtı geldiyse
        String errorMessage = "HTTP ${response.statusCode} hatası";
        if (json.containsKey('meta') && json['meta'] != null && json['meta'].containsKey('message')) {
          errorMessage = json['meta']['message']?.toString() ?? errorMessage;
        } else if (json.containsKey('message')) {
          errorMessage = json['message']?.toString() ?? errorMessage;
        }
        return RegisterResponse(
          isSuccess: false,
          errorType: "status_code:${response.statusCode}",
          errorMessage: errorMessage,
        );
      }

      final result = Result<void>.fromJson(json, (_) => null);
      
      if (result.meta.isSuccess) {
        return RegisterResponse(isSuccess: true);
      } else {
        String errorMessage = "";
        if (result.meta.errorMessages != null && result.meta.errorMessages!.isNotEmpty) {
          errorMessage = result.meta.errorMessages!.join(', ');
        } else if (result.meta.message != null) {
          errorMessage = result.meta.message!;
        }
        return RegisterResponse(
          isSuccess: false,
          errorType: "status_code:${result.meta.statusCode}",
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      print('Register error: $e');
      return RegisterResponse(
        isSuccess: false,
        errorType: "conn",
        errorMessage: "Connection error while registering: $e",
      );
    }
  }

  Future<bool> fakeLogin() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

    Future<bool> fakeRegister() async {

      await Future.delayed(const Duration(milliseconds: 500));

      return true;

    }

  

    Future<bool> refreshToken() async {
    try {
      final refreshToken = await UserService().getRefreshToken();
      if (refreshToken == null) {
        return false;
      }

      // Create a new Dio instance WITHOUT the interceptor for the refresh token call
      final dio = Dio();
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      final response = await dio.post(
        '${BaseApi.ip}/auth/refresh-token',
        data: {'refreshToken': refreshToken},
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          )
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];
        await UserService().updateTokens(newAccessToken, newRefreshToken);
        return true;
      } else {
        await UserService().logout();
        return false;
      }
    } catch (e) {
      await UserService().logout();
      return false;
    }
  }

  }

  