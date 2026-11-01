import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import 'buscar_screen.dart';
import 'home_screen.dart';
import 'mi_espacio_screen.dart';
import 'mi_lista_screen.dart';

/// Navegación inferior como en la app móvil de Prime Video.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _indice = 0;

  static const _pantallas = [
    HomeScreen(),
    BuscarScreen(),
    MiListaScreen(),
    MiEspacioScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cada pestaña conserva su estado (scroll, búsqueda) y el cambio es
      // un fundido con leve zoom, en vez de un salto brusco.
      body: Stack(
        children: List.generate(_pantallas.length, (i) {
          final activa = i == _indice;
          return IgnorePointer(
            ignoring: !activa,
            child: TickerMode(
              enabled: activa,
              child: AnimatedOpacity(
                opacity: activa ? 1 : 0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: AnimatedScale(
                  scale: activa ? 1 : 0.98,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  child: _pantallas[i],
                ),
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppColors.superficie,
          indicatorColor: AppColors.azulPrime.withAlpha(50),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontFamily: AppFonts.encabezado,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: states.contains(WidgetState.selected)
                  ? Colors.white
                  : AppColors.textoSecundario,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _indice,
          animationDuration: const Duration(milliseconds: 350),
          onDestinationSelected: (i) {
            if (i != _indice) HapticFeedback.selectionClick();
            setState(() => _indice = i);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.azulPrime),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              selectedIcon: Icon(Icons.search, color: AppColors.azulPrime),
              label: 'Buscar',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_border),
              selectedIcon: Icon(Icons.bookmark, color: AppColors.azulPrime),
              label: 'Mi lista',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.azulPrime),
              label: 'Mi espacio',
            ),
          ],
        ),
      ),
    );
  }
}
