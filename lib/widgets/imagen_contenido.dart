import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Muestra una imagen LOCAL (Image.asset) o de la NUBE (Image.network)
/// según la ruta. Para las de la nube agrega carga progresiva y un
/// respaldo si no hay internet.
class ImagenContenido extends StatelessWidget {
  final String ruta;
  final BoxFit fit;
  final double? width;
  final double? height;
  final String? textoRespaldo;

  const ImagenContenido({
    super.key,
    required this.ruta,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.textoRespaldo,
  });

  bool get _esLocal => !ruta.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (_esLocal) {
      return Image.asset(
        ruta,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => _respaldo(),
      );
    }
    return Image.network(
      ruta,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (context, child, progreso) {
        if (progreso == null) return child;
        return Container(
          width: width,
          height: height,
          color: AppColors.superficieAlta,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.azulPrime),
          ),
        );
      },
      errorBuilder: (_, __, ___) => _respaldo(),
    );
  }

  Widget _respaldo() => Container(
        width: width,
        height: height,
        color: AppColors.superficieAlta,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Text(
          textoRespaldo ?? 'Sin imagen',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppFonts.titulo,
            fontSize: 22,
            color: AppColors.textoSecundario,
          ),
        ),
      );
}
