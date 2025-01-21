import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//***** System ui overlay style */
SystemUiOverlayStyle systemUiOverlayStyle() {
  return SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white, // Change Background color
    systemNavigationBarIconBrightness: Brightness.dark, // Change Icon color
  );
}
