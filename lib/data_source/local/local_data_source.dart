import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  static LocalDataSource? _instance;

  static LocalDataSource? getInstance() {
    if (_instance == null) {
      _instance = LocalDataSource();
    }
    return _instance;
  }

  Future<void> saveLastPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_page', page);
  }

  Future<int> getLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    final int? page = prefs.getInt('last_page');
    return page ?? 1;
  }
}
