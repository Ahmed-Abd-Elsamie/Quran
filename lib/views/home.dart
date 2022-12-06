import 'dart:collection';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:quran/controllers/main_controller.dart';
import 'package:quran/models/part.dart';
import 'package:quran/models/surah.dart';
import 'package:quran/utils/constants.dart';
import 'package:quran/views/widget/page_content.dart';

class Home extends GetWidget<MainController> {
  final _mainController = Get.put(MainController());
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Map<int, String> justDownloaded = HashMap();

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
                              _mainController.checkLocal(value + 1);
                              _mainController.saveLastPage(value + 1);
                              _mainController.changeCurrentPage(value + 1);
                            },
                            itemCount: 604,
                            reverse: true,
                            itemBuilder: (context, index) => Obx(() {
                              return _mainController.exist ==
                                      true // check if page already downloaded
                                  ? GestureDetector(
                                      onTap: () {
                                        _mainController.changeBarState();
                                      },
                                      child: Container(
                                          child: PageContent(
                                        page: (_mainController.currentPage!),
                                        dir: (((_mainController.currentPage!) %
                                                2) ==
                                            0),
                                        path: justDownloaded[
                                            _mainController.currentPage],
                                      )),
                                    )
                                  : Container(
                                      child: TextButton(
                                        onPressed: () async {
                                          showLoading();
                                          String url =
                                              "https://www.searchtruth.org/quran/images8/" +
                                                  (_mainController.currentPage)
                                                      .toString() +
                                                  ".png";
                                          String? path = await _mainController
                                              .downloadImage(
                                                  url,
                                                  (_mainController
                                                      .currentPage!));

                                          if (path != "") {
                                            print("Download Success");
                                            _mainController.update();
                                            _mainController.setExist();
                                            justDownloaded[_mainController
                                                .currentPage!] = path!;
                                            Phoenix.rebirth(context);
                                          }
                                          hideLoading();
                                        },
                                        child: Text(
                                          "تحميل الصفحه",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
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
                                // check if the current page already downloaded
                                if(_mainController.exist!){
                                  _mainController.sharePage();
                                }
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
                              onPressed: () {},
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
                              onPressed: () {},
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
                      _mainController.checkLocal(data.page);
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
                  onPressed: () {},
                  label: Text(
                    "العلامات",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  icon: Icon(Icons.bookmark_outline_sharp),
                ),
                TextButton.icon(
                  onPressed: () {},
                  label: Text(
                    "التفاسير",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  icon: Icon(Icons.article_outlined),
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
                _mainController.showDownload.value == true
                    ? TextButton.icon(
                        onPressed: () async {
                          _mainController.cancelDownloadAllImages();
                        },
                        label: Text(
                          "الغاء تحميل الصفحات",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        icon: Icon(Icons.cancel_outlined),
                      )
                    : TextButton.icon(
                        onPressed: () async {
                          _mainController.setDownloadVisible();
                          //showLoading();
                          bool state =
                              await _mainController.downloadAllImages();
                          if (state == true) {
                            print("all pages downloaded");
                          } else {
                            print("failed to download all pages");
                          }
                          _mainController.setDownloadInVisible();
                          //hideLoading();
                        },
                        label: Text(
                          "تحميل كل الصفحات",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        icon: Icon(Icons.download_outlined),
                      ),
                SizedBox(
                  height: 20,
                ),
                _mainController.showDownload.value == true
                    ? downloadWidget()
                    : Container()
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

  Widget downloadWidget() {
    return GetBuilder<MainController>(
      builder: (c) {
        return Column(
          children: [
            CircularProgressIndicator(
              strokeWidth: 7,
              color: Colors.black,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              _mainController.progress.value.toString() + " / 604 الصفحات ",
              style: TextStyle(color: Colors.black, fontSize: 22),
            )
          ],
        );
      },
    );
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
