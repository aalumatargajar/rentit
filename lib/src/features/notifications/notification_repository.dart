import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rentit/src/common/model/notifcation_model.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! ############ ADD NOTIFICATION ############
  Future<Either<String, String>> addNotification({
    required NotificationModel notificationModel,
  }) async {
    try {
      await _firestore
          .collection('notifications')
          .add(notificationModel.toJson());
      return right('Notification send successfully');
    } catch (e) {
      return left('Failed to send notification: $e');
    }
  }

  //! ############ GET NOTIFICATION  BY ID ############
  Future<Either<String, NotificationModel>> getNotificationById({
    required String notificationId,
  }) async {
    try {
      final doc =
          await _firestore
              .collection('notifications')
              .doc(notificationId)
              .get();
      if (doc.exists) {
        final notification = NotificationModel.fromJson(doc.data()!);
        return right(notification);
      } else {
        return left('Notification not found');
      }
    } catch (e) {
      return left('Failed to get notification: $e');
    }
  }

  //! ############ UPDATE ALL NOTIFICATIONS READ ############
  Future<Either<String, String>> updateAllNotificationsRead() async {
    try {
      final querySnapshot =
          await _firestore
              .collection('notifications')
              .where('isRead', isEqualTo: false)
              .get();

      final batch = _firestore.batch();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
      return right('All notifications marked as read');
    } catch (e) {
      return left('Failed to update notifications: $e');
    }
  }

  //! ############ UPDATE SINGLE NOTIFICATION READ ############
  Future<Either<String, String>> updateNotificationRead({
    required String notificationId,
  }) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });
      return right('Notification updated successfully');
    } catch (e) {
      return left('Failed to update notification: $e');
    }
  }

  //! ############ GET UNREAD NOTIFICATIONS COUNT ############
  static Stream<int> getUnreadNotificationsCount() {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }
}
