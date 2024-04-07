import 'package:flutter/material.dart';

class DownloadProgressWidget extends StatelessWidget {
  final int progress;

  DownloadProgressWidget({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularProgressIndicator(
          strokeWidth: 7,
          color: Colors.black,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          progress.toString() + " / 604 الصفحات ",
          style: TextStyle(color: Colors.black, fontSize: 22),
        )
      ],
    );
  }
}
