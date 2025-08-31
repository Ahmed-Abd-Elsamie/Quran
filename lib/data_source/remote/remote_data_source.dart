import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:quran/utils/constants.dart';
import 'dart:io';

class RemoteDataSource {
  static RemoteDataSource? _instance;

  final _dio = Dio();

  RemoteDataSource() {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: false,
        maxWidth: 90,
      ),
    );
  }

  static RemoteDataSource? getInstance() {
    if (_instance == null) {
      _instance = RemoteDataSource();
    }
    return _instance;
  }

  Future<void> downloadPage(int page, File localFile) async {
    String downloadUrl = _getDownloadUrl(page);
    try {
      await _dio.download(downloadUrl, localFile.path,
          onReceiveProgress: (downloaded, total) {});
    } catch (e) {
      print("Error downloading page $page: $e");
      throw e;
    }
  }

  String _getDownloadUrl(int page) {
    NumberFormat formatter = new NumberFormat("0000");
    int pageNum = (page + 3);
    String pageNumUrl = formatter.format(pageNum);
    return "$baseUrl/$pageStyleEndPoint/" + pageNumUrl + ".jpg";
  }
}
