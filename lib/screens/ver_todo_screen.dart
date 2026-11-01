import 'package:flutter/material.dart';

import '../models/contenido.dart';
import '../theme/app_theme.dart';
import '../widgets/tarjetas.dart';

/// Cuadrícula con todos los títulos de una fila ("Ver todo").
/// Cada tarjeta entra con un pequeño retraso escalonado.
class VerTodoScreen extends StatelessWidget {
  final String titulo;
  final List<Contenido> contenidos;
  const VerTodoScreen({super.key, required this.titulo, required this.contenidos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar.large(
            backgroundColor: AppColors.fondo,
            title: Text(
              titulo,
              style: const TextStyle(fontFamily: AppFonts.encabezado, fontWeight: FontWeight.w800),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 16 / 9,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) => TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 300 + (i % 10) * 60),
                  curve: Curves.easeOutCubic,
                  builder: (_, t, child) => Opacity(
                    opacity: t,
                    child: Transform.scale(scale: 0.92 + 0.08 * t, child: child),
                  ),
                  child: PosterCard(contenido: contenidos[i], heroPrefijo: 'todo'),
                ),
                childCount: contenidos.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
