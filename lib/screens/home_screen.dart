import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../data/catalogo.dart';
import '../models/contenido.dart';
import '../services/estado_usuario.dart';
import '../services/mi_lista_service.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_perfil.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/logo_prime.dart';
import '../widgets/seccion_horizontal.dart';
import '../widgets/sorpresa_sheet.dart';
import '../widgets/tarjetas.dart';
import 'perfiles_screen.dart';

enum _Filtro { inicio, peliculas, series }

/// Altura de las filas de tarjetas 16:9 (ancho 200).
const double _altoFila = 113;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scroll = ScrollController();
  double _opacidadBarra = 0;
  bool _chipsVisibles = true;
  bool _fabExtendido = true;
  _Filtro _filtro = _Filtro.inicio;
  List<Contenido> _recomendados = [];

  @override
  void initState() {
    super.initState();
    _mezclarRecomendados();
    _scroll.addListener(_alHacerScroll);
  }

  /// Como en Prime Video: la barra se vuelve sólida al bajar, los filtros se
  /// esconden al bajar y reaparecen al subir, y el botón flotante se encoge.
  void _alHacerScroll() {
    final pos = _scroll.position;
    final opacidad = (pos.pixels / 260).clamp(0.0, 1.0);
    final bajando = pos.userScrollDirection == ScrollDirection.reverse;
    final subiendo = pos.userScrollDirection == ScrollDirection.forward;
    var cambio = false;
    if ((opacidad - _opacidadBarra).abs() > 0.02) {
      _opacidadBarra = opacidad;
      cambio = true;
    }
    if (bajando && _chipsVisibles && pos.pixels > 120) {
      _chipsVisibles = false;
      _fabExtendido = false;
      cambio = true;
    } else if ((subiendo || pos.pixels < 120) && !_chipsVisibles) {
      _chipsVisibles = true;
      _fabExtendido = true;
      cambio = true;
    }
    if (cambio) setState(() {});
  }

  void _mezclarRecomendados() {
    _recomendados = [...contenidosVisibles]..shuffle();
  }

  Future<void> _refrescar() async {
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) setState(_mezclarRecomendados);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  List<Contenido> _filtrar(List<Contenido> lista) {
    switch (_filtro) {
      case _Filtro.peliculas:
        return lista.where((c) => c.tipo == TipoContenido.pelicula).toList();
      case _Filtro.series:
        return lista.where((c) => c.tipo == TipoContenido.serie).toList();
      case _Filtro.inicio:
        return lista;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([EstadoUsuario.instancia, MiListaService.instancia]),
      builder: (context, _) => _contenido(context),
    );
  }

  Widget _fila(String titulo, List<Contenido> lista, String prefijo, int orden,
      {String? subtitulo}) {
    return SliverToBoxAdapter(
      child: SeccionHorizontal(
        titulo: titulo,
        subtitulo: subtitulo,
        alto: _altoFila,
        orden: orden,
        cantidad: lista.length,
        verTodo: lista,
        itemBuilder: (_, i) => PosterCard(contenido: lista[i], heroPrefijo: prefijo),
      ),
    );
  }

  Widget _contenido(BuildContext context) {
    final estado = EstadoUsuario.instancia;
    final banners = _filtrar(destacados);
    final continuar = _filtrar(estado.continuarViendo);
    final miLista = _filtrar(MiListaService.instancia.contenidos);
    final origs = _filtrar(originales);
    final top = _filtrar(top10);
    final recomendados = _filtrar(_recomendados.where(contenidosVisibles.contains).toList());
    final listaSeries = _filtrar(series);
    final listaPeliculas = _filtrar(peliculas);
    final meGusta = estado.ultimoMeGusta;
    final porqueTeGusto = meGusta == null ? <Contenido>[] : _filtrar(similaresA(meGusta));

    var orden = 0;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.azulPrime,
        foregroundColor: Colors.white,
        onPressed: () => mostrarSorpresa(context),
        isExtended: _fabExtendido,
        icon: const Icon(Icons.casino_outlined),
        label: const Text(
          '¿Qué veo hoy?',
          style: TextStyle(fontFamily: AppFonts.encabezado, fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            color: AppColors.azulPrime,
            backgroundColor: AppColors.superficie,
            edgeOffset: MediaQuery.of(context).padding.top + 90,
            onRefresh: _refrescar,
            child: CustomScrollView(
              controller: _scroll,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: banners.isNotEmpty
                        ? HeroCarousel(
                            key: ValueKey('${_filtro.name}-${estado.perfil.id}'),
                            items: banners,
                          )
                        : SizedBox(height: MediaQuery.of(context).padding.top + 110),
                  ),
                ),
                if (estado.esNinos) const SliverToBoxAdapter(child: _AvisoNinos()),
                if (continuar.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SeccionHorizontal(
                      titulo: 'Continuar viendo',
                      subtitulo: 'Mantén presionado para más opciones',
                      alto: 165,
                      orden: orden++,
                      cantidad: continuar.length,
                      itemBuilder: (_, i) => TarjetaContinuar(contenido: continuar[i]),
                    ),
                  ),
                if (porqueTeGusto.isNotEmpty)
                  _fila('Porque te gustó ${meGusta!.titulo}', porqueTeGusto, 'gusto', orden++),
                if (miLista.isNotEmpty) _fila('Mi lista', miLista, 'lista', orden++),
                if (origs.isNotEmpty)
                  _fila('Originales de Prime', origs, 'orig', orden++,
                      subtitulo: 'Mantén presionado una portada para la vista previa'),
                if (top.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SeccionHorizontal(
                      titulo: 'Top 10 en Perú hoy',
                      alto: 100,
                      separacion: 6,
                      orden: orden++,
                      cantidad: top.length,
                      verTodo: top,
                      itemBuilder: (_, i) => TarjetaTop(contenido: top[i], posicion: i + 1),
                    ),
                  ),
                if (recomendados.isNotEmpty)
                  _fila('Recomendados para ${estado.perfil.nombre}', recomendados, 'reco', orden++,
                      subtitulo: 'Desliza hacia abajo para actualizar'),
                if (listaSeries.isNotEmpty)
                  _fila('Series incluidas con Prime', listaSeries, 'series', orden++),
                if (listaPeliculas.isNotEmpty)
                  _fila('Películas incluidas con Prime', listaPeliculas, 'pelis', orden++),
                const SliverToBoxAdapter(child: SizedBox(height: 110)),
              ],
            ),
          ),
          _barraSuperior(context),
        ],
      ),
    );
  }

  Widget _barraSuperior(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.fromLTRB(16, top + 8, 12, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(const Color(0xCC000000), AppColors.fondo, _opacidadBarra)!,
            Color.lerp(Colors.transparent, AppColors.fondo.withAlpha(240), _opacidadBarra)!,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LogoPrime(),
              const Spacer(),
              IconButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buscando dispositivos para transmitir…')),
                ),
                icon: const Icon(Icons.cast, color: Colors.white),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PerfilesScreen(cambiando: true)),
                ),
                child: AvatarPerfil(perfil: EstadoUsuario.instancia.perfil, radio: 15),
              ),
            ],
          ),
          // Los filtros se esconden al bajar y vuelven al subir.
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: _chipsVisibles
                ? Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        _chip('Inicio', _Filtro.inicio),
                        _chip('Películas', _Filtro.peliculas),
                        _chip('Series', _Filtro.series),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _chip(String texto, _Filtro filtro) {
    final activo = _filtro == filtro;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          if (_filtro == filtro) return;
          HapticFeedback.selectionClick();
          setState(() => _filtro = filtro);
          if (_scroll.hasClients) {
            _scroll.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: activo ? Colors.white : Colors.white.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            style: TextStyle(
              fontFamily: AppFonts.encabezado,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: activo ? Colors.black : Colors.white,
            ),
            child: Text(texto),
          ),
        ),
      ),
    );
  }
}

class _AvisoNinos extends StatelessWidget {
  const _AvisoNinos();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF77F00).withAlpha(40),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF77F00)),
      ),
      child: const Row(
        children: [
          Icon(Icons.child_care, color: Color(0xFFF77F00)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Perfil Niños: solo se muestra contenido apto (hasta 13+).',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
