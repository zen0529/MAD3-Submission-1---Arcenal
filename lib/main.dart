import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile3_midterm/controller/authcontroller.dart';
import 'package:mobile3_midterm/router/router.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() async {
  // Increase the buffer size for the 'flutter/lifecycle' channel
  AuthController.initialize();
  GlobalRouter.initialize();
  await AuthController.I.loadSession();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: GlobalRouter.I.router,
    );
  }
}
