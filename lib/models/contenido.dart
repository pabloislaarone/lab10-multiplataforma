enum TipoContenido { pelicula, serie }

/// Un título del catálogo. La imagen puede ser local (assets) o de la nube (URL).
class Contenido {
  final String id;
  final String titulo;
  final String descripcion;
  final TipoContenido tipo;
  final List<String> generos;
  final int anio;
  final String clasificacion; // 13+, 16+, 18+...
  final double calificacion; // IMDb-like 0..10
  final String duracion; // "2 h 5 min" o "3 temporadas"
  final String imagen; // ruta asset o URL
  final String? banner; // imagen horizontal opcional
  final bool incluidoConPrime;
  final bool original;
  final double progreso; // 0..1 para "Continuar viendo"

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
    required this.imagen,
    this.banner,
    this.incluidoConPrime = true,
    this.original = false,
    this.progreso = 0,
  });

  bool get esImagenLocal => !imagen.startsWith('http');
  String get imagenHorizontal => banner ?? imagen;
  String get tipoTexto => tipo == TipoContenido.pelicula ? 'Película' : 'Serie';
}
