import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.superficie,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  // Más memoria para imágenes = menos recargas al hacer scroll.
  PaintingBinding.instance.imageCache.maximumSizeBytes = 200 << 20;
  runApp(const PrimeVideoApp());
}

/// Scroll con rebote (como iOS) en todas las listas, y arrastre también
/// con mouse para probar en Windows/web.
class _ScrollFluido extends MaterialScrollBehavior {
  const _ScrollFluido();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class PrimeVideoApp extends StatelessWidget {
  const PrimeVideoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prime Video',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.oscuro,
      scrollBehavior: const _ScrollFluido(),
      home: const SplashScreen(),
    );
  }
}
