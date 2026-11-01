import '../models/contenido.dart';
import '../services/estado_usuario.dart';

/// Catálogo con títulos reales de Prime Video (fines educativos).
///
/// Portadas oficiales tomadas de primevideo.com:
/// - Los títulos con `local: true` usan la copia en assets/images/posters
///   (se descarga con tools/descargar_posters.ps1).
/// - El resto carga la portada desde la nube (CDN de Amazon).
/// Calificaciones IMDb aproximadas; el progreso de "Continuar viendo" es de ejemplo.

const List<Contenido> catalogo = [
  // ---------- Portadas LOCALES ----------
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
    portada: '6e28c101c573e81bb2b0045182c575accdcc1105412003662ed610a53309311f',
    local: true,
    original: true,
    progreso: 0.62,
  ),
  Contenido(
    id: 'rings_of_power',
    titulo: 'El Señor de los Anillos: Los anillos de poder',
    descripcion:
        'Miles de años antes de El Hobbit, la Tierra Media vive la Segunda Edad: la forja de los anillos y el ascenso de Sauron.',
    tipo: TipoContenido.serie,
    generos: ['Fantasía', 'Aventura'],
    anio: 2022,
    clasificacion: '13+',
    calificacion: 6.9,
    duracion: 'Desde 2022',
    portada: '653ef15291b348dd7e364ecb29b1103aa6ae5f575d89457e676e4307d5c48650',
    local: true,
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
    portada: 'aadd9372f927030570c30da0d93b787f762e6be8646b378fb0713ee14e3b1367',
    local: true,
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
    portada: '89431e424bc3c33ebd02e2505471d5e76a4fdbacbbda434e65ca027a0423e2d9',
    local: true,
    original: true,
  ),
  Contenido(
    id: 'invincible',
    titulo: 'Invencible',
    descripcion:
        'Mark Grayson, hijo del superhéroe más poderoso del planeta, desarrolla sus propios poderes y descubre que el legado de su padre no es lo que parecía.',
    tipo: TipoContenido.serie,
    generos: ['Animación', 'Acción'],
    anio: 2021,
    clasificacion: '18+',
    calificacion: 8.7,
    duracion: 'Desde 2021',
    portada: '78afe406779795dfbc13b08845a48edcd88a5deb81130a437b358170a1fa8552',
    local: true,
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
    portada: '5e6e36faf924dfb40910a6598807eb0dd0f4273025fb5783fab4d42d98a72953',
    local: true,
  ),

  // ---------- Portadas en la NUBE ----------
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
    portada: 'bb1e750363fde2fd3b79c581285bc127ad224b53fd05fdf3ede4b9afbe29ffe8',
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
    portada: 'ede264c8cc4b839c56ebe922aad253877f95b23fb950d074a2f4f7b911ce23ce',
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
    portada: '393c024bc6cc12d91bb7eeeb12debf3831865fbff0fa2b874dbbb2ea747981a8',
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
    portada: '781781a5076f248fecdb3a805e17bc62dc1f747b88a9276110812b5ccabe3e1b',
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
    portada: 'a8ac90cd29ae0a00d63677dfdad7d52091e52937119e36a70f33370b315cd0d3',
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
    portada: '3c401ac4e19a002c9b7ef6d1aad1c5871c2843c0397b16949bcba0cec4c954c5',
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
    portada: 'd105cd63bee2a67be66e3ba02753c46efe7caea3a357d42de4795ea98d013ea2',
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
    portada: '1c2bbca31d5b23109670a446bd0e4bfea0e0d71c9569d66a78d6386b79f82cdf',
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
    portada: 'f005c96e6c7e9fb2352bb97adb75dc71e0911d3e45dac7628b3b8d799665a1ee',
    original: true,
    progreso: 0.4,
  ),
  Contenido(
    id: 'road_house',
    titulo: 'El duro (Road House)',
    descripcion:
        'Un ex luchador de UFC acepta trabajar como guardia de seguridad en un bar de los Cayos de Florida y descubre que el lugar esconde algo más.',
    tipo: TipoContenido.pelicula,
    generos: ['Acción', 'Thriller'],
    anio: 2024,
    clasificacion: '18+',
    calificacion: 6.2,
    duracion: '2 h 1 min',
    portada: '55525a2b8ac55f3de8b6e0564e80827bb80a60af547c05e404b10f95974a2261',
    original: true,
  ),
  Contenido(
    id: 'red_white_royal_blue',
    titulo: 'Rojo, Blanco y Sangre Azul',
    descripcion:
        'El hijo de la presidenta de EE. UU. y un príncipe británico pasan de rivales a algo mucho más complicado.',
    tipo: TipoContenido.pelicula,
    generos: ['Romance', 'Comedia'],
    anio: 2023,
    clasificacion: '16+',
    calificacion: 6.9,
    duracion: '1 h 58 min',
    portada: '845494028a59a5d277abb726c67404c33e3e2b06d751bc7f2633883507693087',
    original: true,
  ),
  Contenido(
    id: 'idea_of_you',
    titulo: 'La idea de ti',
    descripcion:
        'Una madre de 40 años inicia un romance inesperado con el vocalista de la boy band más famosa del momento.',
    tipo: TipoContenido.pelicula,
    generos: ['Romance', 'Comedia'],
    anio: 2024,
    clasificacion: '16+',
    calificacion: 6.4,
    duracion: '1 h 55 min',
    portada: '407948ade2ce55df25ecc25815fac8da00c592830cd780febcd79e507dde9ece',
    original: true,
  ),
  Contenido(
    id: 'air',
    titulo: 'AIR: La historia detrás del logo',
    descripcion:
        'La historia de cómo un ejecutivo de Nike apostó todo para fichar a un joven Michael Jordan y crear la línea Air Jordan.',
    tipo: TipoContenido.pelicula,
    generos: ['Drama', 'Deportes'],
    anio: 2023,
    clasificacion: '16+',
    calificacion: 7.4,
    duracion: '1 h 52 min',
    portada: 'c7977119b6e2ed27f182a7efd7602f2090b76770d18116e169b84585428f3067',
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
    portada: 'b33e6d94ac9fb65d9e025adbeb42a3044b2de4c654c6a79291a40c6d410cf4de',
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
