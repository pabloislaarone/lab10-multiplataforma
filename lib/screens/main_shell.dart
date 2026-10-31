import 'package:flutter/material.dart';

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
      body: IndexedStack(index: _indice, children: _pantallas),
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
          onDestinationSelected: (i) => setState(() => _indice = i),
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
