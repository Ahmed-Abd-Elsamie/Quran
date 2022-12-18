import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Map<int, String> downloadedPages = {};

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
                                      child: PageContent(
                                        page: index + 1,
                                        url: downloadedPages[index + 1],
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(top: 200),
                                      child: Column(
                                        children: [
                                          TextButton(
                                            style: ButtonStyle(
                                                fixedSize:
                                                    MaterialStateProperty.all(
                                                        Size(150, 50)),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.brown)),
                                            onPressed: () async {
                                              showLoading();
                                              NumberFormat formatter =
                                                  new NumberFormat("0000");
                                              int pageNum = (_mainController
                                                      .currentPage! +
                                                  3);
                                              String pageNumUrl =
                                                  formatter.format(pageNum);
                                              String url =
                                                  "https://www.searchtruth.org/quran/images4/" +
                                                      pageNumUrl +
                                                      ".jpg";
                                              String downloadPath =
                                                  await _mainController
                                                      .downloadPage(
                                                          url,
                                                          _mainController
                                                              .currentPage!);
                                              if (downloadPath != "") {
                                                print("Download Success");
                                                downloadedPages[_mainController
                                                    .currentPage!] = url;
                                                _mainController.setExist();
                                              }
                                              hideLoading();
                                            },
                                            child: Text(
                                              "تحميل الصفحه",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GetBuilder<MainController>(
                                            builder: (c) {
                                              return _mainController
                                                          .showDownload.value ==
                                                      true
                                                  ? TextButton(
                                                      style: ButtonStyle(
                                                          fixedSize:
                                                              MaterialStateProperty
                                                                  .all(Size(
                                                                      200, 50)),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .brown)),
                                                      onPressed: () async {
                                                        _mainController
                                                            .cancelDownloadAllImages();
                                                        _mainController
                                                            .setDownloadInVisible();
                                                      },
                                                      child: Text(
                                                        "الغاء تحميل الصفحات",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  : TextButton(
                                                      style: ButtonStyle(
                                                          fixedSize:
                                                              MaterialStateProperty
                                                                  .all(Size(
                                                                      200, 50)),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .brown)),
                                                      onPressed: () async {
                                                        toggleDrawer();
                                                        _mainController
                                                            .setDownloadVisible();
                                                        //showLoading();
                                                        bool state =
                                                            await _mainController
                                                                .downloadAllImages();
                                                        if (state == true) {
                                                          print(
                                                              "all pages downloaded");
                                                        } else {
                                                          print(
                                                              "failed to download all pages");
                                                        }
                                                        _mainController
                                                            .setDownloadInVisible();
                                                      },
                                                      child: Text(
                                                        "تحميل كل الصفحات",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    );
                                            },
                                          )
                                        ],
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
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black45, spreadRadius: 5, blurRadius: 5)
                ],
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
              ),
              padding: EdgeInsets.only(top: 25, right: 25),
              height: 105,
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
                      color: Colors.brown,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Get.to(NotificationPage());
                    },
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.brown,
                    ),
                    label: Text(
                      "مقتطفات",
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                  Obx(() {
                    return _mainController.currentPage == null
                        ? CircularProgressIndicator()
                        : Text(
                            surahList
                                .where((element) =>
                                    element.page <=
                                    _mainController.currentPage!)
                                .toList()
                                .last
                                .name,
                            style: TextStyle(color: Colors.brown),
                          );
                  })
                ],
              ),
            ),
          ),
          // lower bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black45, spreadRadius: 5, blurRadius: 5)
                ],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              height: 70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // check if the current page already downloaded
                      if (_mainController.exist!) {
                        _mainController.sharePage();
                      }
                    },
                    label: Text(
                      "مشاركه",
                      style: TextStyle(color: Colors.brown),
                    ),
                    icon: Icon(
                      Icons.share,
                      color: Colors.brown,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
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
                      "تفسير",
                      style: TextStyle(color: Colors.brown),
                    ),
                    icon: Icon(
                      Icons.chat,
                      color: Colors.brown,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _mainController.addToMarks();
                    },
                    label: Text(
                      "علامه",
                      style: TextStyle(color: Colors.brown),
                    ),
                    icon: Icon(
                      Icons.bookmark_remove_outlined,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
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
