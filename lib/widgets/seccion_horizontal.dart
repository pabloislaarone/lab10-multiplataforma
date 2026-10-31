import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Fila horizontal con título, como las del inicio de Prime Video.
class SeccionHorizontal extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final double alto;
  final int cantidad;
  final IndexedWidgetBuilder itemBuilder;
  final double separacion;

  const SeccionHorizontal({
    super.key,
    required this.titulo,
    required this.alto,
    required this.cantidad,
    required this.itemBuilder,
    this.subtitulo,
    this.separacion = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                const Text(
                  'Ver más',
                  style: TextStyle(
                    fontFamily: AppFonts.encabezado,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.azulPrime,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: alto,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cantidad,
              separatorBuilder: (_, __) => SizedBox(width: separacion),
              itemBuilder: itemBuilder,
            ),
          ),
        ],
      ),
    );
  }
}
