import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_tracker/src/components/drawer_component.dart';

import '../base/base.dart';
import '../components/bottom_navigation_component.dart';
import '../components/app_bar_component.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await initializeMap());
    super.initState();
  }

  Future<void> initializeMap() async {
    await Base.locationTrackerController.fetchLocationUpdates();
  }

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
