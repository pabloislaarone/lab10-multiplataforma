import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Logo en texto (Montserrat ExtraBold).
class LogoPrime extends StatelessWidget {
  final double tamano;
  const LogoPrime({super.key, this.tamano = 22});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: AppFonts.encabezado,
          fontWeight: FontWeight.w800,
          fontSize: tamano,
          letterSpacing: -0.5,
        ),
        children: const [
          TextSpan(text: 'prime ', style: TextStyle(color: Colors.white)),
          TextSpan(text: 'video', style: TextStyle(color: AppColors.azulPrime)),
        ],
      ),
    );
  }
}
