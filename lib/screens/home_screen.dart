import 'package:flutter/material.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scroll = ScrollController();
  double _opacidadBarra = 0;
  _Filtro _filtro = _Filtro.inicio;
  List<Contenido> _recomendados = [];

  @override
  void initState() {
    super.initState();
    _mezclarRecomendados();
    _scroll.addListener(() {
      final nueva = (_scroll.offset / 220).clamp(0.0, 1.0);
      if ((nueva - _opacidadBarra).abs() > 0.02) {
        setState(() => _opacidadBarra = nueva);
      }
    });
  }

  void _mezclarRecomendados() {
    _recomendados = [...contenidosVisibles]..shuffle();
  }

  Future<void> _refrescar() async {
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 800));
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

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.azulPrime,
        foregroundColor: Colors.white,
        onPressed: () => mostrarSorpresa(context),
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
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (banners.isNotEmpty)
                  SliverToBoxAdapter(
                    child: HeroCarousel(
                      key: ValueKey('${_filtro.name}-${estado.perfil.id}'),
                      items: banners,
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: SizedBox(height: MediaQuery.of(context).padding.top + 110),
                  ),
                if (estado.esNinos)
                  const SliverToBoxAdapter(child: _AvisoNinos()),
                if (continuar.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SeccionHorizontal(
                      titulo: 'Continuar viendo',
                      subtitulo: 'Mantén presionado para más opciones',
                      alto: 175,
                      cantidad: continuar.length,
                      itemBuilder: (_, i) => TarjetaContinuar(contenido: continuar[i]),
                    ),
                  ),
                if (porqueTeGusto.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SeccionHorizontal(
                      titulo: 'Porque te gustó ${meGusta!.titulo}',
                      alto: 180,
                      cantidad: porqueTeGusto.length,
                      itemBuilder: (_, i) =>
                          PosterCard(contenido: porqueTeGusto[i], heroPrefijo: 'gusto'),
                    ),
                  ),
                if (miLista.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SeccionHorizontal(
                      titulo: 'Mi lista',
                      alto: 180,
                      cantidad: miLista.length,
                      itemBuilder: (_, i) =>
                          PosterCard(contenido: miLista[i], heroPrefijo: 'lista'),
                    ),
                  ),
                if (origs.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SeccionHorizontal(
                      titulo: 'Originales de Prime',
                      subtitulo: 'Mantén presionado un póster para la vista previa',
                      alto: 180,
                      cantidad: origs.length,
                      itemBuilder: (_, i) =>
                          PosterCard(contenido: origs[i], heroPrefijo: 'orig'),
                    ),
                  ),
                if (top.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SeccionHorizontal(
                      titulo: 'Top 10 en Perú hoy',
                      alto: 175,
                      separacion: 4,
                      cantidad: top.length,
                      itemBuilder: (_, i) => TarjetaTop(contenido: top[i], posicion: i + 1),
                    ),
                  ),
                if (recomendados.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SeccionHorizontal(
                      titulo: 'Recomendados para ${estado.perfil.nombre}',
                      subtitulo: 'Desliza hacia abajo para actualizar',
                      alto: 180,
                      cantidad: recomendados.length,
                      itemBuilder: (_, i) =>
                          PosterCard(contenido: recomendados[i], heroPrefijo: 'reco'),
                    ),
                  ),
                if (listaSeries.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SeccionHorizontal(
                      titulo: 'Series incluidas con Prime',
                      alto: 180,
                      cantidad: listaSeries.length,
                      itemBuilder: (_, i) =>
                          PosterCard(contenido: listaSeries[i], heroPrefijo: 'series'),
                    ),
                  ),
                if (listaPeliculas.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SeccionHorizontal(
                      titulo: 'Películas incluidas con Prime',
                      alto: 180,
                      cantidad: listaPeliculas.length,
                      itemBuilder: (_, i) =>
                          PosterCard(contenido: listaPeliculas[i], heroPrefijo: 'pelis'),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
    return Container(
      padding: EdgeInsets.fromLTRB(16, top + 8, 12, 10),
      decoration: BoxDecoration(
        // BoxDecoration no acepta color y gradient a la vez: se usa uno u otro.
        color: _opacidadBarra < 0.3
            ? null
            : AppColors.fondo.withAlpha((_opacidadBarra * 245).round()),
        gradient: _opacidadBarra < 0.3
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xCC000000), Colors.transparent],
              )
            : null,
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
          const SizedBox(height: 6),
          Row(
            children: [
              _chip('Inicio', _Filtro.inicio),
              _chip('Películas', _Filtro.peliculas),
              _chip('Series', _Filtro.series),
            ],
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
          HapticFeedback.selectionClick();
          setState(() => _filtro = filtro);
          if (_scroll.hasClients) {
            _scroll.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: activo ? Colors.white : Colors.white.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            texto,
            style: TextStyle(
              fontFamily: AppFonts.encabezado,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: activo ? Colors.black : Colors.white,
            ),
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
