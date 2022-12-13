import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  final int page;
  final bool dir;

  const PageContent({super.key, required this.page, required this.dir});

  @override
  Widget build(BuildContext context) {
    return (page == 1 || page == 2)
        ? Container(
            color: Colors.white,
            child: FittedBox(
              child: Image.asset("assets/pages/" + page.toString() + ".png"),
              fit: BoxFit.fitHeight,
            ),
          )
        : Container(
            color: Colors.white,
            padding: dir
                ? EdgeInsets.only(top: 125, bottom: 30, right: 60)
                : EdgeInsets.only(top: 125, bottom: 30, left: 60),
            child: FittedBox(
              child: Image.asset("assets/pages/" + page.toString() + ".png"),
              fit: BoxFit.fitHeight,
            ),
          );
  }
}
