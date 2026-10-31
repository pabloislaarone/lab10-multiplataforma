import '../models/contenido.dart';

/// Imágenes en la nube (se descargan por internet con Image.network).
String _nube(String semilla, {int w = 400, int h = 600}) =>
    'https://picsum.photos/seed/$semilla/$w/$h';

/// Catálogo de ejemplo. Los primeros 6 títulos usan imágenes LOCALES
/// (assets/images) y el resto usa imágenes de la NUBE.
const _local = 'assets/images';

final List<Contenido> catalogo = [
  // ---------- Imágenes locales ----------
  const Contenido(
    id: 'selva-neon',
    titulo: 'Selva de Neón',
    descripcion:
        'En una Lima futurista, una hacker y un ex policía siguen el rastro de una red que controla las luces de toda la ciudad.',
    tipo: TipoContenido.serie,
    generos: ['Ciencia ficción', 'Acción'],
    anio: 2026,
    clasificacion: '16+',
    calificacion: 8.4,
    duracion: '2 temporadas',
    imagen: '$_local/poster_selva_neon.jpg',
    banner: '$_local/banner_selva_neon.jpg',
    original: true,
    progreso: 0.62,
  ),
  const Contenido(
    id: 'ultimo-faro',
    titulo: 'El Último Faro',
    descripcion:
        'Un farero solitario recibe señales desde un barco que desapareció hace treinta años.',
    tipo: TipoContenido.pelicula,
    generos: ['Misterio', 'Drama'],
    anio: 2025,
    clasificacion: '13+',
    calificacion: 7.6,
    duracion: '1 h 52 min',
    imagen: '$_local/poster_ultimo_faro.jpg',
    progreso: 0.25,
  ),
  const Contenido(
    id: 'andes-rojo',
    titulo: 'Andes Rojo',
    descripcion:
        'Documental que recorre la cordillera siguiendo a las comunidades que protegen sus glaciares.',
    tipo: TipoContenido.pelicula,
    generos: ['Documental'],
    anio: 2026,
    clasificacion: '7+',
    calificacion: 8.9,
    duracion: '1 h 38 min',
    imagen: '$_local/poster_andes_rojo.jpg',
    banner: '$_local/banner_andes_rojo.jpg',
    original: true,
  ),
  const Contenido(
    id: 'codigo-cero',
    titulo: 'Código Cero',
    descripcion:
        'Una desarrolladora descubre una puerta trasera en el sistema bancario más grande del país.',
    tipo: TipoContenido.serie,
    generos: ['Thriller', 'Acción'],
    anio: 2024,
    clasificacion: '16+',
    calificacion: 7.9,
    duracion: '1 temporada',
    imagen: '$_local/poster_codigo_cero.jpg',
    progreso: 0.8,
  ),
  const Contenido(
    id: 'marea-alta',
    titulo: 'Marea Alta',
    descripcion:
        'Tres hermanos vuelven a su pueblo costero para salvar el restaurante familiar.',
    tipo: TipoContenido.serie,
    generos: ['Drama'],
    anio: 2025,
    clasificacion: '13+',
    calificacion: 7.2,
    duracion: '3 temporadas',
    imagen: '$_local/poster_marea_alta.jpg',
    incluidoConPrime: false,
  ),
  const Contenido(
    id: 'risas-lima',
    titulo: 'Risas en Lima',
    descripcion:
        'Comedia sobre un grupo de amigos que intenta montar un show de stand-up en Barranco.',
    tipo: TipoContenido.pelicula,
    generos: ['Comedia'],
    anio: 2026,
    clasificacion: '13+',
    calificacion: 6.8,
    duracion: '1 h 41 min',
    imagen: '$_local/poster_risa_lima.jpg',
    original: true,
  ),

  // ---------- Imágenes en la nube ----------
  Contenido(
    id: 'horizonte',
    titulo: 'Horizonte Perdido',
    descripcion:
        'Una expedición aérea queda atrapada en una isla que no aparece en ningún mapa.',
    tipo: TipoContenido.pelicula,
    generos: ['Aventura', 'Acción'],
    anio: 2023,
    clasificacion: '13+',
    calificacion: 7.1,
    duracion: '2 h 5 min',
    imagen: _nube('horizonte'),
    banner: _nube('horizonte-b', w: 800, h: 450),
  ),
  Contenido(
    id: 'ciudad-cristal',
    titulo: 'Ciudad de Cristal',
    descripcion:
        'En una metrópoli donde todo es transparente, un detective investiga el primer crimen en décadas.',
    tipo: TipoContenido.serie,
    generos: ['Misterio', 'Ciencia ficción'],
    anio: 2025,
    clasificacion: '16+',
    calificacion: 8.1,
    duracion: '2 temporadas',
    imagen: _nube('cristal'),
    banner: _nube('cristal-b', w: 800, h: 450),
    original: true,
  ),
  Contenido(
    id: 'bosque-silencio',
    titulo: 'El Bosque del Silencio',
    descripcion: 'Un grupo de excursionistas pierde la señal… y la noción del tiempo.',
    tipo: TipoContenido.pelicula,
    generos: ['Terror', 'Misterio'],
    anio: 2024,
    clasificacion: '18+',
    calificacion: 6.9,
    duracion: '1 h 35 min',
    imagen: _nube('bosque'),
  ),
  Contenido(
    id: 'cocina-abuela',
    titulo: 'La Cocina de la Abuela',
    descripcion: 'Reality de cocina donde abuelas de todo el Perú retan a chefs profesionales.',
    tipo: TipoContenido.serie,
    generos: ['Reality', 'Comedia'],
    anio: 2026,
    clasificacion: '7+',
    calificacion: 8.6,
    duracion: '4 temporadas',
    imagen: _nube('cocina'),
    original: true,
  ),
  Contenido(
    id: 'ultima-carrera',
    titulo: 'Última Carrera',
    descripcion: 'Un piloto retirado vuelve a las pistas para una competencia imposible.',
    tipo: TipoContenido.pelicula,
    generos: ['Acción', 'Drama'],
    anio: 2022,
    clasificacion: '13+',
    calificacion: 7.4,
    duracion: '2 h 12 min',
    imagen: _nube('carrera'),
    incluidoConPrime: false,
  ),
  Contenido(
    id: 'estrellas-norte',
    titulo: 'Estrellas del Norte',
    descripcion: 'Una astrónoma aficionada encuentra algo que la NASA no quiere que vea.',
    tipo: TipoContenido.pelicula,
    generos: ['Ciencia ficción', 'Drama'],
    anio: 2025,
    clasificacion: '13+',
    calificacion: 7.8,
    duracion: '1 h 58 min',
    imagen: _nube('estrellas'),
    progreso: 0.4,
  ),
  Contenido(
    id: 'amor-costa',
    titulo: 'Amor en la Costa Verde',
    descripcion: 'Una arquitecta y un surfista se enfrentan por el futuro de una playa.',
    tipo: TipoContenido.pelicula,
    generos: ['Romance', 'Comedia'],
    anio: 2024,
    clasificacion: '13+',
    calificacion: 6.5,
    duracion: '1 h 47 min',
    imagen: _nube('costa'),
  ),
  Contenido(
    id: 'reino-dragones',
    titulo: 'El Reino de Ceniza',
    descripcion: 'Saga épica sobre dos reinos enfrentados por el último volcán activo.',
    tipo: TipoContenido.serie,
    generos: ['Fantasía', 'Aventura'],
    anio: 2026,
    clasificacion: '16+',
    calificacion: 8.7,
    duracion: '2 temporadas',
    imagen: _nube('ceniza'),
    banner: _nube('ceniza-b', w: 800, h: 450),
    original: true,
  ),
  Contenido(
    id: 'pequenos-heroes',
    titulo: 'Pequeños Héroes',
    descripcion: 'Animación para toda la familia sobre un equipo de mascotas rescatistas.',
    tipo: TipoContenido.serie,
    generos: ['Infantil', 'Animación'],
    anio: 2025,
    clasificacion: 'TP',
    calificacion: 7.7,
    duracion: '3 temporadas',
    imagen: _nube('heroes'),
  ),
  Contenido(
    id: 'jugada-final',
    titulo: 'Jugada Final',
    descripcion: 'Documental deportivo sobre la temporada más difícil de un club de barrio.',
    tipo: TipoContenido.serie,
    generos: ['Documental', 'Deportes'],
    anio: 2026,
    clasificacion: '7+',
    calificacion: 8.2,
    duracion: '1 temporada',
    imagen: _nube('jugada'),
  ),
];

/// Banners destacados del carrusel principal (2 locales + 2 en la nube).
List<Contenido> get destacados => [
      catalogo.firstWhere((c) => c.id == 'selva-neon'),
      catalogo.firstWhere((c) => c.id == 'ciudad-cristal'),
      catalogo.firstWhere((c) => c.id == 'andes-rojo'),
      catalogo.firstWhere((c) => c.id == 'reino-dragones'),
    ];

List<Contenido> get continuarViendo => catalogo.where((c) => c.progreso > 0).toList();
List<Contenido> get originales => catalogo.where((c) => c.original).toList();
List<Contenido> get peliculas =>
    catalogo.where((c) => c.tipo == TipoContenido.pelicula).toList();
List<Contenido> get series => catalogo.where((c) => c.tipo == TipoContenido.serie).toList();
List<Contenido> get top10 {
  final lista = [...catalogo]..sort((a, b) => b.calificacion.compareTo(a.calificacion));
  return lista.take(10).toList();
}

List<String> get todosLosGeneros {
  final set = <String>{};
  for (final c in catalogo) {
    set.addAll(c.generos);
  }
  final lista = set.toList()..sort();
  return lista;
}
