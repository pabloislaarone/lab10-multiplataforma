import 'package:flutter/material.dart';

/// Colores y tipografías inspirados en la versión web de Prime Video.
class AppColors {
  static const fondo = Color(0xFF0F171E);
  static const superficie = Color(0xFF1A242F);
  static const superficieAlta = Color(0xFF232F3E);
  static const azulPrime = Color(0xFF00A8E1);
  static const azulOscuro = Color(0xFF0F79AF);
  static const textoSecundario = Color(0xFF8197A4);
  static const dorado = Color(0xFFFFC300);
}

/// Las 3 familias tipográficas declaradas en pubspec.yaml.
class AppFonts {
  static const titulo = 'BebasNeue'; // títulos de pósters/banners
  static const encabezado = 'Montserrat'; // secciones, botones, logo
  static const cuerpo = 'Inter'; // texto general
}

class AppTheme {
  static ThemeData get oscuro {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.fondo,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.azulPrime,
        secondary: AppColors.azulPrime,
        surface: AppColors.superficie,
      ),
      textTheme: base.textTheme.apply(
        fontFamily: AppFonts.cuerpo,
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.fondo,
        elevation: 0,
        centerTitle: false,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.superficieAlta,
        selectedColor: AppColors.azulPrime,
        labelStyle: const TextStyle(fontFamily: AppFonts.cuerpo, color: Colors.white),
        side: BorderSide.none,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.superficieAlta,
        contentTextStyle: TextStyle(fontFamily: AppFonts.cuerpo, color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static const tituloSeccion = TextStyle(
    fontFamily: AppFonts.encabezado,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: Colors.white,
  );

  static const metadato = TextStyle(
    fontFamily: AppFonts.cuerpo,
    fontSize: 12,
    color: AppColors.textoSecundario,
  );
}
