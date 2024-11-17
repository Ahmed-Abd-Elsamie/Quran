import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/modules/notifications/view/notification_page.dart';

class HomeAppBarWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget currentTitle;
  final VoidCallback? onDrawerPress;

  HomeAppBarWidget({
    super.key,
    required this.scaffoldKey,
    required this.currentTitle,
    this.onDrawerPress,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black45, spreadRadius: 5, blurRadius: 5)
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
              onPressed: onDrawerPress,
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
            currentTitle,
          ],
        ),
      ),
    );
  }
}
