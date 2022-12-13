import 'dart:collection';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quran/controllers/main_controller.dart';
import 'package:quran/models/part.dart';
import 'package:quran/models/surah.dart';
import 'package:quran/utils/constants.dart';
import 'package:quran/views/notification_page.dart';
import 'package:quran/views/saved_marks.dart';
import 'package:quran/views/widget/page_content.dart';

class Home extends GetWidget<MainController> {
  final _mainController = Get.put(MainController());
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    gelLastPage();
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          // pages content
          SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    return _mainController.currentPage == null
                        ? CircularProgressIndicator()
                        : PageView.builder(
                            controller: _mainController.pageController,
                            onPageChanged: (value) {
                              _mainController.saveLastPage(value + 1);
                              _mainController.changeCurrentPage(value + 1);
                            },
                            itemCount: 604,
                            reverse: true,
                            itemBuilder: (context, index) => Obx(() {
                              return GestureDetector(
                                onTap: () {
                                  _mainController.changeBarState();
                                },
                                child: Container(
                                    child: PageContent(
                                  page: (_mainController.currentPage!),
                                  dir: (((_mainController.currentPage!) % 2) ==
                                      0),
                                )),
                              );
                            }),
                          );
                  }),
                ),
              ],
            ),
          ),
          // upper bar
          GetBuilder<MainController>(
            builder: (MainController c) {
              return _mainController.barState.value == true
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.brown,
                        padding: EdgeInsets.only(top: 25, right: 25),
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                toggleDrawer();
                              },
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Get.to(NotificationPage());
                              },
                              icon: Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              label: Text(
                                "مقتطفات",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Obx(() {
                              return Text(
                                surahList
                                    .where((element) =>
                                        element.page <=
                                        _mainController.currentPage!)
                                    .toList()
                                    .last
                                    .name,
                                style: TextStyle(color: Colors.white),
                              );
                            })
                          ],
                        ),
                      ),
                    )
                  : Container();
            },
          ),
          // lower bar
          GetBuilder<MainController>(
            builder: (MainController c) {
              return _mainController.barState.value == true
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.brown,
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                _mainController.sharePage();
                              },
                              label: Text(
                                "مشاركه",
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) => SingleChildScrollView(
                                    controller:
                                        ModalScrollController.of(context),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      height: 200,
                                      child: Column(
                                        children: [
                                          Text(
                                            "قريبا ان شاء الله في الاصدارات القادمه",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              label: Text(
                                "تفسير",
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: Icon(
                                Icons.chat,
                                color: Colors.white,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                _mainController.addToMarks();
                              },
                              label: Text(
                                "علامه",
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: Icon(
                                Icons.bookmark_remove_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container();
            },
          ),
        ],
      ),
      drawer: GetBuilder<MainController>(
        builder: (ct) {
          return Container(
            width: 270,
            height: double.maxFinite,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
                  color: Colors.brown,
                  child: Text(
                    "البحث",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownSearch<Surah>(
                    items: surahList,
                    itemAsString: (Surah c) => c.name,
                    selectedItem: surahList[0],
                    onChanged: (Surah? data) {
                      if (data!.page == 0) {
                        return;
                      }
                      _mainController.saveLastPage(data.page);
                      _mainController.changeSurah(data.page);
                    },
                    dropdownDecoratorProps:
                        DropDownDecoratorProps(textAlign: TextAlign.center),
                    dropdownBuilder: (ctx, surah) {
                      return Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          surah!.name,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownSearch<Part>(
                    items: partsList,
                    itemAsString: (Part c) => c.name,
                    selectedItem: partsList[0],
                    onChanged: (Part? data) {
                      if (data!.page == 0) {
                        return;
                      }
                      _mainController.changeSurah(data.page);
                    },
                    dropdownDecoratorProps:
                        DropDownDecoratorProps(textAlign: TextAlign.center),
                    dropdownBuilder: (ctx, part) {
                      return Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          part!.name,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton.icon(
                  onPressed: () {
                    Get.to(SavedMarks());
                  },
                  label: Text(
                    "العلامات",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  icon: Icon(Icons.bookmark_outline_sharp),
                ),
                TextButton.icon(
                  onPressed: () {
                    toggleDrawer();
                    showMaterialModalBottomSheet(
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        controller: ModalScrollController.of(context),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          height: 200,
                          child: Column(
                            children: [
                              Text(
                                "قريبا ان شاء الله في الاصدارات القادمه",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  label: Text(
                    "التفاسير",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  icon: Icon(Icons.article_outlined),
                ),
                TextButton.icon(
                  onPressed: () {
                    Get.to(NotificationPage());
                  },
                  label: Text(
                    "مقتطفات",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  icon: Icon(Icons.notifications),
                ),
                Divider(
                  height: 3,
                  thickness: 3,
                  color: Colors.brown,
                  endIndent: 10,
                  indent: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  toggleDrawer() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  Future<void> gelLastPage() async {
    _mainController.getLastPage();
  }

  void showLoading() {
    Get.dialog(SizedBox(
      width: 100,
      height: 100,
      child: WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 10,
            ),
          ),
        ),
      ),
    ));
  }

  void hideLoading() {
    Get.back();
  }
}
