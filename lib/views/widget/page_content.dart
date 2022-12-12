import 'dart:io';

import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  final int page;
  final bool dir;
  final String? path;

  const PageContent(
      {super.key, required this.page, required this.dir, this.path});

  @override
  Widget build(BuildContext context) {
    String p = "";
    if (path == null) {
      p = "/storage/emulated/0/Android/data/com.deksheno.quran/files/QuranPages/" +
          page.toString() +
          ".png";
    } else {
      p = path!;
      print("PPPPPPPP" + p.toString());
    }
    return (page == 1 || page == 2)
        ? Container(
            color: Colors.white,
            child: FittedBox(
              child: Image.file(
                File(p),
              ),
              fit: BoxFit.fitHeight,
            ),
          )
        : Container(
            color: Colors.white,
            padding: dir
                ? EdgeInsets.only(top: 125, bottom: 30, right: 60)
                : EdgeInsets.only(top: 125, bottom: 30, left: 60),
            child: FittedBox(
              child: Image.file(
                File(p),
              ),
              fit: BoxFit.fitHeight,
            ),
          );
  }
}
