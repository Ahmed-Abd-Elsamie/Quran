import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:quran/utils/constants.dart';
import 'dart:io';

class RemoteDataSource {
  static RemoteDataSource? _instance;

  final _dio = Dio();

  static RemoteDataSource? getInstance() {
    if (_instance == null) {
      _instance = RemoteDataSource();
    }
    return _instance;
  }

  Future<void> downloadPage(int page, File localFile) async {
    String downloadUrl = _getDownloadUrl(page);
    await _dio.download(downloadUrl, localFile.path,
        onReceiveProgress: (downloaded, total) {});
  }

  String _getDownloadUrl(int page) {
    NumberFormat formatter = new NumberFormat("0000");
    int pageNum = (page + 3);
    String pageNumUrl = formatter.format(pageNum);
    return "$baseUrl/$pageStyleEndPoint/" + pageNumUrl + ".jpg";
  }
}
