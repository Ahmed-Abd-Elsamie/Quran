import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/models/mark.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db_helper/database_helper.dart';
import '../utils/constants.dart';

class MainController extends GetxController {
  final dbHelper = DatabaseHelper.instance;

  ValueNotifier<bool> _barState = ValueNotifier(true);

  ValueNotifier<bool> get barState => _barState;

  Rx<int?> _currentPage = Rxn<int>();

  int? get currentPage => _currentPage.value;

  final ValueNotifier<bool> _loading = ValueNotifier(false);

  ValueNotifier<bool> get loading => _loading;

  List<Mark> marksList = [];

  PageController pageController = PageController();

  @override
  Future<void> onInit() async {
    super.onInit();
    _currentPage.bindStream(currentPage.obs.stream);
  }

  MainController() {}

  void getLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    final int? page = prefs.getInt('last_page');
    print("PPPP" + page.toString());
    _currentPage.value = (page == null ? 1 : page);
    pageController = PageController(initialPage: _currentPage.value! - 1);
  }

  Future<void> saveLastPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    print("PPPP" + page.toString());
    await prefs.setInt('last_page', page);
  }

  void changeBarState() {
    _barState.value = !_barState.value;
    update();
  }

  void changeCurrentPage(int page) {
    _currentPage.value = page;
  }

  void changeSurah(int page) {
    pageController.jumpToPage(page - 1);
  }

  Future<void> sharePage() async {
    Share.shareFiles(['assets/pages/' + _currentPage.value.toString() + '.png'], text: 'ورد اليوم');
    //Share.shareXFiles([XFile('assets/pages/1.png')], text: 'ورد اليوم');
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
