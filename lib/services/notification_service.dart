import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('Notificação (background) clicada: ${notificationResponse.payload}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    // Definimos o local padrão para UTC por segurança
    tz.setLocalLocation(tz.getLocation('UTC')); 
    
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notificação clicada: ${details.payload}');
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<void> scheduleDailyPromisse({required String verseText, required String reference}) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_promisse_channel',
      'Pão Diário',
      channelDescription: 'Receba uma promessa bíblica todas as manhãs',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const details = NotificationDetails(android: androidDetails);

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 8, 0);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    try {
      await _plugin.zonedSchedule(
        1,
        'O Teu Pão Diário 📖',
        '$reference: "$verseText"',
        scheduledDate,
        details,
        // Configuração obrigatória para Android 14+
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'daily_promisse',
      );
      debugPrint('Promessa diária agendada com sucesso.');
    } catch (e) {
      debugPrint('Erro ao agendar promessa: $e');
    }
  }
}
