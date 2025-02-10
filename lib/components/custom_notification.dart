import 'package:flutter/material.dart';
import 'package:tech_barter/models/app_notification.dart';

class NotificationService {

  static final colors = {
    NotificationType.success: Colors.green,
    NotificationType.error: Colors.red,
    NotificationType.warning: Colors.orange,
    NotificationType.info: Colors.blue,
  };

  static final icons = {
    NotificationType.success: Icons.check_circle,
    NotificationType.error: Icons.error,
    NotificationType.warning: Icons.warning,
    NotificationType.info: Icons.info,
  };

  static void showNotification(BuildContext context, AppNotification notification) {
    final snackBar = SnackBar(
      content: SizedBox(
        width: 300,
        child: Row(
          children: [
            Icon(icons[notification.type], color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(notification.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(notification.message,
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: colors[notification.type],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      duration: const Duration(seconds: 3),
      action: notification.actionLabel != null
          ? SnackBarAction(
        label: notification.actionLabel!,
        textColor: Colors.white,
        onPressed: notification.onAction ?? () {},
      )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showFixedWidthSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300), // Fixed max width
          child: Text(message),
        ),
        backgroundColor: colors[NotificationType.info],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}