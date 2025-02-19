import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../helpers/route.dart';
import '/src/base/base.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    initPermition();

    super.initState();

    // initDB();
  }

  initPermition() async {
    await Base.locationTrackerController
        .initLocationListener(isListening: false);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/workers.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 50),
            Text(
              "Welcome Back",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Sign in with social media gmail to continue",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF757575)),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: ElevatedButton(
                onPressed: () async {
                  if (await Base.locationTrackerController
                      .initLocationListener(isListening: false)) {
                    offAll(MainPage());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7643), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 25,
                  ),
                ),
                child: Row(
                  spacing: 15,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.string(
                      googleIcon,
                      height: 30,
                    ),
                    Text(
                      "Login with Google",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const googleIcon =
    '''<svg width="16" height="17" viewBox="0 0 16 17" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M15.9988 8.3441C15.9988 7.67295 15.9443 7.18319 15.8265 6.67529H8.1626V9.70453H12.6611C12.5705 10.4573 12.0807 11.5911 10.9923 12.3529L10.9771 12.4543L13.4002 14.3315L13.5681 14.3482C15.1099 12.9243 15.9988 10.8292 15.9988 8.3441Z" fill="#4285F4"/>
<path d="M8.16265 16.3254C10.3666 16.3254 12.2168 15.5998 13.5682 14.3482L10.9924 12.3528C10.3031 12.8335 9.37796 13.1691 8.16265 13.1691C6.00408 13.1691 4.17202 11.7452 3.51894 9.7771L3.42321 9.78523L0.903556 11.7352L0.870605 11.8268C2.2129 14.4933 4.9701 16.3254 8.16265 16.3254Z" fill="#34A853"/>
<path d="M3.519 9.77716C3.34668 9.26927 3.24695 8.72505 3.24695 8.16275C3.24695 7.6004 3.34668 7.05624 3.50994 6.54834L3.50537 6.44017L0.954141 4.45886L0.870669 4.49857C0.317442 5.60508 0 6.84765 0 8.16275C0 9.47785 0.317442 10.7204 0.870669 11.8269L3.519 9.77716Z" fill="#FBBC05"/>
<path d="M8.16265 3.15623C9.69541 3.15623 10.7293 3.81831 11.3189 4.3716L13.6226 2.12231C12.2077 0.807206 10.3666 0 8.16265 0C4.9701 0 2.2129 1.83206 0.870605 4.49853L3.50987 6.54831C4.17202 4.58019 6.00408 3.15623 8.16265 3.15623Z" fill="#EB4335"/>
</svg>''';
