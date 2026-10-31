import '../models/contenido.dart';
import '../services/estado_usuario.dart';

/// Catálogo con títulos reales de Prime Video (fines educativos).
///
/// - Los títulos con `imagenLocal` usan pósters guardados en
///   assets/images/posters (se descargan con tools/descargar_posters.ps1).
/// - El resto carga su póster desde la nube (Wikipedia) en tiempo de ejecución.
/// Calificaciones IMDb aproximadas; el progreso de "Continuar viendo" es simulado.
const _p = 'assets/images/posters';

const List<Contenido> catalogo = [
  // ---------- Pósters LOCALES ----------
  Contenido(
    id: 'the_boys',
    titulo: 'The Boys',
    descripcion:
        'Un grupo de vigilantes se enfrenta a superhéroes corruptos que abusan de su fama y poder, respaldados por la poderosa corporación Vought.',
    tipo: TipoContenido.serie,
    generos: ['Acción', 'Ciencia ficción'],
    anio: 2019,
    clasificacion: '18+',
    calificacion: 8.6,
    duracion: 'Desde 2019',
    wiki: 'The_Boys_(TV_series)',
    imagenLocal: '$_p/the_boys.jpg',
    original: true,
    progreso: 0.62,
  ),
  Contenido(
    id: 'rings_of_power',
    titulo: 'El Señor de los Anillos: Los Anillos de Poder',
    descripcion:
        'Miles de años antes de El Hobbit, la Tierra Media vive la Segunda Edad: la forja de los anillos y el ascenso de Sauron.',
    tipo: TipoContenido.serie,
    generos: ['Fantasía', 'Aventura'],
    anio: 2022,
    clasificacion: '13+',
    calificacion: 6.9,
    duracion: 'Desde 2022',
    wiki: 'The_Lord_of_the_Rings:_The_Rings_of_Power',
    imagenLocal: '$_p/rings_of_power.jpg',
    original: true,
  ),
  Contenido(
    id: 'reacher',
    titulo: 'Reacher',
    descripcion:
        'Jack Reacher, ex policía militar, recorre el país sin rumbo fijo y termina envuelto en conspiraciones que resuelve a su manera.',
    tipo: TipoContenido.serie,
    generos: ['Acción', 'Thriller'],
    anio: 2022,
    clasificacion: '18+',
    calificacion: 8.0,
    duracion: 'Desde 2022',
    wiki: 'Reacher_(TV_series)',
    imagenLocal: '$_p/reacher.jpg',
    original: true,
    progreso: 0.25,
  ),
  Contenido(
    id: 'fallout',
    titulo: 'Fallout',
    descripcion:
        'Doscientos años después del apocalipsis nuclear, una habitante de un refugio sale a la superficie y descubre un mundo brutal.',
    tipo: TipoContenido.serie,
    generos: ['Ciencia ficción', 'Aventura'],
    anio: 2024,
    clasificacion: '18+',
    calificacion: 8.3,
    duracion: 'Desde 2024',
    wiki: 'Fallout_(American_TV_series)',
    imagenLocal: '$_p/fallout.jpg',
    original: true,
  ),
  Contenido(
    id: 'invincible',
    titulo: 'Invincible',
    descripcion:
        'Mark Grayson, hijo del superhéroe más poderoso del planeta, desarrolla sus propios poderes y descubre que el legado de su padre no es lo que parecía.',
    tipo: TipoContenido.serie,
    generos: ['Animación', 'Acción'],
    anio: 2021,
    clasificacion: '18+',
    calificacion: 8.7,
    duracion: 'Desde 2021',
    wiki: 'Invincible_(TV_series)',
    imagenLocal: '$_p/invincible.jpg',
    original: true,
  ),
  Contenido(
    id: 'saltburn',
    titulo: 'Saltburn',
    descripcion:
        'Un estudiante de Oxford queda fascinado por un compañero aristócrata, que lo invita a pasar el verano en la extravagante mansión de su familia.',
    tipo: TipoContenido.pelicula,
    generos: ['Thriller', 'Drama'],
    anio: 2023,
    clasificacion: '18+',
    calificacion: 7.0,
    duracion: '2 h 11 min',
    wiki: 'Saltburn_(film)',
    imagenLocal: '$_p/saltburn.jpg',
  ),

  // ---------- Pósters en la NUBE ----------
  Contenido(
    id: 'gen_v',
    titulo: 'Gen V',
    descripcion:
        'Spin-off de The Boys: jóvenes con superpoderes compiten en la Universidad Godolkin mientras descubren sus oscuros secretos.',
    tipo: TipoContenido.serie,
    generos: ['Acción', 'Ciencia ficción'],
    anio: 2023,
    clasificacion: '18+',
    calificacion: 7.6,
    duracion: 'Desde 2023',
    wiki: 'Gen_V',
    original: true,
  ),
  Contenido(
    id: 'mrs_maisel',
    titulo: 'La maravillosa Sra. Maisel',
    descripcion:
        'En el Nueva York de 1958, un ama de casa descubre su talento para la comedia stand-up y decide abrirse camino en los clubes.',
    tipo: TipoContenido.serie,
    generos: ['Comedia', 'Drama'],
    anio: 2017,
    clasificacion: '16+',
    calificacion: 8.7,
    duracion: '2017 – 2023',
    wiki: 'The_Marvelous_Mrs._Maisel',
    original: true,
  ),
  Contenido(
    id: 'jack_ryan',
    titulo: 'Jack Ryan de Tom Clancy',
    descripcion:
        'Un analista de la CIA es arrastrado al trabajo de campo tras descubrir movimientos financieros sospechosos ligados al terrorismo.',
    tipo: TipoContenido.serie,
    generos: ['Acción', 'Thriller'],
    anio: 2018,
    clasificacion: '16+',
    calificacion: 8.0,
    duracion: '2018 – 2023',
    wiki: 'Jack_Ryan_(TV_series)',
    original: true,
    progreso: 0.8,
  ),
  Contenido(
    id: 'good_omens',
    titulo: 'Good Omens',
    descripcion:
        'Un ángel y un demonio que llevan siglos en la Tierra unen fuerzas para evitar el fin del mundo.',
    tipo: TipoContenido.serie,
    generos: ['Fantasía', 'Comedia'],
    anio: 2019,
    clasificacion: '13+',
    calificacion: 8.0,
    duracion: 'Desde 2019',
    wiki: 'Good_Omens_(TV_series)',
    original: true,
  ),
  Contenido(
    id: 'wheel_of_time',
    titulo: 'La Rueda del Tiempo',
    descripcion:
        'Moiraine, miembro de la poderosa organización Aes Sedai, busca al Dragón Renacido entre cinco jóvenes de una aldea.',
    tipo: TipoContenido.serie,
    generos: ['Fantasía', 'Aventura'],
    anio: 2021,
    clasificacion: '13+',
    calificacion: 7.1,
    duracion: 'Desde 2021',
    wiki: 'The_Wheel_of_Time_(TV_series)',
    original: true,
  ),
  Contenido(
    id: 'citadel',
    titulo: 'Citadel',
    descripcion:
        'Dos espías de una agencia independiente, a quienes les borraron la memoria, se reencuentran para detener a una organización criminal.',
    tipo: TipoContenido.serie,
    generos: ['Acción', 'Thriller'],
    anio: 2023,
    clasificacion: '16+',
    calificacion: 6.1,
    duracion: 'Desde 2023',
    wiki: 'Citadel_(TV_series)',
    original: true,
  ),
  Contenido(
    id: 'upload',
    titulo: 'Upload',
    descripcion:
        'En un futuro donde la conciencia puede subirse a un más allá digital, un joven muerto en un accidente vive en un lujoso paraíso virtual.',
    tipo: TipoContenido.serie,
    generos: ['Comedia', 'Ciencia ficción'],
    anio: 2020,
    clasificacion: '16+',
    calificacion: 7.9,
    duracion: '2020 – 2025',
    wiki: 'Upload_(TV_series)',
    original: true,
  ),
  Contenido(
    id: 'summer_pretty',
    titulo: 'El verano en que me enamoré',
    descripcion:
        'Belly pasa cada verano en la casa de playa de la familia Fisher, dividida entre los hermanos Conrad y Jeremiah.',
    tipo: TipoContenido.serie,
    generos: ['Romance', 'Drama'],
    anio: 2022,
    clasificacion: '13+',
    calificacion: 6.8,
    duracion: '2022 – 2025',
    wiki: 'The_Summer_I_Turned_Pretty_(TV_series)',
    original: true,
  ),
  Contenido(
    id: 'tomorrow_war',
    titulo: 'La guerra del mañana',
    descripcion:
        'Soldados del futuro viajan al presente para reclutar civiles que luchen en una guerra contra una especie alienígena.',
    tipo: TipoContenido.pelicula,
    generos: ['Ciencia ficción', 'Acción'],
    anio: 2021,
    clasificacion: '13+',
    calificacion: 6.5,
    duracion: '2 h 18 min',
    wiki: 'The_Tomorrow_War',
    original: true,
    progreso: 0.4,
  ),
  Contenido(
    id: 'road_house',
    titulo: 'Road House',
    descripcion:
        'Un ex luchador de UFC acepta trabajar como guardia de seguridad en un bar de los Cayos de Florida y descubre que el lugar esconde algo más.',
    tipo: TipoContenido.pelicula,
    generos: ['Acción', 'Thriller'],
    anio: 2024,
    clasificacion: '18+',
    calificacion: 6.2,
    duracion: '2 h 1 min',
    wiki: 'Road_House_(2024_film)',
    original: true,
  ),
  Contenido(
    id: 'red_white_royal_blue',
    titulo: 'Rojo, blanco y sangre azul',
    descripcion:
        'El hijo de la presidenta de EE. UU. y un príncipe británico pasan de rivales a algo mucho más complicado.',
    tipo: TipoContenido.pelicula,
    generos: ['Romance', 'Comedia'],
    anio: 2023,
    clasificacion: '16+',
    calificacion: 6.9,
    duracion: '1 h 58 min',
    wiki: 'Red,_White_&_Royal_Blue_(film)',
    original: true,
  ),
  Contenido(
    id: 'idea_of_you',
    titulo: 'La idea de tenerte',
    descripcion:
        'Una madre de 40 años inicia un romance inesperado con el vocalista de la boy band más famosa del momento.',
    tipo: TipoContenido.pelicula,
    generos: ['Romance', 'Comedia'],
    anio: 2024,
    clasificacion: '16+',
    calificacion: 6.4,
    duracion: '1 h 55 min',
    wiki: 'The_Idea_of_You_(film)',
    original: true,
  ),
  Contenido(
    id: 'air',
    titulo: 'Air',
    descripcion:
        'La historia de cómo un ejecutivo de Nike apostó todo para fichar a un joven Michael Jordan y crear la línea Air Jordan.',
    tipo: TipoContenido.pelicula,
    generos: ['Drama', 'Deportes'],
    anio: 2023,
    clasificacion: '16+',
    calificacion: 7.4,
    duracion: '1 h 52 min',
    wiki: 'Air_(2023_film)',
  ),
  Contenido(
    id: 'sound_of_metal',
    titulo: 'Sound of Metal',
    descripcion:
        'Un baterista de heavy metal empieza a perder la audición y debe replantear toda su vida.',
    tipo: TipoContenido.pelicula,
    generos: ['Drama'],
    anio: 2019,
    clasificacion: '16+',
    calificacion: 7.7,
    duracion: '2 h 0 min',
    wiki: 'Sound_of_Metal',
  ),
  Contenido(
    id: 'coming_2_america',
    titulo: 'Un príncipe en Nueva York 2',
    descripcion:
        'El ahora rey Akeem descubre que tiene un hijo en Estados Unidos y vuelve a Queens para buscarlo.',
    tipo: TipoContenido.pelicula,
    generos: ['Comedia'],
    anio: 2021,
    clasificacion: '13+',
    calificacion: 5.3,
    duracion: '1 h 50 min',
    wiki: 'Coming_2_America',
  ),
];

/// Videos de muestra públicos (películas libres de Blender / Google) para
/// que el reproductor reproduzca video real.
const videoContenido =
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
const videoTrailer =
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4';

/// Clasificaciones aptas para el perfil Niños.
const _aptasNinos = {'TP', '7+', '13+'};

/// Catálogo que puede ver el perfil actual (Niños solo ve contenido apto).
List<Contenido> get contenidosVisibles => EstadoUsuario.instancia.esNinos
    ? catalogo.where((c) => _aptasNinos.contains(c.clasificacion)).toList()
    : catalogo;

/// Carrusel principal: mezcla de pósters locales y en la nube.
List<Contenido> get destacados {
  const ids = ['the_boys', 'gen_v', 'fallout', 'rings_of_power', 'road_house'];
  final visibles = contenidosVisibles;
  final lista = visibles.where((c) => ids.contains(c.id)).toList();
  return lista.isNotEmpty ? lista : visibles.take(4).toList();
}

List<Contenido> get originales => contenidosVisibles.where((c) => c.original).toList();
List<Contenido> get peliculas =>
    contenidosVisibles.where((c) => c.tipo == TipoContenido.pelicula).toList();
List<Contenido> get series =>
    contenidosVisibles.where((c) => c.tipo == TipoContenido.serie).toList();
List<Contenido> get top10 {
  final lista = [...contenidosVisibles]
    ..sort((a, b) => b.calificacion.compareTo(a.calificacion));
  return lista.take(10).toList();
}

/// Títulos parecidos (comparten al menos un género).
List<Contenido> similaresA(Contenido c) => contenidosVisibles
    .where((x) => x.id != c.id && x.generos.any(c.generos.contains))
    .toList();

List<String> get todosLosGeneros {
  final set = <String>{};
  for (final c in contenidosVisibles) {
    set.addAll(c.generos);
  }
  final lista = set.toList()..sort();
  return lista;
}
