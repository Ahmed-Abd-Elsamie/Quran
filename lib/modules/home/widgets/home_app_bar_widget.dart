import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/modules/notifications/view/notification_page.dart';
import 'package:quran/utils/constants.dart';

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
          color: primaryColor,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(top: 0, right: 25),
        height: 65,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onDrawerPress,
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Get.to(NotificationPage());
              },
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              label: Text(
                "مقتطفات",
                style: TextStyle(color: Colors.white),
              ),
            ),
            currentTitle,
          ],
        ),
      ),
    );
  }
}
