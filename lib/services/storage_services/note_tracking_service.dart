import 'package:shared_preferences/shared_preferences.dart';

class NoteTrackingService {
  static const _countKey = 'note_count_today';
  static const _dateKey = 'note_count_date';

  /// Bugünkü not sayısını yükler
  Future<int> loadNoteCountToday() async {
    final prefs = await SharedPreferences.getInstance();

    final storedDate = prefs.getString(_dateKey);
    final today = _todayString();

    // Gün değişmişse sıfırla
    if (storedDate != today) {
      await prefs.setString(_dateKey, today);
      await prefs.setInt(_countKey, 0);
      return 0;
    }

    return prefs.getInt(_countKey) ?? 0;
  }

  /// Bugün eklenen not sayısını 1 artırır
  Future<void> increaseNoteCountToday() async {
    final prefs = await SharedPreferences.getInstance();

    final storedDate = prefs.getString(_dateKey);
    final today = _todayString();

    // Gün değişmişse resetle
    if (storedDate != today) {
      await prefs.setString(_dateKey, today);
      await prefs.setInt(_countKey, 1);
      return;
    }

    final currentCount = prefs.getInt(_countKey) ?? 0;
    await prefs.setInt(_countKey, currentCount + 1);
  }

  /// YYYY-MM-DD formatında bugünün tarihi
  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}
