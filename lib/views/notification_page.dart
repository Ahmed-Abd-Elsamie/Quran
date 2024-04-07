import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';

class NotificationPage extends StatelessWidget {
  final _notificationController = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    _notificationController.getNotifications();
    return Scaffold(
        appBar: AppBar(
          title: Text("مقتطفات"),
        ),
        body: Center(
          child: GetBuilder<NotificationsController>(
            builder: (c) {
              return _notificationController.loading.value
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: _notificationController.notifications!.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.only(right: 20, top: 10)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      elevation: MaterialStateProperty.all(5),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ))),
                                  onPressed: () {},
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              new Text(
                                                _notificationController
                                                    .notifications![index]
                                                    .title,
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              const Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0)),
                                              new Text(
                                                  _notificationController
                                                      .notifications![index]
                                                      .body,
                                                  textAlign: TextAlign.end,
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  style:
                                                      TextStyle(fontSize: 17)),
                                              const Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        );
                      },
                    );
            },
          ),
        ));
  }
}
