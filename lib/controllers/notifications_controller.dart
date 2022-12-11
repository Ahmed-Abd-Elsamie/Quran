import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/notification_model.dart';

class NotificationsController extends GetxController {
  final CollectionReference _notification_ref =
      FirebaseFirestore.instance.collection('notifications');
  ValueNotifier<bool> _loading = ValueNotifier(false);

  ValueNotifier<bool> get loading => _loading;

  List<NotificationModel>? notifications;

  NotificationsController() {}

  Future<void> getNotifications() async {
    _loading.value = true;
    update();
    var value = await _notification_ref.get();
    notifications = List<NotificationModel>.from(
        value.docs.map((e) => NotificationModel.fromJson(e)));
    _loading.value = false;
    update();
  }
}
