// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'src/app.dart';
// import 'src/services/back_services.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Permission.notification.isDenied.then((value) {
//     if (value) {
//       Permission.notification.request();
//     }
//   });
//   await initializeService();
//   runApp(App());
// }
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // This will be executed when the service starts on an Android device.
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
    iosConfiguration: IosConfiguration(
      // This will be executed when the service starts on an iOS device.
      onForeground: onStart,
      autoStart: true,
    ),
  );

  service.startService();
}

void onStart(ServiceInstance service) {
  DartPluginRegistrant
      .ensureInitialized(); // Ensures plugins work in the background

  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "Flutter Background Service",
      content: "This service is running in the background",
    );
  }

  // Listen for events from the UI
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Periodic task: send data back to the UI every 1 second
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        return;
      }
    }

    print("Background service running...");
    service.invoke('update', {"message": "Background task running"});
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Background Service Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                FlutterBackgroundService().invoke("stopService");
              },
              child: const Text("Stop Service"),
            ),
            ElevatedButton(
              onPressed: () async {
                final isRunning = await FlutterBackgroundService().isRunning();
                if (!isRunning) {
                  await FlutterBackgroundService().startService();
                }
              },
              child: const Text("Start Service"),
            ),
          ],
        ),
      ),
    );
  }
}
