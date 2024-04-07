import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/controllers/main_controller.dart';
import 'package:quran/utils/constants.dart';

class QuranPage extends StatefulWidget {
  final int page;

  const QuranPage({
    super.key,
    required this.page,
  });

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  late String localPath;
  final _mainController = Get.put(MainController());

  @override
  void initState() {
    localPath = "$localBaseUrl/" + widget.page.toString() + ".png";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (File(localPath).existsSync()) {
      return Container(
        child: Container(
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
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(top: 200),
        child: Column(
          children: [
            TextButton(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(150, 50)),
                  backgroundColor: MaterialStateProperty.all(Colors.brown)),
              onPressed: () async {
                await _mainController.downloadPage(widget.page);
                setState(() {});
              },
              child: Text(
                "تحميل الصفحه",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
