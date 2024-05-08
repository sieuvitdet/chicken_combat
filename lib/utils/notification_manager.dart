import 'package:chicken_combat/utils/utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    final InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher'),
      iOS: IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      ),
    );

    // Use _notificationsPlugin instead of notificationsPlugin
    await _notificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification
    );
    if (Globals.currentUser != null) {
      await scheduleDailyNotification();
    }
  }

  static void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    // Handle notification tapped logic here
    // Example: You could navigate to a different screen based on the payload
  }

  static void selectNotification(String? payload) {
    // Handle notification selection logic here
    // Example: You could navigate to a different screen based on the payload
  }

  static Future<void> showNotification(String Title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'android_110',
        'android',
        channelDescription: 'notification_android',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics
    );

    await _notificationsPlugin.show(
        0,
        Title,
        body,
        platformChannelSpecifics,
        payload: 'item x'
    );
  }

  static Future<void> scheduleDailyNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Tạo kênh thông báo cho Android
    var androidDetails = AndroidNotificationDetails(
      'daily_notification_channel_id',
      'Daily Notifications',
      channelDescription: 'Channel for daily notifications at 6 AM',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);

    // Thiết lập thời gian gửi thông báo hàng ngày vào lúc 6 giờ sáng
    var time = tz.TZDateTime.now(tz.local);
    var sixAM = tz.TZDateTime(tz.local, time.year, time.month, time.day, 12);
    if (time.isAfter(sixAM)) {
      sixAM = sixAM.add(Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Good Morning!',
      'Time to start your day!',
      sixAM,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Đảm bảo thông báo lặp lại mỗi ngày vào lúc 6 giờ sáng
    );
  }
}