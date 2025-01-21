import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/config_controller.dart';
import '../controllers/location_trece_controller.dart';
import '../controllers/navigation_controller.dart';
import '../services/background_service.dart';
import '../services/permission_handler_service.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConfigController());
    Get.lazyPut(() => LocationTreceController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => NavigationController());
    // Get.lazyPut(() => UserController());

    //****** Services Area ******/
    // Get.lazyPut(() => IsarService());
    Get.lazyPut(() => PermissionHandlerService());
    Get.lazyPut(() => BackgroundService());
  }
}
