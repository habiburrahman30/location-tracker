import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_tracker/src/pages/map_page.dart';

import '../pages/home_page.dart';
import '../pages/local_notification_page.dart';
import '../pages/location_listener_page.dart';

class NavigationController extends GetxController {
  final globalKey = GlobalKey<ScaffoldState>();

  final currentIndex = RxInt(0);
  final isHomeActive = RxBool(true);

  // set setCurrentIndex(String item) => currentIndex.value = getMenuIndex(item);

  Widget getCurrentPage() {
    switch (currentIndex.value) {
      case 0:
        return HomePage();
      case 1:
        return MapPage();
      case 2:
        return LocationListener();
      case 3:
        return LocalNotificationPage();
      default:
        return Center(child: Text('page 3'));
    }
  }
  //  int getMenuIndex(String item) {
  //   return bottomMenus.indexOf(item);
  // }
}
