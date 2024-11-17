import 'package:flutter/material.dart';

class HomeBottomBarItemModel extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback? onPress;

  const HomeBottomBarItemModel({
    super.key,
    required this.title,
    required this.icon,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPress,
      label: Text(
        title,
        style: TextStyle(color: Colors.brown),
      ),
      icon: icon,
    );
  }
}
