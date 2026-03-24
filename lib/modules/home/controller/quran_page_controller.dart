import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
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
    try {
      Directory directory = await _handleDownloadDirectory();
      await _singlePageDownload(directory, page);
    } catch (e) {
      print('Error downloading page $page: $e');
      downloadingPagesStates[page] = false;
    }
  }

  Future<bool> downloadAllPages() async {
    cancelDownload = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      // Safely default to page 1 if null
      int lastDownloadedPage = prefs.getInt('last_download_page') ?? 1;

      progress.value = lastDownloadedPage;
      Directory directory = await _handleDownloadDirectory();

      for (int page = lastDownloadedPage; page <= 604; page++) {
        if (cancelDownload) {
          break;
        }
        await _singlePageDownload(directory, page);

        // Update progress and save state
        progress.value = page;
        await prefs.setInt('last_download_page', page);
      }
      return true;
    } catch (e) {
      print('Error downloading all pages: $e');
      return false;
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

  /// Handles creating and retrieving the safe, app-specific directory.
  /// NO permissions are required for this on any Android or iOS version.
  Future<Directory> _handleDownloadDirectory() async {
    // This safely gets the app's sandbox directory on both OSs
    Directory baseDir = await getApplicationDocumentsDirectory();

    // Using your original folder names based on platform
    String folderName = Platform.isAndroid ? localFolder : "QuranPages";
    Directory targetDirectory = Directory('${baseDir.path}/$folderName');

    if (!await targetDirectory.exists()) {
      await targetDirectory.create(recursive: true);
    }

    return targetDirectory;
  }

  Future<void> _singlePageDownload(Directory directory, int page) async {
    downloadingPagesStates[page] = true;
    try {
      File savePage = File('${directory.path}/$page.png');
      await _remoteDataSource?.downloadPage(page, savePage);
    } catch (e) {
      print('Failed to save page $page: $e');
    } finally {
      // Use finally block to ensure state is ALWAYS reset, even if download fails
      downloadingPagesStates[page] = false;
    }
  }
}
