import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:quran/data_source/remote/remote_data_source.dart';
import 'package:quran/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranPageController extends GetxController {
  RxMap<int, bool> downloadingPagesStates = <int, bool>{}.obs;
  RxInt progress = 0.obs;
  RxBool showDownload = false.obs;
  RxInt currentPage = 1.obs;
  RxString downloadStatus = 'idle'.obs;
  bool cancelDownload = false;
  late final RemoteDataSource? _remoteDataSource;

  @override
  Future<void> onInit() async {
    super.onInit();
    _remoteDataSource = RemoteDataSource.getInstance();
  }

  Future<void> downloadPage(int page) async {
    try {
      downloadStatus.value = 'downloading';
      final directory = await _getDownloadDirectory();
      if (directory != null) {
        await _singlePageDownload(directory, page);
        downloadStatus.value = 'completed';
      } else {
        throw Exception(
            'Failed to get download directory. Please check storage permissions.');
      }
    } catch (e) {
      print('Download error for page $page: $e');
      downloadingPagesStates[page] = false;
      downloadStatus.value = 'error';
      rethrow;
    }
  }

  Future<Directory?> _getDownloadDirectory() async {
    try {
      if (Platform.isAndroid) {
        return await _getAndroidDirectory();
      } else if (Platform.isIOS) {
        return await _getIOSDirectory();
      }
      return null;
    } catch (e) {
      print('Directory error: $e');
      return null;
    }
  }

  Future<Directory?> _getAndroidDirectory() async {
    try {
      // For Android, we don't need special permissions for app-specific directory
      // Use getApplicationDocumentsDirectory which doesn't require permissions
      Directory directory = await getApplicationDocumentsDirectory();

      final downloadDir = Directory('${directory.path}/$localFolder');

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      print("Android download path: ${downloadDir.path}");
      return downloadDir;
    } catch (e) {
      print('Android directory error: $e');
      return null;
    }
  }

  Future<Directory?> _getIOSDirectory() async {
    try {
      // For iOS, use application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${directory.path}/QuranPages');

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      print("iOS download path: ${downloadDir.path}");
      return downloadDir;
    } catch (e) {
      print('iOS directory error: $e');
      return null;
    }
  }

  // Simplified permission check - only needed if you want to save to public directories
  Future<bool> checkPermissions() async {
    if (Platform.isAndroid) {
      try {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkVersion = androidInfo.version.sdkInt;

        if (sdkVersion >= 33) {
          // Android 13+
          return await _requestPermission(Permission.photos);
        } else if (sdkVersion >= 29) {
          // Android 10-12
          return await _requestPermission(Permission.storage);
        } else {
          // Android 9 and below
          return await _requestPermission(Permission.storage);
        }
      } catch (e) {
        return false;
      }
    } else if (Platform.isIOS) {
      return await _requestPermission(Permission.photos);
    }
    return true;
  }

  Future<bool> _requestPermission(Permission permission) async {
    try {
      final status = await permission.status;

      if (status.isGranted) {
        return true;
      }

      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }

      final result = await permission.request();
      return result.isGranted;
    } catch (e) {
      print('Permission error: $e');
      return false;
    }
  }

  Future<void> _singlePageDownload(Directory directory, int page) async {
    try {
      downloadingPagesStates[page] = true;

      final savePath = '${directory.path}/${page.toString()}.png';
      final saveFile = File(savePath);

      if (await saveFile.exists()) {
        print('Page $page already exists, skipping download');
        downloadingPagesStates[page] = false;
        return;
      }

      await _remoteDataSource?.downloadPage(page, saveFile);
      downloadingPagesStates[page] = false;
    } catch (e) {
      downloadingPagesStates[page] = false;
      print('Single page download error for page $page: $e');
      rethrow;
    }
  }

  // Rest of your methods...
  Future<bool> downloadAllPages() async {
    cancelDownload = false;
    downloadStatus.value = 'downloading';

    final prefs = await SharedPreferences.getInstance();
    final int? lastDownloadedPage = prefs.getInt('last_download_page');
    int currentPage = lastDownloadedPage ?? 1;

    progress.value = currentPage - 1;

    try {
      final directory = await _getDownloadDirectory();
      if (directory == null) {
        downloadStatus.value = 'error';
        return false;
      }

      for (int page = currentPage; page <= 604; page++) {
        if (cancelDownload) {
          downloadStatus.value = 'cancelled';
          break;
        }

        await _singlePageDownload(directory, page);
        progress.value = page;
        await prefs.setInt('last_download_page', page);

        await Future.delayed(const Duration(milliseconds: 50));
      }

      if (!cancelDownload) {
        downloadStatus.value = 'completed';
        await prefs.remove('last_download_page');
        progress.value = 0;
      }

      return !cancelDownload;
    } catch (e) {
      print('Bulk download error: $e');
      downloadStatus.value = 'error';
      return false;
    }
  }

  void cancelDownloadAllImages() {
    cancelDownload = true;
    downloadStatus.value = 'cancelled';
  }

  void setDownloadVisible() {
    showDownload.value = true;
  }

  void setDownloadInVisible() {
    showDownload.value = false;
  }
}
