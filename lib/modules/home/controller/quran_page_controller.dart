import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran/data_source/remote/remote_data_source.dart';
import 'package:quran/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranPageController extends GetxController {
  RxMap downloadingPagesStates = {}.obs;

  RxInt progress = 0.obs;

  RxBool showDownload = false.obs;

  RxInt currentPage = 1.obs;

  bool cancelDownload = false;
  late final RemoteDataSource? _remoteDataSource;

  @override
  Future<void> onInit() async {
    super.onInit();
    _remoteDataSource = RemoteDataSource.getInstance();
  }

  Future<void> downloadPage(int page) async {
    Directory? directory;
    try {
      directory = await _handleDownloadDirectory();
      await _singlePageDownload(directory, page);
    } catch (e) {
      print(e);
      downloadingPagesStates[page] = false;
    }
  }

  Future<bool> downloadAllPages() async {
    cancelDownload = false;
    final prefs = await SharedPreferences.getInstance();
    final int? last = prefs.getInt('last_download_page');
    int tot = (last == null ? 1 : last);
    progress.value = tot;
    Directory? directory;
    try {
      directory = await _handleDownloadDirectory();
      for (int page = tot; page <= 604; page++) {
        if (cancelDownload) {
          break;
        }
        await _singlePageDownload(directory, page);
        tot++;
        progress.value += 1;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('last_download_page', tot);
      }
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  void cancelDownloadAllImages() {
    cancelDownload = true;
  }

  void setDownloadVisible() {
    showDownload.value = true;
    update();
  }

  void setDownloadInVisible() {
    showDownload.value = false;
    update();
  }

  Future<Directory?> _handleDownloadDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      if (await _requestPermission(Permission.storage)) {
        directory = await getApplicationDocumentsDirectory();
        directory = Directory('${directory.path}/$localFolder');
        print("PATH ANDROID : " + directory.path);
      } else {}
    } else {
      print("IOS PLATFORM");
      if (await _requestPermission(Permission.photos)) {
        print("PERMISSION GRANTED");
        directory = await getApplicationDocumentsDirectory();
        print("PATH IOS : " + directory.path);
        directory = Directory(directory.path + "/" + "QuranPages");
        print("PATH IOS 2 : " + directory.path);
      } else {
        print("PERMISSION NOT GRANTED");
        await _requestPermission(Permission.photos);
      }
    }
    if (!await directory!.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  Future<void> _singlePageDownload(Directory? directory, int page) async {
    if (await directory?.exists() ?? false) {
      downloadingPagesStates[page] = true;
      File savePage = File(directory!.path + "/" + page.toString() + ".png");
      await _remoteDataSource?.downloadPage(page, savePage);
      downloadingPagesStates[page] = false;
    }
  }
}
