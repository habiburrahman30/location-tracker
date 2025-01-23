import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/components/drawer_component.dart';

import '../base/base.dart';
import '../components/bottom_navigation_component.dart';
import '../components/app_bar_component.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Base.navigationController.globalKey,
      appBar: AppBarComponent(),
      drawer: DrawerComponent(),
      body: Obx(() => Base.navigationController.getCurrentPage()),
      bottomNavigationBar: BottomNavigationComponent(),
    );
  }
}
