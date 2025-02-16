import 'package:flutter/material.dart';

enum NotificationType {
  success,
  error,
  warning,
  info,
}

class AppNotification {
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final String? actionLabel;
  final VoidCallback? onAction;

  AppNotification({
    required this.title,
    required this.message,
    required this.type,
    DateTime? timestamp,
    this.actionLabel,
    this.onAction,
  }) : timestamp = timestamp ?? DateTime.now();
}