import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'src/app.dart';
import 'src/services/back_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await initializeService();
  runApp(App());
}
