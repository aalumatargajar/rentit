import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rentit/src/common/model/notifcation_model.dart';
import 'package:rentit/src/features/notifications/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  //!############ ADD NOTIFICATION ############
  Future<void> addNotification({
    required NotificationModel notificationModel,
  }) async {
    final result = await _notificationRepository.addNotification(
      notificationModel: notificationModel,
    );
    return result.fold(
      (l) => log('Failed to send notification: $l'),
      (r) => log('Notification send successfully: $r'),
    );
  }

  //!############ GET NOTIFICATION BY ID ############
  Future<NotificationModel?> getNotificationById({
    required String notificationId,
  }) async {
    final result = await _notificationRepository.getNotificationById(
      notificationId: notificationId,
    );
    return result.fold((l) {
      log('Failed to get notification: $l');
      return null;
    }, (r) => r);
  }

  //!############ UPDATE ALL NOTIFICATIONS READ ############
  Future<void> updateAllNotificationsRead() async {
    final result = await _notificationRepository.updateAllNotificationsRead();
    return result.fold(
      (l) => log('Failed to update notifications: $l'),
      (r) => log('All notifications marked as read: $r'),
    );
  }
}
