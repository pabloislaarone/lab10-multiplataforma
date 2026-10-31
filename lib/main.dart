import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const PrimeVideoApp());
}

class PrimeVideoApp extends StatelessWidget {
  const PrimeVideoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prime Video',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.oscuro,
      home: const SplashScreen(),
    );
  }
}
