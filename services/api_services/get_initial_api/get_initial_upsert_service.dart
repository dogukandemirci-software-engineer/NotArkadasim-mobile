import 'dart:convert';
import 'package:note_arkadasim/services/api_services/baseapi/base_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../models/initial_upsert_entity.dart';
import '../../../models/meta.dart';
import '../../../models/result.dart';
import '../../../models/College.dart';
import '../../../models/Department.dart';
import '../dio_client.dart';

class GetInitialUpsertService implements BaseApi{

  static late final GetInitialUpsertService _instance = GetInitialUpsertService._internal();

  GetInitialUpsertService._internal();

  static GetInitialUpsertService get instance => _instance;

  final dio = DioClient().dio;
  static const _sharedKey = 'initial_upsert';

  Result<InitialUpsertEntity>? _resultInitialUpsert;

  /// Public getter
  Result<InitialUpsertEntity>? get resultInitialUpsert => _resultInitialUpsert;

  /// Sunucudan veya cache'ten veriyi çek
  Future<GetInitialUpsertService> getInitialUpsert() async {
    // Önce cache'den dene
    final localResult = await _load();
    if (localResult != null) {
      _resultInitialUpsert = localResult;
      print("cache exists!");
      return this;
    }

    // Cache yoksa API'den al
    try {
      final String url = "${BaseApi.ip}/auth/getInitialUpsert";
      print(url + ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      final response = await dio.get(url);

      final result = Result<InitialUpsertEntity>.fromJson(
        response.data,
            (json) => InitialUpsertEntity.fromJson(json),
      );

      if (result.meta.isSuccess && result.entity != null) {
        await _save(result.entity!);
      }

      _resultInitialUpsert = result;
      return this;
    } on DioError catch (e) {
      _resultInitialUpsert = Result<InitialUpsertEntity>(
        meta: Meta.error(e.message),
      );
      return this;
    }
  }

  /// College listesi döner
  List<College> getColleges() {
    return _resultInitialUpsert?.entity?.collages ?? [];
  }

  /// Department listesi döner
  List<Department> getDepartments() {
    return _resultInitialUpsert?.entity?.departments ?? [];
  }

  /// College isimlerini String listesi olarak döner
  List<String> getCollegesAsStr() {
    return getColleges().map((c) => c.name).toList();
  }

  /// Department isimlerini String listesi olarak döner
  List<String> getDepartmentsAsStr() {
    return getDepartments().map((d) => d.name).toList();
  }

  /// SharedPreferences'tan yükleme
  Future<Result<InitialUpsertEntity>?> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_sharedKey);

    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final entity = InitialUpsertEntity.fromJson(jsonMap);
      return Result<InitialUpsertEntity>(
        entity: entity,
        meta: Meta.success('Localden yüklendi'),
      );
    } catch (e) {
      return null;
    }
  }

  /// SharedPreferences'a kaydetme
  Future<void> _save(InitialUpsertEntity entity) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(entity.toJson());
    await prefs.setString(_sharedKey, jsonString);
  }

}
