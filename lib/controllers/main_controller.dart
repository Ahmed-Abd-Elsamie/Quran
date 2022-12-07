import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:quran/models/mark.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db_helper/database_helper.dart';
import '../utils/constants.dart';

class MainController extends GetxController {
  final dbHelper = DatabaseHelper.instance;

  Rx<bool?> _exist = Rxn<bool>();

  bool? get exist => _exist.value;

  ValueNotifier<bool> _barState = ValueNotifier(true);

  ValueNotifier<bool> get barState => _barState;

  ValueNotifier<int> _progress = ValueNotifier(0);

  ValueNotifier<int> get progress => _progress;

  ValueNotifier<bool> _showDownload = ValueNotifier(false);

  ValueNotifier<bool> get showDownload => _showDownload;

  Rx<int?> _currentPage = Rxn<int>();

  int? get currentPage => _currentPage.value;

  bool cancelDownload = false;

  final ValueNotifier<bool> _loading = ValueNotifier(false);

  ValueNotifier<bool> get loading => _loading;

  List<Mark> marksList = [];

  PageController pageController = PageController();

  @override
  Future<void> onInit() async {
    super.onInit();
    _exist.value = false;
    _exist.bindStream(exist.obs.stream);
    _currentPage.bindStream(currentPage.obs.stream);
  }

  MainController() {}

  MainController.page(int page) {
    _exist.bindStream(exist.obs.stream);
    _exist.value = false;
    checkLocal(page);
  }

  void getLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    final int? page = prefs.getInt('last_page');
    print("PPPP" + page.toString());
    _currentPage.value = (page == null ? 1 : page);
    pageController = PageController(initialPage: _currentPage.value! - 1);
    checkLocal(_currentPage.value!);
  }

  Future<void> saveLastPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    print("PPPP" + page.toString());
    await prefs.setInt('last_page', page);
  }

  void checkLocal(int page) async {
    var f = _getLocalFile(page);
    var e = await f.exists();
    if (e) {
      _exist.value = true;
    } else {
      _exist.value = false;
    }
  }

  File _getLocalFile(int page) {
    File file = new File(
        '/storage/emulated/0/Android/data/com.deksheno.quran/files/DekshenoQuran/' +
            page.toString() +
            '.png');
    return file;
  }

  Future<String?> downloadImage(String url, int page) async {
    try {
      var data = await ImageDownloader.downloadImage(
        url,
        destination: AndroidDestinationType.custom(directory: 'DekshenoQuran')
          ..inExternalFilesDir()
          ..subDirectory(page.toString() + ".png"),
      );
      var path = await ImageDownloader.findPath(data!);
      print("DDDDDD : " + path.toString());
      return path;
    } on PlatformException catch (error) {
      print(error);
      return "";
    }
  }

  void cancelDownloadAllImages() {
    cancelDownload = true;
  }

  Future<bool> downloadAllImages() async {
    cancelDownload = false;
    int tot = 1;
    for (int page = 1; page <= 604; page++) {
      if (cancelDownload) {
        break;
      }
      try {
        String url = "https://www.searchtruth.org/quran/images8/" +
            page.toString() +
            ".png";
        var data = await ImageDownloader.downloadImage(
          url,
          destination: AndroidDestinationType.custom(directory: 'DekshenoQuran')
            ..inExternalFilesDir()
            ..subDirectory(page.toString() + ".png"),
        );

        print("DDDDDD : " + data.toString());
        tot++;
        _progress.value += 1;
        update();
      } on PlatformException catch (error) {
        print(error);
        return false;
      }
    }
    // reset value
    //_progress.value = 0;
    if (tot == 604) {
      return true;
    } else {
      return false;
    }
  }

  void setExist() {
    _exist.value = true;
  }

  void changeBarState() {
    _barState.value = !_barState.value;
    update();
  }

  void setDownloadVisible() {
    _showDownload.value = true;
    update();
  }

  void setDownloadInVisible() {
    _showDownload.value = false;
    update();
  }

  void changeCurrentPage(int page) {
    _currentPage.value = page;
  }

  void changeSurah(int page) {
    pageController.jumpToPage(page - 1);
  }

  void sharePage() {
    Share.shareFiles([
      '/storage/emulated/0/Android/data/com.deksheno.quran/files/DekshenoQuran/' +
          _currentPage.value.toString() +
          '.png'
    ], text: 'ورد اليوم');
  }

  Future<void> addToMarks() async {
    Get.dialog(
      AlertDialog(
        title: const Text('حفظ كعلامه مرجعيه'),
        content: Container(
          height: 100,
          child: Column(
            children: [
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.brown)),
                child: const Text(
                  "علامه القراءه",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Mark m = await dbHelper.insertMark(Mark(
                      0,
                      _currentPage.value!,
                      surahList
                          .where((element) => element.page <= currentPage!)
                          .toList()
                          .last
                          .name,
                      1,
                      DateTime.now().toString()));
                  Get.back();
                  Get.snackbar("تم", "تم حفظ العلامه",
                      backgroundColor: Colors.green, colorText: Colors.white);
                },
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.brown)),
                child: const Text(
                  "علامه الحفظ",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Mark m = await dbHelper.insertMark(Mark(
                      0,
                      _currentPage.value!,
                      surahList
                          .where((element) => element.page <= currentPage!)
                          .toList()
                          .last
                          .name,
                      2,
                      DateTime.now().toString()));
                  Get.back();
                  Get.snackbar("تم", "تم حفظ العلامه",
                      backgroundColor: Colors.green, colorText: Colors.white);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getAllMarks() async {
    _loading.value = true;
    //update();
    marksList = (await dbHelper.getAllMarks())!;
    marksList = marksList.reversed.toList();
    _loading.value = false;
    update();
  }

  Future<void> deleteMark(int id) async {
    int d = await dbHelper.deleteMark(id);
    getAllMarks();
  }
}
