enum TipoContenido { pelicula, serie }

/// Un título real del catálogo de Prime Video (uso educativo).
///
/// Imágenes (portadas oficiales 16:9 de primevideo.com):
///  - [imagenLocal]: copia guardada en assets/images/posters (imagen LOCAL),
///    se descarga con tools/descargar_posters.ps1.
///  - [imagenNube]: la misma portada servida desde el CDN de Amazon
///    (imagen en la NUBE). También es el respaldo si falta el archivo local.
class Contenido {
  final String id;
  final String titulo;
  final String descripcion;
  final TipoContenido tipo;
  final List<String> generos;
  final int anio;
  final String clasificacion;
  final double calificacion; // IMDb aproximado
  final String duracion;
  final String portada; // id de la imagen en el CDN de Prime Video
  final bool local; // true = usa la copia en assets
  final bool incluidoConPrime;
  final bool original;
  final double progreso; // 0..1 para "Continuar viendo" (datos de ejemplo)

  const Contenido({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    required this.generos,
    required this.anio,
    required this.clasificacion,
    required this.calificacion,
    required this.duracion,
    required this.portada,
    this.local = false,
    this.incluidoConPrime = true,
    this.original = false,
    this.progreso = 0,
  });

  static const _cdn = 'https://m.media-amazon.com/images/S/pv-target-images';

  /// Portada desde la nube con el ancho pedido (720 para tarjetas, 1280 para banners).
  String imagenNubeAncho(int ancho) => '$_cdn/$portada._UR1920,1080_SX${ancho}_FMjpg_.png';
  String get imagenNube => imagenNubeAncho(720);
  String get imagenBanner => local ? imagenLocal : imagenNubeAncho(1280);

  String get imagenLocal => 'assets/images/posters/$id.png';

  /// Ruta que se muestra en tarjetas: local si corresponde, si no la nube.
  String get imagen => local ? imagenLocal : imagenNube;
  String get imagenHorizontal => imagenBanner;
  bool get esImagenLocal => local;
  String get tipoTexto => tipo == TipoContenido.pelicula ? 'Película' : 'Serie';
}
