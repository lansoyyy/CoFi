import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();
  static const String _unreadCountKey = 'unread_notifications_count';

  // Initialize the service
  Future<void> init() async {
    await GetStorage.init();
  }

  // Get notifications for the current user
  Stream<List<NotificationModel>> getUserNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Create a notification for a new event
  Future<void> createEventNotification(String eventId, String eventTitle, String? imageUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final notification = NotificationModel(
      id: _firestore.collection('users').doc().id,
      title: 'New Event Posted',
      body: 'Check out the new event: $eventTitle',
      type: 'event',
      relatedId: eventId,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      isRead: false,
    );

    await _saveNotification(user.uid, notification);
  }

  // Create a notification for a new job posting
  Future<void> createJobNotification(String jobId, String jobTitle, String shopName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final notification = NotificationModel(
      id: _firestore.collection('users').doc().id,
      title: 'New Job Posted',
      body: '$shopName is hiring: $jobTitle',
      type: 'job',
      relatedId: jobId,
      createdAt: DateTime.now(),
      isRead: false,
    );

    await _saveNotification(user.uid, notification);
  }

  // Create a notification for a new shop submission
  Future<void> createShopNotification(String shopId, String shopName, String? imageUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final notification = NotificationModel(
      id: _firestore.collection('users').doc().id,
      title: 'New Shop Submitted',
      body: 'Check out the new coffee shop: $shopName',
      type: 'shop',
      relatedId: shopId,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      isRead: false,
    );

    await _saveNotification(user.uid, notification);
  }

  // Save notification to Firestore
  Future<void> _saveNotification(String userId, NotificationModel notification) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toFirestore());

      // Update unread count
      final currentCount = _storage.read(_unreadCountKey) ?? 0;
      _storage.write(_unreadCountKey, currentCount + 1);
    } catch (e) {
      print('Error saving notification: $e');
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});

      // Update unread count
      final currentCount = _storage.read(_unreadCountKey) ?? 0;
      if (currentCount > 0) {
        _storage.write(_unreadCountKey, currentCount - 1);
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final batch = _firestore.batch();
      
      final notifications = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .get();

      for (final doc in notifications.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
      
      // Reset unread count
      _storage.write(_unreadCountKey, 0);
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }

  // Get unread notifications count from local storage
  int getUnreadCount() {
    return _storage.read(_unreadCountKey) ?? 0;
  }

  // Reset unread count (call when user opens notifications screen)
  void resetUnreadCount() {
    _storage.write(_unreadCountKey, 0);
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final notificationDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(notificationId)
          .get();

      if (notificationDoc.exists) {
        final wasUnread = notificationDoc.data()?['isRead'] == false;
        
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notifications')
            .doc(notificationId)
            .delete();

        // Update unread count if it was unread
        if (wasUnread) {
          final currentCount = _storage.read(_unreadCountKey) ?? 0;
          if (currentCount > 0) {
            _storage.write(_unreadCountKey, currentCount - 1);
          }
        }
      }
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }
}