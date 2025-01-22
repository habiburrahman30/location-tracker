import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_tracker/src/pages/login_page.dart';

import '../helpers/hex_color.dart';
import '../helpers/route.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      offAll(LoginPage());
      // Base.locationTreceController;
    });

    super.initState();
  }

  void updateAppbar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: hexToColor("#FF7643"),
      body: Stack(
        children: [
          // Center(
          //   child: Image.asset(
          //     'assets/images/touchLogo.png',
          //     // width: 150,
          //     height: 150,
          //   ),
          // ),
          Center(child: FlutterLogo(size: 100)),
          // App version at the bottom
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Text(
              'Version v1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
