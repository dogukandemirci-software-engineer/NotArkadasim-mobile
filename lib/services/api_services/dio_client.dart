import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:note_arkadasim/services/user_service.dart';
import 'auth_api/auth_service.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  late final Dio dio;

  DioClient._internal() {
    dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    // Geliştirme sırasında SSL sertifika hatalarını atla
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // İstek gönderilmeden önce token'ı ekle
          final accessToken = await UserService().getAccessToken();
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // 401 Unauthorized hatası alındığında
          if (e.response?.statusCode == 401) {
            try {
              // Token'ı yenilemeyi dene
              final success = await ApiService.instance.refreshToken();
              if (success) {
                // Token yenileme başarılıysa, orijinal isteği tekrarla
                final newAccessToken = await UserService().getAccessToken();
                e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                final opts = Options(
                  method: e.requestOptions.method,
                  headers: e.requestOptions.headers,
                );
                final cloneReq = await dio.request(
                  e.requestOptions.path,
                  options: opts,
                  data: e.requestOptions.data,
                  queryParameters: e.requestOptions.queryParameters,
                );
                return handler.resolve(cloneReq);
              } else {
                // Token yenileme başarısızsa, kullanıcıyı logout yap ve hatayı devam ettir
                await UserService().logout();
                return handler.next(e);
              }
            } catch (err) {
              await UserService().logout();
              return handler.next(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
}
