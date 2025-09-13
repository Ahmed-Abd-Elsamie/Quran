import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/controllers/main_controller.dart';
import 'package:quran/modules/home/controller/quran_page_controller.dart';
import 'package:quran/utils/constants.dart';
import 'package:quran/widget/download_progress_widget.dart';

class QuranPage extends StatelessWidget {
  final int page;
  final QuranPageController _quranPageController =
      Get.put(QuranPageController());

  final MainController _mainController = Get.find<MainController>();

  QuranPage({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final String localPath = "${_mainController.localBaseUrl()}/" + page.toString() + ".png";

    return Obx(() {
      if (_quranPageController.downloadingPagesStates[page] == true) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        if (File(localPath).existsSync()) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.only(top: 70, bottom: 30),
            child: FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(45),
                child: Image.file(
                  width: 100,
                  height: 100,
                  File(localPath),
                ),
              ),
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.only(top: 200),
            child: Column(
              children: [
                if (_quranPageController.showDownload.value == false)
                  TextButton(
                    style: ButtonStyle(
                        fixedSize: WidgetStateProperty.all(Size(150, 50)),
                        backgroundColor: WidgetStateProperty.all(Colors.brown)),
                    onPressed: () {
                      _quranPageController.downloadPage(page);
                    },
                    child: Text(
                      "تحميل الصفحه",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                _quranPageController.showDownload.value
                    ? ElevatedButton.icon(
                        onPressed: () async {
                          _quranPageController.cancelDownloadAllImages();
                        },
                        label: Text(
                          "الغاء تحميل الصفحات",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        icon: Icon(Icons.cancel_outlined),
                      )
                    : ElevatedButton.icon(
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
                      ),
                SizedBox(
                  height: 10,
                ),
                Obx(() => _quranPageController.showDownload.value
                    ? DownloadProgressWidget(
                        progress: _quranPageController.progress.value,
                      )
                    : SizedBox())
              ],
            ),
          );
        }
      }
    });
  }
}
