import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran/data_source/local/local_data_source.dart';
import 'package:quran/data_source/remote/remote_data_source.dart';
import 'package:quran/utils/app_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class MainController extends GetxController {
  ValueNotifier<int> _progress = ValueNotifier(0);

  ValueNotifier<int> get progress => _progress;

  RxBool showDownload = false.obs;

  RxInt currentPage = 1.obs;

  RxBool isLoadingLastPage = false.obs;

  bool cancelDownload = false;

  PageController pageController = PageController();

  late final RemoteDataSource? _remoteDataSource;
  late final LocalDataSource? _localDataSource;

  @override
  Future<void> onInit() async {
    super.onInit();
    _remoteDataSource = RemoteDataSource.getInstance();
    _localDataSource = LocalDataSource.getInstance();
    getLastPage();
  }

  void getLastPage() async {
    isLoadingLastPage.value = true;
    currentPage.value = await _localDataSource!.getLastPage();
    pageController = PageController(initialPage: currentPage.value - 1);
    isLoadingLastPage.value = false;
  }

  Future<void> saveLastPage(int page) async {
    await _localDataSource!.saveLastPage(page);
  }

  Future<void> downloadPage(int page) async {
    AppHelper.showLoading();
    Directory? directory;
    try {
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
      if (await directory.exists()) {
        File savePage = File(directory.path + "/" + page.toString() + ".png");
        await _remoteDataSource?.downloadPage(page, savePage);
        AppHelper.hideLoading();
      }
    } catch (e) {
      print(e);
      AppHelper.hideLoading();
    }
  }

  Future<bool> downloadAllPages() async {
    cancelDownload = false;
    final prefs = await SharedPreferences.getInstance();
    final int? last = prefs.getInt('last_download_page');
    int tot = (last == null ? 1 : last);
    _progress.value = tot;
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getApplicationDocumentsDirectory();
          directory = Directory('${directory.path}/$localFolder');
          print("PATH ANDROID : " + directory.path);
        } else {
          return false;
        }
      } else {
        print("IOS PLATFORM");
        if (await _requestPermission(Permission.photos)) {
          print("PERMISSION GRANTED");
          directory = await getApplicationDocumentsDirectory();
          print("PATH IOS : " + directory.path);
          directory = Directory('${directory.path}/$localFolder');
          print("PATH IOS 2 : " + directory.path);
        } else {
          print("PERMISSION NOT GRANTED");
          await _requestPermission(Permission.photos);
          return false;
        }
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        for (int page = tot; page <= 604; page++) {
          if (cancelDownload) {
            break;
          }
          File savePage = File(directory.path + "/" + page.toString() + ".png");
          await _remoteDataSource?.downloadPage(page, savePage);
          tot++;
          _progress.value += 1;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('last_download_page', tot);
          update();
        }
        return true;
      }
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

  Future<void> changeCurrentPage(int page) async {
    currentPage.value = page + 1;
    await saveLastPage(page + 1);
  }

  void changeSurah(int page) {
    pageController.jumpToPage(page - 1);
  }

  void sharePage() {
    Share.shareXFiles(
        [XFile('$localBaseUrl/' + currentPage.value.toString() + '.png')],
        text: 'ورد اليوم');
  }

}
