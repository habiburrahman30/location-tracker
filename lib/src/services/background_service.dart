import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get/get.dart';

import '../helpers/klog.dart';

class BackgroundService extends GetxService {
  @override
  void onInit() async {
    await initializeService();
    super.onInit();
  }

  //Initialize the background service
  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStartBackgroundService,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: true,
        isForegroundMode: true,
        autoStartOnBoot: true,
        onStart: onStartBackgroundService,
      ),
    );
  }

  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    return true;
  }

  @pragma('vm:entry-point')
  static void onStartBackgroundService(ServiceInstance service) async {
    // service.on("stop").listen((event) {
    //   service.stopSelf();
    //   klog("background process is now stopped");
    // });

    // service.on("start").listen((event) {});

    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   klog("service is successfully running ${DateTime.now().second}");
    // });

    if (service is AndroidServiceInstance) {
      service.on("setAsForeground").listen((event) {
        service.setAsForegroundService();
        klog("setAsForegroundService");
      });

      service.on("setAsBackground").listen((event) {
        service.setAsBackgroundService();
        klog("setAsBackground");
      });
    }

    service.on("stopService").listen((event) {
      service.stopSelf();
      klog("background process is now stopped");
    });

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          service.setForegroundNotificationInfo(
            title: 'title',
            content: DateTime.now().toString(),
          );
          klog("Foreground Service running ${DateTime.now().second}");
        }
      }
    });
  }

  void startBackgroundService() {
    final service = FlutterBackgroundService();
    service.startService();
  }

  void stopBackgroundService() {
    final service = FlutterBackgroundService();
    service.invoke("stop");
  }
}
