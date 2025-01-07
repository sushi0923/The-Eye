import 'package:flutter/material.dart';

class NotificationConfig extends ChangeNotifier {
  bool autoNotification = true;

  void toggleAutoNotification() {
    autoNotification = !autoNotification;
    notifyListeners();
  }
}

final notificationConfig = NotificationConfig();
