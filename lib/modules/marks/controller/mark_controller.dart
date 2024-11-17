import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/data_source/local/database_helper.dart';
import 'package:quran/models/mark.dart';
import 'package:quran/utils/constants.dart';

class MarksController extends GetxController {
  final _dbHelper = DatabaseHelper.instance;

  final ValueNotifier<bool> _loading = ValueNotifier(false);

  ValueNotifier<bool> get loading => _loading;

  List<Mark> marksList = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    getAllMarks();
  }

  Future<void> addToMarks(int page) async {
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
                  await _dbHelper.insertMark(Mark(
                      0,
                      page,
                      surahList
                          .where((element) => element.page <= page)
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
                  await _dbHelper.insertMark(Mark(
                      0,
                      page,
                      surahList
                          .where((element) => element.page <= page)
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
    marksList = (await _dbHelper.getAllMarks())!;
    marksList = marksList.reversed.toList();
    _loading.value = false;
    update();
  }

  Future<void> deleteMark(int id) async {
    await _dbHelper.deleteMark(id);
    getAllMarks();
  }
}
