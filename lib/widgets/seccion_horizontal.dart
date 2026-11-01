import 'package:flutter/material.dart';

import '../models/contenido.dart';
import '../screens/ver_todo_screen.dart';
import '../theme/app_theme.dart';

/// Fila horizontal con título, como las del inicio de Prime Video.
/// - Aparece con un fundido + subida suave la primera vez.
/// - "Ver todo" abre la cuadrícula completa si se pasa [verTodo].
class SeccionHorizontal extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final double alto;
  final int cantidad;
  final IndexedWidgetBuilder itemBuilder;
  final double separacion;
  final List<Contenido>? verTodo;
  final int orden; // para escalonar la animación de entrada

  const SeccionHorizontal({
    super.key,
    required this.titulo,
    required this.alto,
    required this.cantidad,
    required this.itemBuilder,
    this.subtitulo,
    this.separacion = 10,
    this.verTodo,
    this.orden = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 450 + orden * 90),
      curve: Curves.easeOutCubic,
      builder: (_, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, (1 - t) * 24), child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: verTodo == null
                  ? null
                  : () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => VerTodoScreen(titulo: titulo, contenidos: verTodo!),
                      )),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(titulo, style: AppTheme.tituloSeccion),
                          if (subtitulo != null) Text(subtitulo!, style: AppTheme.metadato),
                        ],
                      ),
                    ),
                    if (verTodo != null)
                      const Row(
                        children: [
                          Text(
                            'Ver todo',
                            style: TextStyle(
                              fontFamily: AppFonts.encabezado,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppColors.azulPrime,
                            ),
                          ),
                          Icon(Icons.chevron_right, size: 18, color: AppColors.azulPrime),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: alto,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cantidad,
                separatorBuilder: (_, __) => SizedBox(width: separacion),
                itemBuilder: itemBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
