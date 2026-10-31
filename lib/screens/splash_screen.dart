import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/logo_prime.dart';
import 'perfiles_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..forward();

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const PerfilesScreen(),
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: Center(
        child: FadeTransition(
          opacity: _anim,
          child: ScaleTransition(
            scale: Tween(begin: 0.85, end: 1.0)
                .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutBack)),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LogoPrime(tamano: 40),
                SizedBox(height: 18),
                SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.azulPrime),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
