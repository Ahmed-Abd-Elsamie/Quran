import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  static LocalDataSource? _instance;
  late SharedPreferences _sharedPreferences;

  static LocalDataSource? getInstance() {
    if (_instance == null) {
      _instance = LocalDataSource();
    }
    return _instance;
  }

  Future<void> initLocalDataSource() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> saveLastPage(int page) async {
    await _sharedPreferences.setInt('last_page', page);
  }

  int getLastPage() {
    final int? page = _sharedPreferences.getInt('last_page');
    return page ?? 1;
  }
}
