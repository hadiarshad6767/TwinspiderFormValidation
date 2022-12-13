// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:form_using_firebase/service/local_notifications_service.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  log("message received inside handler! ${message.notification!.title} ");
}

class NotificationService {
  static Future<void> initialize(BuildContext context) async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("Notifications initialized");
      BackgroundNotificationService();
      ForegroundNotificationService();
      BackgroundNavigationNotificationService(context);
      BackgroundTerminatedNavigationNotificationService(context);
    }
  }

  //background simple on open
  static Future<void> BackgroundNotificationService() async {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.onMessage.listen((message) {
      log("background notification service:message received! ${message.notification!.title} ");
    });
  }

  //foreground on open
  static Future<void> ForegroundNotificationService() async {
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        log("foreground notification service: message received! ${message.notification!.title} ");
        LocalNotificationService.display(message);
      }
    });
  }

  //background on navigation
  static Future<void> BackgroundNavigationNotificationService(
      BuildContext context) async {
    // FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final route = message.data['route'];
      log("background running navigation notification service: message received! $route ");
      Navigator.of(context).pushNamed(route);
    });
  }

  //terminated on navigation
  static Future<void> BackgroundTerminatedNavigationNotificationService(
      BuildContext context) async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final route = message.data['route'];
        log("Background navigator when app  is terminated service: message received! $route ");
        Navigator.of(context).pushNamed(route);
      }
    });
  }
}
