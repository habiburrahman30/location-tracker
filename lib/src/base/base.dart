import 'package:get/get.dart';

import '../controllers/config_controller.dart';
import '../controllers/location_tracker_controller.dart';
import '../controllers/navigation_controller.dart';

class Base {
  static final configController = Get.find<ConfigController>();
  static final locationTrackerController =
      Get.find<LocationTrackerController>();
  static final navigationController = Get.find<NavigationController>();
  // static final userController = Get.find<UserController>();

  // ****** Services Area ******/
  // static final isarService = Get.find<IsarService>();
}
