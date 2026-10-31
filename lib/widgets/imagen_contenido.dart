import 'package:flutter/material.dart';

import '../services/imagen_service.dart';
import '../theme/app_theme.dart';

/// Muestra el póster de un título:
///  - ruta "assets/..."  -> imagen LOCAL (Image.asset). Si el archivo no
///    existe, usa la imagen de la nube como respaldo.
///  - ruta "wiki:Titulo" -> imagen en la NUBE (Wikipedia + Image.network).
class ImagenContenido extends StatelessWidget {
  final String ruta;
  final String? wiki;
  final BoxFit fit;
  final Alignment alignment;
  final double? width;
  final double? height;
  final String? textoRespaldo;

  const ImagenContenido({
    super.key,
    required this.ruta,
    this.wiki,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.textoRespaldo,
  });

  @override
  Widget build(BuildContext context) {
    if (ruta.startsWith('wiki:')) {
      return _ImagenNube(
        tituloWiki: ruta.substring(5),
        fit: fit,
        alignment: alignment,
        width: width,
        height: height,
        respaldo: _respaldo(),
        cargando: _cargando(),
      );
    }
    return Image.asset(
      ruta,
      fit: fit,
      alignment: alignment,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => wiki == null
          ? _respaldo()
          : _ImagenNube(
              tituloWiki: wiki!,
              fit: fit,
              alignment: alignment,
              width: width,
              height: height,
              respaldo: _respaldo(),
              cargando: _cargando(),
            ),
    );
  }

  Widget _cargando() => Container(
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

class _ImagenNube extends StatelessWidget {
  final String tituloWiki;
  final BoxFit fit;
  final Alignment alignment;
  final double? width;
  final double? height;
  final Widget respaldo;
  final Widget cargando;

  const _ImagenNube({
    required this.tituloWiki,
    required this.fit,
    required this.alignment,
    required this.width,
    required this.height,
    required this.respaldo,
    required this.cargando,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: ImagenService.urlPoster(tituloWiki),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) return cargando;
        final url = snap.data;
        if (url == null) return respaldo;
        return Image.network(
          url,
          headers: ImagenService.cabeceras,
          fit: fit,
          alignment: alignment,
          width: width,
          height: height,
          loadingBuilder: (_, child, progreso) => progreso == null ? child : cargando,
          errorBuilder: (_, __, ___) => respaldo,
        );
      },
    );
  }
}
