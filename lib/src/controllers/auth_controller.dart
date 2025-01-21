
import 'package:get/get.dart';

class AuthController extends GetxController {
  final isLoading = RxBool(false);

  //**** For SignUp ****

  final fullName = RxString('');
  final regEmail = RxString('');
  final mobileNumer = RxString('');
  final regPassword = RxString('');
  final regConfirmPassword = RxString('');

  final isObscure = RxBool(true);
  void changeNewObscure() => isObscure.toggle();
  final isConfirmObscure = RxBool(true);
  void changeConfirmObscure() => isConfirmObscure.toggle();

  //**** For login ****
  final loginEmail = RxString('');
  final password = RxString('');

  final serverToken = RxString('');

  bool isSignupButtonValid() {
    if (fullName.value.isNotEmpty &&
        mobileNumer.value.isNotEmpty &&
        regEmail.value.isNotEmpty &&
        mobileNumer.value.length >= 14 &&
        regPassword.value.length > 6 &&
        regConfirmPassword.value == regPassword.value) {
      return true;
    } else {
      return false;
    }
  }

  bool isLoginButtonValid() {
    if (loginEmail.value.isNotEmpty &&
        password.value.isNotEmpty &&
        password.value.length >= 6) {
      return true;
    } else {
      return false;
    }
  }

  //**** START ****

  // final userRef = FirebaseFirestore.instance.collection('users');
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final FirebaseAuth auth = FirebaseAuth.instance;

  // Future<void> registerUser() async {
  //   isLoading.value = true;
  //   Codec<String, String> stringToBase64 = utf8.fuse(base64);

  //   try {
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: regEmail.value,
  //       password: stringToBase64
  //           .encode('pKode${regPassword.value.replaceAll(' ', '')}'),
  //     );

  //     // Send email verification
  //     // await userCredential.user!.sendEmailVerification();

  //     // Save user data in Firestore with isApproved = false
  //     await userRef.doc(userCredential.user!.uid).set({
  //       'fullName': fullName.value,
  //       'email': regEmail.value,
  //       'phone': mobileNumer.value,
  //       'image': '',
  //       'isApproved': false,
  //       'isAdmin': false,
  //     });

  //     isLoading.value = false;
  //     fullName.value = '';
  //     regEmail.value = '';
  //     mobileNumer.value = '';
  //     regPassword.value = '';
  //     regConfirmPassword.value = '';
  //     isObscure.value = false;
  //     isConfirmObscure.value = false;

  //     offAll(LoginPage());

  //     // Notify the user that their account is pending approval
  //     DialogHelper.globalDialog(
  //       dialogType: DialogType.success,
  //       message: "Registration successful. Please wait for admin approval.",
  //       onTap: () => Get.back(),
  //     );
  //   } catch (e) {
  //     isLoading.value = false;
  //     var errorMessage = e.toString().split('\]').last;
  //     Get.snackbar(
  //       'Invalid Credential',
  //       "$errorMessage",
  //       icon: Icon(Icons.error_outline_rounded, color: Colors.yellow),
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  // Future<void> loginUser() async {
  //   try {
  //     isLoading.value = true;
  //     Codec<String, String> stringToBase64 = utf8.fuse(base64);

  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: loginEmail.value,
  //       password:
  //           stringToBase64.encode('pKode${password.value.replaceAll(' ', '')}'),
  //     );

  //     klog(auth.currentUser);
  //     // Check if user is approved
  //     final userDoc = await userRef.doc(userCredential.user!.uid).get();
  //     klog("===============");
  //     klog(userDoc);

  //     if (userDoc.exists && userDoc['isApproved'] == true) {
  //       // Proceed to app's main screen
  //       if (userDoc['isAdmin'] == true) {
  //         // Redirect to admin dashboard
  //         // klog("Login successful. Welcome Admin!");
  //         offAll(AdminMainPage());
  //       } else {
  //         // Redirect to user dashboard
  //         offAll(MainPage());
  //         // klog("Login successful. Welcome!");
  //       }
  //     } else {
  //       // Logout user and show approval pending message
  //       await FirebaseAuth.instance.signOut();

  //       DialogHelper.globalDialog(
  //         dialogType: DialogType.warning,
  //         message:
  //             "Your account is pending approval. Please wait for admin approval..",
  //         onTap: () => Get.back(),
  //       );
  //     }

  //     isLoading.value = false;
  //     fullName.value = '';
  //     regEmail.value = '';
  //     mobileNumer.value = '';
  //     regPassword.value = '';
  //     regConfirmPassword.value = '';
  //     isObscure.value = false;
  //     isConfirmObscure.value = false;
  //   } catch (e) {
  //     isLoading.value = false;
  //     var errorMessage = e.toString().split('\]').last;
  //     Get.snackbar(
  //       'Invalid Credential',
  //       "$errorMessage",
  //       icon: Icon(Icons.error_outline_rounded, color: Colors.yellow),
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //     klog(e);
  //   }
  // }

  // Future<void> logoutUser() async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     offAll(LoginPage());
  //   } catch (e) {
  //     klog("Error during logout: $e");
  //   }
  // }

  // Future<void> deleteUser(String id) async {
  //   final userCredential = FirebaseFirestore.instance.collection('users');
  //   final userDoc = await userRef.doc(id).get();
  //   try {
  //     if (userDoc.exists) {
  //       await FirebaseAuth.instance.currentUser!.delete();
  //       await userCredential.doc(id).delete();
  //       klog("Delete successful.");
  //     }
  //   } catch (e) {
  //     klog("Error during deletion: $e");
  //   }
  // }

  // Future<void> approveUser(String userId) async {
  //   await userRef.doc(userId).update({'isApproved': true});
  //   klog("User approved successfully!");
  // }
}
