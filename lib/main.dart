import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'src/app.dart';

void main() async {
  // Initialize port for communication between TaskHandler and UI.
  FlutterForegroundTask.initCommunicationPort();

  runApp(App());
}
