import 'package:flutter/material.dart';
import 'package:quran/modules/home/model/home_bottom_bar_item_model.dart';

class HomeBottomBarWidget extends StatelessWidget {
  final List<HomeBottomBarItemModel> tabs;

  const HomeBottomBarWidget({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black45, spreadRadius: 5, blurRadius: 5)
          ],
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        height: 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: tabs,
        ),
      ),
    );
  }
}
