import 'package:flutter/foundation.dart';
import 'notification_service.dart';

class LocalNotificationService implements NotificationService {
  @override
  Future<void> initialize() async {
    // In a real app, initialize flutter_local_notifications here
    debugPrint('LocalNotificationService: Initialized');
    
    // NOTE: SMS_BACKEND_REQUIRED
    // We do NOT implement fake SMS alerts here. Real SMS requires a 
    // dedicated backend to dispatch to the mobile number collected in UserProfile.
  }

  @override
  Future<void> showNotification({required String title, required String body}) async {
    // In a real app, dispatch to flutter_local_notifications plugin
    debugPrint('🔔 LOCAL NOTIFICATION: $title - $body');
  }
}
