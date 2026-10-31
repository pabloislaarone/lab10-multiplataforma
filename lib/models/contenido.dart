enum TipoContenido { pelicula, serie }

/// Un título real del catálogo de Prime Video (uso educativo).
///
/// Imágenes:
///  - [imagenLocal]: póster guardado en assets/images/posters (imagen LOCAL).
///  - [wiki]: título del artículo en Wikipedia (en inglés); de ahí se obtiene
///    el póster por internet (imagen en la NUBE). También sirve de respaldo
///    si falta el archivo local.
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
  final String wiki;
  final String? imagenLocal;
  final bool incluidoConPrime;
  final bool original;
  final double progreso; // 0..1 para "Continuar viendo" (simulado)

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
    required this.wiki,
    this.imagenLocal,
    this.incluidoConPrime = true,
    this.original = false,
    this.progreso = 0,
  });

  /// Ruta que entiende ImagenContenido: asset local o "wiki:Titulo".
  String get imagen => imagenLocal ?? 'wiki:$wiki';
  String get imagenHorizontal => imagen;
  bool get esImagenLocal => imagenLocal != null;
  String get tipoTexto => tipo == TipoContenido.pelicula ? 'Película' : 'Serie';
}
