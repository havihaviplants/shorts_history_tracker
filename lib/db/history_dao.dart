import 'database_helper.dart';
import '../models/history_model.dart';

class HistoryDao {
  Future<void> insertUrl(String url) async {
    final db = await DatabaseHelper.instance.database;
    String folder = _categorizeUrl(url);
    await db.insert('history', {
      'url': url,
      'folder': folder,
      'dateTime': DateTime.now().toIso8601String(),
    });
  }

  Future<List<HistoryModel>> getAllUrls() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('history');
    return List.generate(maps.length, (i) {
      return HistoryModel(
        id: maps[i]['id'],
        url: maps[i]['url'],
        folder: maps[i]['folder'],
        dateTime: DateTime.parse(maps[i]['dateTime']),
      );
    });
  }

  Future<void> clearAllUrls() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('history');
  }

  String _categorizeUrl(String url) {
    if (url.contains('/reel/')) return '릴스';
    if (url.contains('/stories/')) return '스토리';
    return '기타';
  }
}
