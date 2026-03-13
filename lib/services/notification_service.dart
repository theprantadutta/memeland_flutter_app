import 'package:flutter/foundation.dart';

/// Skeleton notification service for Firebase Messaging
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> initialize() async {
    // TODO: Initialize Firebase Messaging
    debugPrint('NotificationService initialized (skeleton)');
  }

  Future<String?> getToken() async {
    // TODO: Get FCM token
    return null;
  }

  Future<void> requestPermission() async {
    // TODO: Request notification permission
  }
}
