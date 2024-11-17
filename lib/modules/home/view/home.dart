import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quran/controllers/main_controller.dart';
import 'package:quran/modules/home/controller/quran_page_controller.dart';
import 'package:quran/modules/home/model/home_bottom_bar_item_model.dart';
import 'package:quran/modules/home/widgets/home_app_bar_widget.dart';
import 'package:quran/modules/home/widgets/home_bottom_bar_widget.dart';
import 'package:quran/modules/marks/controller/mark_controller.dart';
import 'package:quran/models/part.dart';
import 'package:quran/models/surah.dart';
import 'package:quran/utils/constants.dart';
import 'package:quran/modules/notifications/view/notification_page.dart';
import 'package:quran/modules/marks/view/saved_marks.dart';
import 'package:quran/widget/download_progress_widget.dart';
import 'package:quran/modules/home/widgets/quran_page.dart';

class Home extends GetWidget<MainController> {
  final _mainController = Get.put(MainController());
  final _quranPageController = Get.put(QuranPageController());
  final _marksController = Get.put(MarksController());
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          // pages content
          _buildPageContent(),
          // upper bar
          _buildAppBar(),
          // lower bar
          _buildBottomBar(context),
        ],
      ),
      drawer: Container(
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
                onChanged: (Surah? surah) {
                  if (surah!.page == 0) {
                    return;
                  }
                  _mainController.changeSurah(surah.page);
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
                            style: TextStyle(color: Colors.black, fontSize: 20),
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
            GetBuilder<QuranPageController>(
              builder: (ctrl) {
                return _quranPageController.showDownload.value
                    ? TextButton.icon(
                        onPressed: () async {
                          _quranPageController.cancelDownloadAllImages();
                        },
                        label: Text(
                          "الغاء تحميل الصفحات",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        icon: Icon(Icons.cancel_outlined),
                      )
                    : TextButton.icon(
                        onPressed: () async {
                          _quranPageController.setDownloadVisible();
                          bool state =
                              await _quranPageController.downloadAllPages();
                          if (state == true) {
                            print("all pages downloaded");
                          } else {
                            print("failed to download all pages");
                          }
                          _quranPageController.setDownloadInVisible();
                        },
                        label: Text(
                          "تحميل كل الصفحات",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        icon: Icon(Icons.download_outlined),
                      );
              },
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() => _quranPageController.showDownload.value
                ? DownloadProgressWidget(
                    progress: _quranPageController.progress.value,
                  )
                : SizedBox())
          ],
        ),
      ),
    );
  }

  String _getSurahName() {
    return surahList
        .where((element) => element.page <= _mainController.currentPage.value)
        .toList()
        .last
        .name;
  }

  Widget _buildPageContent() {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _mainController.pageController,
              onPageChanged: (value) {
                _mainController.changeCurrentPage(value);
              },
              physics: const ScrollPhysics(),
              itemCount: 604,
              reverse: true,
              itemBuilder: (context, index) => QuranPage(
                page: index + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return HomeAppBarWidget(
      scaffoldKey: _scaffoldKey,
      currentTitle: Obx(
        () => Text(
          _getSurahName(),
          style: TextStyle(color: Colors.brown),
        ),
      ),
      onDrawerPress: () {
        toggleDrawer();
      },
    );
  }

  Widget _buildBottomBar(context) {
    return HomeBottomBarWidget(
      tabs: [
        HomeBottomBarItemModel(
          title: "مشاركه",
          icon: Icon(
            Icons.share,
            color: Colors.brown,
          ),
          onPress: () {
            _mainController.sharePage();
          },
        ),
        HomeBottomBarItemModel(
          title: "تفسير",
          icon: Icon(
            Icons.chat,
            color: Colors.brown,
          ),
          onPress: () {
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
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        HomeBottomBarItemModel(
          title: "علامه",
          icon: Icon(
            Icons.bookmark_remove_outlined,
            color: Colors.brown,
          ),
          onPress: () {
            _marksController.addToMarks(_mainController.currentPage.value);
          },
        ),
      ],
    );
  }

  toggleDrawer() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}
