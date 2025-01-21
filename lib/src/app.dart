import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base/base_binding.dart';
import 'pages/splash_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      // initialRoute: '/',
      initialBinding: BaseBinding(),
      debugShowCheckedModeBanner: false,
      // getPages: GetxRouteGenerator.appRoutes(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashPage(),
    );
  }
}
