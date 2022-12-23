import 'dart:io';

import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  final int page;
  final String? url;

  const PageContent({super.key, required this.page, this.url});

  @override
  Widget build(BuildContext context) {
    String path =
        "/data/user/0/com.deksheno.quran/app_flutter/QuranPages/" +
            page.toString() +
            ".png";

    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
      ),
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
            child: url == null
                ? Image.file(
                    width: 100,
                    height: 100,
                    File(path),
                  )
                : FadeInImage.assetNetwork(
                    width: 100,
                    height: 100,
                    placeholder: "assets/images/loading.gif",
                    image: url!,
                  ),
          ),
        ),
      ),
    );
  }
}
