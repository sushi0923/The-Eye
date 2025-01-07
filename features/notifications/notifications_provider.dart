import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsProvider extends AsyncNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _db
          .collection("users")
          .doc(user.uid)
          .set({'token': token}, SetOptions(merge: true));
    }
  }

  @override
  Future<void> build() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await updateToken(token);
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }
}

final notificationsProvider = AsyncNotifierProvider(
  () => NotificationsProvider(),
);
