import 'package:get/get.dart';

class ConfigController extends GetxController {
  @override
  void onInit() async {
    // await initAppConfig();

    super.onInit();
  }

  // @override
  // void onReady() async {
  //   await 2.delay();

  //   final settingsModel =
  //       await Base.isarService.get<SettingsModel>('currentSettings');
  //   if (settingsModel == null) {
  //     await initDB();
  //   }

  //   await readyToGo();

  //   super.onReady();
  // }

  // Future<void> initAppConfig() async {
  //   Base.isarService;
  // }

  // Future<void> initDB() async {
  //   final settingsModel = SettingsModel(
  //     id: 'currentSettings',
  //     email: '',
  //     password: '',
  //     isFirstTime: true,
  //     loggedIn: false,
  //     isAdmin: false,
  //   );
  //   await Base.isarService.put<SettingsModel>(settingsModel);
  // }

  // Future<void> readyToGo() async {
  //   // Get.offAll(() => GetStartPage());
  //   // await initDB();

  //   final currentUser = await Base.isarService.get<UserModel>('currentUser');
  //   final settingsModel =
  //       await Base.isarService.get<SettingsModel>('currentSettings');

  //   klog(settingsModel!.isFirstTime);

  //   Base.userController.currentUser.value = currentUser;
  //   Base.userController.currentSettings.value = settingsModel;

  //   // if (currentUser != null &&
  //   //     settingsModel != null &&
  //   //     settingsModel.loggedIn == true) {
  //   //   await 2.delay();
  //   //   if (settingsModel.isAdmin == true) {
  //   //     Get.offAll(() => AdminHomePage());
  //   //   } else {
  //   //     Get.offAll(() => MainPage());
  //   //   }
  //   // } else if (settingsModel != null && settingsModel.isFirstTime == false) {
  //   //   Get.offAll(() => OnboardingScreen());
  //   // } else {
  //   //   Get.offAll(() => LoginPage());
  //   // }

  //   User? user = FirebaseAuth.instance.currentUser;

  //   klog('DATA => $user');
  //   if (settingsModel != null && settingsModel.isFirstTime == false) {
  //     if (user != null) {
  //       var userData = await Base.userController.getUserData(user.uid);
  //       klog(userData);
  //       // klog(userData[0]['isAdmin']);

  //       if (userData.isNotEmpty && userData[0]['isAdmin'] == true) {
  //         Get.offAll(() => AdminMainPage());
  //       } else if (userData.isNotEmpty && userData[0]['isApproved'] == true) {
  //         Get.offAll(() => MainPage());
  //       } else {
  //         Get.offAll(() => LoginPage());
  //       }
  //     } else {
  //       Get.offAll(() => LoginPage());
  //     }
  //   } else {
  //     Get.to(() => OnboardingScreen());
  //   }
  // }
}
