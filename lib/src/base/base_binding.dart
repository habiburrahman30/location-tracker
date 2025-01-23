import 'package:get/get.dart';

import '../controllers/config_controller.dart';
import '../controllers/location_tracker_controller.dart';
import '../controllers/navigation_controller.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConfigController());
    Get.lazyPut(() => LocationTrackerController());
    Get.lazyPut(() => NavigationController());
    // Get.lazyPut(() => UserController());

    //****** Services Area ******/
    // Get.lazyPut(() => IsarService());
  }
}
