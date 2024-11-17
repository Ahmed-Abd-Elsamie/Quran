import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/data_source/local/local_data_source.dart';
import 'package:quran/utils/constants.dart';
import 'package:share_plus/share_plus.dart';

class MainController extends GetxController {
  RxInt currentPage = 1.obs;
  PageController pageController = PageController();
  late final LocalDataSource? _localDataSource;

  @override
  Future<void> onInit() async {
    super.onInit();
    _localDataSource = LocalDataSource.getInstance();
    getLastPage();
  }

  void getLastPage() async {
    currentPage.value = _localDataSource!.getLastPage();
    pageController = PageController(initialPage: currentPage.value - 1);
  }

  Future<void> saveLastPage(int page) async {
    await _localDataSource!.saveLastPage(page);
  }

  void changeCurrentPage(int page) {
    currentPage.value = page + 1;
    saveLastPage(page + 1);
  }

  void changeSurah(int page) {
    pageController.jumpToPage(page - 1);
  }

  Future<void> sharePage() async {
    String localPath = "$localBaseUrl/" + currentPage.value.toString() + ".png";
    if (File(localPath).existsSync()) {
      await Share.shareXFiles([XFile(localPath)], text: 'ورد اليوم');
    } else {
      Get.defaultDialog(
        title: "تحميل الصفحة",
        content: Text("يجب تحميل الصفحة أولا قبل المشاركة"),
      );
    }
  }
}
