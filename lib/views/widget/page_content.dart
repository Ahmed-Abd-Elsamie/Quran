import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  final int page;

  const PageContent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
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
            child: Image.asset("assets/pages/${page.toString()}.png",
                width: 100, height: 100),
          ),
        ),
      ),
    );
  }
}
