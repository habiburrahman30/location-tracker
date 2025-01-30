import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location_tracker/src/helpers/klog.dart';
import 'package:location_tracker/src/helpers/route.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';

import '../../pages/map/map_view_page.dart';

class NotificationsServices {
  /// A notification action which triggers a url launch event
  static String urlLaunchActionId = 'id_1';

  /// A notification action which triggers a App navigation event
  static String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  static String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  static String darwinNotificationCategoryPlain = 'plainCategory';

  // @pragma('vm:entry-point')
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  // On tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);

    if ("This is payload" == notificationResponse.payload) {
      logSuccess(onClickNotification.value);
      push(MapViewPage());
    }
  }

  static final darwinNotificationCategories = <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  // Android initialization settings
  final androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  //iOS initialization settings
  final darwinInitializationSettings = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    notificationCategories: darwinNotificationCategories,
    // onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {},
  );

  //Linux initialization settings
  final linuxInitializationSettings = LinuxInitializationSettings(
    defaultActionName: 'Open notification',
    defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
  );

  Future<void> initializeNotification() async {
    final initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
      macOS: darwinInitializationSettings,
      linux: linuxInitializationSettings,
    );

    // Request notification permissions
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    // When app is closed
    final details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onClickNotification.add(details.notificationResponse!.payload!);
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  // Show a simple notification
  Future showSimpleNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final androidNotificationDetails = AndroidNotificationDetails(
      'channelId 0',
      'channelName',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      // sound: RawResourceAndroidNotificationSound(_sound)
      // styleInformation: BigPictureStyleInformation(
      //   FilePathAndroidBitmap(bigPicturePath),
      //   largeIcon: FilePathAndroidBitmap(largeIconPath),
      // ),
      // icon: 'logo',
      // channelShowBadge: true,
      // largeIcon: DrawableResourceAndroidBitmap('logo'),
    );

    final darwinNotificationDetails =
        DarwinNotificationDetails(presentSound: true);

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Show a simple notification with actions button
  Future showSimpleNotificationWithActions({
    required String title,
    required String body,
    required String payload,
  }) async {
    final androidNotificationDetails = const AndroidNotificationDetails(
      'channelId 1',
      'channelName 1',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      // icon: 'logo',
      // channelShowBadge: true,
      // largeIcon: DrawableResourceAndroidBitmap('logo'),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'dismiss',
          'DISMISS',
          cancelNotification: true,
        ),
        AndroidNotificationAction(
          'approve',
          'APPROVE',
          cancelNotification: false,
        ),
        AndroidNotificationAction(
          'viewChangesID',
          'VIEW',
          cancelNotification: false,
        ),
      ],
    );

    final darwinNotificationDetails = const DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Show a simple notification with big image
  Future sendNotificationWithBigImage({
    required int id,
    required String usl,
    required String title,
    required String body,
    String? payload,
  }) async {
    // final bigPictureStyleInformation = BigPictureStyleInformation(
    //   DrawableResourceAndroidBitmap('bigimage'),
    //   contentTitle: 'Code Compilee',
    //   largeIcon: DrawableResourceAndroidBitmap('nazrul_islam'),
    // );

    final response = await Dio().get(
      usl,
      options: Options(responseType: ResponseType.bytes),
    );

    final bigPictureStyleInformation = BigPictureStyleInformation(
      ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.data)),
      // DrawableResourceAndroidBitmap('bigimage'),
      largeIcon:
          ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.data)),
    );

    final androidNotificationDetails = AndroidNotificationDetails(
      'channelId 2',
      'channelName',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: bigPictureStyleInformation,
    );

    final darwinNotificationDetails = const DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      2,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // To schedule a local notification
  Future showPeriodicallyNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    final androidNotificationDetails = const AndroidNotificationDetails(
      'channelId 3',
      'channelName',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    final darwinNotificationDetails = const DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
      3,
      title,
      body,
      RepeatInterval.everyMinute,
      notificationDetails,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  // To schedule a local notification
  Future showScheduleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    tz.initializeTimeZones();

    final androidNotificationDetails = const AndroidNotificationDetails(
      'channelId 4',
      'channelName',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    final darwinNotificationDetails = const DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      4,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 2)),
      notificationDetails,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  // close a specific channel notification
  Future cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // close all the notifications available
  Future cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
