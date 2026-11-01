import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'shimmer.dart';

/// Muestra la portada de un título:
///  - ruta "assets/..." -> imagen LOCAL (Image.asset). Si el archivo no
///    existe, usa [respaldo] (la misma portada en la nube).
///  - ruta "http..."    -> imagen en la NUBE (Image.network).
/// Mientras carga muestra un shimmer y luego aparece con un fundido suave.
class ImagenContenido extends StatelessWidget {
  final String ruta;
  final String? respaldo;
  final BoxFit fit;
  final Alignment alignment;
  final double? width;
  final double? height;
  final String? textoRespaldo;

  const ImagenContenido({
    super.key,
    required this.ruta,
    this.respaldo,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.textoRespaldo,
  });

  @override
  Widget build(BuildContext context) {
    if (ruta.startsWith('http')) return _red(ruta);
    return Image.asset(
      ruta,
      fit: fit,
      alignment: alignment,
      width: width,
      height: height,
      frameBuilder: _fundido,
      errorBuilder: (_, __, ___) => respaldo == null ? _error() : _red(respaldo!),
    );
  }

  Widget _red(String url) {
    // Decodifica la imagen al tamaño que se va a pintar (menos memoria, scroll más fluido).
    final dpr = WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final cacheW = width != null ? (width! * dpr).round() : null;
    return Image.network(
      url,
      fit: fit,
      alignment: alignment,
      width: width,
      height: height,
      cacheWidth: cacheW,
      gaplessPlayback: true,
      frameBuilder: _fundido,
      errorBuilder: (_, __, ___) => _error(),
    );
  }

  Widget _fundido(BuildContext context, Widget child, int? frame, bool sincrono) {
    if (sincrono) return child;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (frame == null) Shimmer(width: width, height: height),
        AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          child: child,
        ),
      ],
    );
  }

  Widget _error() => Container(
        width: width,
        height: height,
        color: AppColors.superficieAlta,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Text(
          textoRespaldo ?? '',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: const TextStyle(
            fontFamily: AppFonts.titulo,
            fontSize: 22,
            color: AppColors.textoSecundario,
          ),
        ),
      );
}
