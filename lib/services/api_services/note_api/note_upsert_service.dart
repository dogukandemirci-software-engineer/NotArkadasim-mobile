import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:note_arkadasim/models/note_upsert_data.dart';
import 'package:note_arkadasim/services/api_services/baseapi/base_api.dart';
import 'package:note_arkadasim/services/api_services/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteUpsertService {
  static final NoteUpsertService _instance = NoteUpsertService._internal();
  factory NoteUpsertService() => _instance;
  NoteUpsertService._internal();

  final Dio _dio = DioClient().dio;
  static const String _cacheKey = 'note_upsert_data';

  Future<NoteUpsertData> getNoteUpsertData() async {
    // 1. Cache'i kontrol et
    final cachedData = await _loadFromCache();
    if (cachedData != null) {
      print("NoteUpsertData loaded from cache.");
      return cachedData;
    }

    // 2. Cache yoksa API'den çek
    print("Fetching NoteUpsertData from API...");
    try {
      final response = await _dio.get('${BaseApi.ip}/note/getInitialUpsert');

      if (response.statusCode == 200 && response.data['meta']['isSuccess']) {
        final entity = NoteUpsertData.fromJson(response.data['entity']);
        // 3. API'den gelen veriyi cache'le
        await _saveToCache(entity);
        return entity;
      } else {
        throw Exception(
            'API returned an error: ${response.data['meta']?['message'] ?? 'Unknown error'}');
      }
    } on DioException catch (e) {
      print('Failed to fetch NoteUpsertData: $e');
      throw Exception('Network error while fetching note data: ${e.message}');
    } catch (e) {
      print('An unexpected error occurred: $e');
      throw Exception('An unexpected error occurred while fetching note data.');
    }
  }

  Future<void> _saveToCache(NoteUpsertData data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(data.toJson());
    await prefs.setString(_cacheKey, jsonString);
  }

  Future<NoteUpsertData?> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cacheKey);
    if (jsonString != null) {
      try {
        final jsonMap = json.decode(jsonString);
        return NoteUpsertData.fromJson(jsonMap);
      } catch (e) {
        print('Failed to parse NoteUpsertData from cache: $e');
        return null;
      }
    }
    return null;
  }

  // Cache'i temizlemek için bir yardımcı metod
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
